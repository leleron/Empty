//
//  LoginViewController.m
//  飞科智能
//
//  Created by leron on 15/6/8.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TencentOAuth.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "RegisterViewController.h"
#import "loginMock.h"
#import "UserInfo.h"
#import "forgetPswViewController.h"
@interface LoginViewController ()<TencentSessionDelegate,WBHttpRequestDelegate,WXApiDelegate,WeiboSDKDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnLoginQQ;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginWeChat;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginWeibo;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UITextField *textPhoneNum;

@property (weak, nonatomic) IBOutlet UITextField *textPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnFogetPsw;

@property(strong,nonatomic)TencentOAuth* tencentOAuth;
@property(strong,nonatomic)NSArray* permissions;
@property(strong,nonatomic)WBAuthorizeRequest* request;
@property(strong,nonatomic)loginMock* myLoginMock;

@property(strong,nonatomic)NSString* phoneNum;      //保存的手机号

@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"登陆";
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self.btnLoginQQ addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLoginWeChat addTarget:self action:@selector(loginWithWX) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLoginWeibo addTarget:self action:@selector(loginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRegister addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFogetPsw addTarget:self action:@selector(gotoForgetPsw) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postWeiboUserInfo) name:@"get_weibo_response" object:nil];
    // Do any additional setup after loading the view.
    
}

-(void)initQuickUI{
    self.textPsw.delegate = self;
    self.textPhoneNum.delegate = self;
}
-(void)initQuickMock{
    self.myLoginMock = [loginMock mock];
    self.myLoginMock.delegate = self;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoRegister{
    RegisterViewController* controller = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)gotoLogin{
    if (self.textPhoneNum.text != nil && self.textPsw.text!= nil) {
        loginParam* param = [loginParam param];
        param.sendMethod = @"POST";
        param.LOGINID = self.textPhoneNum.text;
        param.PASSWORD = self.textPsw.text;
        self.phoneNum = param.LOGINID;
//        param.LOGINID = @"15021631445";
//        param.PASSWORD = @"85314248";
        [self.myLoginMock run:param];
    }
}

-(void)gotoForgetPsw{
    forgetPswViewController* controller = [[forgetPswViewController alloc]initWithNibName:@"forgetPswViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)loginWithQQ{
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_QQ;
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104692486"andDelegate:self];
    _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

-(void)loginWithWX{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_WECHAT;
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

-(void)loginWithWeibo{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_WEIBO;
    self.request = [[WBAuthorizeRequest alloc]init];
    self.request.redirectURI = SinaRedirectURI;
    self.request.scope = @"all";
//    request.userInfo = @{@"SSO_From":@"SendMessageToWeiboViewController",}
    [WeiboSDK sendRequest:self.request];
}

-(void)postWeiboUserInfo{
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    NSNumber *userID = [NSNumber numberWithInteger:[myUserInfo.wbUserID integerValue]];
    NSDictionary* param = @{@"access_token":myUserInfo.wbTokenID,@"uid":userID};
    NSString* url = @"https://api.weibo.com/2/users/show.json";
//   [WBHttpRequest requestWithAccessToken:myUserInfo.wbTokenID url:url httpMethod:@"GET" params:param delegate:self withTag:nil];
    NSString* sendMethod = @"GET";
    [WBHttpRequest requestWithURL:url httpMethod:sendMethod params:param delegate:self withTag:nil];
    

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
        [_tencentOAuth getUserInfo];
        
    }
    else
    {
//        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}
- (void)getUserInfoResponse:(APIResponse*) response{
    UserInfo *myUserInfo = [[UserInfo alloc]init];

    myUserInfo.nickName = [response.jsonResponse objectForKey:@"nickname"];
    NSData* userHeadData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[response.jsonResponse objectForKey:@"figureurl_qq_2"]]];
    myUserInfo.headImg = [UIImage imageWithData:userHeadData];
    myUserInfo.userLoginType = LOGIN_QQ;
    [[WHGlobalHelper shareGlobalHelper]put:myUserInfo key:USER_INFO];
    [self.navigationController popViewControllerAnimated:YES];
//    self.myUserInfo.headImg = [UIIm]
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

#pragma mark 微博delegate


-(void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
}






-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    NSString* title = nil;
    UIAlertView* alert = nil;
    title = @"收到网络回调";
    NSLog(@"lirong:%@",request);
    alert = [[UIAlertView alloc]initWithTitle:title message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    NSString* title = @"请求异常";
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}



#pragma mark 微信登陆delegate
-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    
}


#pragma mark QUMockDelegate
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[loginMock class]]) {
        loginEntity* e = (loginEntity*)entity;
        if ([e.status isEqualToString:@"SUCCESS"]) {
            UserInfo* myUserInfo = [[UserInfo alloc]init];
            myUserInfo.phoneNum = self.phoneNum;
            myUserInfo.tokenID = e.tokenId;
            myUserInfo.userLoginType = LOGIN_PHONE;
            [[WHGlobalHelper shareGlobalHelper]put:myUserInfo key:USER_INFO];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.textPhoneNum resignFirstResponder];
//    [self.textPsw resignFirstResponder]
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
