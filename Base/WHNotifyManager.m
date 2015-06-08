//
//  CPBNotifyManager.m
//  CaoPanBao
//
//  Created by zhuojian on 14-6-25.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "WHNotifyManager.h"

@implementation WHNotifyManager
static WHNotifyManager* shareNotifyManager;
+(WHNotifyManager*)shareNotifyManager{
    if(!shareNotifyManager)
    {
        shareNotifyManager=[[WHNotifyManager alloc] init];
    }
    
    return shareNotifyManager;
}

/**
 是否有通知
 @param notifyName 通知别名
 */
-(BOOL)hasNotifyName:(NSString*)notifyName
{
    return [self.pNotifyDict objectForKey:notifyName]?YES:NO;
}

/**
 添加通知
 @param target 通知目标对象
 @param selector 回调选择器
 @param notifyName 通知别名
 */
-(void)addNotificationTarget:(id)target selector:(SEL)selector notifyName:(NSString*)notifyName{
    if([self.pNotifyDict objectForKey:notifyName])
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:notifyName object:nil];
    
    [self.pNotifyDict setObject:notifyName forKey:notifyName];
}

/**
 移除通知
 @param target 移除目标对象通知
 @param notifyName 移除的通知别名
 */
-(void)removeNotificationTarget:(id)target notifyName:(NSString*)notifyName
{
    [[NSNotificationCenter defaultCenter]removeObserver:target name:notifyName object:nil];
    [self.pNotifyDict removeObjectForKey:notifyName];
}

/**
 发送通知
 @param notifyName 通知别名
 */
-(void)postNotify:(NSString*)notifyName{
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:nil userInfo:nil];
}

@end
