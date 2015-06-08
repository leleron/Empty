//
//  MyNoNetController.m
//  CaoPanBao
//
//  Created by zhuojian on 14-9-1.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "MyNoNetController.h"


@interface MyNoNetController ()

@end

static NSDictionary* _enabledNoNetworkDict;

@implementation MyNoNetController

/**
 添加启用无WIFI处理的Controller
 */
+(NSDictionary*)enabledDict{
    
    if(!_enabledNoNetworkDict)
    {
        _enabledNoNetworkDict=@{
                                // ZJ
//                                NSStringFromClass([WCFDiscoverPhoneChargeController class]): @(1),  // 手机充值
//                                NSStringFromClass([WCFDiscoverLifeController class]): @(1),          // 生活缴费
                                
                                // QDS

//                                
//                                
//                                //chw
//                                NSStringFromClass([WCFAccountSavingPotController class]): @(1),  // 存钱罐老用户视图页面
//                                NSStringFromClass([WCFMoneyMyCollectController class]): @(1),  // 存钱罐新用户视图页面

//                                NSStringFromClass([WCFAccountSavingPotRecordController class]): @(1),   // 存钱罐查看收益详情(转入转出记录)页面
//                                NSStringFromClass([WCFAccountSavingPotDetailController class]): @(1),   // 存钱罐查看累计收益
//                                
//                                NSStringFromClass([WCFMoneyMyCollectPayInController class]): @(1),  // 购买存钱罐 - 输入转入金额页面
//                                NSStringFromClass([WCFMoneyMyCollectPayOutController class]): @(1),  // 转出存钱罐 - 输入转出金额页面
//                                NSStringFromClass([WCFP2PAndBillProductsSubController class]): @(1),  //购买金银猫、点融 - 输入转入金额页面
//                                NSStringFromClass([WCFAccountMyWealthController class]): @(1),   // 我的财富首页
//                                NSStringFromClass
//                                    ([WCFPPMaoController class]): @(1),  // PP猫已投资页面
//                                NSStringFromClass([WCFPiaoPiaoMaoController class]): @(1), // 票票猫已投资页面
//                                NSStringFromClass([WCFPPMaoDetailController class]): @(1), // PP猫还款详情页面
//                                NSStringFromClass([WCFAccountSafetyCheckController class]): @(1), // 安全体检页面
//                                NSStringFromClass([WCFAccountSkipPayPassController class]): @(1) // 小额免密页面
                                };
    }
    
    return _enabledNoNetworkDict;
}

/** 是否需要对目标Controller应用NoWifi风格 */
+(BOOL)beShowWithTargetController:(UIViewController*)controller{
    NSString* enabledKey=NSStringFromClass([controller class]);
    if([self enabledDict][enabledKey])
        return YES;
    
    return NO;
}


+(instancetype)controllerWithTargetController:(UIViewController*)targetController{
    
    MyNoNetController* noNetController;
    
    /*
    if([MyNoNetController beShowWithTargetController:targetController])
    {
        CPBAppDelegate* delegate=(CPBAppDelegate*)[[UIApplication sharedApplication] delegate];
        if(delegate.haveNetwork==NO) // 无网络时跳转
        {
            noNetController=[[MyNoNetController alloc] initWithNibName:@"MyNoNetController" bundle:nil];
        }
        else  // 否则返回空，由WHNavigationcontroller 执行默认跳转行为
        {
            
        }
    }
    */
    return noNetController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click delegate

-(IBAction)clickedRefresh:(id)sender
{
    [self.navigationController restorePrevController];
//    [self.navigationController popViewControllerAnimated:NO];
//    
//    if([self.pDelegate  respondsToSelector:@selector(MyNoNetController:backHaveNetowrk:)])
//        [self.pDelegate MyNoNetController:self backHaveNetowrk:YES];
    
}



@end
