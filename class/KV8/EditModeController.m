//
//  EditModeController.m
//  KV8
//
//  Created by MasKSJ on 14-8-14.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "EditModeController.h"
//#import "include/AVSTREAM_IO_Proto.h"
//#import "include/DCAM_API.h"
#import "SearchWIFIController.h"
#import "AppDelegate.h"
#import "WToast.h"
#import "miscClasses/GSetting.h"
BOOL switchbtn;
BOOL okbtn;
//IOCTRL_TYPE_LISTWIFIAP_RESP
typedef enum
{
    IOCTRL_WIFIAPENC_INVALID		= 0x00,
    IOCTRL_WIFIAPENC_NONE			= 0x01,
    IOCTRL_WIFIAPENC_WEP_NO_PWD		= 0x02,
    IOCTRL_WIFIAPENC_WEP_WITH_PWD	= 0x03,
    IOCTRL_WIFIAPENC_WPA_TKIP		= 0x04,
    IOCTRL_WIFIAPENC_WPA_AES		= 0x05,
    IOCTRL_WIFIAPENC_WPA2_TKIP		= 0x06,
    IOCTRL_WIFIAPENC_WPA2_AES		= 0x07,
    IOCTRL_WIFIAPENC_WPA_PSK_AES    = 0x08,
    IOCTRL_WIFIAPENC_WPA_PSK_TKIP   = 0x09,
    IOCTRL_WIFIAPENC_WPA2_PSK_AES   = 0x0A,
    IOCTRL_WIFIAPENC_WPA2_PSK_TKIP  = 0x0B,
}ENUM_WIFIAP_ENC;


@interface EditModeController ()
{
    UILabel *_mode;
    UILabel *_ssid;
    UILabel *_password;
    UITextField *_ssidField;
    UITextField *_passwordField;
    UISwitch *_mySwitch;
    UIView *_backView;
    UIView *_line;
    UIButton *_selectSSID;
    UILabel *_select;
    
    UILabel *_selectSSIDLabel;
    
    UIView * _pormtview;    //20141127  EngelChen  add     提示VIew
    UIImageView *_pormtbgview;   //20141127 EngelChen add
    UILabel *_pormtLabel;       //20141127 EngelChen add
    
    
     GSetting *_gSetting;   //20141203 Engelchen
    UILabel * ChangeSSID_label;  //切换模式连接失败提示
    UILabel *statusLabel;   // 切换后，状态显示成没有连接
    
    UIButton *OKButton;

}
@end

