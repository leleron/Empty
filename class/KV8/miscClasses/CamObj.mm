//
//  CamObj.m
//
#import <sys/time.h>

#import "CamObj.h"
#import "DelegateCamera.h"
#import "AppDelegate.h"
#import "RJONE_LibCallBack.h"
#define MAX_SIZE_IOCTRL_BUF   5120    //5K
#define MAX_SIZE_AV_BUF       262144  //256K


#define DATATYPE_VIDEO	0
#define DATATYPE_AUDIO	1

typedef struct{
    union{
        struct{
            UINT16  VCodecID; //refer to DCAM_V_CODECID
            UINT16  ACodecID; //refer to DCAM_A_CODECID
        }stAVCodec;
        UINT32 nAVCodec;
    };
}st_DCAM_OUT_CODECID;


//add from DCAM_proto---------------------
typedef enum {
    DCAM_OUT_V_UNKN,
    DCAM_OUT_V_H264,
    DCAM_OUT_V_RGB565,
    DCAM_OUT_V_RGB24,
    DCAM_OUT_V_YUV420,
}DCAM_V_CODECID;


typedef enum
{
    DCAM_VFRAME_FLAG_I	= 0x00,	// Video I Frame
    DCAM_VFRAME_FLAG_P	= 0x01,	// Video P Frame
    DCAM_VFRAME_FLAG_B	= 0x02,	// Video B Frame
}DCAM_VFRAME;



@implementation CamObj
@synthesize nRowID, mCamState;
@synthesize m_bVideoPlaying;
@synthesize mVideoHeight, mVideoWidth;
@synthesize m_fifoVideo;
@synthesize nsCamName, nsDID, nsViewPwd;
@synthesize m_bPausePlayback;
@synthesize m_delegateCam;

#pragma mark -
#pragma mark init and release

//for Video and Audio data info
typedef struct{
    UINT16 nCodecID;	//refer to DCAM_V_CODECID or DCAM_A_CODECID
    UCHAR  nOnlineNum;
    UCHAR  flag;		//Video:=DCAM_VFRAME; Audio:=(DCAM_AUDIO_SAMPLERATE << 2) | (DCAM_AUDIO_DATABITS << 1) | (DCAM_AUDIO_CHANNEL)
    UCHAR  nSizeSpeexPacket;//size of one speex packet when audio is speex
    UCHAR  tag;			//0=live audio&video; 1=playback audio&video
    UCHAR  reserve[2];
    
    UINT32 nDataSize;
    UINT32 nTimeStamp;	//system tick
}st_AVDataInfo;



- (void) initValue
{
    nRowID    =-1;
//    nsCamName =@"";
    nsDID     =@"";
    nsViewPwd =@"";
    
    mConnMode=CONN_MODE_UNKNOWN;
    mCamState=CONN_INFO_UNKNOWN;
    
    m_nTickUpdateInfo=0L;
    m_bVideoPlaying  =NO;
    
    mThreadPlayVideo  =nil;
    mLockPlayVideo   =nil;
    mLock_stopAll=[[NSLock alloc] init];
    
    m_handle    =-1;
    mWaitTime_ms=0L;
    
    mVideoHeight=0;
    mVideoWidth =0;
    
    m_fifoVideo=av_FifoNew();
    m_nInitH264Decoder=-1;
    
    m_nPlayType=AV_TYPE_REALAV;
    m_nAvFileTime  =0L;
    m_bPausePlayback=0;
    
    m_delegateCam=nil;
}

- (id)init
{
    if((self = [super init]))
        [self initValue];
    _WIFIarray = [[NSMutableArray alloc]init];
    _myLock = [[NSLock alloc]init];
    int a ;
    a = RJONE_Lib_Init(1,self);
    
    return self;
}

- (void) releaseObj
{
    [nsCamName release];
    [nsDID release];
    [nsViewPwd release];
    nsCamName=nil;
    nsDID=nil;
    nsViewPwd=nil;
    
    if(m_fifoVideo){
        av_FifoRelease(m_fifoVideo);
        m_fifoVideo=NULL;
    }
    [mLock_stopAll release];
}


- (NSInteger) getLastError
{
    m_handle = RJONE_LiB_checkStatus(m_handle);
    return m_handle;
}

