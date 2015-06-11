//
//  Constant.h
//  CaoPanBao
//
//  Created by QDS on 14-12-9.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#ifndef CaoPanBao_Constant_h
#define CaoPanBao_Constant_h

// 宏定义
#if !defined(WP_DEBUG)
#define WPNSLOG(...) do {} while (0)
#define ISDEBUG false
#else
#define WPNSLOG(...) NSLog(__VA_ARGS__)
#define ISDEBUG true
#endif

#if defined(WP_TEST_SERVER) // 测试环境
#define BASE_URL @"http://121.40.104.203:8080/UserCore/service/"
#elif defined(WP_DEVELOP_SERVER) // 开发环境
#define BASE_URL @"http://121.40.104.203:8080/UserCore/service/"
#elif defined(WP_LINKTEST_SERVER) // 联调测试环境
#define BASE_URL @"http://121.40.104.203:8080/UserCore/service/"
#else // 生产环境
#define BASE_URL @"http://121.40.104.203:8080/UserCore/service"
#endif

#define kReachHostUrl @"www.sina.com.cn"

// 底部tabbar的高度设置为49
#define KTabBarHeight 49.0
#define kCurrentDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kCurrentDeciceHeight [UIScreen mainScreen].bounds.size.height

#define IOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)


#define VERSION  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]


//Dock的背景图片修改
//#define kDockBackgroundImage @"tabbar_slider.png"
//Dock上button内如文字根图片站位比例尺寸
#define kTitleRatio 0.3
//Dock高度
#define kDockHight   49

//全局动画时长
#define kDurationTime 0.3


//手机规格

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//iPhone6到5的宽高比
#define WIDTH6TO5 320/375
#define HEIGTH6TO5 480/667
//iphone6到6p
#define WIDTH6TO6P 414/375
#define HEIGTH6TO6P 736/667

//键盘延时出现时间
#define DelayShowKeyBoard 0.1

// 自定义RGB色值
#define Color_Bg_RGB(x, y, z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0f]

// 全局颜色变量的宏定义，可参考规范图
#define Color_Bg_222222 Color_Bg_RGB(34.0f, 34.0f,  34.0f) //一级文字
#define Color_Bg_757575 Color_Bg_RGB(117.0f, 117.0f, 117.0f)//二级文字
#define Color_Bg_ababab Color_Bg_RGB(171.0f, 171.0f, 171.0f)//三级文字
#define Color_Bg_6a6a6a Color_Bg_RGB(106.0f, 106.0f, 106.0f)//分组文字
#define Color_Bg_007aff Color_Bg_RGB(0.0f, 122.0f, 255.0f)//全局蓝色
#define Color_Bg_fc4653 Color_Bg_RGB(252.0f,70.0f, 83.0f)//涨红
#define Color_Bg_1bc07d Color_Bg_RGB(27.0f, 192.0f, 125.0f)//跌绿

#define Color_Bg_f2f2f2 Color_Bg_RGB(242.0f, 242.0f, 242.0f)
#define Color_Bg_000000 Color_Bg_RGB(0.0f,   0.0f,   0.0f)
#define Color_Bg_ef2121 Color_Bg_RGB(31.0f, 33.0f, 33.0f)
#define Color_Bg_333333 Color_Bg_RGB(51.0f,  51.0f,  51.0f)
#define Color_Bg_CustomPlaceholder Color_Bg_RGB(207.0f, 207.0f, 211.0f)
#define Color_Bg_Money  Color_Bg_RGB(251.f,136.f,1.f)
#define Color_Bg_Enable Color_Bg_RGB(18.f, 141.f, 226.0f) //按钮可点击时的背景颜色
#define Color_Bg_SelectBT [UIColor colorWithRed:196.f/255.f green:196.f/255.f blue:196.f/255.f alpha:1.f] // 选中按钮背景颜色
#define QU_BLACK_COLOR_TABLE_BG [UIColor blackColor]



// Sina SDK相关
#define SinaAppKey                  @"1680146197"
#define SinaAppSecret               @"3bbcd02b685b4fa39afb3549c42d32ef"
#define SinaRedirectURI             @"https://api.weibo.com/oauth2/default.html"

// 友盟APPKey



/** 弹出验证手势密码页的时间间隔 */
// 生产时间为10，其他为1
#if defined(WP_TEST_SERVER) // 测试环境
#define kShowGesturesViewIntervalTime 1
#elif defined(WP_DEVELOP_SERVER) // 开发环境
#define kShowGesturesViewIntervalTime 1
#elif defined(WP_LINKTEST_SERVER) // 联调测试环境
#define kShowGesturesViewIntervalTime 1
#else // 生产环境
#define kShowGesturesViewIntervalTime 10
#endif


/** AppDelegate的弘 */
#define  kShareAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define  kGetProductionName ([[NSUserDefaults standardUserDefaults] objectForKey:PRODUCTIONTYPE])

// App Store Link
#define AppStoreLink                @"http://itunes.apple.com/cn/app/id859903036?mt=8"

// 支付密码所包含字符的正则表达式
#define CPB_Regex_PayPassword @"^[A-Za-z0-9`~!@#$%^&*()+=|{}':;',\"\\[\\].\\\\<>/\\-_?~]+$"

// 身份证校验规则
#define CPB_Regex_SfzID @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"