@implementation EditModeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMode) name:@"refreshMode" object:nil];
        //20141203 EngelChen

         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeConnnectSSID:) name:@"ChangeConnnectSSID" object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RefreshStatus) name:@"RefreshStatus" object:nil];
        _gSetting=[GSetting instance];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.WIFISSID.length)
    {
          _ssidField.text = delegate.WIFISSID;
        for (NSDictionary *dic in _cam.WIFIarray)
        {
            if ([delegate.WIFISSID isEqualToString:[dic objectForKey:@"ssid"]])
            {
                switch ([[dic objectForKey:@"enctype"]charValue])
                {
                    case IOCTRL_WIFIAPENC_INVALID:
                    {
//                        [_selectSSID setTitle:@"INVALID" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"INVALID"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_NONE:
                    {
//                        [_selectSSID setTitle:@"NONE" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"NONE"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WEP_NO_PWD:
                    {
//                        [_selectSSID setTitle:@"NO_PWD" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"NO_PWD"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WEP_WITH_PWD:
                    {
//                        [_selectSSID setTitle:@"WITH_PWD" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WITH_PWD"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA_TKIP:
                    {
//                        [_selectSSID setTitle:@"WPA_TKIP" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA_TKIP"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA_AES:
                    {
//                        [_selectSSID setTitle:@"WPA_AES" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA_AES"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA2_TKIP:
                    {
//                        [_selectSSID setTitle:@"WPA2_TKIP" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA2_TKIP"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA2_AES:
                    {
//                        [_selectSSID setTitle:@"WPA2_AES" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA2_AES"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA_PSK_AES:
                    {
//                        [_selectSSID setTitle:@"WPA_PSK_AES" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA_PSK_AES"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA_PSK_TKIP:
                    {
//                        [_selectSSID setTitle:@"WPA_PSK_TKIP" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA_PSK_TKIP"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA2_PSK_AES:
                    {
//                        [_selectSSID setTitle:@"WPA2_PSK_AES" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA2_PSK_AES"];
                    }
                        break;
                    case IOCTRL_WIFIAPENC_WPA2_PSK_TKIP:
                    {
//                        [_selectSSID setTitle:@"WPA2_PSK_TKIP" forState:UIControlStateNormal];
                        [_selectSSIDLabel setText:@"WPA2_PSK_TKIP"];
                    }
                        break;
                        
                    default:
                        break;
                }
                break;
            }
        }
    
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  [NSString stringWithFormat:LOCAL(@"change_s_network"),_cam.nsCamName];
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    OKButton.frame = CGRectMake(0, 0, 25, 23.53);
    [OKButton setImage:[UIImage imageWithContentsOfFile:PATH(@"ok_no")] forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(myOK) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:OKButton];
    if (_cam.mCamState !=CONN_INFO_CONNECTED )
    {
        OKButton.userInteractionEnabled = NO;
    }
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 200, 30)];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = TOPBARCOLOR;
    
    
    
    NSDictionary *ifs =  [(AppDelegate *)[[UIApplication sharedApplication] delegate] fetchSSIDInfo];
    NSString *ssid = [[ifs objectForKey:@"SSID"] lowercaseString];
    NSLog(@"%s  %d   %@",__FILE__,__LINE__,ssid);
    //    NSDictionary *dic = [self fetchSSIDInfo];
    //    NSString *ssida = [[dic objectForKey:@"SSID"] lowercaseString];
    if (_cam.mCamState == CONN_INFO_CONNECTED)
    {
        if(_cam.WIFI_SSID.length)
        {
            statusLabel.text = LOCAL(@"connected_hint");
            NSLog(@"mySSID:%@",_cam.WIFI_SSID);
            statusLabel.text = [NSString stringWithFormat:@"%@%@",statusLabel.text,_cam.WIFI_SSID];
        }
        else{
            statusLabel.text = [NSString stringWithFormat:@"%@",LOCAL(@"connected_hint")];
        }
    }
    else
    {
        statusLabel.text = LOCAL(@"disconnected_hint");
        statusLabel.text = [NSString stringWithFormat:@"%@%@",statusLabel.text,ssid];
        statusLabel.textColor = [UIColor purpleColor];
    }
    statusLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:statusLabel];
    
    //backView
    _backView = [[UIView alloc]initWithFrame:CGRectMake(10, 60+20, SCREEN_WIDTH-20, 240-60)];
    _backView.backgroundColor = UIColorFromRGB(0x009AD3);
    _backView.layer.cornerRadius = 8;
    [self.view addSubview:_backView];
    
    for (int i =0; i <2; i++)
    {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 60+i*60, SCREEN_WIDTH-20, 2)];
        line.backgroundColor = BLUECOLOR;
        [_backView addSubview:line];
    }
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, 60+2*60, SCREEN_WIDTH-20, 2)];
    _line.backgroundColor = BLUECOLOR;
    //    [_backView addSubview:_line];
    
    _mode = [[UILabel alloc]initWithFrame:CGRectMake(15, 18, 150, 30)];
    _mode.backgroundColor = [UIColor clearColor];
    _mode.text = LOCAL(@"wifi_mode");
    _mode.textColor = [UIColor whiteColor];
    //根据语言做相应布局
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"en"])
    {
        _mode.font = [UIFont systemFontOfSize:15];
    }
    //    [_backView addSubview:_mode];
    
    _mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(235, 16, 0, 0)];
    [_mySwitch addTarget:self action:@selector(myMode:) forControlEvents:UIControlEventValueChanged];
    //    [_backView addSubview:_mySwitch];
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        _mySwitch.userInteractionEnabled = NO;
    }
    if (iOSVERSION <7.0)
    {
        _mySwitch.frame = CGRectMake(215, 16, 0, 0);
    }
    
    _ssid = [[UILabel alloc]initWithFrame:CGRectMake(15, 18+60-60, 150, 30)];
    _ssid.backgroundColor = [UIColor clearColor];
    _ssid.text = LOCAL(@"wifi_ssid");
    _ssid.textColor = [UIColor whiteColor];
    if ([currentLanguage isEqualToString:@"en"])
    {
        _ssid.font = [UIFont systemFontOfSize:15];
    }
    [_backView addSubview:_ssid];
    
    _ssidField = [[UITextField alloc]initWithFrame:CGRectMake(110, 71-60, 180, 40)];
    _ssidField.layer.cornerRadius = 5;
    _ssidField.backgroundColor = [UIColor whiteColor];
    _ssidField.delegate = self;
    _ssidField.returnKeyType = UIReturnKeyDone;
    _ssidField.textColor = TOPBARCOLOR;
    _ssidField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _ssidField.text = _cam.WIFI_SSID;
    [_backView addSubview:_ssidField];
    
    _password = [[UILabel alloc]initWithFrame:CGRectMake(15, 18+60+60-60, 150, 30)];
    _password.backgroundColor = [UIColor clearColor];
    _password.text = LOCAL(@"wifi_pwd");
    _password.textColor = [UIColor whiteColor];
    _password.tag = 1001;
    if ([currentLanguage isEqualToString:@"en"])
    {
        _password.font = [UIFont systemFontOfSize:12];
    }
    [_backView addSubview:_password];
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(110, 131-60, 150, 40)];
    _passwordField.layer.cornerRadius = 5;
    _passwordField.backgroundColor = [UIColor whiteColor];
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.secureTextEntry = NO;
    _passwordField.textColor = TOPBARCOLOR;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_backView addSubview:_passwordField];
    
    SSCheckBoxView *cbv = nil;
    CGRect frame = CGRectMake(265, _ssidField.frame.size.height/2+55, 240, 30);
    SSCheckBoxViewStyle style = (2 % kSSCheckBoxViewStylesCount);
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                          style:style
                                        checked:YES];
    
    [_backView addSubview:cbv];
    [cbv setStateChangedBlock:^(SSCheckBoxView *v) {
        [self checkBoxViewChangedState:v];
    }];
    
    _select = [[UILabel alloc]initWithFrame:CGRectMake(15, 18+60+60+60-60, 150, 30)];
    _select.backgroundColor = [UIColor clearColor];
    _select.text = LOCAL(@"select_ssid");
    _select.textColor = [UIColor whiteColor];
    if ([currentLanguage isEqualToString:@"en"])
    {
        _select.font = [UIFont systemFontOfSize:15];
    }
    [_backView addSubview:_select];
    
    _selectSSIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 18+60+60, 150, 30)];
    _selectSSIDLabel.backgroundColor = [UIColor clearColor];
    _selectSSIDLabel.textColor = [UIColor whiteColor];
    if ([currentLanguage isEqualToString:@"en"])
    {
        _selectSSIDLabel.font = [UIFont systemFontOfSize:15];
    }
    [_backView addSubview:_selectSSIDLabel];
    _selectSSID = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectSSID.frame =CGRectMake(140, 198-7-60, 180, 40);
    [_selectSSID setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSSID setImage:IMAGE(@"arrow") forState:UIControlStateNormal];
    _selectSSID.imageEdgeInsets = UIEdgeInsetsMake(10, 152-60, 10, 0);
    _selectSSID.showsTouchWhenHighlighted = YES;
    [_selectSSID addTarget:self action:@selector(mySelect) forControlEvents:UIControlEventTouchUpInside];
    _selectSSID.titleLabel.font = [UIFont systemFontOfSize:15];
    _selectSSID.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_backView addSubview:_selectSSID];
    
    
    ChangeSSID_label =[[UILabel alloc]init];
    ChangeSSID_label.textColor= [ UIColor redColor];
    ChangeSSID_label.text = LOCAL(@"changewifip");
    [_backView addSubview:ChangeSSID_label];
    ChangeSSID_label.hidden = YES;
    [ChangeSSID_label setTextAlignment:NSTextAlignmentLeft];
    ChangeSSID_label.font = [UIFont systemFontOfSize:6];
    [ChangeSSID_label setNumberOfLines:0];
    
    
    //设置自动行数与字符换行
    [ChangeSSID_label setNumberOfLines:0];
    ChangeSSID_label.lineBreakMode = UILineBreakModeWordWrap;
    // 测试字串
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    //设置一个行高上限
    CGSize size = CGSizeMake(320,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [ChangeSSID_label.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [ChangeSSID_label setFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
    CGRect rect = _select.frame;
    ChangeSSID_label.frame = CGRectMake(rect.origin.x, rect.origin.y+ 60, ChangeSSID_label.frame.size.width, ChangeSSID_label.frame.size.height);
    
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        _selectSSID.userInteractionEnabled = NO;
    }
    
    //20141127 EngelChen add
    
    _pormtview  = [[UIView alloc] init];
    _pormtview.frame = CGRectMake(0, 240, SCREEN_WIDTH, 60);
    
    _pormtbgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    _pormtbgview.backgroundColor = [UIColor blueColor];
    [_pormtview addSubview:_pormtbgview];
    _pormtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    //
    
    
    if (iOSVERSION >=7.0)
    {
        statusLabel.frame = CGRectMake(statusLabel.frame.origin.x,statusLabel.frame.origin.y+ADJSTHEIGHT,statusLabel.frame.size.width+200,statusLabel.frame.size.height);
        _backView.frame = CGRectMake(_backView.frame.origin.x,_backView.frame.origin.y+ADJSTHEIGHT,_backView.frame.size.width,_backView.frame.size.height);
    }
//    [_cam sendIOCtrl:IOCTRL_TYPE_GET_SN_ETC2_REQ withIOData:NULL  withDataSize:0];

}
//WIFI
-(id)fetchSSIDInfo
{
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam)));
        if (info && [info count]) {
            break;
        }

    }
    return info ;
}

- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (  id)CFBridgingRelease(CNCopySupportedInterfaces());
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam)));
        NSLog(@"dici：%@",[info  allKeys]);
        if (info[@"SSIDD"]) {
            ssid = info[@"SSID"];
            
        }
    }
    return ssid;
}

- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    NSLog(@"checkBoxViewChangedState: %d", cbv.checked);
    NSLog(@"checkBoxViewChangedState: %ld", (long)cbv.tag);
    if(cbv.checked == YES)
    {
        _passwordField.secureTextEntry = NO;
    }
    else
    {
         _passwordField.secureTextEntry = YES;
    }
}
- (void)myMode:(UISwitch *)mySwitch
{
    switchbtn = true;
    if (mySwitch.isOn)
    {
        _mode.text = LOCAL( @"ap_mode");
        _ssid.text = LOCAL(@"ap_ssid");
        _password.text = LOCAL(@"ap_pwd");
        _ssidField.text = _cam.DEV_SSID;
        _passwordField.text = @"12345678";
        _ssidField.backgroundColor = UNAVAILABLECOLOR;
        _passwordField.backgroundColor = UNAVAILABLECOLOR;
        _ssidField.userInteractionEnabled =  NO;
        _passwordField.userInteractionEnabled = NO;
        _backView.frame = CGRectMake(_backView.frame.origin.x,_backView.frame.origin.y,_backView.frame.size.width,180);
        _selectSSID.hidden = YES;
        _select.hidden = YES;
        CGRect rect = _password.frame;
//        ChangeSSID_label.frame = CGRectMake(rect.origin.x, rect.origin.y + 60, SCREEN_HEIGHT-40, rect.size.height);
//        [ChangeSSID_label setFrame:CGRectMake(rect.origin.x, rect.origin.y + 60, labelsize.width, labelsize.height)];
        ChangeSSID_label.frame = CGRectMake(rect.origin.x, rect.origin.y+ 60, ChangeSSID_label.frame.size.width, ChangeSSID_label.frame.size.height);
    }
    else
    {
        _mode.text = LOCAL( @"wifi_mode");
        _ssid.text = LOCAL(@"wifi_ssid");
        _password.text = LOCAL(@"wifi_pwd");
        _ssidField.text = _cam.WIFI_SSID;
        _passwordField.text = @"";
        _ssidField.backgroundColor = [UIColor whiteColor];
        _passwordField.backgroundColor = [UIColor whiteColor];
        _ssidField.userInteractionEnabled =  NO;
        _passwordField.userInteractionEnabled = YES;
        _backView.frame = CGRectMake(_backView.frame.origin.x,_backView.frame.origin.y,_backView.frame.size.width,240-60);
        _selectSSID.hidden = NO;
        _select.hidden = NO;
        CGRect rect = _select.frame;
//        ChangeSSID_label.frame = CGRectMake(rect.origin.x, rect.origin.y + 60, SCREEN_HEIGHT-40, rect.size.height);
         ChangeSSID_label.frame = CGRectMake(rect.origin.x, rect.origin.y+ 60, ChangeSSID_label.frame.size.width, ChangeSSID_label.frame.size.height);
    }
}