+ (NSString *) infoCode2Str:(int)infoCode
{
    NSString *result=@"";
    switch(infoCode) {
        case CONN_INFO_NO_NETWORK:
            result=NSLocalizedString(@"Network is not reachable",nil);
            break;
            
        case CONN_INFO_CONNECTING:
            result=NSLocalizedString(@"Connecting...",nil);
            break;
            
        case CONN_INFO_CONNECT_WRONG_DID:
            result=NSLocalizedString(@"Wrong DID",nil);
            break;
            
        case CONN_INFO_CONNECT_WRONG_PWD:
            result=NSLocalizedString(@"Wrong password",nil);
            break;
            
        case CONN_INFO_CONNECT_OFFLINE:
            result=NSLocalizedString(@"Not online",nil);
            break;
            
        case CONN_INFO_CONNECT_FAIL:
            result=NSLocalizedString(@"Failed to connect",nil);
            break;
            
        case CONN_INFO_CONNECTED:
            result=NSLocalizedString(@"Connected",nil);
            break;
            
        case STATUS_INFO_SESSION_CLOSED:
            result=NSLocalizedString(@"Disconnected",nil);
            break;
            
        default:
            break;
    }
    return result;
}

#pragma mark - misc function
+ (unsigned long) getTickCount
{
	struct timeval tv;
	if(gettimeofday(&tv, NULL)!=0) return 0;
	return (tv.tv_sec*1000 +tv.tv_usec/1000);
}


-(void) ResetVideoVar
{
	m_nFirstTickLocal_video=0L;
	m_nTick2_video=0L;
	m_nFirstTimestampDevice_video=0L;
    
	av_FifoEmpty(m_fifoVideo);
    m_bFirstFrame=TRUE;
}

- (BOOL) mayContinue
{
    if(nsDID==nil || [nsDID length]<=0) return NO;
    else return YES;
}

#pragma mark - callback function



typedef  enum
{
    SET_DEV_PASSWD_RESP = 0,
    VIDEO_START_RESP,
    VIDEO_STOP_RESP,
    GET_SN_ETC2_RESP,
    GET_DEV_PARAMETER_RESP,
    SET_DEV_PARAMETER_RESP,
    SETWIFI_RESP,
    DEVICE_PUSH_STATUS,
    GET_SYSFWVER_RESP,
    LISTWIFIAP_RESP,
    PUT_USER_OVER_MAX,
    AUTH_TYPE_FAILED,
    AUTH_TYPE_OK,
    BOOKING_CLEAN_TIME_RESP,
    INQUIRE_CHAREG_TYPE_RESP,
    INQUIRE_BATTERY_CAPACITY_RESP,
}IoLibEnum;

