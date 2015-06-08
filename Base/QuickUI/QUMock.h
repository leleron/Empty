//
//  QUMock.h
//  CaoPanBao
//
//  Created by zhuojian on 14-5-7.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QUNetAdaptor.h"

@class QUEntity;
@class QUMock;
@class QUNetResponse;


@protocol QUMockDelegate<NSObject>
@optional
-(void)QUMock:(QUMock*)mock entity:(QUEntity*)entity;
@end

@interface QUMockParam : NSObject
/** 网络接口名称 */
@property(nonatomic,strong)NSString* operationType;
@property(strong,nonatomic)NSString* sendMethod;      //POST还是GET方法
+(instancetype)param;
@end

@interface QUMock : NSObject<QUNetAdaptorDelegate>
@property(nonatomic,strong)QUNetResponse* response;
@property(nonatomic,weak)id<QUMockDelegate> delegate;
@property(nonatomic,strong)QUMockParam* param;
+(instancetype)mock;
-(void)normal:(QUMockParam*)param;
-(void)test:(QUMockParam*)param;
-(void)run:(QUMockParam*)param;
-(void)run:(QUMockParam *)param waitView:(UIView*)waitView;
-(void)run:(QUMockParam *)param waitView:(UIView*)waitView withPoint:(CGPoint)point;//可调节高度
-(void)run:(QUMockParam *)param waitViewController:(UIViewController*)controller;
//-(BOOL)isMock;
@property(nonatomic,weak)UIView* waitView;

-(NSString*)getOperatorType;

-(QUNetAdaptor*)getAdaptor;

-(NSDictionary*)getEntityMap;

-(Class)getEntityClass;

-(NSString*)getMockJson;

-(QUNetResponse*)getMockResponse;

/** 延迟模拟转圈间隔(默认1秒） */
-(double)delayMockInterval;

/**  网络请求超时(默认30秒) */
-(double)delayRequestTimeOut;

/** 设置别名 */
-(NSString*)getAliasName;
@end
