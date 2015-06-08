//
//  EditInfoController.m
//  KV8
//
//  Created by MasKSJ on 14-8-14.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "EditInfoController.h"
#import "miscClasses/SQLSingle.h"
#import "WToast.h"
@interface EditInfoController ()
{
    UITextField *_nameField;
    UITextField *_ssidField;
    UITextField *_passwordField;
    UITextField *_newpasswordField;
    BOOL _isSync;
    
    
    MBProgressHUD *HUD;
    SSCheckBoxView *cbv ;
    SSCheckBoxView *cbv1 ;
}
@end

@implementation EditInfoController

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
    self.title = LOCAL(@"change_info1");
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 25, 25.78);
    [saveButton setImage:[UIImage imageWithContentsOfFile:PATH(@"save_no")] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(mySave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
    //nameView
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 60)];
    nameView.backgroundColor = UIColorFromRGB(0x009AD3);
    nameView.layer.cornerRadius = 8;
    [self.view addSubview:nameView];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    name.backgroundColor = [UIColor clearColor];
    name.text = LOCAL(@"name");
    name.textColor = [UIColor whiteColor];
    name.center = CGPointMake(40, nameView.frame.size.height/2);
    name.font = [UIFont systemFontOfSize:15];
    [nameView addSubview:name];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    _nameField.layer.cornerRadius = 5;
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.center = CGPointMake(190, nameView.frame.size.height/2);
    _nameField.delegate = self;
    _nameField.returnKeyType = UIReturnKeyDone;
    _nameField.textColor = TOPBARCOLOR;
    _nameField.text = _cam.nsCamName;
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [nameView addSubview:_nameField];
    
    UILabel *nameDescribeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, SCREEN_WIDTH-20, 40)];
    nameDescribeLable.backgroundColor = [UIColor clearColor];
    nameDescribeLable.textColor =UIColorFromRGB(0x009AD8);
    nameDescribeLable.text = LOCAL(@"hint1");
    nameDescribeLable.font = [UIFont systemFontOfSize:14];
    nameDescribeLable.numberOfLines = 0;
    [self.view addSubview:nameDescribeLable];
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 200, 30)];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = TOPBARCOLOR;
    if (_cam.mCamState == CONN_INFO_CONNECTED)
    {
        statusLabel.text = LOCAL(@"connected");
    }
    else
    {
        statusLabel.text = LOCAL(@"disconnected_hint");
        statusLabel.textColor = [UIColor purpleColor];
    }
    statusLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:statusLabel];
    
    //deviceView
    UIView *deviceView = [[UIView alloc]initWithFrame:CGRectMake(10, 150, SCREEN_WIDTH-20, 180)];
    deviceView.backgroundColor = UIColorFromRGB(0x009AD3);
    deviceView.layer.cornerRadius = 8;
    [self.view addSubview:deviceView];
    
    
    UILabel *syn = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    syn.backgroundColor = [UIColor clearColor];
    syn.text = LOCAL(@"sync_remote");
    syn.textColor = [UIColor whiteColor];
    syn.center = CGPointMake(110, syn.frame.size.height/2+10);
    syn.font = [UIFont systemFontOfSize:13];
    if (iOSVERSION >=7.0)
    {
        syn.font = [UIFont systemFontOfSize:12];
    }
    [deviceView addSubview:syn];
    
    UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    mySwitch.center = CGPointMake(260, syn.frame.size.height/2+10);
    [mySwitch addTarget:self action:@selector(mySync:) forControlEvents:UIControlEventValueChanged];
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        mySwitch.userInteractionEnabled = NO;
    }
    if (iOSVERSION <7.0)
    {
        mySwitch.center = CGPointMake(250, syn.frame.size.height/2+10);
    }
    [deviceView addSubview:mySwitch];
    
    
    CGRect labelrect = CGRectMake(0, 0, 70, 30);
    CGRect textfieldrect = CGRectMake(0, 0, 190, 30);
    
    
    UILabel *ssid = [[UILabel alloc]initWithFrame:labelrect];
    ssid.backgroundColor = [UIColor clearColor];
    ssid.text = LOCAL(@"dev_id");
    ssid.textColor = [UIColor whiteColor];
    ssid.center = CGPointMake(50, nameView.frame.size.height/2+40);
    ssid.font = [UIFont systemFontOfSize:14];
    [deviceView addSubview:ssid];
    
    _ssidField = [[UITextField alloc]initWithFrame:textfieldrect];
    _ssidField.layer.cornerRadius = 5;
    _ssidField.backgroundColor = UNAVAILABLECOLOR;
    _ssidField.center = CGPointMake(176, nameView.frame.size.height/2+40);
    _ssidField.delegate = self;
    _ssidField.returnKeyType = UIReturnKeyDone;
    _ssidField.textColor = TOPBARCOLOR;
    _ssidField.text = _cam.nsDID;
    //    _ssidField.userInteractionEnabled = NO;
    _ssidField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [deviceView addSubview:_ssidField];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 2)];
    line1.backgroundColor = BLUECOLOR;
    line1.center = CGPointMake(deviceView.frame.size.width/2, deviceView.frame.size.height/4);
    [deviceView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 2)];
    line2.backgroundColor = BLUECOLOR;
    line2.center = CGPointMake(deviceView.frame.size.width/2, deviceView.frame.size.height/2);
    [deviceView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 2)];
    line3.backgroundColor = BLUECOLOR;
    line3.center = CGPointMake(deviceView.frame.size.width/2, deviceView.frame.size.height*3/4);
    [deviceView addSubview:line3];
    
    UILabel *password = [[UILabel alloc]initWithFrame:labelrect];
    password.backgroundColor = [UIColor clearColor];
    password.text = LOCAL(@"oldpwd");
    password.textColor = [UIColor whiteColor];
    password.center = CGPointMake(50, nameView.frame.size.height/2+85);
    password.font = [UIFont systemFontOfSize:14];
    [deviceView addSubview:password];
    
    _passwordField = [[UITextField alloc]initWithFrame:textfieldrect];
    _passwordField.layer.cornerRadius = 5;
    _passwordField.backgroundColor = UNAVAILABLECOLOR;
    _passwordField.center = CGPointMake(176, nameView.frame.size.height/2+85);
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.secureTextEntry = NO;
    _passwordField.textColor = TOPBARCOLOR;
    //    _passwordField.text = _cam.nsViewPwd;
    _passwordField.userInteractionEnabled = NO;
    _passwordField.tag = 1004;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [deviceView addSubview:_passwordField];
    
    
    UILabel *newPassword = [[UILabel alloc] initWithFrame:labelrect];
    newPassword.backgroundColor = [UIColor clearColor];
    newPassword.text = LOCAL(@"newpwd");
    newPassword.textColor = [UIColor whiteColor];
    newPassword.center = CGPointMake(50, nameView.frame.size.height/2+130);
    newPassword.font = [UIFont systemFontOfSize:14];
    [deviceView addSubview:newPassword];
    
    _newpasswordField = [[UITextField alloc]initWithFrame:textfieldrect];
    _newpasswordField.layer.cornerRadius = 5;
    _newpasswordField.backgroundColor = UNAVAILABLECOLOR;
    _newpasswordField.center = CGPointMake(176, nameView.frame.size.height/2+130);
    _newpasswordField.delegate = self;
    _newpasswordField.returnKeyType = UIReturnKeyDone;
    _newpasswordField.secureTextEntry = NO;
    _newpasswordField.textColor = TOPBARCOLOR;
    _newpasswordField.userInteractionEnabled = NO;
    _newpasswordField.tag = 1003;
    _newpasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [deviceView addSubview:_newpasswordField];
    
    
    
    CGRect frame = CGRectMake(265, nameView.frame.size.height/2+65, 240, 30);
    SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                          style:style
                                        checked:YES];
    cbv.userInteractionEnabled = NO;
    [deviceView addSubview:cbv];
    
    
    
    CGRect frame1 = CGRectMake(265, nameView.frame.size.height/2+110, 240, 30);
    //    SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
    cbv1 = [[SSCheckBoxView alloc] initWithFrame:frame1
                                           style:style
                                         checked:YES];
    cbv1.userInteractionEnabled = NO;
    [deviceView addSubview:cbv1];
    cbv.tag = 1001;
    cbv1.tag = 1002;
    
    //防止重复引用
    __block EditInfoController *controller = self;
    [cbv setStateChangedBlock:^(SSCheckBoxView *v)
    {
        [controller checkBoxViewChangedState:v];
    }];
    [cbv1 setStateChangedBlock:^(SSCheckBoxView *v)
    {
        [controller checkBoxViewChangedState:v];
    }];
    
    
    UILabel *deviceDescribeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 332, SCREEN_WIDTH-20, 60)];
    deviceDescribeLable.numberOfLines = 0;
    deviceDescribeLable.backgroundColor = [UIColor clearColor];
    deviceDescribeLable.textColor =UIColorFromRGB(0x009AD3);
    deviceDescribeLable.text = LOCAL(@"label3");
    deviceDescribeLable.font = [UIFont systemFontOfSize:14];
    deviceDescribeLable.numberOfLines = 0;
    [self.view addSubview:deviceDescribeLable];
    
    if (iOSVERSION >=7.0)
    {
        nameView.frame = CGRectMake(nameView.frame.origin.x,nameView.frame.origin.y+ADJSTHEIGHT,nameView.frame.size.width,nameView.frame.size.height);
        nameDescribeLable.frame = CGRectMake(nameDescribeLable.frame.origin.x,nameDescribeLable.frame.origin.y+ADJSTHEIGHT,nameDescribeLable.frame.size.width,nameDescribeLable.frame.size.height);
        statusLabel.frame = CGRectMake(statusLabel.frame.origin.x,statusLabel.frame.origin.y+ADJSTHEIGHT,statusLabel.frame.size.width,statusLabel.frame.size.height);
        deviceView.frame = CGRectMake(deviceView.frame.origin.x,deviceView.frame.origin.y+ADJSTHEIGHT,deviceView.frame.size.width,deviceView.frame.size.height);
        deviceDescribeLable.frame = CGRectMake(deviceDescribeLable.frame.origin.x,deviceDescribeLable.frame.origin.y+ADJSTHEIGHT,deviceDescribeLable.frame.size.width,deviceDescribeLable.frame.size.height);
    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetDevPassWD:) name:@"SetDevPassWD" object:nil];
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View lifecycle

- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
//    NSLog(@"checkBoxViewChangedState: %d", cbv.checked);
//    NSLog(@"checkBoxViewChangedState: %d", cbv.tag);
//    [UIHelpers showAlertWithTitle:@"CheckBox State Changed"
//                              msg:[NSString stringWithFormat:@"checkBoxView state: %d", cbv.checked]];
    
    // toggle all

//        cbv.enabled = !cbv.enabled;
    if(cbv.tag == 1001)
    {
        if(cbv.checked == YES)
            _passwordField.secureTextEntry = NO;
        else
            _passwordField.secureTextEntry = YES;
    }
    else if(cbv.tag == 1002)
    {
        if(cbv.checked == YES)
            _newpasswordField.secureTextEntry = NO;
        else
            _newpasswordField.secureTextEntry = YES;
    }
    
    
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)mySave
{

    if(_nameField.text.length  && _isSync == NO)
    {
        SQLSingle *sql = [SQLSingle shareSQLSingle];
        [sql.dataBase executeUpdate:@"update camre_info set CAMERA_NAME=? where DEV_ID=?",_nameField.text,_cam.nsDID];
        _cam.nsCamName = _nameField.text;
        [WToast showWithText:LOCAL(@"save_db_success")];
        
    }
    if (_nameField.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"名称不能为空" delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    if (_isSync == YES)
    {
        if(_passwordField.text.length == 0  || _newpasswordField.text.length == 0  )
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:LOCAL(@"pwd_not_empty") delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
            [alter show];
            return;
        }
    }
    
    if((_passwordField.text.length > 0)  &&( _newpasswordField.text.length > 0) )
    {
        if(![_cam.nsCamName  isEqualToString:_nameField.text])
        {
            SQLSingle *sql = [SQLSingle shareSQLSingle];
            [sql.dataBase executeUpdate:@"update camre_info set CAMERA_NAME=? where DEV_ID=?",_nameField.text,_cam.nsDID];
            _cam.nsCamName = _nameField.text;
            [WToast showWithText:LOCAL(@"save_db_success")];
        }
        if(_passwordField.text.length < 8 || _newpasswordField.text.length < 8)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码位数少于8位" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if(_passwordField.text.length >8 ||_newpasswordField.text.length > 8)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码位数大于8位" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if (_isSync == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未开启同步按钮" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
//        NSLog(@"sync:%d",_isSync);
//        IOCTRLSetDevPasswdReq req;
//        memset(&req, 0, sizeof(req));
//        strcpy(req.oldDevPasswd, [_passwordField.text UTF8String]);
//        strcpy(req.newDevPasswd, [_newpasswordField.text UTF8String]);
//        NSLog(@"cam pwd:%@",_cam.nsViewPwd);
        
        [_newpasswordField resignFirstResponder];
        [_cam Rjone_SetPassword:(char *)[_passwordField.text UTF8String] :(char *)[_newpasswordField.text UTF8String]];
        HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = LOCAL(@"please_wait");
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }

}
- (void)SetDevPassWD:(NSNotification *)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
        
        int result = [[[notification userInfo]objectForKey:@"key"]intValue];
      
        if (1 == result)
        {         NSLog(@"changedevpass old password error :%ld",(long)_cam.setpassresult);
                [HUD hide:YES];
                [WToast showWithText:LOCAL(@"change_pwd_failed")];
            
        }
        else if(0 == result)
        {
            NSLog(@"changedevpass succ :%ld\n",(long)_cam.setpassresult);
            [HUD hide:YES];
            _cam.nsViewPwd = _newpasswordField.text;
            SQLSingle *sql = [SQLSingle shareSQLSingle];
            [sql.dataBase executeUpdate:@"update camre_info set DEV_PWD=? where DEV_ID=?",_newpasswordField.text,_cam.nsDID];
            
            [WToast showWithText:LOCAL(@"change_pwd_success")];
        }
    });
}
- (void)TimeShowChangeSucc:(NSTimer *)theTimer
{
    

}
- (void)TimeShowChangeError:(NSTimer *)theTimer
{
    
}