void callBackIO (int type, void *data, void *pUserData)
{
    CamObj *camObj = (CamObj *)pUserData;
//    camObj.nsCamName =@"";
    char *dataArray = (char *)data;
    
    if (type == SET_DEV_PASSWD_RESP)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SetDevPassWD" object:nil userInfo:@{@"key": [NSNumber numberWithInt:dataArray[0]]}];
        camObj.setpassresult = (NSInteger)dataArray[0];
    }
    if (type == VIDEO_START_RESP)
    {
        if(camObj.m_delegateCam && [camObj.m_delegateCam respondsToSelector:@selector(postVideoStartResp:)])
            [camObj.m_delegateCam postVideoStartResp:dataArray[0]];
    }
    if (type == VIDEO_STOP_RESP)
    {
        if(camObj.m_delegateCam && [camObj.m_delegateCam respondsToSelector:@selector(postVideoStopResp:)])
            [camObj.m_delegateCam postVideoStopResp:dataArray[0]];
    }
    if (type == GET_SN_ETC2_RESP)
    {
        char a[64];
        strncpy(a, dataArray, 64);
        NSString *wifiSsid = [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
        char b[64];
        strncpy(b, dataArray+64, 64);
        NSString *devSsid = [NSString stringWithCString:b encoding:NSUTF8StringEncoding];
        camObj.WIFI_SSID = wifiSsid;
        camObj.DEV_SSID = devSsid;
        camObj.netMode = dataArray[128];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMode" object:nil];
    }
    if (type == GET_DEV_PARAMETER_RESP)
    {
        if ((dataArray[3]&0x02) == 0x02)
        {
            camObj.resolution = (NSInteger)dataArray[0];
            camObj.contrast = (NSInteger)dataArray[1];
            camObj.brightness = (unsigned int)dataArray[2];
            if (camObj.brightness < 0)
            {
                camObj.brightness = 0-camObj.brightness;
            }
        }
    }
    if (type == SET_DEV_PARAMETER_RESP)
    {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if ((dataArray[0] &0x02) == 0x02)
        {
            if (dataArray[1] == 0)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeResolution" object:nil];
            }
        }
        if ((dataArray[0] &0x08) == 0x08)
        {
            if (dataArray[1] == 0)
            {
                
                camObj.contrast = delegate.contrast;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeContrast" object:nil userInfo:@{@"key": [NSNumber numberWithBool:YES]}];
            }
            else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeContrast" object:nil userInfo:@{@"key": [NSNumber numberWithBool:NO]}];
            }
        }
        if ((dataArray[0] &0x10) == 0x10)
        {
            if (dataArray[1] == 0)
            {
                camObj.brightness = delegate.brightness;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeBright" object:nil userInfo:@{@"key": [NSNumber numberWithBool:YES]}];
            }
            else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeBright" object:nil userInfo:@{@"key": [NSNumber numberWithBool:NO]}];
            }

        }
        
    }
    if (type == SETWIFI_RESP)
    {
        if(dataArray[0] == 1)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeConnnectSSID" object:nil userInfo:@{@"key": [NSNumber numberWithInt:1]}];
        }else if(dataArray[0] == 2)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeConnnectSSID" object:nil userInfo:@{@"key": [NSNumber numberWithInt:2]}];
        }else if(dataArray[0] == -1)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeConnnectSSID" object:nil userInfo:@{@"key": [NSNumber numberWithInt:-1]}];
        }
        
    }
    if (type == DEVICE_PUSH_STATUS)
    {
        //        int b3 = pResp->data[3]&0xFF;
        int b3 = dataArray[4]&0xFF;
        //        int b4 = pResp->data[4]&0xFF;
        int b4 = dataArray[5]&0xFF;
        if (0==b3 && 0x50 == b4)
        {
            //电量低
        }else if(0==b3 && 0x51 == b4)
        {
            //正在充电
        }else if(0==b3 && 0x52 == b4)
        {
            //发送机器状态
            int machine_state = (dataArray[6] & 0xFF);
            int speed_int = (dataArray[7] & 0xFF);
            int error_code0 = (dataArray[8] & 0xFF);
            switch (machine_state)
            {
                case 0:
                    //待机
                    camObj.statusType = STATUS_TYPE_STANDBY;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeWork" object:nil userInfo:@{@"key": [NSNumber numberWithInt:0]}];
                    break;
                case 1:
                    // 自动工作状态
                    camObj.statusType = STATUS_TYPE_WORK;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeWork" object:nil userInfo:@{@"key": [NSNumber numberWithInt:1]}];
                    break;
                case 2:
                    // 回充状态
                    camObj.statusType = STATUS_TYPE_BACK_CHARGE;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeWork" object:nil userInfo:@{@"key": [NSNumber numberWithInt:2]}];
                    break;
                case 3:
                    // 充电状态
                    camObj.statusType = STATUS_TYPE_CHARGE;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeWork" object:nil userInfo:@{@"key": [NSNumber numberWithInt:3]}];
                    break;
                case 4:
                    // 睡眠（按下遥控器的POWER键）状态
                    camObj.statusType = STATUS_TYPE_SLEEP;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeWork" object:nil userInfo:@{@"key": [NSNumber numberWithInt:4]}];
                    break;
                case 5:
                    // 故障等待状态
                    camObj.statusType = STATUS_TYPE_ERROR;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeWork" object:nil userInfo:@{@"key": [NSNumber numberWithInt:5]}];
                    break;
                default:
                    break;
            }
            //机器速度
            camObj.speed = speed_int;
            //机器故障
            camObj.error = error_code0;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeStatus" object:nil];
    }
    if (type == GET_SYSFWVER_RESP)
    {
        camObj.version = atoi(dataArray);
    }
    
    if (type == LISTWIFIAP_RESP)
    {
        char a[18];
        strncpy(a, dataArray+2, 18);
        NSMutableString *address = [NSMutableString stringWithCString:a encoding:NSUTF8StringEncoding];
        char b[64];
        strncpy(b, dataArray+20, 64);
        NSMutableString *ssid = [NSMutableString stringWithCString:b encoding:NSUTF8StringEncoding];
    
        //去掉双引号
        if (ssid.length)
        {
            [ssid deleteCharactersInRange:{0,1}];
            [ssid deleteCharactersInRange:{ssid.length-1,1}];
        }
        NSNumber *channel = [NSNumber numberWithChar:dataArray[84]];
        NSNumber *enctype = [NSNumber numberWithChar:dataArray[85]];
        
        NSDictionary *dic = @{@"address": address,@"ssid":ssid,@"channel":channel,@"enctype":enctype};
        
        if (dataArray[0] == 0)
        {
            [camObj.WIFIarray removeAllObjects];
        }
        if (dataArray[0] <= dataArray[1]-1 )
        {
            [camObj.WIFIarray addObject:dic];
        }
        if (dataArray[0] == dataArray[1] -1)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchWIFI" object:nil];
        }
        
    }
    if (type == PUT_USER_OVER_MAX)
    {
        if (dataArray[0] ==1)
        {
            camObj.mCamState = CONN_INFO__OVER_MAX;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshStatus" object:nil];
        }
    }
    if (type == BOOKING_CLEAN_TIME_RESP)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"BookCleanTime" object:nil userInfo:@{@"key": [NSNumber numberWithInt:dataArray[0]]}];
    }
    if (type == INQUIRE_CHAREG_TYPE_RESP )
    {
        NSLog(@"INQUIRE_CHAREG_TYPE_RESP");
    }
    if (type == INQUIRE_BATTERY_CAPACITY_RESP)
    {
        NSLog(@"INQUIRE_BATTERY_CAPACITY_RESP");
    }
}

