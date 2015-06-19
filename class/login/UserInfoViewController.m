//
//  UserInfoViewController.m
//  Empty
//
//  Created by leron on 15/6/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "loginTypeView.h"
@interface UserInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIView *viewFlycoAccount;
@property (strong,nonatomic)viewBindFlycoCount* bindFlycoCount;
@end



@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bindFlycoCount =[QUNibHelper loadNibNamed:@"loginTypeView" ofClass:[viewBindFlycoCount class]];
    self.bindFlycoCount.frame = CGRectMake(0, self.viewFlycoAccount.frame.origin.y, SCREEN_WIDTH, 150);
    [self.view addSubview:self.bindFlycoCount];
    self.bindFlycoCount.textPhoneNum.delegate = self;
    self.bindFlycoCount.textPsw.delegate = self;
    self.bindFlycoCount.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bindFlycoAccount) name:LOGIN_PHONE_SUCCESS object:nil];
    
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    if (myUserInfo) {
        self.imgHead.image = myUserInfo.headImg;
        self.lblName.text = myUserInfo.nickName;
        self.lblPhoneNum.text = myUserInfo.phoneNum;
    }
    if (myUserInfo.userLoginType == LOGIN_PHONE) {
        self.viewFlycoAccount.hidden = YES;
        viewThirdLogin* view = [[viewThirdLogin alloc]initWithFrame:CGRectMake(0, self.viewFlycoAccount.frame.origin.y, SCREEN_WIDTH, 202)];
        [self.view addSubview:view];
    }else{
        if (!myUserInfo.phoneNum) {
            self.viewFlycoAccount.hidden = YES;
            self.bindFlycoCount.hidden = NO;
        }
            [self.btnDelete addTarget:self action:@selector(deleteFlycoCount) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
//绑定手机成功
-(void)bindFlycoAccount{
    self.bindFlycoCount.hidden = YES;
    self.viewFlycoAccount.hidden = NO;
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    self.lblPhoneNum.text = myUserInfo.phoneNum;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//删除飞科账号绑定
-(void)deleteFlycoCount{
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    myUserInfo.phoneNum = nil;
    myUserInfo.tokenID = nil;
    self.viewFlycoAccount.hidden = YES;
    self.bindFlycoCount.hidden = NO;
}

#pragma mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField:textField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField:textField up:NO];
}

//屏幕上下移动
- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    
    const int movementDistance = 80; // tweak as needed
    
    const float movementDuration = 0.3f; // tweak as needed
    
    
    
    int movement = (up ? -movementDistance : movementDistance);
    
    
    //
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
    
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
