//
//  QUNetworkManager.h
//  CaoPanBao
//
//  Created by zhuojian on 14-5-27.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QUNetAdaptor;
@interface QUNetManager : NSObject
+(QUNetManager*)shareNetworkManager;
+(QUNetAdaptor*)createAdaptor:(Class)cls;
@end