void callBackAVT (char nDataType,void *pAVData, int nAVDataSize, void *pUserData)
{
    
    CamObj *camObj=(CamObj *)pUserData;
    if(nAVDataSize<0)
    {
        [camObj dispatchCamState:STATUS_INFO_SESSION_CLOSED];
        return;
    }
    
    if(!camObj.m_bVideoPlaying && nDataType==DATATYPE_VIDEO)
        return;
    
    else if(nDataType==DATATYPE_VIDEO)
    {
        block_t *b=(block_t *)malloc(sizeof(block_t));
        block_Alloc(b,pAVData, nAVDataSize);
        av_FifoPut(camObj.m_fifoVideo, b);
    }
}


#pragma mark - interface of CamObj
- (BOOL) isConnected
{
    return (m_handle>=0 ? YES : NO);
}

- (void)dispatchCamState:(E_CAM_STATE)eCamState
{
    if(eCamState==STATUS_INFO_SESSION_CLOSED)
    {
        [NSThread detachNewThreadSelector:@selector(stopAll) toTarget:self withObject:nil];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.mCamState=eCamState;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshStatus" object:nil];
    });
    
    if(self.m_delegateCam==nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.m_delegateCam respondsToSelector:@selector(refreshSessionInfo:withObj:withString:)])
            [self.m_delegateCam refreshSessionInfo:mCamState withObj:self withString:nsDID];
    });
}

- (void) stopAll
{
    [mLock_stopAll lock];
    [self stopVideo:m_nPlayType withTime:m_nAvFileTime];
    [self stopConnect];
    [mLock_stopAll unlock];
}

