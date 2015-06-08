//
//  WpBaseAdapter.m
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-10.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "WpBaseAdapter.h"
#import "Constant.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "WpCommonFunction.h"
#import "WpGlobalOption.h"
#import "WHStringHelper.h"
#import "NSString+MD5.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "commonFun.h"
#include "base64.h"
//#import "exitMock.h"
//#import "IFInfoEntity.h"
#pragma mark - WpResponse


@implementation WpResponse

@synthesize adapter;
@synthesize retCode;
@synthesize retString;
@synthesize data;
@synthesize errorData;

@end
#pragma mark - WpBaseAdapter

@interface WpBaseAdapter ()
{
    id target;
    SEL selector;
    ResponseBlock responseBlock;
    
}
@property(nonatomic,strong)NSString* body;
- (void)toCallback;
- (void)getRequestFinish:(ASIHTTPRequest*)request;
- (void)getRequestError:(ASIHTTPRequest*)request;
- (void)getPostContent:(ASIFormDataRequest*)request;


@end

@implementation WpBaseAdapter



- (id)initWithTarget:(id)_target selector:(SEL)_selector
{
    self = [super init];
    if (self) 
    {
        target = _target;
        selector = _selector;
        
        response = [[WpResponse alloc] init];
        response.adapter = self;
        
        paramDict = [[NSMutableDictionary alloc] init];
        
        needHttpScheme=[[NSMutableDictionary alloc] initWithCapacity:10];
        
        /** 以下接口，需采用http */
//        needHttpScheme=@{
//                         @"HHQ":@"1",
//                         @"HHQCHART":@"1",
//                         @"HSTATE":@"1",
//                         @"HTradeState":@"1"
//                         };
        
    }
    return self;
}

- (id)initWithResponse:(ResponseBlock)_responseBlock
{
    self = [super init];
    if (self)
    {
        responseBlock =_responseBlock;
        
        response = [[WpResponse alloc] init];
        response.adapter = self;
        
        paramDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self removeTarget];
}

- (void)removeTarget
{
    target = nil;
    responseBlock = nil;
}

//- (NSString*)getOperationType
//{
//    return @"";
//}

//- (void)getPostBody
//{
//    
//}

//- (void)getBigPostBody
//{
//    
//}

- (void)parseResponseRoot:(NSDictionary*)root
{
    response.data=root;
}

- (void)parseErrorResponseRoot:(NSDictionary*)root
{
    response.errorData=root;
//    id codeError=
}

//- (double)getTimeOutSeconds
//{
//    return 30.0;
//}

/**
 *  产品域名：openpro.jyzd.sina.com   对应96 8115
 用户域名：openuser.jyzd.sina.com    对应96 8116
 http://hqn.jyzd.sina.com/    晚上行情，黄金白银
 http://hqd.jyzd.sina.com/    早上行情，股票期指
 
 */

- (BOOL)isShowContent
{
    return YES;
}



- (void)main
{
    
    NSString *url2 = @"http://192.168.5.96:8115";
    NSString *url = @"http://192.168.5.96:8116";
    
#if defined(WP_TEST_SERVER) // 测试环境
    
    url2 = @"http://192.168.5.96:8115";
    url = @"http://192.168.5.96:8116";
    
#elif defined(WP_DEVELOP_SERVER) // 开发环境
    
    url2 = @"http://openpro.jyzd.sina.com";
    url = @"http://openuser.jyzd.sina.com";
    
#elif defined(WP_LINKTEST_SERVER) // 联调测试环境
    
#else // 生产环境
    
    url2 = @"http://openpro.jyzd.sina.com";
    url = @"http://openuser.jyzd.sina.com";
    
#endif
    
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:nil];
    
    NSString* strUrl = nil;
    
    [paramDict addEntriesFromDictionary:self.params];
    if ([self.sendMethod isEqualToString:@"GET"]) {
        [request setRequestMethod:@"GET"];
        strUrl = [strUrl stringByAppendingString:@"?"];
        NSArray* keys= [self.params allKeys];
        
        for (int i = 0; i<[keys count]; i++) {
            strUrl = [strUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[keys objectAtIndex:i],[self.params objectForKey:[keys objectAtIndex:i]]]];
        }
        
        strUrl = [strUrl substringToIndex:[strUrl length]-1];
        
    }
    else{
        [request setRequestMethod:@"POST"];
        [self getPostContent:request];
    }
    
    
    strUrl = BASE_URL;
    strUrl = [strUrl stringByAppendingString:self.operationType];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [request setURL:[NSURL URLWithString:strUrl]];
    
    WPNSLOG(@"leleron%@",self.operationType);
    
