//
//  CPBTimerManager.h
//  CaoPanBao
//
//  Created by zhuojian on 14-5-7.
//  Copyright (c) 2014年 Mark. All rights reserved.
//


#define WCF_TIME_MANAGER_MESSAGECODE @"WCF_TIME_MANAGER_MESSAGECODE" // 短信发送按钮倒计时
#define WCF_TIME_BEGINSALE @"WCF_TIME_BEGINSALE" // 理财产品开始发售倒计时

/** 操盘行情定时器通知 */
#define CPB_TIME_MANAGER_ORDER_MARKET @"CPB_TIME_MANAGER_ORDER_MARKET" // 分时图，行情数据
#define CPB_TIME_MANAGER_PHJ_ORDER_LIST @"CPB_TIME_MANAGER_PHJ_ORDER_LIST" //黄金订单列表
#define CPB_NOTIFY_MANAGER_RULETYPE_SELECTED_ERROR @"CPB_NOTIFY_MANAGER_RULETYPE_SELECTED_ERROR" // 方案选择错误触发UI获取新方案

#define CLALLBACK_ORDER_STATE @"CLALLBACK_ORDER_STATE" //订单状态回调

#define CPB_TIME_MANAGER_PHJ_ORDERCREATE @"CPB_TIME_MANAGER_PHJ_ORDERCREATE" //黄金下单页面

//股票
//定时器通知
#define JYZD_TIME_MANAGER_STO_NEWBUY @"JYZD_TIME_MANAGER_STO_NEWBUY"//玩家最新买入个股
#define CPB_TIME_MANAGER_STO_STOCKDETAIL @"CPB_TIME_MANAGER_STO_STOCKDETAIL" //个股详情页面
#define JYZD_TIME_STO_BUY_CONFRIM @"JYZD_TIME_STO_BUY_CONFRIM" //股票点买确认页
#define CPB_TIME_MANAGER_ORDER_ORDER_LIST @"CPB_TIME_MANAGER_ORDER_ORDER_LIST" // 股票订单列表刷新
#define JYZD_TIME_STO_BUY_CHANGE_TRRIGER @"JYZD_TIME_STO_BUY_CHANGE_TRRIGER" //点买带触发
#define JYZD_TIME_STO_TRRIGER_HQ @"JYZD_TIME_STO_TRRIGER_HQ" //修改触发价行情

#define JYZD_TIME_STO_SELL_LIST @"JYZD_TIME_STO_SELL_LIST" //点卖列表
#define STO_TIME_MANAGER_STO_ORDERCRATE @"STO_TIME_MANAGER_STO_ORDERCRATE"

#define JYZD_TIME_STO_GTAPH @"JYZD_TIME_STO_GTAPH" //图
#define STO_SELL_OPERATION_VIEW @"STO_SELL_OPERATION_VIEW" //点卖操作页（点卖行情界面）
#define JYZD_TIME_SELL_CONFIRM @"JYZD_TIME_SELL_CONFIRM" //点卖确认页




//期指定时器通知
#define JYZD_TIME_IF_BUY_CONFIRM @"JYZD_TIME_IF_BUY_CONFIRM"   //期指点买确认

/** 定时通知管理类 */
@interface WHTimerManager : NSObject
{
    
}
+(WHTimerManager*)shareTimerManager;

/**
 添加通知监听
 @param target 添加的目标对象
 @param selector 目标选择器
 @param notifyName 通知名称
 */
-(void)addTarget:(id)target selector:(SEL)selector notifyName:(NSString*)notifyName;

/**
 移除通知监听
 @param target 移除的目标对象
 @param notifyName 移除的通知名称
 */
-(void)removeTarget:(id)target notifyName:(NSString*)notifyName;

/**
 是否监听了此通知
 @param notifyName 通知名称
 @return YES 有监听，NO 无监听
 */
-(BOOL)hasNotifyName:(NSString*)notifyName;

/** 
 禁用通知监听
 @param 通知名称
 */
-(void)disabledNotify:(NSString*)notify;


/** 
 启用通知监听
 @param 通知名称
 */
-(void)enabledNotify:(NSString*)notify;


/** 删除所有通知监听 */
-(void)removeAll;


@property(nonatomic,strong)NSMutableDictionary* pDiabledDict;

@property(nonatomic,strong)NSMutableDictionary* pNotifyDict;

@end