- (NSInteger) startConnect:(unsigned long)waitTime_sec
{
    [_myLock lock];
    if(![self mayContinue])
    {
        return -1;
    }

    else if(m_handle<0)
    {
        mConnMode=CONN_MODE_UNKNOWN;
        [self dispatchCamState:CONN_INFO_CONNECTING];
        char *sDID=NULL, *sViewPwd=NULL;
        sDID=(char *)[nsDID cStringUsingEncoding:NSASCIIStringEncoding];
        sViewPwd=(char *)[nsViewPwd cStringUsingEncoding:NSASCIIStringEncoding];
        m_handle = RJONE_LibConnect(1, 1, sDID,sViewPwd,3);
        
        if (m_handle >= 0)
        {
            RJONE_Lib_set_cb(m_handle,(OnCallBackDataIO )callBackIO,(OnCallBackDataAV )callBackAVT,self);
            
            
            st_DCAM_OUT_CODECID outCodecID;
            outCodecID.stAVCodec.VCodecID=DCAM_OUT_V_H264;
            [self dispatchCamState:CONN_INFO_CONNECTED];
            
            //查询设备SSID
            RJONE_LiBGetEtc2(m_handle);
            
            
            //查询参数
            RJONE_LiBGetDevParameter(m_handle, 0x02|0x08|0x10);
            
            //查询固件版本
            RJONE_LiBGetSysVer(m_handle);
            
            //校准时间
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *now;
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            
            now=[NSDate date];
            comps = [calendar components:unitFlags fromDate:now];
            NSInteger year = [comps year];
            NSInteger month = [comps month];
            NSInteger day = [comps day];
            NSInteger hour = [comps hour];
            NSInteger min = [comps minute];
            NSInteger sec = [comps second];
            NSInteger week = [comps weekday];
            
            RJONE_LiBSetTimeFromPhone(m_handle, (int)year,(int) month, (int)day, (int)hour, (int)min, (int)sec, (int)week);
            [self setHandle];

        }
        else
        {
            switch(m_handle)
            {
                case ERR_DCAM_INVALID_ID:
                    break;
                case ERR_DCAM_INVALID_PARAMETER:
                    break;
                    case ERR_DCAM_NOT_INITIALIZED:
                    [self dispatchCamState:CONN_INFO_CONNECT_WRONG_PWD];
                    break;
                case ERR_DCAM_INVALID_PREFIX:
                    [self dispatchCamState:CONN_INFO_CONNECT_WRONG_DID];
                    break;
                    
                case ERR_DCAM_DEVICE_NOT_ONLINE:
                    [self dispatchCamState:CONN_INFO_CONNECT_OFFLINE];
                    break;
                    
                case ERR_DCAM_WRONG_PASSWORD:
                    [self dispatchCamState:CONN_INFO_CONNECT_WRONG_PWD];
                    break;
                    
                default:
//                    [self dispatchCamState:CONN_INFO_CONNECT_FAIL];
                    break;
            }
        }
    }
    [_myLock unlock];

    return m_handle;
}

- (void) stopConnect
{
    if(m_handle>=0)
    {
        [self stopVideo:m_nPlayType withTime:m_nAvFileTime];
        RJONE_LibDisconnect(m_handle);
        m_handle=-1;
        
        [self dispatchCamState:STATUS_INFO_SESSION_CLOSED];
    }
}
-(int)setHandle
{
   return RJONE_LibSethandle(m_handle);
}

- (NSInteger)setCleanTimeday:(unsigned char) day
                        hour:(unsigned char) hour
                      minute:(unsigned char) minute
                     curweek:(unsigned char) curweek
                     curhour:(unsigned char) curhour
                   curminute:(unsigned char) curminute
                   cursecond:(unsigned char) cursecond
{
    return RJONE_LiBCleanTime(m_handle, day, hour, minute, curweek, curhour, curminute, cursecond);
}

- (NSInteger) startVideo:(int)nPlayType withTime:(long)avFileTime
{
    NSInteger nRet;
    m_nPlayType=nPlayType;
    m_nAvFileTime=avFileTime;
    
    if(nPlayType==AV_TYPE_REALAV)
    {
        NSLog(@"video handle:%d",m_handle);
        nRet = RJONE_LibSethandle(m_handle);
        
        nRet = RJONE_LibOpenVideo(m_handle);
    }
    
    if(nRet>=0 && mThreadPlayVideo==nil)
    {
        mLockPlayVideo=[[NSConditionLock alloc] initWithCondition:NOTDONE];
        mThreadPlayVideo=[[NSThread alloc] initWithTarget:self selector:@selector(ThreadPlayVideo) object:nil];
        [mThreadPlayVideo start];
    }
    return nRet;
}

- (void) stopVideo:(int)nPlayType withTime:(long)avFileTime
{
    NSInteger nRet=-1;
    if(nPlayType==AV_TYPE_REALAV)
    {
        nRet = RJONE_LibStopVideo(m_handle);
    }

    NSLog(@"stopVideo++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++, nRet=%ld", (long)nRet);
    
    m_bVideoPlaying=NO;
    if(mThreadPlayVideo!=nil  && nRet >=0)
    {
        [mLockPlayVideo lockWhenCondition:DONE];
        [mLockPlayVideo unlock];
        
        [mLockPlayVideo release];
        mLockPlayVideo  =nil;
        [mThreadPlayVideo release];
        mThreadPlayVideo=nil;
    }
}