//    NSMutableDictionary* headDict = [NSMutableDictionary dictionaryWithCapacity:5];
//    NSString* did = [WpCommonFunction getUniqueDeviceIdentifier];
//    NSUserDefaults* session = [NSUserDefaults standardUserDefaults];
//    NSString* sseionid = [session valueForKey:JYZD_SESSION_ID];
//    NSString* uid = [session valueForKey:USER_ID];
    
    //设置响应头字符串
//    [headDict setObject:did?did:@"" forKey:@"x-qfgj-did"];
//    [headDict setObject:sseionid?sseionid:@"" forKey:@"x-qfgj-sid"];
//    [headDict setObject:uid?uid:@"" forKey:@"x-qfgj-uid"];
    
    
    [request setShouldContinueWhenAppEntersBackground:NO];
    // 设置超时时间
    request.timeOutSeconds = self.timeOutRequest;
    // 保存cookie，恢复登录状态
    [request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithArray:[WCFUser sharedUser].requestCookies]];
    
//    [request setRequestHeaders:headDict];
    [request startSynchronous];
    [self getRequestError:request];
}




- (void)toCallback
{
    if(responseBlock)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            responseBlock(response, self);
        });
    }
    else
    {
        if ([target respondsToSelector:selector])
        {
            [target performSelectorOnMainThread:selector withObject:response waitUntilDone:YES];
        }
    }
}

