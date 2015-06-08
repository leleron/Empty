//
//  QUMock.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-7.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "QUMock.h"
#import "QUNetManager.h"
#import "QUNetASIAdaptor.h"
#import "QUNetAdaptor.h"

#import "ViewControllerManager.h"

@implementation QUMockParam
+(instancetype)param{
   QUMockParam *param = [[self alloc] init];
//    param.interfaceType = @"YP";//夜盘
    return param;
}

@end

@interface QUMock()
@end

@implementation QUMock

+(instancetype)mock{
    return [[self alloc] init];
}

-(void)run:(QUMockParam *)param waitViewController:(UIViewController*)controller{
    
    [self run:param waitView:controller.navigationController.view];
}

- (void)run:(QUMockParam *)param waitView:(UIView *)waitView {
    [self run:param waitView:waitView withPoint:CGPointZero];
}

-(void)run:(QUMockParam *)param waitView:(UIView*)waitView withPoint:(CGPoint)point{
    if (point.y) {
        self.waitView = waitView;
        [[ViewControllerManager sharedManager] showWaitView:waitView withPoint:point];
    } else if(waitView) {
        self.waitView=waitView;
        [[ViewControllerManager sharedManager] showWaitView:waitView];
    }
    
    self.param=param;
    
    BOOL bMock=QU_MOCK==1?YES:NO;
    /*
     if(!self.isMock)
     {
     bMock=NO;
     }*/
    
    if(bMock)
    {
        //测试环境
        NSString* json=[self getMockJson];
        if(!json) // 未实现接口
        {
            [self test:param];
        }
        else{
            [self performSelector:@selector(delayMockCallback) withObject:nil afterDelay:[self delayMockInterval]];
        }
    }
    else //真实网络数据环境
        [self normal:param];
}

/** 延迟间隔(秒） */
-(double)delayMockInterval{
    return 1.f;
}

/**  请求超时 */
-(double)delayRequestTimeOut{
    return 30.f;
}


-(void)run:(QUMockParam*)param{
    [self run:param waitView:nil];
}

/** 模拟延迟调用 */
-(void)delayMockCallback{
    NSString* json=[self getMockJson];
    
    QUJsonParse *jsonParse = [[QUJsonParse alloc]init];
    
    QUEntity* e =[jsonParse objFromString:json withClass:[self getEntityClass] withMetmod:[self getAliasName]];
        
    QUNetResponse* response=[self getMockResponse];
    
    response.pEntity=e;
    
    response.pReason=[[WpGlobalOption sharedOption] serviceCallBackFromApp:response andShowMessage:NO];// 服务端请求返回状态判断，包括响应头，这种风险提示
    
    
    self.response=response;
    
    SEL selector=@selector(QUNetAdaptor:response:);
    
    [self performSelector:selector withObject:nil withObject:response];
    
    if(self.waitView)
        [[ViewControllerManager sharedManager] hideWaitView]; // 模拟网络请求结束，关闭提示
    
}


-(void)test:(QUMockParam*)param{
    
}

//-(BOOL)isMock{
//    return YES;
//}


-(void)normal:(QUMockParam*)param
{
    param.operationType=[self getOperatorType];
    
    QUNetAdaptor* adaptor=[self getAdaptor];
    
    adaptor.delegate=self;
    
    adaptor.delayTimeOut=[self delayRequestTimeOut];
    
    [adaptor request:param];
}


-(QUNetAdaptor*)getAdaptor{
    return [QUNetManager createAdaptor:[QUNetASIAdaptor class]];
}

-(NSString*)getOperatorType{
    return nil;
}

-(Class)getEntityClass{
    return nil;
}

-(NSDictionary*)getEntityMap{
    return @{};
}

-(NSString*)getAliasName{
    return nil;
}

#pragma mark - callback delegate
-(void)QUNetworkAdaptor:(QUNetAdaptor*)adaptor
{
    
    
}

-(NSString*)getMockJson{
    return nil;
}

-(QUNetResponse*)getMockResponse{
    QUNetResponse* response=[QUNetResponse response];
    response.pRetCode = 0;
    response.pReason=QU_SERVICE_BACK_OK;
    response.pRetServerTime=[NSString stringWithFormat:@"%d",(int)[NSDate timeIntervalSinceReferenceDate]];
    
    QUNetAdaptor* adaptor=[self getAdaptor];
    adaptor.operationType=[self getOperatorType];
    response.pAdapter=adaptor;
    
    return response;
}


@end