-(NSInteger)getListwifi
{
    return  RJONE_LiBListWifi(m_handle);
}


-(void) myDoVideoData:(CHAR *)pData
{
	st_AVDataInfo stFrameHead;
	int nLenFrameHead=sizeof(st_AVDataInfo);
	memcpy(&stFrameHead, pData, nLenFrameHead);
	long nDiffTimeStamp=0L;
    
    //update online num every 3s
    unsigned long nTick2=[CamObj getTickCount];
    NSUInteger nTimespan=nTick2-m_nTickUpdateInfo;
    if(nTimespan==0) nTimespan=1000;
    if(nTimespan>=3000 || m_bFirstFrame)
    {
        m_nTickUpdateInfo=nTick2;
        NSUInteger totalFrame=mTotalFrame;
        mTotalFrame=0;
        nTimespan=nTimespan/1000;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.m_delegateCam && [self.m_delegateCam respondsToSelector:@selector(refreshSessionInfo:OnlineNm:TotalFrame:Time:)])
                [self.m_delegateCam refreshSessionInfo:mConnMode OnlineNm:stFrameHead.nOnlineNum TotalFrame:totalFrame Time:nTimespan];
        });
    }
    
	switch(stFrameHead.nCodecID)
	{
		case DCAM_OUT_V_H264:
			if(m_nInitH264Decoder>=0){
				if(m_bFirstFrame && stFrameHead.flag!=DCAM_VFRAME_FLAG_I) break;
				m_bFirstFrame=FALSE;
                
				int consumed_bytes=0;
				int nFrameSize=stFrameHead.nDataSize;
				UCHAR *pFrame=(UCHAR *)(pData+nLenFrameHead);
                
				while(nFrameSize>0){
                AGAIN_DECODER_NAL:
                    
					if(consumed_bytes<0){
						nFrameSize=0;
						break;
					}
					if(!m_bVideoPlaying) break;
					
					if(m_framePara[0]>0)
                    {
						if(m_framePara[2]>0 && m_framePara[2]!=mVideoWidth)
                        {
							mVideoWidth		=m_framePara[2];
							mVideoHeight	=m_framePara[3];
							NSLog(@"  myDoVideoData(..): DecoderNal(.)>=0, %dX%d, pFrame[2,3,4,5]=%X,%X,%X,%X\n",
                                  m_framePara[2], m_framePara[3], pFrame[2],pFrame[3],pFrame[4],pFrame[5]);
						}
						
						m_nTick2_video=[CamObj getTickCount];
						if(m_nFirstTimestampDevice_video==0 || m_nFirstTickLocal_video==0){
							m_nFirstTimestampDevice_video=stFrameHead.nTimeStamp;
							m_nFirstTickLocal_video		 =m_nTick2_video;
						}
						if(m_nTick2_video<m_nFirstTickLocal_video ||
                           stFrameHead.nTimeStamp<m_nFirstTimestampDevice_video)
                        {
							m_nFirstTimestampDevice_video=stFrameHead.nTimeStamp;
							m_nFirstTickLocal_video		 =m_nTick2_video;
						}
						
						nDiffTimeStamp=(stFrameHead.nTimeStamp-m_nFirstTimestampDevice_video) - (m_nTick2_video-m_nFirstTickLocal_video);
                        if(nDiffTimeStamp<3000){
                            for(int kk=0; kk<nDiffTimeStamp; kk++){
                                if(!m_bVideoPlaying) break;
                                usleep(1000);
                            }
                        }
                        
                        mTotalFrame++;
                        if (self.m_bVideoPlaying) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if(self.m_delegateCam &&
                                   [self.m_delegateCam respondsToSelector:@selector(refreshFrame:withVideoWidth:videoHeight:withObj:)])
                                    [self.m_delegateCam refreshFrame:m_pBufBmp24
                                                      withVideoWidth:mVideoWidth
                                                         videoHeight:mVideoHeight
                                                             withObj:self];
                            });
                        }
					}
					nFrameSize-=consumed_bytes;
					if(nFrameSize>0) memcpy(pFrame, pFrame+consumed_bytes, nFrameSize);
					else nFrameSize=0;
				}//while--end
			}
			break;
		default:;
	}
}
//video: decord and display it
- (void)ThreadPlayVideo
{
    block_t *pBlock=NULL;
    NSLog(@"    ThreadPlayVideo, nNumFiFo=%d", av_FifoCount(m_fifoVideo));
    
    m_nTickUpdateInfo =0L;
    mTotalFrame=0;
    
    [mLockPlayVideo lock];
    if(self.m_delegateCam && [self.m_delegateCam respondsToSelector:@selector(postH264InitDecode:)])
        [self.m_delegateCam postH264InitDecode:1];
    m_pBufBmp24=(unsigned char *)malloc(MAXSIZE_IMG_BUFFER);
    m_bVideoPlaying=YES;
    while(m_bVideoPlaying)
    {
        if(m_nPlayType==AV_TYPE_PLAYBACK && m_bPausePlayback){
            usleep(8000);
            continue;
        }
        //   141128    EngelChen
        
        if(true == _cleanFifo)
        {
            av_FifoEmpty(m_fifoVideo);
            _cleanFifo = false;
        }

        
        
        pBlock=av_FifoGetAndRemove(m_fifoVideo);
        if(pBlock==NULL){
            usleep(8000);
            continue;
        }
        
        //将AV数据传过去进行解码                                                     /////////////141128 EngelChen
        st_AVDataInfo stFrameHead;
        int nLenFrameHead=sizeof(st_AVDataInfo);
        memcpy(&stFrameHead, pBlock->p_buffer, nLenFrameHead);
        int nFrameSize=stFrameHead.nDataSize;
        UCHAR *pFrame=(UCHAR *)(pBlock->p_buffer+nLenFrameHead);
        
        if(self.m_delegateCam &&
           [self.m_delegateCam respondsToSelector:@selector(postH264DecodeData:anddatasize:)])
            [self.m_delegateCam postH264DecodeData:pFrame anddatasize:nFrameSize];
        
        //update online num every 3s
        mTotalFrame++;
        unsigned long nTick2=[CamObj getTickCount];
        NSUInteger nTimespan=nTick2-m_nTickUpdateInfo;
        if(nTimespan==0) nTimespan=1000;
        if(nTimespan>=3000 || m_bFirstFrame){
            m_nTickUpdateInfo=nTick2;
            NSUInteger totalFrame=mTotalFrame;
            mTotalFrame=0;
            nTimespan=nTimespan/1000;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.m_delegateCam && [self.m_delegateCam respondsToSelector:@selector(refreshSessionInfo:OnlineNm:TotalFrame:Time:)])
                    
                    [self.m_delegateCam refreshSessionInfo:mConnMode OnlineNm:stFrameHead.nOnlineNum TotalFrame:totalFrame Time:nTimespan];
            });
        }
        
        
        block_Release(pBlock);
        pBlock=NULL;
    }
    free(m_pBufBmp24);
