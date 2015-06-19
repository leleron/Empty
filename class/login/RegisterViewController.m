//
//  RegisterViewController.m
//  Empty
//
//  Created by leron on 15/6/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "RegisterViewController.h"
#import "getCodeMock.h"
#import "AFNetworking.h"
#import "ASIHTTPRequest.h"
#import "identifyCodeMock.h"
#import "registerMock.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *vertifyCode;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;       //注册button
@property(strong,nonatomic)NSString* phone;
@property(strong,nonatomic)NSString* vertifyNum;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property(strong,nonatomic)NSString*psw;
@property(strong,nonatomic)getCodeMock* myCodeMock;
@property(strong,nonatomic)getCodeParam* myCodeParam;
@property(strong,nonatomic)identifyCodeMock* myIdentifyCodeMock;
@property(strong,nonatomic)identifyCodeParam* myIndentifyCodeParam;
@property(strong,nonatomic)registerMock* myRegisterMock;        //注册mock
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"注册";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initQuickUI{
    [self.clickButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.btnGetCode addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
}
-(void)initQuickMock{
    self.myCodeMock = [getCodeMock mock];
    self.myCodeMock.delegate = self;
    self.myCodeParam = [getCodeParam param];
    self.myCodeParam.sendMethod = @"POST";
    self.myIdentifyCodeMock = [identifyCodeMock mock];
    self.myIdentifyCodeMock.delegate = self;
    self.myIndentifyCodeParam = [identifyCodeParam param];
    self.myRegisterMock = [registerMock mock];
    self.myRegisterMock.delegate = self;
}

-(void)getCode{
    self.phone = self.phoneNum.text;
    self.myCodeParam.MOBILE = self.phone;
    [self.myCodeMock run:self.myCodeParam];
}


-(void)gotoRegister{
    self.phone = self.phoneNum.text;
    self.vertifyNum = self.vertifyCode.text;
    self.psw = self.passWord.text;
    registerParam* param = [registerParam param];
    param.USER_NAME = self.phone;
    param.PASSWORD = self.psw;
    param.MOBILE = self.phone;
    param.IDENTIFY_CODE = self.vertifyNum;
    param.SECURITYCODE = self.vertifyNum;
    [self.myRegisterMock run:param];
}


-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getCodeMock class]]) {
        getCodeEntity* e = (getCodeEntity*)entity;
    }
    if ([mock isKindOfClass:[registerMock class]]) {
        
    }
    
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
