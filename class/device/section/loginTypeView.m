//
//  loginTypeView.m
//  Empty
//
//  Created by leron on 15/6/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "loginTypeView.h"
#import "TencentOAuth.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "loginMock.h"

@implementation loginTypeView
@end
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@interface viewThirdLogin()<TencentSessionDelegate,WBHttpRequestDelegate,WXApiDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnAddWechat;
@property (strong, nonatomic) IBOutlet UIButton *btnAddQQ;
@property (strong, nonatomic) IBOutlet UIButton *btnAddWeibo;
@property (strong,nonatomic)TencentOAuth* tencentOAuth;
@end

@interface viewBindFlycoCount()<QUMockDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnBind;
@property (strong,nonatomic)loginMock* myLoginMock;
@property (assign,nonatomic)BOOL bindSuccess;
@end

@implementation viewBindFlycoCount

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.bindSuccess = false;
    [self.btnBind addTarget:self action:@selector(bindFlycoCount) forControlEvents:UIControlEventTouchUpInside];
    self.myLoginMock = [loginMock mock];
    self.myLoginMock.delegate = self;
}
-(void)bindFlycoCount{
    if(self.textPhoneNum.text && self.textPsw.text){
        loginParam* param = [loginParam param];
        param.LOGINID = self.textPhoneNum.text;
        param.PASSWORD = self.textPsw.text;
        [self.myLoginMock run:param];
    }
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[loginMock class]]) {
        loginEntity* e = (loginEntity*)entity;
        if ([e.status isEqualToString:@"success"]) {
            UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
            myUserInfo.phoneNum = self.textPhoneNum.text;
            myUserInfo.password = self.textPsw.text;
            self.bindSuccess = true;
            [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_PHONE_SUCCESS object:nil];
        }
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textPhoneNum resignFirstResponder];
    [self.textPsw resignFirstResponder];
}
@end

@implementation viewThirdLogin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.btnAddQQ addTarget:self action:@selector(gotoAddQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAddWechat addTarget:self action:@selector(gotoAddWeChat) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAddWeibo addTarget:self action:@selector(gotoAddWeibo) forControlEvents:UIControlEventTouchUpInside];
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    if (myUserInfo.qqTokenID) {
        self.btnAddQQ.titleLabel.text = @"删除";
    }
    if(myUserInfo.wbTokenID){
        self.btnAddWeibo.titleLabel.text = @"删除";
    }
    if (myUserInfo.wxTokenID) {
        self.btnAddWechat.titleLabel.text = @"删除";
    }
    
}
-(void)gotoAddQQ{
    if ([self.btnAddQQ.titleLabel.text isEqualToString:@"删除"]) {
        UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
        myUserInfo.qqTokenID = nil;
        myUserInfo.qqUserID = nil;
    }else{
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104692486"andDelegate:self];
        NSArray* permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
        [_tencentOAuth authorize:permissions inSafari:NO];
    }
    
}

-(void)gotoAddWeChat{
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

-(void)gotoAddWeibo{
    WBAuthorizeRequest* request = [[WBAuthorizeRequest alloc]init];
    request.redirectURI = SinaRedirectURI;
    request.scope = @"all";
    //    request.userInfo = @{@"SSO_From":@"SendMessageToWeiboViewController",}
    [WeiboSDK sendRequest:request];
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


@end