//    UninitCodec();   //141128 Engel chen
    if(self.m_delegateCam && [self.m_delegateCam respondsToSelector:@selector(postH264FiniDecode:)])
        [self.m_delegateCam postH264FiniDecode:1];
    [mLockPlayVideo unlockWithCondition:DONE];
    
    NSLog(@"=== ThreadPlayVideo exit ===");
}

#pragma mark - LibMethods

-(int)Rjone_PtzControl :(unsigned char) control
                       :(int) speed
                       :(int) step
                       :(int) point

{
    return  RJONE_LiBPtzCommand(m_handle, control, speed, step, point);
}

-(int)Rjone_SetParameter :(int)bit_field
                         :(char) resolution
                         :(char)contrast
                         :(char)brightness

{
    return RJONE_LiBSetDevParameter(m_handle, bit_field, resolution, 1024, 30, contrast, brightness);
}

-(int)Rjone_SetEtc2
{
    return  RJONE_LiBGetEtc2(m_handle);
}

-(int)Rjone_GetEtc2
{
    return RJONE_LiBGetEtc2(m_handle);
}
-(int)Rjone_SetPassword :(char *)oldPasswd
                        :(char *)newPasswd
{
    return RJONE_LiBSetDevPassword(m_handle, oldPasswd, newPasswd);
}

-(int)Rjone_SetWifi :(int) Type
                    :(char *)SSID
                    :(char *)Password
                    :(char)enctype
{
    return RJONE_LiBSetWifi(m_handle, Type, SSID, Password, enctype);
}

-(int)Rjone_ListWif
{
    return  RJONE_LiBListWifi(m_handle);
}
@end

