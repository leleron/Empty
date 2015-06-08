//
//  QUNetowrkAdaptor.h
//  CaoPanBao
//
//  Created by zhuojian on 14-5-27.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QUMockParam;
@class QUMock;
@class QUNetAdaptor;
@class QUNetResponse;

@protocol QUNetAdaptorDelegate <NSObject>
@optional
-(void)QUNetAdaptor:(QUNetAdaptor*)adaptor response:(QUNetResponse*)response;
@end

@interface QUNetAdaptor : NSObject
-(void)request:(QUMockParam*)params;
@property(nonatomic,weak)id<QUNetAdaptorDelegate> delegate;
@property(nonatomic,strong)NSString* operationType;
@property(nonatomic,assign)double delayTimeOut;
@end
