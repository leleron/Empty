////
////  ViewControllerManager.m
////  CaoPanBao
////
////  Created by QDS on 14-4-15.
////  Copyright (c) 2014年 Mark. All rights reserved.
////
//#import "Constant.h"
////#import "WCFLoginSuccessDelegate.h"
//#import "ViewControllerManager.h"
#import "WpWaitView2.h"
//#import "MyWebViewController.h"
#import "WpWaitViewController.h"
#import "AppDelegate.h"
//#import "Login2ViewController.h"
//#import "LoginViewController.h"
//
////#import "WHDrawPswViewController.h"
//
////#import "CPBLoginViewController.h"
////#import "CPBLogin2ViewController.h"
////#import "CPBFilloutSecurityCodeViewController.h"
////#import "CPBSetupPayPasswordViewController.h"
////#import "CPBValidateIdentityCardViewController.h"
////#import "CPBValidatePayPasswordViewController.h"
////#import "CPBLookOverRealNameInfoViewController.h"
//
//// #import "WHAlertView.h"
//#import "WpAlertViewCommon.h"
//
//
////#import "CPBMobileAndSecurityViewController.h"
////#import "CPBLoginViewController.h"
////#import "CPBSetupWcpNicknameViewController.h"
////#import "CPBOrderCategoryController.h"
//
////#import "CPBMyAccountOverviewViewController.h"
////#import "CPBRealNameAuthenticationViewController.h"
////#import "CPBWithdrawalBankCardViewController.h"
////#import "CPBBindWithdrawalOFBankCardViewController.h"
////#import "CPBCaopanbaoRechargeViewController.h"
//
////#import "CPBExtractedToCPBResultSuccViewController.h"
////#import "CPBExtractedToCPBResultFailViewController.h"
////#import "CPBWithdrawalBankCardFailViewController.h"
//
////#import "CPBIntroduceViewController.h"
//
////#import "CPBTradeBridgeViewController.h"
////#import "CPBPHJMainViewController.h"
//
//
static ViewControllerManager* _controllerManager = nil;

@interface ViewControllerManager ()
{
    WpWaitView2* cWaitView2;
}



@end


@implementation ViewControllerManager


// 获得全局的ViewControllerManager
+ (ViewControllerManager*)sharedManager
{
    if (!_controllerManager) {
        _controllerManager = [[ViewControllerManager alloc] init];
    }
    return _controllerManager;
}
//
//
-(void)showText:(NSString *)text controller:(UIViewController*)controller delay:(float)delay
{
    [self showText:controller.navigationController.view text:text delay:delay];
}
//
-(void)showText:(NSString *)text controller:(UIViewController *)controller delay:(float)delay block:(dispatch_block_t)block
{
    const double delayInSeconds = delay;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)); // 1
    
    [self showText:NSLocalizedString(text, nil) controller:controller delay:delayInSeconds];
    
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}
-(void)showText:(UIView *)parentView text:(NSString*)text delay:(float)delay
{
    if (HUD)
    {
        HUD=nil;
    }
    HUD = [[MBProgressHUD alloc] initWithView:parentView];
	[parentView addSubview:HUD];
    
    WpWaitViewController* waitViewController = [[WpWaitViewController alloc] initWithNibName:@"WpWaitViewController" bundle:nil tips:text WaitType:AlertWaitType];
    HUD.customView = waitViewController.view;
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
    
//    HUD.backgroundColor=[UIColor colorWithRed:20.f/255.f green:20.f/255.f blue:20.f/255.f alpha:0.8];
    HUD.backgroundColor=[UIColor clearColor];
	[HUD show:YES];
    
    [HUD hide:YES afterDelay:delay];
}

// 显示、隐藏等待框
- (void)showWaitView:(UIView*)parentView
{
//    if (cWaitView2)
//        return;
//    
//    cWaitView2 = [[WpWaitView2 alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [parentView addSubview:cWaitView2];
    
    [self showWaitView:parentView withPoint:CGPointMake(0, 0)];
}