- (void)getRequestFinish:(ASIHTTPRequest*)request
{
    NSString* content = [request responseString];
    
    // 更新请求的cookies值
    [WCFUser sharedUser].requestCookies = request.responseCookies;
    
    if ([self isShowContent])
    {
        if (!([self.operationType isEqualToString:@"/v1/tpo/prices"] || [self.operationType isEqualToString:@"/v1/tpo/price"] || [self.operationType isEqualToString:@"/user/login_repeat"])) {
            
            WPNSLOG(@"############\ncontent: %@\nsdk operationType: %@\ncookiesResponse: %@\ncookiesRequest: %@", content, self.operationType, request.responseCookies, request.requestCookies);
        }
    }
    
    @try
    {
        if (request.responseStatusCode == 200 && nil != content && content.length > 0 && ![content isEqualToString:@"[]"])
        {
            NSDictionary* rootDict = [[request responseData] objectFromJSONData];
            
//            if ([self.operationType isEqualToString:@"/stock/buy_order"]) {
//                rootDict = @{@"p_id":content};
//            }
            
     //       NSArray* rootArray = [[request responseData] objectFromJSONData];   尝试用NSArray解析
            
            NSString *result = [[NSString alloc] initWithData:[request responseData]  encoding:NSUTF8StringEncoding];
            NSString* temp = @"\"id\"";
            NSRange range = [result rangeOfString:temp];
            if (range.length>0) {
                NSString *newString = [result stringByReplacingOccurrencesOfString:@"\"id\":" withString:@"\"ID\":"];   //将id转为ID
                NSData *newData = [newString dataUsingEncoding:NSUTF8StringEncoding];
                rootDict = [newData objectFromJSONData];
            }
            
            
            if ([result rangeOfString:@"\"init_fund\""].length) {
                
                NSString *newString = [result stringByReplacingOccurrencesOfString:@"\"init_fund\":" withString:@"\"Init_fund\":"];   //将id转为ID
                NSData *newData = [newString dataUsingEncoding:NSUTF8StringEncoding];
                rootDict = [newData objectFromJSONData];
            }
            
            if (range.length > 0 && [result rangeOfString:@"\"init_fund\""].length) {
                
                NSString *newString = [result stringByReplacingOccurrencesOfString:@"\"id\":" withString:@"\"ID\":"];   //将id转为ID
                newString = [newString stringByReplacingOccurrencesOfString:@"\"init_fund\":" withString:@"\"Init_fund\":"];   //将id转为ID
                NSData *newData = [newString dataUsingEncoding:NSUTF8StringEncoding];
                rootDict = [newData objectFromJSONData];
            }
            
            
            
            
         //   NSDictionary* headDict = [rootDict objectForKey:@"head"];
            
//            if ([headDict class] == [NSNull class])
//            {
//                response.retCode = @"99998";
//                response.retString = NSLocalizedString(@"ServiceCallError3", @"");
//            }
      //      else
    //        {
                response.retCode = [[WpCommonFunction JsonStringFromDict:rootDict andKey:@"error_code"] intValue];
                response.retString = [WpCommonFunction JsonStringFromDict:rootDict andKey:@"error_msg"];
             //   response.retServiceTime=[WpCommonFunction JsonStringFromDict:headDict andKey:@"serverTime"];
                response.sessionId = [WpCommonFunction JsonStringFromDict:rootDict andKey:@"session_id"];
            
            
            if (![response.sessionId isEqualToString:@""]) {
//                NSUserDefaults* sessionId = [NSUserDefaults standardUserDefaults];
//                [sessionId setObject:response.sessionId forKey:JYZD_SESSION_ID];
            }
            
     //异地设备请求拦截
            
            if (response.retCode == 110006) {
                
//                exitParam* param = [exitParam param];
//                exitMock* mock = [exitMock mock];
//                [mock run:param];    //发出退出请求
//


                
            }
            
    
                if (response.retCode)
                {
                  //  NSDictionary* body = [rootDict objectForKey:@"body"];
                    
                    if([WHStringHelper isNilByValue:rootDict]==YES)
                    {
                   //     body=nil;
                    }
                    else{
                        response.jsonBody= [rootDict JSONString];
                    }
                    
                    [self parseResponseRoot:rootDict];
                }
                else
                {
              //      NSDictionary* body = [rootDict objectForKey:@"body"];
                    
                    if([WHStringHelper isNilByValue:rootDict]==YES)
                    {
                      //  body=nil;
                    }
                    else{
                        response.jsonBody= [rootDict JSONString];
                    }
                    
                    [self parseErrorResponseRoot:rootDict];
                }
   //         }
        }
        else
        {
            response.retCode = request.responseStatusCode;
            response.retString = NSLocalizedString(@"网络异常，请检查你的手机是否联网", @"");
        }
    }
    @catch (NSException* e)
    {
     //   response.retCode = @"99998";
        response.retString = NSLocalizedString(@"服务请求异常", @"");
    }
    @finally
    {
        
    }
    

    [self toCallback];
}

- (void)getRequestError:(ASIHTTPRequest*)request
{
    NSError *error = [request error];
    
//    if ([self.operationType isEqualToString:@"pankouInterface"] || [self.operationType isEqualToString:@"chartInterface"]) {
//        WPNSLOG(@"发现错误啦!");
//    }
//    
    if (error)
    {
        WPNSLOG(@"error: %@", error);
        
        if([error code] == ASIRequestTimedOutErrorType) 
        {
            response.retCode = 99999;
            response.retString = NSLocalizedString(@"ServiceCallError1", @"");
        }
        else 
        {
            
//            response.retCode = [NSString stringWithFormat:@"%d", request.responseStatusCode];
            if (request.responseStatusCode != 0) {
                response.retString = NSLocalizedString(@"ServiceCallError2", @"");
            }
        }
        
        [self toCallback];
    }
    else 
    {
        [self getRequestFinish:request];
    }
}

