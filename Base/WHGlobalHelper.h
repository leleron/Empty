//
//  CPBGlobalHelper.h
//  CaoPanBao
//
//  Created by zhuojian on 14-5-8.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "QUEntity.h"

@class WCFFavoriteBannerListEntity;
@class WCFSevenDaysProfitInfoEntity;
@class WCFAccountSafetyCheckEntity;
@class WCFPaymentEntity;

#define WH_GLOBAL_USERR_NAME @"WH_GLOBAL_USERR_NAME" // 名字

#define WH_SERALIZE_CLASS_NAME @"serialize_class_name" // 序列化类名的键值名

#define WH_GLOBAL_EXPIRE_SESSION @"WH_GLOBAL_EXPIRE_SESSION" 

#define WCF_MESSAGE_CODE_COOLDOWN @"WH_MESSAGE_CODE_COOLDOWN" //获取验证码计时器状态

#define WCF_GLOBAL_REALNAME @"WCF_GLOBAL_REALNAME" //是否是实名用户

#define WCF_USER_INFO @"WCF_USER_INFO"          // 用户信息

#define WCF_GLOBAL_BANNER_ENTITY NSStringFromClass([WCFFavoriteBannerListEntity class])

#define WCF_GLOBAL_SAFETYCHECK_ENTITY NSStringFromClass([WCFAccountSafetyCheckEntity class])     // 安全体检分数

#define WCF_GLOBAL_FIRSTUSEPAYMENT_ENTITY NSStringFromClass([WCFPaymentEntity class])     // 是否是第一次使用收银台

#define WCF_GLOBAL_PROFIT_ENTITY NSStringFromClass([WCFSevenDaysProfitInfoEntity class])

#define WCF_GLOBAL_CHARGE_PHONE_HISTORY NSStringFromClass([WCFDiscoverHistoryPhoneListEntity class]) // 充值手机历史

//#define WCF_JUMPLOGINVIEW_CURRENTCLASS_NAME @"WcfJumpLoginViewCurrentClass"    // 跳转登录页的当前类的名字

#define WCF_JUMPLOGINVIEW_NEEDBINDEDWEIBO @"WcfJumpLoginViewNeedBindingWeibo"  // 跳转登录页面是否需要绑定微博账号

#define CPB_GLOBAL_TIME_STAMP @"CPB_GLOBAL_TIME_STAMP" // 全局时间戳
#define CPB_GLOBAL_WORKDAY @"CPB_GLOBAL_WORKDAY" // 非工作日
#define CPB_GLOBAL_IS_DEAL_TIME @"CPB_GLOBAL_IS_DEAL_TIME" // 是否交易时间

#define STO_GLOBAL_RULE @"STO_GLOBAL_RULE" //方案
#define __stockDictionary_ @"__stockDictionary_"//股票名字，跟code
#define __inversterDict_ @"__inversterDict_" //股票投资人信息
#define __detailOrderMessage_ @"__detailOrderMessage_" //股票详情信息
#define __refreshOrderMessage_ @"__refreshOrderMessage_"//股票状态信息
/**
 离线缓存接口
 在实体类头文件增加此接口，使实体类具有离线磁盘缓存的特性
 */
@protocol WHGlobalHelperDelegate <NSObject>
/**缓存*/
-(void)store:(NSString*)key;

/** 从磁盘恢复缓存 */
+(instancetype)restore:(NSString*)key content:(NSDictionary*)content;
@end

/** 全局变量存取类
 例子:
 
 [[WHGlobalHelper]shareGlobalHelper put:@"zhuojian" key:@"name"];
 NSString* name=[[WHGlobalHelper]shareGlobalHelper get:@"name"];
 
 */
@interface WHGlobalHelper : QUEntity
{
    NSMutableDictionary* dict;
}

/**
 保存键值
 @param obj 值
 @param key 键
 */
-(void)put:(id)obj key:(NSString*)key;

/**
 获取值
 @param key 键
 @return 返回值(如果值不存在，返回nil)
 */
-(id)get:(NSString*)key;

/**
 @param key 键
 @param defValue 默认获取失败返回的值
 @return 返回值(如果获取失败，返回defValue)
 */
-(id)get:(NSString*)key defValue:(id)defValue;

+(WHGlobalHelper*)shareGlobalHelper;

+(NSString*)key:(NSString*)key prefix:(NSString*)prefix;

-(void)removeAll;
-(void)removeByKey:(NSString*)key;
@end
