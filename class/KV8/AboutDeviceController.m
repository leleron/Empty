//
//  AboutDeviceController.m
//  KV8
//
//  Created by MasKSJ on 14-8-14.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "AboutDeviceController.h"
//#import "include/DCAM_API.h"
//#import "include/AVSTREAM_IO_Proto.h"
@interface AboutDeviceController ()
{
    UILabel *_versionLabel;
    UILabel *_modeLabel;
    UILabel *_ssidLabel;
    
}
@end

@implementation AboutDeviceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMode) name:@"refreshMode" object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:LOCAL(@"about_device"),_cam.nsCamName];
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 180)];
    backView.backgroundColor = UIColorFromRGB(0x009AD3);
    backView.layer.cornerRadius = 8;
    [self.view addSubview:backView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 2)];
    line1.backgroundColor = BLUECOLOR;
    line1.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/3);
    [backView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 2)];
    line2.backgroundColor = BLUECOLOR;
    line2.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height*0.666667);
    [backView addSubview:line2];
    
    UILabel *version = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    version.backgroundColor = [UIColor clearColor];
    version.text = LOCAL(@"fm_ver");
    version.textColor = [UIColor whiteColor];
    version.center = CGPointMake(50, backView.frame.size.height/3/2);
    version.font = [UIFont systemFontOfSize:15];
    //根据语言做相应布局
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"en"])
    {
        version.frame=CGRectMake(0, 0, 150, 20);
        version.center = CGPointMake(85, backView.frame.size.height/3/2);
    }
    [backView addSubview:version];
    
    UILabel *mode = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    mode.backgroundColor = [UIColor clearColor];
    mode.text = LOCAL(@"net_mode");
    mode.textColor = [UIColor whiteColor];
    mode.center = CGPointMake(50, backView.frame.size.height*0.5);
    mode.font = [UIFont systemFontOfSize:15];
    if ([currentLanguage isEqualToString:@"en"])
    {
        mode.frame=CGRectMake(0, 0, 120, 20);
        mode.center = CGPointMake(70, backView.frame.size.height*0.5);
    }
    [backView addSubview:mode];
    
    UILabel *ssid = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    ssid.backgroundColor = [UIColor clearColor];
    ssid.text = LOCAL(@"ssid_of_wifi");
    ssid.textColor = [UIColor whiteColor];
    ssid.center = CGPointMake(83, backView.frame.size.height*0.84);
    ssid.font = [UIFont systemFontOfSize:15];
    [backView addSubview:ssid];
    
    _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 21, 150, 20)];
    _versionLabel.text = [NSString stringWithFormat:@"%ld",(long)_cam.version];
    if (_cam.mCamState !=CONN_INFO_CONNECTED )
    {
        _versionLabel.text = @"---";
        
    }
    _versionLabel.backgroundColor = [UIColor clearColor];
    _versionLabel.textColor = [UIColor whiteColor];
    _versionLabel.font = [UIFont systemFontOfSize:15];
    _versionLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_versionLabel];
    
    _modeLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 81, 150, 20)];
    if (_cam.netMode == 1)
    {
        _modeLabel.text = @"AP";
    }
    if (_cam.netMode == 2)
    {
        _modeLabel.text = @"Wi-Fi";
    }
    if (_cam.mCamState !=CONN_INFO_CONNECTED )
    {
        _modeLabel.text = @"---";
        
    }
    _modeLabel.backgroundColor = [UIColor clearColor];
    _modeLabel.textColor = [UIColor whiteColor];
    _modeLabel.font = [UIFont systemFontOfSize:15];
    _modeLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_modeLabel];
    
    _ssidLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 141, 150, 20)];
    _ssidLabel.text = _cam.DEV_SSID;
    if (_cam.mCamState !=CONN_INFO_CONNECTED )
    {
        _ssidLabel.text = @"---";
        
    }
    _ssidLabel.backgroundColor = [UIColor clearColor];
    _ssidLabel.textColor = [UIColor whiteColor];
    _ssidLabel.font = [UIFont systemFontOfSize:15];
    _ssidLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_ssidLabel];
    
    [_cam Rjone_GetEtc2];
    
    if (iOSVERSION >=7.0)
    {
        backView.frame = CGRectMake(backView.frame.origin.x,backView.frame.origin.y+ADJSTHEIGHT,backView.frame.size.width,backView.frame.size.height);
    }
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshMode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_cam.netMode == 1)
        {
            _modeLabel.text = @"AP";
        }
        if (_cam.netMode == 2)
        {
            _modeLabel.text = @"Wi-Fi";
        }
    });
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
