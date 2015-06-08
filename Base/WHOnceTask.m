//
//  CPBOnceTask.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-7.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "WHOnceTask.h"

@implementation WHOnceTask
static WHOnceTask* _shareOnceTask;



+(WHOnceTask*)shareOnceTask{
    if(!_shareOnceTask)
    {
        _shareOnceTask=[[WHOnceTask alloc] init];
    }
    
    return _shareOnceTask;
}

-(id)init{
    self=[super init];
    taskDict=[[NSMutableDictionary alloc ] init];
    return self;
}


-(void)validTask:(NSString*)taskName{
    [taskDict setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:taskName];
    
    
}


/**
 任务过期
 @return YES 过期，触发任务 NO 不过期，不触发任务
 */
-(BOOL)expired:(NSString *)key validTime:(double)validTime{

    
    NSNumber* number=taskDict[key];
    
    if(!number)
        number=[NSNumber numberWithDouble:0];
    
    double time=[number doubleValue];
    
    double now= [[NSDate date] timeIntervalSince1970];
    
    double seconds=now-time;
    
//    double seconds=interval/1000.f;
    
    if(seconds>=validTime)
    {
        [self validTask:key]; // 更新有效时间
        return YES;
    }
    
    return NO;
}


-(void)removeTask:(NSString*)key{
    if([taskDict objectForKey:key])
        [taskDict removeObjectForKey:key];

}

-(void)removeAll{
    [taskDict removeAllObjects];
}


@end
