//
//  ViewControllerManager.h
//  CaoPanBao
//
//  Created by QDS on 14-4-15.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WeiboSDK.h"
#import "MBProgressHUD.h"
//#import "WHDrawPswViewController.h"

//#import "WCFLoginSuccessDelegate.h"
//#import "CPBBindedWeiboViewController.h"

#import "WHNotifyManager.h"
//#import "CPBConfirmPswView.h"

@interface ViewControllerManager : NSObject<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property(strong,nonatomic)NSString* mark;   // 登陆界面2异地设备登陆标识
//@property (weak, nonatomic) id<WCFLoginSuccessDelegate> loginDelegate;
//@property (weak, nonatomic) id<WeiboSDKDelegate> sinaLoginDelegate;

// 获得全局的ViewControllerManager
+ (ViewControllerManager*)sharedManager;

-(UIViewController*)currentController1;


/** 新浪微博登录 */
//- (void)sinaWbLoginIn:(id<WeiboSDKDelegate>)viewController;

/** 新浪微博处理URL - APP发起 */
- (void)sinaWbHandleUrl:(NSURL*)url;


/** 
 显示等待框（浮层文字）
 @param parentView 父视图
 @param text 显示文本
 @param delay 显示停留时间
 */
-(void)showText:(UIView *)parentView text:(NSString*)text delay:(float)delay;

-(void)showText:(NSString *)text controller:(UIViewController*)controller delay:(float)delay;

-(void)showText:(NSString *)text controller:(UIViewController *)controller delay:(float)delay block:(dispatch_block_t)block;

/** 
 显示等待框
 @param parentView 父视图
 */
- (void)showWaitView:(UIView*)parentView;

/**
 显示等待框
 @param parentView 父视图
 @param point 坐标
 */
-(void)showWaitView:(UIView *)parentView withPoint:(CGPoint)point;

// 隐藏等待框
- (void)hideWaitView;


// 页面回跳至指定页面
- (void) fromTheViewController:(UIViewController*)parentViewController jumptoSpecifyViewController:(NSString *)specifyViewController;

// 页面回调至指定页面
- (void) fromTheViewController:(UIViewController*)parentViewController backtoSpecifyViewController:(Class)specifyViewController;

// 回跳至跳转到登录页面的页面
// - (void) backJumpLoginController:(UIViewController *)parentViewController;


- (UIViewController*) forTheViewController:(UIViewController*)parentViewController targetController:(Class)specifyViewController;

// 登录系统的页面返回的处理
- (void) clickBackButtonHandleCtrollerJumping:(UIViewController*)parentViewController;


// 跳转登录页
- (void) launchLoginViewController:(UIViewController*)parentViewController andMobileNum:(NSString *)mobileNum;

// 跳转登录页面2
- (void) launchLogin2ViewController:(UIViewController*)parentViewController andLocalData:(NSArray *)localData;

//
-(void) launchLogin2ViewController:(UIViewController*)parentViewController;


#pragma mark - 跳转手势密码页
//- (void) launchDrawPswViewController:(id<WHGesturePswDrawedResultDelegate>)parentViewController andDrawType:(int)drawType;

#pragma mark - 跳转验证手势密码页
- (void) launchVerifyGesturePswViewController;

// 跳转填写验证码
- (void) launchFilloutSecurityCodeViewController:(UIViewController*)parentViewController andMobileNumber:(NSString *)mobilenumStr;

// 跳转设置支付密码页面
- (void) launchSetupPayPasswordViewController:(UIViewController*)parentViewController;

// 跳转填写身份证号页面
- (void) launchValidateIdentityCardViewController:(UIViewController*)parentViewController;

// 跳转验证支付密码页面
- (void) launchValidatePayPasswordViewController:(UIViewController*)parentViewController;

// 跳转实名认证页（操盘宝）
- (void)launchRealNameAuthenticationViewController:(UIViewController*)parentViewController;

// 跳转查看实名信息页面
- (void) launchLookOverRealNameInfoViewController:(UIViewController*)parentViewController;

// 跳转独立的h5解释说明页面
- (void) launchMyWebViewController:(UIViewController*)parentViewController withUrlStr:(NSString *)urlStr andNavTitle:(NSString *) navTitleStr;

// 跳转登录页面
// 返回登录过用户保存在本地的信息
// 返回nil则未登录过
//- (void) jumpToLoginViewController:(UIViewController*)parentViewController andDelegate:(id<WCFLoginSuccessDelegate>)adelegate;

// session超时，提示长时间未登录的处理方法
// jump to登录页面
- (void) jumpToLoginWithSessionTimeout;

#pragma mark - 从手势密码页面跳转登录页面
- (void) jumpToLoginWithGesturePswViewWithTag:(int)tag;


// 跳转绑定微博页面
//- (void) launchBindedWeiboViewController:(id<CPBBindWeiboSuccessDelegate>)parentViewController;

// 跳转 手机号和短信验证码的页面
- (void) launchMobileAndSecurityViewController:(UIViewController*)parentViewController;

// 跳转 设置微操盘昵称页面
- (void) launchSetupWcpNicknameViewController:(UIViewController*)parentViewController;

// 跳转到微操盘的相关页面
- (void) launchOrderCategoryController:(UIViewController*)parentViewController;

// 跳转我的账户页
- (void)launchMyAccountOverviewViewController:(UIViewController*)parentViewController;

// 跳转提现到银行卡页CPBWithdrawalBankCardViewController
- (void) launchWithdrawalBankCardViewController:(UIViewController*)parentViewController;

// 跳转绑定银行卡页
- (void) launchBindWithdrawalOFBankCardViewController:(UIViewController*)parentViewController;

// 跳转到充值到操盘宝页
- (void) launchCaopanbaoRechargeViewController:(UIViewController*)parentViewController withJumpController:(NSString *)jumpTagStr;

// 跳转微操盘收益提取到操盘宝成功页
- (void) launchExtractedToCPBResultSuccViewController:(UIViewController*)parentViewController andMoney:(NSString *)moneyamount;

// 跳转微操盘收益提取到操盘宝失败页
- (void) launchExtractedToCPBResultFailViewController:(UIViewController*)parentViewController;

// 提现失败页
- (void) launchWithdrawalBankCardFailViewController:(UIViewController*)parentViewController;

// 添加确认支付密码页面
//- (CPBConfirmPswView *) addConfirmPayPswView:(id<CPBConfirmPswViewDelegate>) parentViewController;

// 跳转引导页
- (void) launchIntroduceViewController:(UIViewController*)parentViewController;

// 跳转产品交易页
- (void) launchPHJMainViewController:(UIViewController*)parentViewController withProductType:(NSInteger) type;



@end