- (void)mySelect
{
    [_cam Rjone_ListWif];
    SearchWIFIController *search = [[SearchWIFIController alloc]init];
    search.cam = _cam;
    [self.navigationController pushViewController:search animated:YES];
    
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)myOK
{
    okbtn = true;
    [_passwordField resignFirstResponder];
    if (_mySwitch.isOn)
    {
        //AP模式
//        IOCTRLSetWifiReq req;
//        memset(&req, 0, sizeof(req));
//        req.flag_wifi_info = 1;
        NSInteger nRet;
        nRet = [_cam Rjone_SetWifi:1 :NULL :NULL :NULL];
        
        NSLog(@"set AP mode result=%ld",(long)nRet);
    }
    else
    {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        for (NSDictionary *dic in _cam.WIFIarray)
        {
            if ([delegate.WIFISSID isEqualToString:[dic objectForKey:@"ssid"]])
            {
                //WIFI模式
//                IOCTRLSetWifiReq req;
//                memset(&req, 0, sizeof(req));
//                strcpy((char *)req.ssid, [_ssidField.text UTF8String]);
//                strcpy((char *)req.password, [_passwordField.text UTF8String]);
//                req.signal_channel = [[dic objectForKey:@"channel"]charValue];
//                req.enctype = [[dic objectForKey:@"enctype"]charValue];
//                req.flag_wifi_info  = 2;
                [_cam Rjone_SetWifi:2 :(char *)[_ssidField.text UTF8String] :(char *)[_passwordField.text UTF8String] :[[dic objectForKey:@"enctype"]charValue]];
                
                break;
            }
        }
    }
}

