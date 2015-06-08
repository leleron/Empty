//
//  WpUser.h
//  CaoPanBao
//
//  Created by QDS on 14-4-15.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WCPUser : NSObject

@property (nonatomic, assign) int wcpUserId;                   // 微操盘用户id
@property (nonatomic, strong) NSString *wcpNickName;           // 微操盘昵称
@property (nonatomic, strong) NSString *wcpUserPhoto;          // 微操盘用户头像

/** 操盘收益 */
@property (strong, nonatomic) NSString *profitAmount;

/** 最大提取金额 */
@property (strong, nonatomic) NSString *withdrawAmount;

/** 冻结操盘收益 */
@property (strong, nonatomic) NSString *freezeAmount;

@end


typedef enum : int {
    kFlowID_Regist_1 = 1,           // 1：注册用户
    kFlowID_WeiboLoginNew_2 = 2,    // 2：微博账号登录，新用户【未激活】，手机未绑定
    kFlowID_WeiboLoginOld_3 = 3,    // 3：微博账号登录，老用户【已激活】，本地没有手势密码，手机未绑定
    kFlowID_SMSCodeLogin_4 = 4,     // 4：短信验证码登录
    kFlowID_ForgetPsw_5 = 5,        // 5：忘记密码
    kFlowID_GestPsw_Bind_6 = 6,     // 6：微博登录，本地有手势密码，手机已绑定
    kFlowID_GestPsw_UnBind_7 = 7,   // 7：微博登录，本地有手势密码，但手机未绑定
    kFlowID_WeiboLoginOld_Bind_8 = 8,   // 8：微博老用户登录，本地没有手势密码，手机已绑定
} AccountLoginFlowId;

typedef enum : int {
    kEnterLoginSys_NomalTag = 1111,        // 进入登录系统，正常的进入，即从整个登录流程进入
    
    kEnterLoginSys_FromAccountForgetPswTag = 1112   // 进入登录系统，从我的账户信息忘记密码进入
    
} AccountEnterLoginSysTag;


/** 操盘宝用户信息 */
@interface WCFUser : NSObject

/** 会员编号 */
@property (nonatomic, strong) NSString* memberId;               

/** 是否被激活(1：是  0：否) */
@property (nonatomic, strong) NSString* activeStatus;           

/** 是否实名(1：是  0：否) */
@property (nonatomic, strong) NSString* certified;              

/** 是否绑定手机(1：是  0：否) */
@property (nonatomic, strong) NSString* mobileBinded;           

/** 真实姓名 */
@property (nonatomic, strong) NSString* realName;               

/** 身份证号 */
@property (nonatomic, strong) NSString* identityCard;           

/** 绑定的手机号 */
@property (nonatomic, strong) NSString* mobile;                 

/** 最后登录时间 */
@property (nonatomic, strong) NSString* lastLoginTime;          

/** 用户是否已绑定微博uid(1:是 0：否) */
@property (nonatomic, strong) NSString* bindUid;

/** 用户的头像 */
@property (nonatomic, strong) NSString *headImgURL;

/** 微博ID */
@property (nonatomic, strong) NSString *wbId;

// 头像采用base64编码的字符串从后端返回，故取到头像值后直接保存在本地，不在缓存中座存储
// @property (nonatomic, strong) NSString* headImg;             // 头像(Base64编码的字符串)

/** 登录时的流程编号 */
@property (nonatomic, assign) AccountLoginFlowId loginFlowId;


/** 进入登录系统的来源标记 */
@property (assign, nonatomic) AccountEnterLoginSysTag enterLoginSysTag;

/** 用户登录的标识（1：是  其他：否） */
@property (nonatomic, strong) NSString* userLoggedInTag;

/** 保存服务端返回的cookie，为了恢复用户的登录状态 */
@property (nonatomic, strong) NSArray *requestCookies;

@property (nonatomic, strong) WCPUser *wcpUser;


//@property (nonatomic, strong) NSString* needValidMobile;        // 是否需要验证手机（是否是更换设备），
//@property (nonatomic, strong) NSString* wbNickname;             // 微博昵称
//@property (nonatomic, strong) NSString* cpbToken;               // 操盘宝token
//@property (nonatomic, strong) NSString* cpbBalance;             // 操盘宝余额
@property (nonatomic, strong) NSString* availableBalance;       // 可用余额
@property (nonatomic, strong) NSString* frozenBalance;          // 冻结余额
@property (nonatomic, strong) NSString* withdrawAvailableBalance;        // 可提现余额
@property (nonatomic, strong) NSArray* bankcardList;             // 提现银行卡列表


/** 获得全局的WpUser */
+ (WCFUser *)sharedUser;

/** 清空全局WpUser */
+ (void)resetSharedUser;

/** 根据保存在本地的用户信息判断用户是否登录 */
- (BOOL)isUserLoggedin;

/** 是否绑定微博 */
- (BOOL)isBindWeibo;

/** 用户是否为激活状态 */
- (BOOL)isUserActivate;

/** 用户是否实名认证过 */
- (BOOL)isUserCertified;

/** 将用户设置为实名认证过 */
- (void)setUserCertifiedWithName:(NSString*)name_ andNO:(NSString*)certNO_;

/** 得到混淆后的电话号码 */
+ (NSString*)getConfusePhone:(NSString*)phoneStr;

/** 手机号码是否认证 */
- (BOOL)isPhoneCertified;

/** 将手机号设置为认证过 */
- (void)setUserBindPhone:(NSString*)phone_;

/** 将微博账号设置为绑定 */
- (void)setUserWbid:(NSString *)awbid;

// 用户是否绑定过提现银行卡
- (BOOL) isBindWithdrawalBankCard;

///** 用户是否绑定过提现银行卡 */
//- (BOOL) isBindWithdrawalBankCard;
//
///** 是否是安全手机 */
//- (BOOL)isSafetyPhone;
//
///** 解析用户登录接口数据 */
//+ (NSMutableDictionary*)parseMemberLoginAdapterData:(NSDictionary*)root;

@end

@interface WCFGlobalTag : NSObject

+ (WCFGlobalTag *)sharedTag;

/** 用户安全退出时是否需要忽略长时间未登录 */
@property (nonatomic, assign) BOOL isIgnoreLongtimeNotHandle;

@end

/** 弹出手势密码的定时器 */
@interface WCFGestureTimer : NSObject
{
    // 倒计时【还剩多久】
    int timeCount;
    
    // 时间间隔【走了多久】
    int timeInterval;
    
    NSTimer *timer;
}

// 定时器无效时的处理标识
// 出现该情况是  home键和电源键的情况
@property (assign, nonatomic) BOOL isInvalidateTimerMark;

// 统计定时器走了几圈（超过定时时间）【屏幕常亮，当前处于手势密码页（包括设置页、验证页和修改页）】
@property (assign, nonatomic) int timeLoopCount;

// 缓存服务器的时间【用户启动APP时保存一次，其他时间不保存】
@property (assign, nonatomic) double serviceTime;

/** 判断当前页面是否是手势密码页 */
@property (assign, nonatomic) BOOL isGestureController;

+ (WCFGestureTimer *) sharedTimer;

/** 初始化定时器 */
- (void) createTime;

/** 删除定时器 */
- (void) invalidateTime;

@end
