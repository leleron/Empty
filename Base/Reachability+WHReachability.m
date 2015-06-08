//
//  Reachability+WHReachability.m
//  CaoPanBao
//
//  Created by 余龙 on 14-10-15.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "Reachability+WHReachability.h"

@implementation Reachability (WHReachability)
+(Reachability *) reachabilityNetwork{
    return  [Reachability reachabilityWithHostName:@"www.sina.com.cn"];
}

@end
