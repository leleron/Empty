//
//  RJONE_LibCallBack.h
//  RJONE_macvideo
//
//  Created by RJONE on 15/3/16.
//  Copyright (c) 2015年 RJONE. All rights reserved.
//

#ifndef RJONE_LibCallBack_h
#define RJONE_LibCallBack_h


#ifdef __cplusplus
extern "C"
{
#endif
#define LIB_API_API
#define LIB_CALLBACK
#define LIBCALLBACK
    
    
    //NSlog
#define DEBUGEd  0
#ifdef DEBUGEd
# define DLog(fmt, ...) NSLog((@"[文件名:%s]" "[函数名:%s]\n" "[行号:%d] " fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
    
#else
# define DLog(...);
#endif
    
    //Error
    
#define ERR_DCAM_SUCCESSFUL							0
#define ERR_DCAM_NOT_INITIALIZED					-1
#define ERR_DCAM_ALREADY_INITIALIZED				-2
#define ERR_DCAM_TIME_OUT							-3
#define ERR_DCAM_INVALID_ID							-4
#define ERR_DCAM_INVALID_PARAMETER					-5
#define ERR_DCAM_DEVICE_NOT_ONLINE					-6
#define ERR_DCAM_FAIL_TO_RESOLVE_NAME				-7
#define ERR_DCAM_INVALID_PREFIX						-8
#define ERR_DCAM_ID_OUT_OF_DATE						-9
#define ERR_DCAM_NO_RELAY_SERVER_AVAILABLE			-10
#define ERR_DCAM_INVALID_SESSION_HANDLE				-11
#define ERR_DCAM_SESSION_CLOSED_REMOTE				-12
#define ERR_DCAM_SESSION_CLOSED_TIMEOUT				-13
#define ERR_DCAM_SESSION_CLOSED_CALLED				-14
#define ERR_DCAM_REMOTE_SITE_BUFFER_FULL			-15
#define ERR_DCAM_USER_LISTEN_BREAK					-16
#define ERR_DCAM_MAX_SESSION						-17
#define ERR_DCAM_UDP_PORT_BIND_FAILED				-18
#define ERR_DCAM_USER_CONNECT_BREAK					-19
#define ERR_DCAM_SESSION_CLOSED_INSUFFICIENT_MEMORY	-20
    
#define ERR_DCAM_FAIL_CREATE_THREAD					-501
#define ERR_DCAM_REACH_MAX_CONN_NUM					-502
#define ERR_DCAM_WRONG_PASSWORD						-503
#define ERR_DCAM_RECV_DATA_NOT_READY				-504
    
    //Type
    
    typedef int INT32;
    typedef unsigned int UINT32;
    
    typedef short INT16;
    typedef unsigned short UINT16;
    
    typedef char CHAR;
    typedef signed char	 SCHAR;
    typedef unsigned char UCHAR;
    
    typedef long LONG;
    typedef unsigned long ULONG;
    
    typedef struct _IPC_CALLSEARCH_RESP //save as little endian
    {
        unsigned char cmd_id[4];
        unsigned char result;
        unsigned char reserve[3];
        
        unsigned char core_ver[4];	//kernel version e.g.:2.6.26.0  core_ver[0,1,2,3]=0,26,6,2
        unsigned char sys_ver[4];	//p2p program version. Refer to above
        unsigned char p2papi_ver[4];//P2P api version. Refer to above
        unsigned char web_ver[4];	//web service version. Refer to above
        
        unsigned char  dev_id[20];	//device ID
        unsigned short dev_web_port;//web service port
        unsigned short dev_p2p_port;//p2p port
        unsigned char  dev_mac[6];  //e.g.: 00:0C:29:84:46:1F  dev_mac[0,1,2,3,4,5]=00,0C,29,84,46,1F
        unsigned char  dev_isStaticIP;//0: no static ip(DHCP); 1: yes
        unsigned char  dev_network_mode; //0: AP WiFi mode; 1: Network card mode ; 2: AP + Network card
        
        unsigned char  dev_ip[4];			//device ip   //e.g.:192.168.1.100  dev_ip[0,1,2,3]=100,1,168,192
        unsigned char  dev_subnet_mask[4];	//device subnet mask
        unsigned char  dev_gateway[4];		//device gateway. Refer to device ip
        unsigned char  dev_dns1[4];
        unsigned char  dev_dns2[4];
        unsigned char  reserv2[4];
        
        unsigned char  dev_ssid[64];//added 2013-01-20
        unsigned char  dev_sn[20];  //added 2012-06-28
        unsigned char  reserve3[4]; //2013-01-20
    }SEARCH_CALL_RESP;
    
    
    typedef struct{
        unsigned short nCodecID;	//refer to DCAM_V_CODECID or DCAM_A_CODECID
        unsigned char   nOnlineNum;
        unsigned char   flag;		//Video:=DCAM_VFRAME; Audio:=(DCAM_AUDIO_SAMPLERATE << 2) | (DCAM_AUDIO_DATABITS << 1) | (DCAM_AUDIO_CHANNEL)
        unsigned char   nSizeSpeexPacket;//size of one speex packet when audio is speex
        unsigned char   tag;			//0=live audio&video; 1=playback audio&video
        unsigned char   reserve[2];
        
        unsigned int nDataSize;
        unsigned int nTimeStamp;	//system tick
    }st_AVLibDataInfo;
    
    
#pragma mark - LibCallBack.h methods
    
    typedef void (LIB_CALLBACK *OnCallBackDataIO)(int type, void *array,void *pUserData); //IO
    
    typedef void (LIB_CALLBACK *OnCallBackDataAV)(char nDataType,void *pAVData, int nAVDataSize, void *pUserData);// AVT
    
    int RJONE_Send(int Handle,int orderType,char* sendData,int sendlen,int chan,int IOtype);
    
    SEARCH_CALL_RESP *RJONE_LibSearch (int num , int timeout ,int *count);
    
    //    int RJONE_LibSearch (int num , int timeout);
    //    SEARCH_CALL_RESP *RJONE_LibSearchData (int *count );
    
    LIB_API_API int LIBCALLBACK RJONE_Lib_Init(int connectType ,void *puserdata);
    
    int RJone_DeInit;
    
    void RJONE_Lib_set_cb(int handle,OnCallBackDataIO onIODatahandcall, OnCallBackDataAV onAVTDatahandcall,void *puserdata);
    
    int RJONE_LibConnect(int netType,int connectType,char *did,char *pwd,int timeout);
    
    int RJONE_LibDisconnect(int handle);
    
    int  RJONE_LiB_checkStatus(int handle);
    
    int RJONE_LibSethandle (int handle);
    
    int RJONE_LibOpenVideo (int handle);
    int RJONE_LibStopVideo (int handle);
    
    int RJONE_LibOpenAudio ( int handle);
    int RJONE_LibStopAudio (int handle);
    
    int RJONE_LibStartSpeak( int handle, unsigned short nCodeID);
    int RJONE_LibStopSpeak (int handle);
    
    int RJONE_LiBListWifi (int handle);
    
    int RJONE_LiBSetWifi (int handle,int Type,char *SSID,char *Password,unsigned char enctype);
    
    int RJONE_LiBPtzCommand (int handle,unsigned char control,int speed,int step,int point);
    
    int RJONE_LiBGetEtc2 (int handle);
    
    int RJONE_LiBSetDevTimezone (int handle,int zoneValue);
    
    int RJONE_LiBSetDevParameter(int handle,int bit_field,char resolution,int bit_stream,char fps,char contrast, char brightness);
    
    int RJONE_LiBGetDevParameter (int handle,int bit_field);
    
    int RJONE_LiBRecordPlaycontrol ( int handle,int command,int param,int year,char month,char day,char hour,char minute,char second,char week,int tmp);
    
    int RJONE_LiBSetDevPassword (int handle, char *oldDevPasswd,
                                 char *newDevPasswd);
    
    int RJONE_LiBGetStatus (int handle, int bit_field,char isManuRec);
    
    int RJONE_LiBGetTimeFromPhone (int handle,int year,int month,int day,int hour,int minute,int second,int week);
    
    int RJONE_LiBSetTimeFromPhone (int handle, int year,int month,int day,int hour,int minute,int second,int week);
    
    int RJONE_LiBGetSysVer (int handle);
    
    int RJONE_LiBCleanTime (int handle , unsigned char day,unsigned char hour,unsigned char minute,unsigned char curweek, unsigned char curhour, unsigned char curminute, unsigned char cursecond );
    
    int RJONE_LiBInquCharType (int handle);
    
    int RJONE_LiBInquBattCapacity (int handle);
    
    
#ifdef __cplusplus
}

#endif
#endif