//20141203 Engelchen

- (void)ChangeConnnectSSID:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{

        int result = [[[notification userInfo]objectForKey:@"key"]intValue];
        if (1 == result)
        {
//            [WToast showWithText:LOCAL(@"save_ok")];
            [WToast showWithText:[NSString stringWithFormat:@"%@%@",LOCAL(@"save_ok"),_ssidField.text]];
        }
        else if(2 == result)
        {
//            [WToast showWithText:LOCAL(@"save_ok")];
            [WToast showWithText:[NSString stringWithFormat:@"%@%@",LOCAL(@"save_ok"),_ssidField.text]];
        }
        else if(-1 == result)
        {
             [WToast showWithText:LOCAL(@"save_fail")];
        }
       
    });
}


- (void)RefreshStatus
{
     dispatch_async(dispatch_get_main_queue(), ^{
    {
    for(int i =0 ; i < [_gSetting.arrCam count]; i++)
    {
    CamObj *cam = [_gSetting.arrCam objectAtIndex:i];

        
        if([cam.nsDID  isEqualToString:_cam.nsDID])
        {
            if(cam.mCamState != 5008)
            {
                statusLabel.text = LOCAL(@"disconnected_hint");
                ChangeSSID_label.text = [NSString stringWithFormat:@"%@%@%@%@%@",LOCAL(@"changewifip"),@"“",_ssidField.text,@"”",LOCAL(@"changewifip2")];
                ChangeSSID_label.hidden = NO;
            }else
            {
                ChangeSSID_label.hidden = YES;
            }
                
            switchbtn = false;
            okbtn = false;
            break;
        }
        
    }

          }
          });
}


- (void)myResult:(NSNumber *)nRet
{
    if ([nRet integerValue]<0)
    {
        [WToast showWithText:LOCAL(@"save_fail")];
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
        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-60);
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
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 1001)
    {
    if (range.location>=8)
    {
        return NO;
    }
    return YES;
    }
    else return YES;
}

- (void)refreshMode
{
        _mode.text = LOCAL( @"wifi_mode");
        _ssid.text = LOCAL(@"wifi_ssid");
        _password.text = LOCAL(@"wifi_pwd");
        _ssidField.text = _cam.WIFI_SSID;
        _passwordField.text = @"";
        _ssidField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _passwordField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _ssidField.userInteractionEnabled =  NO;
        _passwordField.userInteractionEnabled = YES;
        _backView.frame = CGRectMake(_backView.frame.origin.x,_backView.frame.origin.y,_backView.frame.size.width,240-60);
        _selectSSID.hidden = NO;
        _select.hidden = NO;
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
