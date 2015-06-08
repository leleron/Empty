//
//  DelegateCamera.h
//

#import <Foundation/Foundation.h>

@protocol DelegateCamera <NSObject>
    - (void) refreshFrame:(uint8_t *)imgData withVideoWidth:(NSInteger)width videoHeight:(NSInteger)height withObj:(NSObject *)obj;
    - (void) updateRecvIOCtrl:(int)ioType withIOData:(char *)pIOData withSize:(int)nIODataSize withObj:(NSObject *)obj;

    - (void) refreshSessionInfo:(int)infoCode withObj:(NSObject *)obj withString:(NSString *)strValue;

    - (void) refreshSessionInfo:(NSInteger)mode 
                       OnlineNm:(NSInteger)onlineNm
                     TotalFrame:(NSInteger)totalFrame
                           Time:(NSInteger)time_s;



-(void)postVideoStartResp:(int)type;
-(void)postVideoStopResp:(int) type;
//-(void)postAudioStopResp:(int)type;



-(void) changedevpass:(int) value;

- (void)postH264DecodeData:(unsigned char*)data anddatasize:(int) length;   //141128 EngelChen



@end
