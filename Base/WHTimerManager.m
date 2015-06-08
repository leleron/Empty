//
//  CPBTimerManager.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-7.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "WHTimerManager.h"
#import <objc/runtime.h>
#import "MyViewController.h"
#import "WHGlobalHelper.h"
#import "WHOnceTask.h"
@implementation WHTimerManager
static WHTimerManager* _shareTimerManager;
+(id)shareTimerManager{
    if(!_shareTimerManager)
    {
        _shareTimerManager=[[WHTimerManager alloc] init];
    }
    return _shareTimerManager;
}

-(id)init{
    self=[super init];
//    self.pNotifycationArray=[[NSMutableArray alloc] initWithCapacity:20];
//    self.pDeletedArray=[[NSMutableArray alloc] initWithCapacity:20];
    self.pNotifyDict=[[NSMutableDictionary alloc] initWithCapacity:20];
    
    self.pDiabledDict=[[NSMutableDictionary alloc] initWithCapacity:20];
    
    [self runloop];
    
    return self;
}

-(BOOL)hasNotifyName:(NSString*)notifyName
{
    return [self.pNotifyDict objectForKey:notifyName]?YES:NO;
}

-(void)addTarget:(id)target selector:(SEL)selector notifyName:(NSString*)notifyName{
    if([self.pNotifyDict objectForKey:notifyName])
    {
        NSLog(@"notifyName 已存在!");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:notifyName object:nil];
  
    [self.pNotifyDict setObject:notifyName forKey:notifyName];
}

-(void)removeTarget:(id)target notifyName:(NSString*)notifyName
{
    [[NSNotificationCenter defaultCenter]removeObserver:target name:notifyName object:nil];
    [self.pNotifyDict removeObjectForKey:notifyName];
}

/** 禁止通知 */
-(void)disabledNotify:(NSString *)notify{
    [self.pDiabledDict setObject:notify forKey:notify];
}

/** 解禁通知 */
-(void)enabledNotify:(NSString*)notify
{
    [self.pDiabledDict removeObjectForKey:notify];
}

/** 循环调度方法 */
-(void)runloop{
    NSMutableArray* forArray=[NSMutableArray arrayWithCapacity:[self.pNotifyDict count]];
    for (id obj in self.pNotifyDict) {
        [forArray addObject:obj];
    }
    
    for (NSString* notifyName in forArray) {
        if([self.pNotifyDict objectForKey:notifyName])
        {
            if([self.pDiabledDict objectForKey:notifyName]==nil) // 此通知状态未暂停
            {
                NSNumber* expire=[[WHGlobalHelper shareGlobalHelper] get:WH_GLOBAL_EXPIRE_SESSION defValue:@(0)];
                if([expire intValue]==0)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:nil userInfo:nil];
                }
            }
        }
    }
    
    [self performSelector:@selector(runloop) withObject:nil afterDelay:1]; // 循环调用
}

-(void)removeAll{
    [self.pDiabledDict removeAllObjects];
    [self.pNotifyDict removeAllObjects];
}

-(void)test{
    /**
     例子
     */
    
    
    
    // 添加监听对象，和回调方法
    [[WHTimerManager shareTimerManager] addTarget:self selector:@selector(testCallback) notifyName:CPB_TIME_MANAGER_ORDER_MARKET];
    
    
    // 移除监听对象
    [[WHTimerManager shareTimerManager] removeTarget:self notifyName:CPB_TIME_MANAGER_ORDER_MARKET];
}

// 回调方法
-(void)testCallback
{
    if([[WHOnceTask shareOnceTask] expired:CPB_ONCETASK_HQ_KEY validTime:CPB_ONCETASK_HQ_VAL])
    {
         // ...
    }
}

@end