- (void)getPostContent:(ASIFormDataRequest*)request
{
//    [self getPostBody];
    
//    [paramDict addEntriesFromDictionary:self.params];
//    [paramDict setDictionary:self.params];
    
    // 增加固定参数
    // 请求服务标识
//    [paramDict setObject:self.operationType forKey:@"operationType"];
//    // 应用版本
//    [paramDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
//    // 应用平台 1 iphone 2 android
//    [paramDict setObject:@"1" forKey:@"platformType"];
//    // 应用类别 1表示app 2表示sdk  3表示操盘宝
//    [paramDict setObject:@"1" forKey:@"appType"];
//    // 设备唯一标识
//    [paramDict setObject:kShareAppDelegate.deviceUdid forKey:@"deviceIdentify"];
//    // 设备Mac地址
//    [paramDict setObject:[WpCommonFunction wpUniqueDeviceIdentifier] forKey:@"macAddr"];
//    // 客户端请求时间 客户端使用从1970-1-1 00:00:00到现在的毫秒数
//    [paramDict setObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000] forKey:@"reqTime"];
//    // 本地化信息 目前客户端填写zh_CN, 目前的处理方法是,无论客户端填写什么都转成zh_CN
//    [paramDict setObject:@"zh_CN" forKey:@"locale"];
//    // 设备信息收集hash
//    [paramDict setObject:[[WpGlobalOption sharedOption] getDeviceHashValue] forKey:@"hashValue"];
//    // app 下载 渠道id
//    [paramDict setObject:@"20" forKey:@"channelId"];
//
//    [paramDict setObject:@"1" forKey:@"x-qfgj-sid"];
//    [paramDict setObject:@"1" forKey:@"x-qfgj-uid"];
//    [paramDict setObject:@"1" forKey:@"x-qfgj-did"];
//    [paramDict setObject:@"2" forKey:@"x-qfgj-rid"];
//    [paramDict setObject:@"2" forKey:@"x-qfgj-rtime"];
//    [paramDict setObject:@"ba035678685a46adee051dca85be88ea" forKey:@"x-qfgj-contentmd5"];
//    [paramDict setObject:@"Y2RmNTFhZmJlYjE5N2MzNWM2MjhhOGRiMmNjNDM1NjEwMGMyMzc1Zg%3D%3D" forKey:@"x-qfgj-signature"];
    WPNSLOG(@"Sdk post body: %@", paramDict);
    
    
 //   NSArray* keyArray = [paramDict allKeys];
//    for (NSString* key in keyArray) 
//    {
//        [request setPostValue:[paramDict objectForKey:key] forKey:key];
//    }
  //  QUJsonParse* parse = [[QUJsonParse alloc]init];
    if ([paramDict count] != 0) {
    
        NSString* jsonStr = [paramDict JSONString];
        NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        [request setPostBody:tempJsonData];
        self.body = jsonStr;

    }
}


- (NSString *)hmacSha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
 //   NSString *hash = [HMAC base64String];
    NSString *hash = [[NSString alloc] initWithData:HMAC encoding:NSASCIIStringEncoding];

    return hash;
}


//- (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
//
//{
//    
//    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    
//    uint8_t cHMAC[16];
//    
//    
//    
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    
//    
//    
//    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
//    
//    NSString *hash;
//    
//    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < 16; i++)
//        
//        [output appendFormat:@"%02x", cHMAC[i]];
//    
//    hash = output;
//    
//    
//    
//    return hash;
//    
//}
- (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
    
//    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
//    unsigned char result[20];
//    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
//    char base64Result[32];
//    size_t theResultLength = 32;
//    Base64EncodeData(result, 20, base64Result, &theResultLength,YES);
//    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
//    NSString* hash = [theData base64Encoding];
// //   NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
//    return hash;
    return nil;
}



#pragma mark - netflow count
//static long long send_bytes=0;
//-(void)countSendNetFlow:(NSDictionary*)dict
//{
//    
//}
//
//-(void)countRecvNetFlow:(NSDictionary*)dict{
//
//}

@end
