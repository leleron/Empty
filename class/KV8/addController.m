//
//  addController.m
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "addController.h"
#import "SearchController.h"
#import "miscClasses/CamObj.h"
#import "GSetting.h"
#import "SQLSingle.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
@interface addController ()
{
    UITextField *_nameField;
    UITextField *_didField;
    UITextField *_passwordField;
}
@end

@implementation addController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    _nameField.text = delegate.camDID;
    _didField.text = delegate.camDID;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOCAL(@"add_device");
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
    if (iOSVERSION >= 7.0)
    {
        nameView.frame = CGRectMake(10, 20+ADJSTHEIGHT, SCREEN_WIDTH-20, 60);
    }
    nameView.backgroundColor = UIColorFromRGB(0x009AD3);
    nameView.layer.cornerRadius = 8;
    [self.view addSubview:nameView];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    name.backgroundColor = [UIColor clearColor];
    name.text = LOCAL(@"name");
    name.textColor = [UIColor whiteColor];
    name.center = CGPointMake(40, nameView.frame.size.height/2);
    //根据语言做相应布局
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"en"])
    {
        name.font = [UIFont systemFontOfSize:14];
    }
    [nameView addSubview:name];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    _nameField.layer.cornerRadius = 5;
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.center = CGPointMake(190, nameView.frame.size.height/2);
    _nameField.delegate = self;
    _nameField.returnKeyType = UIReturnKeyDone;
    _nameField.textColor = TOPBARCOLOR;
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [nameView addSubview:_nameField];
    
    UILabel *nameDescribeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, SCREEN_WIDTH-20, 40)];
    if (iOSVERSION >=7.0)
    {
        nameDescribeLable.frame = CGRectMake(20, 85+ADJSTHEIGHT, SCREEN_WIDTH-20, 40);
    }
    nameDescribeLable.backgroundColor = [UIColor clearColor];
    nameDescribeLable.textColor =UIColorFromRGB(0x009AD8);
    nameDescribeLable.text = LOCAL(@"hint1");
    nameDescribeLable.font = [UIFont systemFontOfSize:14];
    nameDescribeLable.numberOfLines = 0;
    if ([currentLanguage isEqualToString:@"en"])
    {
        nameDescribeLable.font = [UIFont systemFontOfSize:13];
    }
    [self.view addSubview:nameDescribeLable];
    
    //deviceView
    UIView *deviceView = [[UIView alloc]initWithFrame:CGRectMake(10, 125, SCREEN_WIDTH-20, 120)];
    if (iOSVERSION >=7.0)
    {
        deviceView.frame = CGRectMake(10, 125+ADJSTHEIGHT, SCREEN_WIDTH-20, 120);
    }
    deviceView.backgroundColor = UIColorFromRGB(0x009AD3);
    deviceView.layer.cornerRadius = 8;
    [self.view addSubview:deviceView];
    
    UILabel *ssid = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    ssid.backgroundColor = [UIColor clearColor];
    ssid.text = LOCAL(@"dev_id");
    ssid.textColor = [UIColor whiteColor];
    ssid.center = CGPointMake(50, nameView.frame.size.height/2);
    if ([currentLanguage isEqualToString:@"en"])
    {
        ssid.font = [UIFont systemFontOfSize:14];
    }
    [deviceView addSubview:ssid];
    
    _didField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    _didField.layer.cornerRadius = 5;
    _didField.backgroundColor = [UIColor whiteColor];
    _didField.center = CGPointMake(190, nameView.frame.size.height/2);
    _didField.delegate = self;
    _didField.returnKeyType = UIReturnKeyDone;
    _didField.textColor = TOPBARCOLOR;
    _didField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [deviceView addSubview:_didField];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 2)];
    line.backgroundColor = BLUECOLOR;
    line.center = CGPointMake(deviceView.frame.size.width/2, deviceView.frame.size.height/2);
    [deviceView addSubview:line];
    
    UILabel *password = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    password.backgroundColor = [UIColor clearColor];
    password.text = LOCAL(@"pwd");
    password.textColor = [UIColor whiteColor];
    password.center = CGPointMake(50, nameView.frame.size.height/2+60);
    if ([currentLanguage isEqualToString:@"en"])
    {
        password.font = [UIFont systemFontOfSize:14];
    }
    [deviceView addSubview:password];
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    _passwordField.layer.cornerRadius = 5;
    _passwordField.backgroundColor = [UIColor whiteColor];
    _passwordField.center = CGPointMake(190, nameView.frame.size.height/2+60);
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.secureTextEntry = YES;
    _passwordField.textColor = TOPBARCOLOR;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [deviceView addSubview:_passwordField];
    
    UILabel *deviceDescribeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 250, SCREEN_WIDTH-20, 40)];
    if (iOSVERSION >=7.0)
    {
        deviceDescribeLable.frame = CGRectMake(20, 250+ADJSTHEIGHT, SCREEN_WIDTH-20, 40);
    }
    deviceDescribeLable.backgroundColor = [UIColor clearColor];
    deviceDescribeLable.textColor =UIColorFromRGB(0x009AD3);
    deviceDescribeLable.text = LOCAL(@"label2");
    deviceDescribeLable.font = [UIFont systemFontOfSize:14];
    deviceDescribeLable.numberOfLines = 0;
    //根据语言做相应布局
    if ([currentLanguage isEqualToString:@"en"])
    {
        deviceDescribeLable.font = [UIFont systemFontOfSize:13];
    }
    [self.view addSubview:deviceDescribeLable];
    
    //searchButton
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(10, 290, SCREEN_WIDTH-20, 60);
    if (iOSVERSION >=7.0)
    {
        searchButton.frame = CGRectMake(10, 290+ADJSTHEIGHT, SCREEN_WIDTH-20, 60);
    }
    searchButton.backgroundColor = UIColorFromRGB(0x009AD3);
    searchButton.layer.cornerRadius = 8;
    searchButton.showsTouchWhenHighlighted = YES;
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton setTitle:LOCAL(@"search_in_lan") forState:UIControlStateNormal];
    [searchButton setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 180);
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(20, 265, 20, 20);
    if ([currentLanguage isEqualToString:@"en"])
    {
        searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    [searchButton addTarget:self action:@selector(mySearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_nameField == textField)
    {
        if ([toBeString length] > 30) {
            textField.text = [toBeString substringToIndex:30];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)mySave
{
    if (_nameField.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:LOCAL(@"camera_name_not_empty") delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    if (_didField.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:LOCAL(@"device_id_not_empty") delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    if (_passwordField.text.length == 0)
    {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:LOCAL(@"pwd_not_empty") delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    
    
    CamObj *camObj=[[CamObj alloc] init];
    camObj.nsDID    =  _didField.text;
    camObj.nsViewPwd  = _passwordField.text;
    camObj.nsCamName= _nameField.text;
    
    SQLSingle *sql = [SQLSingle shareSQLSingle];
    NSString *did =[sql.dataBase stringForQuery:@"select DEV_ID from camre_info where DEV_ID = ?",camObj.nsDID];
    if (did.length)
    {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:LOCAL(@"have_added") delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    else
    {
        GSetting *gSetting = [GSetting instance];
        [gSetting.arrCam addObject:camObj];
        [sql.dataBase executeUpdate:@"insert into camre_info(CAMERA_NAME,DEV_ID,DEV_PWD) values(?,?,?)",camObj.nsCamName,camObj.nsDID,camObj.nsViewPwd];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)mySearch
{
    SearchController *search = [[SearchController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
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
        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-70);
        [UIView commitAnimations];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (SCREEN_HEIGHT == 480) {
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