-(void)showWaitView:(UIView *)parentView withPoint:(CGPoint)point
{
    if (cWaitView2)
        return;
    
    cWaitView2 = [[WpWaitView2 alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    cWaitView2.frame=CGRectMake(point.x, point.y, cWaitView2.frame.size.width, cWaitView2.frame.size.height);
    [parentView addSubview:cWaitView2];
}

- (void)hideWaitView
{
    if (cWaitView2 == nil)
        return;
    
    [cWaitView2 closeView];
    [cWaitView2 removeFromSuperview];
    cWaitView2 = nil;
}

// 页面回跳至指定页面
- (void) fromTheViewController:(UIViewController*)parentViewController jumptoSpecifyViewController:(NSString *)specifyViewController
{
    for (UIViewController *controller in parentViewController.navigationController.viewControllers)
    {
        if ([controller class] == NSClassFromString(specifyViewController))
        {
            [parentViewController.navigationController popToViewController:controller animated:YES];
             
             break;
        }
    }
}

// 页面回跳至指定页面
- (void) fromTheViewController:(UIViewController*)parentViewController backtoSpecifyViewController:(Class)specifyViewController
{
    for (UIViewController *controller in parentViewController.navigationController.viewControllers)
    {
        if ([controller isMemberOfClass:specifyViewController])
        {
            [parentViewController.navigationController popToViewController:controller animated:YES];
            
            break;
        }
    }
}

//// 回跳至跳转到登录页面的页面
////#pragma mark - 登录成功后跳转回跳转登录的页面
////- (void) backJumpLoginController:(UIViewController *)parentViewController
////{
////    NSString *backedViewName = (NSString *) [[WHGlobalHelper shareGlobalHelper] get:WCF_JUMPLOGINVIEW_CURRENTCLASS_NAME];
////    
////    [[WHGlobalHelper shareGlobalHelper] put:@"" key:WCF_JUMPLOGINVIEW_CURRENTCLASS_NAME];
////    
////    [self fromTheViewController:parentViewController jumptoSpecifyViewController:backedViewName];
////    
////    
////    if ([self.loginDelegate respondsToSelector:@selector(operationLoginSuccess)])
////    {
////        [self.loginDelegate operationLoginSuccess];
////        
////        self.loginDelegate = nil;
////    }
////    
////    
////    // 若能pop，则pop
////    
////    // 若不能pop，则push
////}
//
//- (UIViewController*) forTheViewController:(UIViewController*)parentViewController targetController:(Class)specifyViewController
//{
//    for (UIViewController *controller in parentViewController.navigationController.viewControllers)
//    {
//        if ([controller isMemberOfClass:specifyViewController])
//        {
//            return controller;
//        }
//    }
//    return nil;
//}
//
//// 登录系统的页面返回的处理
//- (void) clickBackButtonHandleCtrollerJumping:(UIViewController*)parentViewController
//{
//    if ([WCFUser sharedUser].enterLoginSysTag == kEnterLoginSys_FromAccountForgetPswTag)
//    {
//        // 若来自账户信息中的忘记密码，则popTo帐户信息
//        // [[ViewControllerManager sharedManager] forTheViewController:parentViewController targetController:[CPBAccountDetailInfoViewController class]];
//        
//        // 若返回，则标识从帐户信息跳转的标识去除
//        [WCFUser sharedUser].enterLoginSysTag = 0;
//        
//        [self fromTheViewController:parentViewController backtoSpecifyViewController:[CPBAccountDetailInfoViewController class]];
//    }
//    else
//    {
//        NSArray *navControllers = parentViewController.navigationController.viewControllers;
//        
//        UIViewController *rootController = [navControllers firstObject];
//        
//        
//        if ([rootController isMemberOfClass:[CPBLoginViewController class]])// || [rootController isMemberOfClass:[CPBLogin2ViewController class]])
//        {
//            // 若rootViewController是登录页，则popTo首页
//            
//            [parentViewController.navigationController popToRootViewControllerAnimated:YES];
//        }
//        else
//        {
//            UIViewController *anyLoginController;
//            
//            // int sum = 0;
//            
//            // 若rootViewController不是loginView，则popTo登录页
//            for (UIViewController *item in navControllers)
//            {
//                if ([item isMemberOfClass:[CPBLoginViewController class]])
//                {
//                    // 若有登录页面1，返回1，跳出循环
//                    anyLoginController = item;
//                    
//                    // ++ sum;
//                    
//                    break;
//                }
//                else if ([item isMemberOfClass:[CPBLogin2ViewController class]])
//                {
//                    // 有登录页面2，则返回到2，继续遍历是否有登录页面1
//                    anyLoginController = item;
//                    
//                    // ++ sum;
//                }
//                
////                if (sum == 3)
////                {
////                    // 若找到2个页面了，则跳出循环
////                    
////                    break;
////                }
//            }
//            
//            // 根据以上遍历，返回到登录页，若有登录页面1，返回登录页面1，若无登录1，则返回登录页面2
//            [parentViewController.navigationController popToViewController:anyLoginController animated:YES];
//        }
//    }
//}

// 获取当前的controller
-(UIViewController*)currentController1{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

    UIViewController *result = delegate.topController;
    
    // 需要判断其他的controller
    
    return result;

    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
            else{
                
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        // 当前不处于nav.viewcontrollers中返回的当前controller
        result = nextResponder;
        
//        if ([result isMemberOfClass:[WHDrawPswViewController class]])
//        {
//            return result;
//        }
    }
    else
        result = window.rootViewController;
    
    UIViewController *resultCtrl = [((UINavigationController *)result).viewControllers lastObject];
    
    return resultCtrl;
    return  nil;

}


///** 新浪微博登录 */
////- (void)sinaWbLoginIn:(id<WeiboSDKDelegate>)viewController
////{
////    self.sinaLoginDelegate = nil;
////    
////    self.sinaLoginDelegate = viewController;
////    
////    [WeiboSDK enableDebugMode:YES];
////    
////    [WeiboSDK registerApp:SinaAppKey];
////    
////    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
////    
////    request.redirectURI = SinaRedirectURI;
////    
////    request.scope = @"all";
////    
////    [WeiboSDK sendRequest:request];
////}
//
///** 新浪微博处理URL - APP发起 */
//- (void)sinaWbHandleUrl:(NSURL*)url
//{
//    // [sinaweibo handleOpenURL:url];
//
//    [WeiboSDK handleOpenURL:url delegate:self.sinaLoginDelegate];
//    
//    self.sinaLoginDelegate = nil;
//}
//
//
//
//
//// 跳转登录页
//- (void) launchLoginViewController:(UIViewController*)parentViewController  andMobileNum:(NSString *)mobileNum
//{
//    // 防止多次弹出登录页
//    if ([parentViewController isMemberOfClass:[CPBLoginViewController class]])
//    {
//        return;
//    }
//    
//    CPBLoginViewController *controller = [[CPBLoginViewController alloc] initWithNibName:@"CPBLoginViewController" bundle:nil];
//    
//    controller.accountMobileNumString = mobileNum;
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转登录页面2
//- (void) launchLogin2ViewController:(UIViewController*)parentViewController andLocalData:(NSArray *)localData
//{
//    // 防止多次弹出登录页
//    if ([parentViewController isMemberOfClass:[CPBLogin2ViewController class]])
//    {
//        return;
//    }
//    
//    CPBLogin2ViewController *controller = [[CPBLogin2ViewController alloc] initWithNibName:@"CPBLogin2ViewController" bundle:nil];
//    
//    controller.localDataArray = localData;
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}

//-(void) launchLogin2ViewController:(UIViewController*)parentViewController{
//    if ([parentViewController isKindOfClass:[Login2ViewController class]]) {
//        return;
//    }
//    if ([parentViewController isKindOfClass:[LoginViewController class]]) {
//        return;
//    }
//    
//
//    Login2ViewController* controller = [[Login2ViewController alloc]initWithNibName:@"Login2ViewController" bundle:nil];
//    controller.mark = self.mark;
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}