-(void) changedevpass:(int) value;
{
    NSLog(@"%s %d    changedevpass:%d",__FILE__,__LINE__,value);
}
- (void)mySync:(UISwitch *)sync
{
    _isSync = sync.isOn;
   if(_isSync == YES)
   {
       _passwordField.userInteractionEnabled = YES;
       _newpasswordField.userInteractionEnabled = YES;
       _passwordField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
       _newpasswordField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
       cbv.userInteractionEnabled = YES;
       cbv1.userInteractionEnabled = YES;
       _ssidField.userInteractionEnabled  = NO;
   }
    else
    {
        _passwordField.userInteractionEnabled = NO;
        _newpasswordField.userInteractionEnabled = NO;
        cbv.userInteractionEnabled = NO;
        cbv1.userInteractionEnabled = NO;
        _passwordField.backgroundColor = UNAVAILABLECOLOR;
        _newpasswordField.backgroundColor = UNAVAILABLECOLOR;
        _ssidField.userInteractionEnabled = NO;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _passwordField && SCREEN_HEIGHT == 480)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-60);
        [UIView commitAnimations];
    }
    if(textField == _newpasswordField && SCREEN_HEIGHT == 480)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4-20);
        [UIView commitAnimations];
    }
    if (textField == _passwordField && SCREEN_HEIGHT == 568)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/3-40);
        [UIView commitAnimations];
    }
    if(textField == _newpasswordField && SCREEN_HEIGHT == 568)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/4);
        [UIView commitAnimations];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
        if (iOSVERSION <7.0) {
            self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-32);
            return;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [UIView commitAnimations];
    }
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 1003 || textField.tag == 1004)
    {
    if (range.location>=8)
    {
        return NO;
    }
    return YES;
    }
    else
        return  YES;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
