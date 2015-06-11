//
//  QUNetWorkASIAdaptor.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-27.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUNetASIAdaptor.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "WpBaseAdapter.h"
#import "QUJsonParse.h"
#import "WpGlobalOption.h"
#import "QUNetResponse.h"
#import "QUURLDownLoadParams.h"


@implementation QUNetASIAdaptor
-(void)request:(QUMockParam *)params{
    WpBaseAdapter* adaptor=[[WpBaseAdapter alloc] initWithTarget:self selector:@selector(responseCallback:)];
    
    adaptor.timeOutRequest=self.delayTimeOut;
    
    QUJsonParse* parse=[[QUJsonParse alloc] init];
    adaptor.params=[parse dictionaryFromObjc:params];
    adaptor.operationType=params.operationType;
    adaptor.sendMethod = params.sendMethod;
    [[WpGlobalOption sharedOption] executeUrlOperation:adaptor];
}

#pragma mark - WPBaseAdaptor delegate
-(void)responseCallback:(WpResponse *)wpResponse
{
    QUNetResponse* response=[[QUNetResponse alloc] init];
    response.pAdapter=self;
    response.pData=wpResponse.data;
    response.pErrorData=wpResponse.errorData;
    response.pRetCode=wpResponse.retCode;
    response.pRetString=wpResponse.retString;
    response.pJsonBody=wpResponse.jsonBody;
    response.pRetServerTime=wpResponse.retServiceTime;
    
    QUMock* mock=(QUMock*)self.delegate;
    
    response.pAdapter.operationType=[mock getOperatorType];
    
    response.pReason=[[WpGlobalOption sharedOption] serviceCallBackFromApp:response andShowMessage:YES];
    
    Class cls=[mock getEntityClass];

    response.pEntity=[[[QUJsonParse alloc] init] objFromString:response.pJsonBody withClass:cls withMetmod:[mock getAliasName]];

    
    mock.response=response;
    [self.delegate QUNetAdaptor:self response:response];
    
    if(mock.waitView)
     [[ViewControllerManager sharedManager] hideWaitView]; // 网络请求结束，关闭提示

}

//是否是纯数字
- (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"^([0-9])+$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
    
}



@end

@interface QUNetASIDownLoadAdaptor()
@property(nonatomic,strong)id mydelegate;
@end

@implementation QUNetASIDownLoadAdaptor
@synthesize mydelegate;


-(void)request:(QUURLDownLoadParams *)params{
    if (self.delegate) {
        mydelegate = self.delegate;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:((QUURLDownLoadParams*)params).downLoadUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                QUNetResponse* response=[[QUNetResponse alloc] init];
                response.pData = @{[NSNumber numberWithInteger:params.tag]: data};
                [mydelegate QUNetAdaptor:self response:response];
            }
        });
        
    });
}
@end