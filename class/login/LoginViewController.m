//
//  LoginViewController.m
//  飞科智能
//
//  Created by leron on 15/6/8.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "LoginViewController.h"
#import "TencentOAuth.h"
@interface LoginViewController ()<TencentSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnLoginQQ;
@property(strong,nonatomic)TencentOAuth* tencentOAuth;
@property(strong,nonatomic)NSArray* permissions;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"登陆";
    [super viewDidLoad];
    [self.btnLoginQQ addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginWithQQ{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104617507"andDelegate:self];
    _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

#pragma mark QQ登陆delelgate
- (void)tencentDidLogin
{
//    _labelTitle.text = @"登录完成";
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
//        _labelAccessToken.text = _tencentOAuth.accessToken;
        NSLog(@"%@",_tencentOAuth.accessToken);
    }
    else
    {
//        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
//        _labelTitle.text = @"用户取消登录";
        NSLog(@"用户取消登陆");
    }
    else
    {
//        _labelTitle.text = @"登录失败";
        NSLog(@"登陆失败");
    }
}

-(void)tencentDidNotNetWork
{
//    _labelTitle.text=@"无网络连接，请设置网络";
    NSLog(@"无网络连接 请设置网络");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
