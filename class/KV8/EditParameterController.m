//
//  EditParameterController.m
//  KV8
//
//  Created by MasKSJ on 14-8-14.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "EditParameterController.h"
//#import "include/DCAM_API.h"
//#import "AVSTREAM_IO_Proto.h"
#import "WToast.h"
#import "AppDelegate.h"
@interface EditParameterController ()
{
    UILabel *_contrastValue;
    UILabel *_lightValue;
}
@end

@implementation EditParameterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeContrast:) name:@"ChangeContrast" object:nil];
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
    self.title = [NSString stringWithFormat:LOCAL(@"change_s_parameter"),_cam.nsCamName];
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton *OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    OKButton.frame = CGRectMake(0, 0, 25, 23.53);
    [OKButton setImage:[UIImage imageWithContentsOfFile:PATH(@"ok_no")] forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(myOK) forControlEvents:UIControlEventTouchUpInside];
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        OKButton.userInteractionEnabled =  NO;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:OKButton];
    
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 200, 30)];
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
    
    //backView
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-20, 120)];
    backView.backgroundColor = UIColorFromRGB(0x009AD3);
    backView.layer.cornerRadius = 8;
    [self.view addSubview:backView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 2)];
    line.backgroundColor = BLUECOLOR;
    line.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2);
    [backView addSubview:line];
    
    //对比度
    UILabel *contrast = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 100, 30)];
    contrast.backgroundColor = [UIColor clearColor];
    contrast.text = LOCAL(@"contrast");
    contrast.textColor = [UIColor whiteColor];
    contrast.font = [UIFont systemFontOfSize:14];
    contrast.textColor = [UIColor whiteColor];
    [backView addSubview:contrast];
    
    UILabel *contrastCurrent =[[UILabel alloc]initWithFrame:CGRectMake(20, 28, 70, 30)];
    contrastCurrent.backgroundColor = [UIColor clearColor];
    contrastCurrent.text = LOCAL(@"cur_val");
    contrastCurrent.textColor = [UIColor whiteColor];
    contrastCurrent.font = [UIFont systemFontOfSize:13];
    contrastCurrent.textColor = [UIColor whiteColor];
    //根据语言做相应布局
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"en"])
    {
        contrastCurrent.font = [UIFont systemFontOfSize:9];
    }
    [backView addSubview:contrastCurrent];
    
    _contrastValue =[[UILabel alloc]initWithFrame:CGRectMake(65, 28, 60, 30)];
    _contrastValue.backgroundColor = [UIColor clearColor];
    _contrastValue.text = [NSString stringWithFormat:@"%ld",(long)_cam.contrast];
    _contrastValue.textColor = [UIColor whiteColor];
    _contrastValue.font = [UIFont systemFontOfSize:13];
    _contrastValue.textColor = [UIColor whiteColor];
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        _contrastValue.text= @"";
    }
    if ([currentLanguage isEqualToString:@"en"])
    {
        _contrastValue.frame =CGRectMake(80, 28, 60, 30);
        _contrastValue.font = [UIFont systemFontOfSize:9];
    }
    [backView addSubview:_contrastValue];
    
    UISlider *contrastSlider = [[UISlider alloc]initWithFrame:CGRectMake(110, 22, 170, 20)];
    contrastSlider.minimumTrackTintColor = [UIColor blackColor];
    contrastSlider.maximumTrackTintColor = [UIColor whiteColor];
    contrastSlider.minimumValue = 0;
    contrastSlider.maximumValue = 100;
    [contrastSlider addTarget:self action:@selector(myCcontrast:) forControlEvents:UIControlEventValueChanged];
    [contrastSlider setValue:_cam.contrast animated:YES];
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        contrastSlider.userInteractionEnabled = NO;
        [contrastSlider setValue:0 animated:YES];
    }
    [backView addSubview:contrastSlider];
    
    //亮度
    UILabel *light = [[UILabel alloc]initWithFrame:CGRectMake(20, 68, 100, 30)];
    light.backgroundColor = [UIColor clearColor];
    light.text = LOCAL(@"brightness");
    light.textColor = [UIColor whiteColor];
    light.font = [UIFont systemFontOfSize:14];
    light.textColor = [UIColor whiteColor];
    [backView addSubview:light];
    
    UILabel *lightCurrent =[[UILabel alloc]initWithFrame:CGRectMake(20, 88, 70, 30)];
    lightCurrent.backgroundColor = [UIColor clearColor];
    lightCurrent.text = LOCAL(@"cur_val");
    lightCurrent.textColor = [UIColor whiteColor];
    lightCurrent.font = [UIFont systemFontOfSize:13];
    lightCurrent.textColor = [UIColor whiteColor];
    if ([currentLanguage isEqualToString:@"en"])
    {
        lightCurrent.font = [UIFont systemFontOfSize:9];
    }
    [backView addSubview:lightCurrent];
    
    _lightValue =[[UILabel alloc]initWithFrame:CGRectMake(65, 88, 60, 30)];
    _lightValue.backgroundColor = [UIColor clearColor];
    _lightValue.text = [NSString stringWithFormat:@"%ld",(long)_cam.brightness];
    _lightValue.textColor = [UIColor whiteColor];
    _lightValue.font = [UIFont systemFontOfSize:13];
    _lightValue.textColor = [UIColor whiteColor];
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        _lightValue.text= @"";
    }
    if ([currentLanguage isEqualToString:@"en"])
    {
        _lightValue.frame =CGRectMake(80, 88, 60, 30);
        _lightValue.font = [UIFont systemFontOfSize:9];
    }
    [backView addSubview:_lightValue];
    
    UISlider *lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(110, 82, 170, 20)];
    lightSlider.minimumTrackTintColor = [UIColor blackColor];
    lightSlider.maximumTrackTintColor = [UIColor whiteColor];
    lightSlider.minimumValue = 0;
    lightSlider.maximumValue = 100;
    [lightSlider addTarget:self action:@selector(myLight:) forControlEvents:UIControlEventValueChanged];
    [lightSlider setValue:_cam.brightness animated:YES];
    if (_cam.mCamState != CONN_INFO_CONNECTED)
    {
        lightSlider.userInteractionEnabled = NO;
        [lightSlider setValue:0 animated:YES];
    }
    [backView addSubview:lightSlider];
    
    if (iOSVERSION >=7.0)
    {
        statusLabel.frame = CGRectMake(statusLabel.frame.origin.x,statusLabel.frame.origin.y+ADJSTHEIGHT,statusLabel.frame.size.width,statusLabel.frame.size.height);
        backView.frame = CGRectMake(backView.frame.origin.x,backView.frame.origin.y+ADJSTHEIGHT,backView.frame.size.width,backView.frame.size.height);
    }
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)myOK
{
    if ([_contrastValue.text integerValue] == _cam.contrast && [_lightValue.text integerValue] == _cam.brightness)
    {
        [WToast showWithText:LOCAL(@"save_ok")];
        return;
    }
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    IOCTRLSetDevParameterReq req;
//    memset(&req, 0, sizeof(req));
//    req.bit_field = 0x08|0x10;
//    req.contrast = [_contrastValue.text integerValue];
//    req.brightness = [_lightValue.text integerValue] * 2.55;
    NSInteger nRet=[_cam Rjone_SetParameter:0x08|0x10 :NULL :[_contrastValue.text integerValue] :[_lightValue.text integerValue] * 2.55];
    delegate.contrast = [_contrastValue.text integerValue];
    delegate.brightness = [_lightValue.text integerValue] * 2.55;
    [WToast showWithText:LOCAL(@"sending_data")];
    
    [self performSelector:@selector(myResult:) withObject:[NSNumber numberWithInteger:nRet] afterDelay:1];
}
- (void)myCcontrast:(UISlider *)ContrastSlider
{
    _contrastValue.text = [NSString stringWithFormat:@"%ld",(long)ContrastSlider.value];
}
- (void)myLight:(UISlider *)LightSlider
{
    _lightValue.text = [NSString stringWithFormat:@"%ld",(long)LightSlider.value];
}
- (void)myResult:(NSNumber *)nRet
{
    if ([nRet integerValue]<0)
    {
        [WToast showWithText:LOCAL(@"save_fail")];
    }
}
- (void)ChangeContrast:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL result = [[[notification userInfo]objectForKey:@"key"]boolValue];
        if (result)
        {
            [WToast showWithText:LOCAL(@"save_ok")];
        }
        else
        {
            [WToast showWithText:LOCAL(@"save_fail")];
        }
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
