//
//  CPBOnceTask.h
//  CaoPanBao
//
//  Created by zhuojian on 14-5-7.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CPB_ONCETASK_WORKDAY_KEY @"CPB_ONCETASK_WORKDAY_KEY"          // 刷新工作日

#define CPB_ONCETASK_HQ_KEY @"CPB_ONCETASK_HQ_KEY"   // 刷新行情
#define CPB_ONCETASK_HQ_VAL 1                        // 刷新时间一秒钟

#define CPB_ONCETASK_GETMSG_KEY @"CPB_ONCETASK_GETMSG_KEY"  //跑马灯
#define CPB_ONCETASK_GETMSG_VAL 180

#define WCF_ONCETASK_RESENDMESSAGE_KEY @"WCF_ONCETASK_RESENDMESSAGE_KEY"   // 重新发送短信倒计时
#define WCF_ONCETASK_RESENDMESSAGE_VAL 60                        // 刷新时间60秒钟

#define WCF_ONCETASK_CANBUYPRODUCT_KEY @"WCF_ONCETASK_CANBUYPRODUCT"   // 购买理财产品倒计时
#define WCF_ONCETASK_CANBUYPRODUCT_VAL 1                        // 刷新时间60秒钟

#define CPB_ONCETASK_ORDERLIST_KEY @"CPB_ONCETASK_ORDERLIST_KEY"   // 刷新订单列表
#define CPB_ONCETASK_ORDERLIST_VAL 3

#define CPB_ONCETASK_RULE_KEY @"CPB_ONCETASK_RULE_KEY"          // 刷新方案
#define CPB_ONCETASK_RULE_VAL 20                              // 刷新间隔


#define CPB_ONCETASK_HQCHART_KEY @"CPB_ONCETASK_HQCHART_KEY"  // 刷新分时图60秒
#if defined(WP_DEBUG) // 调试
#define CPB_ONCETASK_HQCHART_VAL  60 // 60                           // 刷新间隔
#else                 // 生产
#define CPB_ONCETASK_HQCHART_VAL  60 // 60                           // 刷新间隔
#endif


#define JYZD_ONCETASK_STO_BUYNEW_KEY @"JYZD_ONCETASK_STO_BUYNEW_KEY" //玩家最新买入
#define JYZD_ONCETASK_STO_BUYNEW_VAL 3                              //刷新频率3s
#define CPB_ONCETASK_STO_TPOHQ_KEY  @"CPB_ONCETASK_STO_TPOHQ_KEY" //个股行情
#define CPB_ONCETASK_STO_TPOHQ_VAL  3
#define CPB_ONCETASK_STO_ORDERCREATE_KEY @"CPB_ONCETASD_STO_ORDERCREATE_KEY" //资金最大利用率
#define CPB_ONCETASK_STO_ORDERCREATE_VAL 3

#define CPB_ONCETASK_STO_TPOHQCHART_KEY @"CPB_ONCETASK_STO_TPOHQCHART_KEY"   //股票行情图
#define CPB_ONCETASK_STO_TPOHQCHART_VAL 60

#define CPB_ONCETASK_STO_TPOHQKCHART_KEY @"CPB_ONCETASK_STO_TPOHQKCHART_KEY"  //股票K线图
#define CPB_ONCETASK_STO_TPOHQKCHART_VAL 1

//点买
#define STO_HQ_REFRESH_KEY @"STO_HQ_REFRESH_KEY" //股票行情刷新
#define STO_HQ_REFRESH_VAL 3
#define STO_BUY_WAIT_TRRIGER_KEY @"STO_BUY_WAIT_TRRIGER_KEY" //点买待触发
#define STO_BUY_WAIT_TRRIGER_VAL 3
//点卖tab
#define STO_SELL_ORDER_STATUS_KEY @"STO_SELL_ORDER_STATUS_KEY"//点卖列表状态刷新
#define STO_SELL_ORDER_STATUS_VAL 3
#define STO_SELL_HQ_FEFRESH_KEY @"STO_SELL_HQ_FEFRESH_KEY" //点卖行情
#define STO_SELL_HQ_FEFRESH_VAL 3
#define STO_SELL_CONFIRM_KEY @"STO_SELL_CONFIRM_KEY"//点卖确认
#define STO_SELL_CONFIRM_VAL 3

#define STO_SELL_DISDEAL_LIST_KEY @"STO_SELL_DISDEAL_LIST_KEY" //点卖未成交列表
#define STO_SELL_DISDEAL_LIST_VAL 3

/**
 WHOnceTask 间隔调用类
 
 例子：
 
 WHOnceTask.h
 #define CPB_ONCETASK_HQ_KEY @"CPB_ONCETASK_HQ_KEY"   // 刷新行情
 #define CPB_ONCETASK_HQ_VAL 1                        // 刷新时间一秒钟

 xxx.m
 
 if([[WHOnceTask shareOnceTask]expired:CPB_ONCETASK_HQ_KEY validTime:CPB_ONCETASK_HQ_VAL]) // 如果过期执行下面代码
 {
 
 }
 
 
 */
@interface WHOnceTask : NSObject
{
    NSMutableDictionary* taskDict;
}
+(WHOnceTask*)shareOnceTask;
/**
 任务过期
 @param 任务名称
 @validTime 间隔时间（秒）
 @return YES 过期，触发任务 NO 不过期，不触发任务
 */
-(BOOL)expired:(NSString *)key validTime:(double)validTime;

/**
 移除任务(达到任务立刻过期的效果)
 @param key 任务名称
 */
-(void)removeTask:(NSString*)key;

/** 清空任务(所有任务全部过期) */
-(void)removeAll;

@end