// 银行卡号校验规则 15~25位数字
#define CPB_Regex_BankCardNO @"^[0-9\\-]{15,25}$"

// 金额格式
#define PRICE_REGEX_STRING  @"^[0-9]+(.[0-9]{1,2})?$|^[0-9]*$"

//锁屏时间
#define CLOSETIME 5

// 校验支付密码（非登录功能中的支付密码校验）
#define kUNLoginCheckPayPsw_FlowIDType_account01 @"account-01"      // 账户设置中新用户实名认证
#define kUNLoginCheckPayPsw_FlowIDType_account02 @"account-02"      // 账户设置中换绑手机[已绑定银行卡]
#define kUNLoginCheckPayPsw_FlowIDType_account03 @"account-03"      // 账户设置中换绑手机[未绑定银行卡]
#define kUNLoginCheckPayPsw_FlowIDType_bankcard01 @"bankcard-01"    // 我的银行卡中 绑定银行卡
#define kUNLoginCheckPayPsw_FlowIDType_safeset01 @"safeset-01"      // 安全设置中 新用户-小额免密设置
#define kUNLoginCheckPayPsw_FlowIDType_safeset02 @"safeset-02"      // 安全设置中重置密码
#define kUNLoginCheckPayPsw_FlowIDType_safeset03 @"safeset-03"      // 安全设置中开/关手势密码
#define kUNLoginCheckPayPsw_FlowIDType_cashier01 @"cashier-01"      // 收银台绑卡支付

#define __kStockRuleConfisk_url @"http://openh5.wcp.sina.com/site/tpoRule" //股票规则确认页面
#define __kPhjRuleConfisk_url @"http://openh5.wcp.sina.com/site/auRule" //黄金规则确认页

// long to string
#define fffLongToString(x) [NSString stringWithFormat:@"%ld",x]

// 获取本地化字符
#define fLocalStr(LocaledString)  NSLocalizedString(LocaledString, nil)



/** 获取本地化字符,带1个参数
 key 键名(localizable.string 中常量)
 value 键值（变量)
 */
#define fLocalStr1(key,a) [NSString stringWithFormat:NSLocalizedString(key, nil),a]

/** 获取本地化字符，带2个参数
 key 键名(localizable.string 中常量)
 value 键值（变量1)
 value 键值（变量2)
 */
#define fLocalStr2(key,a,b) [NSString stringWithFormat:NSLocalizedString(key, nil),a,b]


#define QU_BLACK_COLOR_LINE [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1.f] // 水平线颜色

//cell选中时的背景色
#define CPB_COLOR_CELL_BG_SELECTED2 [UIColor colorWithRed:28.f/255.f green:32.f/255.f blue:31.f/255.f alpha:1]
//忽略的版本号
#define IGNOREVERSION @"ignoreVersion"

#define CPB_COLOR_1 [UIColor colorWithRed:230.f/255.f green:8.f/255.f blue:30.f/255.f alpha:1] //
#define CPB_COLOR_2 [UIColor colorWithRed:248.f/255.f green:182.f/255.f blue:45.f/255.f alpha:1]
#define CPB_COLOR_5 [UIColor colorWithRed:110.f/255.f green:185.f/255.f blue:43.f/255.f alpha:1]
#define CPB_COLOR_9 [UIColor colorWithRed:153.f/255.f green:153.f/255.f blue:153.f/255.f alpha:1]
#define CPB_COLOR_10 [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1]
#define CPB_COLOR_11 [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1]
#define FIVE_LINE_COLOR [UIColor colorWithRed:50.f/255.f green:171.f/255.f blue:246.f/255.f alpha:1]
#define TEN_LINE_COLOR [UIColor colorWithRed:255.f/255.f green:211.f/255.f blue:114.f/255.f alpha:1]
#define TWENTY_LINE_COLOR [UIColor colorWithRed:255.f/255.f green:21.f/255.f blue:21.f/255.f alpha:1]
#define SIXTY_LINE_COLOR  [UIColor colorWithRed:194.f/255.f green:90.f/255.f blue:255.f/255.f alpha:1]
#define __beComeBackground_ @"__beComeBackground_" //进入后台
#define __beEnterAction_ @"__beEnterAction_" //进入前台

#define __hqViewNeedCodeString_ @"__hqViewNeedCodeString_" //行情界面需要的code
#define __dyanStockIsOperation_ @"__dyanStockIsOperation_" //股票是否递延
#define __stockSuspended_ @"__stockSuspended_" //是否停牌
#define __changeNavTitle_ @"__changeNavTitle_" //nav title change

#define __changeTabbarIndex_ @"__changeTabbarIndex_" //tabbar改变通知

/** 微博头像的保存key */
#define fffwbAvatarNameKey [NSString stringWithFormat:@"avatar_%@", [WCFUser sharedUser].memberId]

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


/* 列表一次请求的最大数   */
#define request_limit 20



//用户信息保存key
#define USER_INFO @"userinfo"
#define USER_NICKNAME @"user_NickName"
#define USER_PHONENUMBER @"user_phonenumber"
#define USER_TOUXIANG @"user_touxiang"
#define USER_ID @"user_id"
#define USER_SESSIONID @"user_sessionid"
//消息轮查保存key
#define MESSAGE_TIME @"message_time"


#endif
