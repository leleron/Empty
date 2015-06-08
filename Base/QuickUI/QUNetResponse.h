//
//  QUNetworkResponse.h
//  CaoPanBao
//
//  Created by zhuojian on 14-6-17.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum _QUNetWorkResponseReason {
//	QUNetWorkResponseReasonOK,
//	QUNetWorkResponseReasonError
//} QUNetResponseReason;

#import "QUNetAdaptor.h"
#import "WpGlobalOption.h"

@class QUEntity;

@interface QUNetResponse : NSObject
{
    
}
@property (nonatomic, weak) QUNetAdaptor* pAdapter;
@property (nonatomic, assign) NSInteger pRetCode;
@property(nonatomic,assign)   QUServiceState pReason;
@property (nonatomic, strong) NSString* pRetString;
@property(nonatomic,strong)NSString* pRetServerTime;
@property (nonatomic, strong) id pData;
@property(nonatomic,strong) NSString* pJsonBody;
@property (nonatomic, strong) id pErrorData;
@property(nonatomic,strong) QUEntity* pEntity;

+(instancetype)response;
//@property(nonatomic,assign)QUNetResponseReason pReason;
@end