//
//#pragma mark - 跳转手势密码设置页
//- (void) launchDrawPswViewController:(id<WHGesturePswDrawedResultDelegate>)parentViewController andDrawType:(int)drawType
//{
//    WHDrawPswViewController *controller = [[WHDrawPswViewController alloc] initWithNibName:iPhone5 ? @"WHDrawPswViewController" : @"WHDrawPswViewController_iPhone4" bundle:nil];
//    
//    controller.drawType = drawType;
//    
//    controller.gestPswDelegate = parentViewController;
//    
//    /** 手势密码的跳转方法 模态跳转 */
//    [(UIViewController *)parentViewController presentViewController:controller animated:NO completion:nil];
//}
//
//#pragma mark - 跳转手势密码验证页
//- (void) launchVerifyGesturePswViewController
//{
//    [WCFGestureTimer sharedTimer].isInvalidateTimerMark = NO;
//    
//    // 初始化弹出手势密码的计时器
//    WCFGestureTimer *gestureTimer = [WCFGestureTimer sharedTimer];
//    
//    [gestureTimer createTime];
//    
//    /**
//     * 以下3种情况不弹出手势密码验证页
//     * 1、当前页即为手势密码验证页；
//     * 2、当前页为登录页面1（退出登录时）；
//     * 3、当前页为登录页面2（退出登录时）；
//     */
//    
//    if (gestureTimer.isGestureController)
//    {
//        return;
//    }
//    
//    // 若当前有AlertVie，移除
//    [WpAlertViewCommon closeCurrentAlertView];
//    
//    // 若当前有ActionSheet，移除
//    [[WHActionSheetManager shareManager] closeCurrentActionSheet];
//    
//    
//    UIViewController *nowController = [self currentController1];
//    
//
//    
//    WHDrawPswViewController *controller = [[WHDrawPswViewController alloc] initWithNibName:iPhone5 ? @"WHDrawPswViewController" : @"WHDrawPswViewController_iPhone4" bundle:nil];
//    
//    
//    // 如果弹出手势密码页面是CPBTradeBridgeViewController，则需要通过实现协议方法跳转下一页面(CPBPHJMainViewController)
//    if ([nowController isMemberOfClass:[CPBTradeBridgeViewController class]])
//    {
//        controller.gestPswDelegate = (id)nowController;
//    }
//    
//    controller.drawType = kDrawGesturePswTypeVertify;
//    
//    [nowController presentViewController:controller animated:NO completion:nil];
//}
//
//// 跳转填写验证码
//- (void) launchFilloutSecurityCodeViewController:(UIViewController*)parentViewController andMobileNumber:(NSString *)mobilenumStr
//{
//    CPBFilloutSecurityCodeViewController *controller = [[CPBFilloutSecurityCodeViewController alloc] initWithNibName:@"CPBFilloutSecurityCodeViewController" bundle:nil];
//    
//    controller.mobileNumbString = mobilenumStr;
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转设置支付密码页面
//- (void) launchSetupPayPasswordViewController:(UIViewController*)parentViewController
//{
//    CPBSetupPayPasswordViewController *controller = [[CPBSetupPayPasswordViewController alloc] initWithNibName:@"CPBSetupPayPasswordViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转填写身份证号页面
//- (void) launchValidateIdentityCardViewController:(UIViewController*)parentViewController
//{
//    CPBValidateIdentityCardViewController *controller = [[CPBValidateIdentityCardViewController alloc] initWithNibName:@"CPBValidateIdentityCardViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转验证支付密码页面
//- (void) launchValidatePayPasswordViewController:(UIViewController*)parentViewController
//{
//    CPBValidatePayPasswordViewController *controller = [[CPBValidatePayPasswordViewController alloc] initWithNibName:@"CPBValidatePayPasswordViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//
//// 跳转实名认证页（操盘宝）
//- (void)launchRealNameAuthenticationViewController:(UIViewController*)parentViewController
//{
//    CPBRealNameAuthenticationViewController *controller = [[CPBRealNameAuthenticationViewController alloc] initWithNibName:@"CPBRealNameAuthenticationViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转查看实名信息页面
//- (void) launchLookOverRealNameInfoViewController:(UIViewController*)parentViewController
//{
//    CPBLookOverRealNameInfoViewController *controller = [[CPBLookOverRealNameInfoViewController alloc] initWithNibName:@"CPBLookOverRealNameInfoViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//
//// 跳转独立的h5解释说明页面
//- (void) launchMyWebViewController:(UIViewController*)parentViewController withUrlStr:(NSString *)urlStr andNavTitle:(NSString *) navTitleStr
//{
//    MyWebViewController *controller = [MyWebViewController controllerWithUrl:urlStr];
//    
//    controller.navigationBarTitle = navTitleStr;
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//
//// 跳转登录页面
//// 返回登录过用户保存在本地的信息
//// 返回nil则未登录过
//- (void) jumpToLoginViewController:(UIViewController*)parentViewController andDelegate:(id<WCFLoginSuccessDelegate>)adelegate
//{
//    self.loginDelegate = nil;
//    
//    if (adelegate)
//    {
//        self.loginDelegate = adelegate;
//    }
//    
////    // 退出登录跳转交易页
////    NSString *jumpCtrlClassName = [NSString stringWithFormat:@"%@", [CPBPHJMainViewController class]];
////    
////    // 保存当前跳转的类名
////    [[WHGlobalHelper shareGlobalHelper] put:jumpCtrlClassName key:WCF_JUMPLOGINVIEW_CURRENTCLASS_NAME];
//    
//    // 保存在本地的第一个手机号用户的数据
//    NSArray *userInfoArray = [WpCommonFunction getLocalDataWithFirst];
//    
//    if (userInfoArray)
//    {
//        [self launchLogin2ViewController:parentViewController andLocalData:userInfoArray];
//    }
//    else
//    {
//        [self launchLoginViewController:parentViewController  andMobileNum:nil];
//    }
//}
//
//#pragma mark - session超时，提示长时间未登录的处理方法
//// jump to登录页面
//- (void) jumpToLoginWithSessionTimeout
//{
//    // session超时跳转登录页，置空保存在本地的相关数据
//    
//    if ([kShareAppDelegate.topController isMemberOfClass:[WHDrawPswViewController class]])
//    {
//        // 当前处于手势密码页，不清空cookiesAndMemberID
//        // 保证手势密码能验证成功
//    }
//    else
//    {
//        // 当前不在手势密码页
//        // 删除cookie和mid
//        [WpCommonFunction delegateCookiesAndMemberIDFromLocal];
//    }
//    
//    // 清空全局数据 （这里的flowID也会被清空，此时会不会对整个系统有影响）
//    [WCFUser resetSharedUser];
//    
//    // 和手势密码有关的跳转登录页面
//    
//    UIViewController *parentViewController = [self currentController1];
//    
////    // 跳转其他页面的时候remove
////    for (UIView *item in parentViewController.navigationController.view.subviews)
////    {
////        if ([item isKindOfClass:[WHAlertView class]])
////        {
////            [item removeFromSuperview];
////        }
////    }
//    
//    // 长时间未操作，跳转登录页面
//    
//    // 跳转页 --> 手势密码页 -->  回到跳转页 --> （长时间未操作）登录页
//
//    [self jumpToLoginViewController:parentViewController andDelegate:nil];
//    // [WpCommonFunction messageBoxWithMessage:[NSString stringWithFormat:@"%@", viewController]];
//}
//
//#pragma mark - 从手势密码页面跳转登录页面
//// tag==1代表跳转登录页面1
//- (void) jumpToLoginWithGesturePswViewWithTag:(int)tag
//{
//    self.loginDelegate = nil;
//    
//    UIViewController *parentViewController = [self currentController1];
//    
////    for (UIView *item in parentViewController.navigationController.view.subviews)
////    {
////        if ([item isKindOfClass:[WHAlertView class]])
////        {
////            [item removeFromSuperview];
////        }
////    }
////    
////    // 保存当前跳转的类名
////    [[WHGlobalHelper shareGlobalHelper] put:[self getBackCtrlNameFromGesture:parentViewController] key:WCF_JUMPLOGINVIEW_CURRENTCLASS_NAME];
//    
//    // 跳转登录页面1
//    if (tag == 1)
//    {
//        [self launchLoginViewController:parentViewController andMobileNum:nil];
//        
//        return;
//    }
//    
//    NSArray *userInfoArray = [WpCommonFunction getLocalDataWithFirst];
//    
//    if (userInfoArray)
//    {
//        [self launchLogin2ViewController:parentViewController andLocalData:userInfoArray];
//    }
//    else
//    {
//        [self launchLoginViewController:parentViewController  andMobileNum:nil];
//    }
//}
//
////// 获取跳转手势密码页，返回时的那个页面
////- (NSString *) getBackCtrlNameFromGesture:(UIViewController*)parentViewController
////{
////    UIViewController *specCtrlLast = [parentViewController.navigationController.viewControllers lastObject];
////
////    Class specCtrlLastClass = [specCtrlLast class];
////    
////    NSArray *specCtrollers = [NSArray arrayWithObjects:
////                              @"WCFP2PAndBillProductsMainController",   // 商品详情页
////                              @"WCFAAboutCommentController",            // 意见反馈
////                              @"WCFMySafeSetupViewController",          // 安全设置
////                              
////                              nil];
////    
////    BOOL isSpecCtrl = NO;
////    
////    for (UIViewController *item in specCtrollers)
////    {
////        if ([item isMemberOfClass:specCtrlLastClass])
////        {
////            isSpecCtrl = YES;
////            
////            break;
////        }
////    }
////    
////    NSString *jumpCtrlClassName;
////    
////    if (isSpecCtrl)
////    {
////        jumpCtrlClassName = [NSString stringWithFormat:@"%@", specCtrlLastClass];
////    }
////    else
////    {
////        jumpCtrlClassName = [NSString stringWithFormat:@"%@", [[parentViewController.navigationController.viewControllers firstObject] class]];
////    }
////    
////    return jumpCtrlClassName;
////}
//
//// 跳转绑定微博页面
//- (void) launchBindedWeiboViewController:(id<CPBBindWeiboSuccessDelegate>)parentViewController
//{
//    CPBBindedWeiboViewController *controller = [[CPBBindedWeiboViewController alloc] initWithNibName:@"CPBBindedWeiboViewController" bundle:nil];
//    
//    controller.bindWeiboDelegate = parentViewController;
//    
//    [((UIViewController *)parentViewController).navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转 手机号和短信验证码的页面
//- (void) launchMobileAndSecurityViewController:(UIViewController*)parentViewController
//{
//    CPBMobileAndSecurityViewController *controller = [[CPBMobileAndSecurityViewController alloc] initWithNibName:@"CPBMobileAndSecurityViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转 设置微操盘昵称页面
//- (void) launchSetupWcpNicknameViewController:(UIViewController*)parentViewController
//{
//    CPBSetupWcpNicknameViewController *controller = [[CPBSetupWcpNicknameViewController alloc] initWithNibName:@"CPBSetupWcpNicknameViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转到微操盘的相关页面
//- (void) launchOrderCategoryController:(UIViewController*)parentViewController
//{
//    // [WpCommonFunction messageBoxWithMessage:@"登录成功，执行跳转微操盘的相关页面"];
//    CPBOrderCategoryController *controller = [[CPBOrderCategoryController alloc] initWithNibName:@"CPBOrderCategoryController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转我的账户页
//- (void)launchMyAccountOverviewViewController:(UIViewController*)parentViewController
//{
//    CPBMyAccountOverviewViewController *controller = [[CPBMyAccountOverviewViewController alloc] initWithNibName:@"CPBMyAccountOverviewViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转提现到银行卡页CPBWithdrawalBankCardViewController
//- (void) launchWithdrawalBankCardViewController:(UIViewController*)parentViewController
//{
//    CPBWithdrawalBankCardViewController *controller = [[CPBWithdrawalBankCardViewController alloc] initWithNibName:@"CPBWithdrawalBankCardViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转绑定银行卡页
//- (void) launchBindWithdrawalOFBankCardViewController:(UIViewController*)parentViewController
//{
//    CPBBindWithdrawalOFBankCardViewController *controller = [[CPBBindWithdrawalOFBankCardViewController alloc] initWithNibName:@"CPBBindWithdrawalOFBankCardViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转到充值到操盘宝页
//- (void) launchCaopanbaoRechargeViewController:(UIViewController*)parentViewController withJumpController:(NSString *)jumpTagStr
//{
//    CPBCaopanbaoRechargeViewController *controller = [[CPBCaopanbaoRechargeViewController alloc] initWithNibName:@"CPBCaopanbaoRechargeViewController" bundle:nil];
//    
//    controller.jumpTagStr = jumpTagStr;
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转微操盘收益提取到操盘宝成功页
//- (void) launchExtractedToCPBResultSuccViewController:(UIViewController*)parentViewController andMoney:(NSString *)moneyamount
//{
//    CPBExtractedToCPBResultSuccViewController *controller = [[CPBExtractedToCPBResultSuccViewController alloc] initWithNibName:@"CPBExtractedToCPBResultSuccViewController" bundle:nil];
//    
//    controller.succExtractedAmountString = moneyamount;
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转微操盘收益提取到操盘宝失败页
//- (void) launchExtractedToCPBResultFailViewController:(UIViewController*)parentViewController
//{
//    CPBExtractedToCPBResultFailViewController *controller = [[CPBExtractedToCPBResultFailViewController alloc] initWithNibName:@"CPBExtractedToCPBResultFailViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 提现失败页
//- (void) launchWithdrawalBankCardFailViewController:(UIViewController*)parentViewController
//{
//    CPBWithdrawalBankCardFailViewController *controller = [[CPBWithdrawalBankCardFailViewController alloc] initWithNibName:@"CPBWithdrawalBankCardFailViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 添加确认支付密码页面
//- (CPBConfirmPswView *) addConfirmPayPswView:(id<CPBConfirmPswViewDelegate>) parentViewController
//{
//    // WHShareToSNSView *shareView = [[WHShareToSNSView alloc] init];
//    
//    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CPBConfirmPswView" owner:self options:nil];
//    
//    CPBConfirmPswView *payPswView = [array objectAtIndex:0];
//    
//    
//    
//    payPswView.confirmDelegate = parentViewController;
//    
//    [payPswView.payPswTextField becomeFirstResponder];
//    
//    CGRect frame = [UIScreen mainScreen].bounds;
//    
//    payPswView.frame = frame;
//    
//    payPswView.alpha = 0.2;
//    
//    [((UIViewController *)parentViewController).navigationController.view addSubview:payPswView];
//    
//    [UIView animateWithDuration:kAnimationDuration animations:^{
//        
//        payPswView.alpha = 1;
//        
//    }];
//    
//    return payPswView;
//}
//
//// 跳转引导页
//- (void) launchIntroduceViewController:(UIViewController*)parentViewController
//{
//    CPBIntroduceViewController *controller = [[CPBIntroduceViewController alloc] initWithNibName:@"CPBIntroduceViewController" bundle:nil];
//    
//    [parentViewController.navigationController pushViewController:controller animated:YES];
//}
//
//// 跳转产品交易页
//- (void) launchPHJMainViewController:(UIViewController*)parentViewController withProductType:(NSInteger) type
//{
//    CPBPHJMainViewController *controller = [[CPBPHJMainViewController alloc] initWithNibName:@"CPBPHJMainViewController" bundle:nil];
//    
//    controller.index = type;
//    
//    [parentViewController.navigationController pushViewController:controller animated:NO];
//}

@end
