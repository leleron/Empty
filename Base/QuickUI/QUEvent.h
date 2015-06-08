//
//  QUEvent.h
//  WeiPay
//
//  Created by zhuojian on 14-3-24.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QUSection;

@protocol QUEvent <NSObject>

-(void)QUEvent:(QUEvent*)event reuseSection:(QUSection*)reuseSection withNewEntity:(Entity*)newEntity;

//-(void)QUEvent:(QUEvent*)event newSection:(QUSection*)section newEntity:(Entity*)newEntity;

@end
