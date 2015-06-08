//
//  CPBNotifyManager.h
//  CaoPanBao
//
//  Created by zhuojian on 14-6-25.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WH_NOTIFY_MANAGER_RULETYPE_SELECTED_ERROR @"WH_NOTIFY_MANAGER_RULETYPE_SELECTED_ERROR" // 方案选择错误触发UI获取新方案

#define WH_NOTIFY_DISCOVER_LIFE_INDEX_CHANGED @"WH_NOTIFY_DISCOVER_LIFE_INDEX_CHANGED" // 首页内容变更，重新加载数据
#define WH_NOTIFY_DISCOVER_LIFE_DETAIL_CHANGED @"WH_NOTIFY_DISCOVER_LIFE_DETAIL_CHANGED" // 缴费详情页变更，重新加载数据

#define WH_NOTIFY_LOGIN_SUCCESS @"WH_NOTIFY_LOGIN_SUCCESS"      // 登录成功后的消息通知

#define WH_NOTIFY_BINGDED_WEIBO @"WH_NOTIFY_BINGDED_WEIBO"      // 绑定微博成功后的通知

@interface WHNotifyManager : NSObject
+(WHNotifyManager*)shareNotifyManager;

/**
 添加通知
 @param target 通知目标对象
 @param selector 回调选择器
 @param notifyName 通知别名
 */
-(void)addNotificationTarget:(id)target selector:(SEL)selector notifyName:(NSString*)notifyName;

/**
 移除通知
 @param target 移除目标对象通知
 @param notifyName 移除的通知别名
 */
-(void)removeNotificationTarget:(id)target notifyName:(NSString*)notifyName;

/**
 是否有通知
 @param notifyName 通知别名
 */
-(BOOL)hasNotifyName:(NSString*)notifyName;

/**
 发送通知
 @param notifyName 通知别名
 */
-(void)postNotify:(NSString*)notifyName;


@property(nonatomic,strong)NSMutableDictionary* pNotifyDict;
@end
