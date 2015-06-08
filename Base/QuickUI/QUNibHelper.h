//
//  QUNibHelper.h
//  WeiPay
//
//  Created by zhuojian on 14-3-25.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QUNibHelper : NSObject
+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass;
+ (NSArray*)loadNibNamed:(NSString *)nibName;
+ (id)loadNibArray:(NSArray *)nibArray ofClass:(Class)objClass;

#pragma mark - instance
- (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass;
- (id)loadNibArray:(NSArray *)nibArray ofClass:(Class)objClass;


@end


