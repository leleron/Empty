//
//  CamObj.h
//

#import <Foundation/Foundation.h>
#import "av_fifo.h"
#define MAXSIZE_IMG_BUFFER  2764800

#define NOTDONE             0
#define DONE                1

#define CONN_MODE_UNKNOWN  -1
#define CONN_MODE_P2P       0
#define CONN_MODE_RLY       1

#define AV_TYPE_REALAV      1
#define AV_TYPE_PLAYBACK    2


@protocol DelegateCamera;
typedef enum {
    CONN_INFO_UNKNOWN=5000,
    CONN_INFO_CONNECTING,        CONN_INFO_NO_NETWORK,
    CONN_INFO_CONNECT_WRONG_DID, CONN_INFO_CONNECT_WRONG_PWD,
    CONN_INFO_CONNECT_OFFLINE,   CONN_INFO_CONNECT_FAIL,
    STATUS_INFO_SESSION_CLOSED,  CONN_INFO_CONNECTED,
    CONN_INFO__OVER_MAX
}E_CAM_STATE;

extern int  gAPIVer;

@interface CamObj : NSObject
{
    NSUInteger nRowID;
    NSString  *nsCamName;
    NSString  *nsDID;
    NSString  *nsViewPwd;
    //-------------------
    E_CAM_STATE   mCamState;
    volatile int  mConnMode;
    volatile int  m_handle;
    av_fifo_t *m_fifoVideo;
    volatile BOOL m_bVideoPlaying;
    NSThread *mThreadPlayVideo;
    NSConditionLock *mLockPlayVideo;
    NSLock  *mLock_stopAll;
    unsigned long m_nTickUpdateInfo;
    unsigned long m_nFirstTickLocal_video, m_nTick2_video, m_nFirstTimestampDevice_video;
    BOOL  m_bFirstFrame;
    int   m_nInitH264Decoder;
	int   m_framePara[4];
	unsigned char *m_pBufBmp24;
    NSInteger  mVideoHeight, mVideoWidth;
    NSUInteger mTotalFrame;
    char  mTmp[40];
    unsigned long mWaitTime_ms;
    int  m_nPlayType;
    long m_nAvFileTime;
    volatile char m_bPausePlayback;

}


@property(assign)  BOOL cleanFifo;
@property(assign)  NSUInteger   nRowID;
@property(assign)  E_CAM_STATE  mCamState;
@property(assign)  NSInteger mVideoHeight, mVideoWidth;
@property(assign)  av_fifo_t *m_fifoVideo;
@property(assign)  char m_bPausePlayback;
@property(assign) BOOL m_bVideoPlaying;
@property(nonatomic, retain) NSString *nsCamName;
@property(nonatomic,strong)NSString *addedName;
@property(nonatomic, retain) NSString *nsDID;
@property(nonatomic, retain) NSString *nsViewPwd;
@property(nonatomic, retain) id<DelegateCamera> m_delegateCam;

- (void) releaseObj;
+ (NSString *) infoCode2Str:(int)infoCode;
+ (unsigned long) getTickCount;
- (void) initValue;
- (NSInteger) getLastError;
- (BOOL) isConnected;
- (void) stopAll;
- (NSInteger) startConnect:(unsigned long)waitTime_sec;
- (void) stopConnect;
- (int)setHandle;
- (NSInteger) startVideo:(int)nPlayType withTime:(long)avFileTime;
- (void) stopVideo:(int)nPlayType withTime:(long)avFileTime;
- (void)dispatchCamState:(E_CAM_STATE)eCamState;
- (NSInteger)setCleanTimeday:(unsigned char) day
                         hour:(unsigned char) hour
                         minute:(unsigned char) minute
                         curweek:(unsigned char) curweek
                         curhour:(unsigned char) curhour
                         curminute:(unsigned char) curminute
                         cursecond:(unsigned char) cursecond;

@property (nonatomic,strong)UIImage *snapshot;
@property (nonatomic,strong)NSString *WIFI_SSID;
@property (nonatomic,strong)NSLock *myLock;
@property (nonatomic,assign)BOOL isExist;
@property (nonatomic,assign)NSInteger resolution;
@property (nonatomic,assign)STATUS_TYPE statusType;
@property (nonatomic,assign)NSInteger speed;
@property (nonatomic,assign)NSInteger error;
@property (nonatomic,assign)NSInteger contrast;
@property (nonatomic,assign)NSInteger brightness;
@property (nonatomic,assign)NSInteger version;
@property (nonatomic,assign)NSInteger netMode;
@property (nonatomic,strong)NSString *DEV_SSID;
@property (nonatomic,assign) NSInteger setpassresult;
@property (nonatomic,strong)NSMutableArray *WIFIarray;


-(int)Rjone_PtzControl :(unsigned char) control
                       :(int) speed
                       :(int) step
                       :(int) point;

-(int)Rjone_SetParameter :(int)bit_field
                         :(char) resolution
                         :(char)contrast
                         :(char)brightness;

-(int)Rjone_SetEtc2;

-(int)Rjone_SetPassword :(char *)oldPasswd
                        :(char *)newPasswd;

-(int)Rjone_SetWifi :(int) Type
                    :(char *)SSID
                    :(char *)Password
                    :(char)enctype;

-(int)Rjone_ListWif;
-(int)Rjone_GetEtc2;
@end

