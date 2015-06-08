//
//  VideoController.m
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "VideoController.h"
//#import "include/AVSTREAM_IO_Proto.h"
#import <AVFoundation/AVFoundation.h>
#import "WToast.h"
#import "StatusView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RJONE_LibCallBack.h"
#import "SKDropDown.h"
#import "AppDelegate.h"
typedef enum
{
    IOCTRL_QUALITY_QQVGA	       = 0x00,	// 160*120
    IOCTRL_QUALITY_QVGA		= 0x01,	// 320*240
    IOCTRL_QUALITY_VGA		= 0x02,	// 640*480
    IOCTRL_QUALITY_720P		= 0x03,	// 1280*720
    
}ENUM_RESOLUTION_LEVEL;


// IOCTRL PTZ Command Value
typedef enum
{
    IOCTRL_PTZ_STOP,
    IOCTRL_PTZ_UP,
    IOCTRL_PTZ_DOWN,
    IOCTRL_PTZ_LEFT,
    IOCTRL_PTZ_RIGHT,
    IOCTRL_PTZ_LEFT_UP,
    IOCTRL_PTZ_LEFT_DOWN,
    IOCTRL_PTZ_RIGHT_UP,
    IOCTRL_PTZ_RIGHT_DOWN,
    IOCTRL_LENS_ZOOM_IN,
    IOCTRL_LENS_ZOOM_OUT,
    IOCTRL_PTZ_SET_POINT,
    IOCTRL_PTZ_CLEAR_POINT,
    IOCTRL_PTZ_GOTO_POINT,
    IOCTRL_PTZ_FORWARD_SHORT,            // add for ZhiGuan PTZ
    IOCTRL_PTZ_BACKWARD_SHORT,           // add for ZhiGuan PTZ
    IOCTRL_PTZ_MOTO_TURN_L,              // add for ZhiGuan PTZ
    IOCTRL_PTZ_MOTO_TURN_R,              // add for ZhiGuan PTZ
    
    IOCTRL_CLEANER_POWER_ONOFF,	         //Power of cleaner is on or off
    IOCTRL_CLEANER_AUTO_CLEAN,	         //Cleaner clean auto automatically
    IOCTRL_CLEANER_FIXED_CLEAN,	         //Cleaner clean to fixed place
    IOCTRL_CLEANER_SPEED,		         //Cleaner speed
    IOCTRL_CLEANER_CHARGE,		         //Cleaner come back and charge
    
}ENUM_PTZCMD;


@interface VideoController ()
{
    UIImageView *_imageView;
    UIView *_panelView;
    NSTimer *_timer;
    ENUM_RESOLUTION_LEVEL _resolution;
    UIButton *_HD;
    MBProgressHUD *HUD;
    StatusView *_statusView;
    UIButton *_speed;
    UILabel *_FPSLabel;
    UILabel *_contrastValue;
    UILabel *_lightValue;
    UILabel *_contrast;
    UISlider *_contrastSlider;
    UILabel *_light;
    UISlider *_lightSlider;
    UIView *_middleView;
    BOOL _showError;
    
    int   _isSaveImgStatus;//141129 EngelChen
    BOOL _isSaveImg;
    
    RJONE_macvideo *_rjone ;
    CGRect SaveImageFrame;
    UIButton *power;
    SKDropDown *drop;
    UIButton *optionButton;
}
@end

VideoController *instance1;
@implementation VideoController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        m_bTimer=NO;
        m_bSpeak=0;
        _isSaveImg = NO;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeResolution) name:@"ChangeResolution" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeStatus) name:@"ChangeStatus" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeWork:) name:@"changeWork" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeContrastVideo:) name:@"ChangeContrast" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector
         (ChangeBrightVideo:) name:@"ChangeBright" object:nil];
    }
    return self;
}

- (void)ChangeContrastVideo:(NSNotification *)notification
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


- (void)ChangeBrightVideo:(NSNotification *)notification
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


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.cam.m_delegateCam=self;
    NSInteger nRet=[_cam startVideo:AV_TYPE_REALAV withTime:0L];
    
    if(nRet>=0) [self startTimer];

    BOOL initResult=[_rjone RJONE_InitDecode:640 andHe:480 andFrame:SaveImageFrame];//141128 EngelChen
    if (!initResult)
    {
        [NSThread sleepForTimeInterval:100000000];
    }
     savetime = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(StartSaveOneImg2Doc:) userInfo:nil repeats:YES];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
   
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
        _cam.m_delegateCam=nil;
        [_statusView myRelease];
        [self stopTimer];
        
        [_cam stopVideo:AV_TYPE_REALAV withTime:0L];
    
        [savetime invalidate];
    
        _cam.cleanFifo = true;
        [_rjone RJONE_UninitDecode];  //141128   EngelChen
    
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        
        [super viewWillDisappear:animated];

}

+(VideoController *)share
{
    return instance1;
}
- (void)viewDidLoad
{
    instance1 = self;
    //根据语言做相应布局
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    m_colorSpaceRGB   = CGColorSpaceCreateDeviceRGB();
    m_bytesPerRow	  =0;
    m_nWidth=m_nHeight=0;
    m_nImgDataSize    =0;
    _cam.m_delegateCam=self;
    
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:LOCAL(@"live"),_cam.nsCamName];
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    optionButton.frame = CGRectMake(0, 0, 38, 37);
    [optionButton setImage:[UIImage imageWithContentsOfFile:PATH(@"edit_no")] forState:UIControlStateNormal];
    [optionButton addTarget:self action:@selector(myEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:optionButton];
    
    //监控主页面
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    _FPSLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 215 +60, SCREEN_WIDTH, 20)];
    _FPSLabel.backgroundColor = [UIColor clearColor];
    _FPSLabel.textColor = [UIColor whiteColor];
    _FPSLabel.font = [UIFont systemFontOfSize:12];
    //    [_imageView addSubview:_FPSLabel];
    [self.view addSubview:_FPSLabel];
    
    _middleView = [[UIView alloc]initWithFrame:CGRectMake(10, 0+120, SCREEN_WIDTH-20, 100)];
    _middleView.layer.cornerRadius = 8;
    _middleView.backgroundColor = [UIColor lightGrayColor];
    _middleView.alpha = 0.8;
    //    _middleView.center = CGPointMake(_imageView.frame.size.width/2, _imageView.frame.size.height/2);
    //    [_imageView addSubview:_middleView];
    [self.view addSubview:_middleView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_middleView addGestureRecognizer:tap1];
    
    //////////////////////////////////////   141128 EngelChen
    _rjone = [[RJONE_macvideo alloc]init];
    [_rjone SettView:self.view andImg:_imageView];
    [_rjone setDelegate:self ];
    SaveImageFrame =  _imageView.frame;
    
    _isSaveImgStatus = -1;
    
    
    
    //对比度
    _contrast = [[UILabel alloc]initWithFrame:CGRectMake(20, 16, 70, 30)];
    _contrast.backgroundColor = [UIColor clearColor];
    _contrast.text = LOCAL(@"contrast");
    _contrast.textColor = [UIColor whiteColor];
    _contrast.font = [UIFont systemFontOfSize:15];
    _contrast.textColor = [UIColor whiteColor];
    [_middleView addSubview:_contrast];
    
    _contrastValue =[[UILabel alloc]initWithFrame:CGRectMake(70, 16, 60, 30)];
    _contrastValue.backgroundColor = [UIColor clearColor];
    _contrastValue.text = [NSString stringWithFormat:@"%ld",(long)_cam.contrast];
    _contrastValue.textColor = [UIColor whiteColor];
    _contrastValue.font = [UIFont systemFontOfSize:15];
    _contrastValue.textColor = [UIColor whiteColor];
    if ([currentLanguage isEqualToString:@"en"])
    {
        _contrastValue.frame  = CGRectMake(_contrastValue.frame.origin.x+15, _contrastValue.frame.origin.y, _contrastValue.frame.size.width, _contrastValue.frame.size.height);
    }
    [_middleView addSubview:_contrastValue];
    
    _contrastSlider = [[UISlider alloc]initWithFrame:CGRectMake(110, 20, 170, 20)];
    _contrastSlider.minimumTrackTintColor = TOPBARCOLOR;
    _contrastSlider.maximumTrackTintColor = [UIColor whiteColor];
    _contrastSlider.minimumValue = 0;
    _contrastSlider.maximumValue = 100;
    [_contrastSlider addTarget:self action:@selector(myCcontrast:) forControlEvents:UIControlEventValueChanged];
    [_contrastSlider setValue:_cam.contrast animated:YES];
    [_middleView addSubview:_contrastSlider];
    
    //亮度
    _light = [[UILabel alloc]initWithFrame:CGRectMake(20, 59, 70, 30)];
    _light.backgroundColor = [UIColor clearColor];
    _light.text = LOCAL(@"brightness");
    _light.textColor = [UIColor whiteColor];
    _light.font = [UIFont systemFontOfSize:15];
    _light.textColor = [UIColor whiteColor];
    [_middleView addSubview:_light];
    
    _lightValue =[[UILabel alloc]initWithFrame:CGRectMake(70, 59, 60, 30)];
    _lightValue.backgroundColor = [UIColor clearColor];
    _lightValue.text = [NSString stringWithFormat:@"%ld",(long)_cam.brightness];
    _lightValue.textColor = [UIColor whiteColor];
    _lightValue.font = [UIFont systemFontOfSize:15];
    _lightValue.textColor = [UIColor whiteColor];
    if ([currentLanguage isEqualToString:@"en"])
    {
        _lightValue.frame  = CGRectMake(_lightValue.frame.origin.x+15, _lightValue.frame.origin.y, _lightValue.frame.size.width, _lightValue.frame.size.height);
        _light.font = [UIFont systemFontOfSize:13];
    }
    [_middleView addSubview:_lightValue];
    
    _lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(110, 63, 170, 20)];
    _lightSlider.minimumTrackTintColor = TOPBARCOLOR;
    _lightSlider.maximumTrackTintColor = [UIColor whiteColor];
    _lightSlider.minimumValue = 0;
    _lightSlider.maximumValue = 100;
    [_lightSlider addTarget:self action:@selector(myLight:) forControlEvents:UIControlEventValueChanged];
    [_lightSlider setValue:_cam.brightness animated:YES];
    [_middleView addSubview:_lightSlider];
    
    _middleView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myTap:)];
    [_imageView addGestureRecognizer:tap];
    
    //    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(changeResolution)];
    //    [_imageView addGestureRecognizer:longTap];
    
    
    _panelView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 209)];
    _panelView.backgroundColor = BLUECOLOR;
    [self.view addSubview:_panelView];
    
    //功能键
    power = [UIButton buttonWithType:UIButtonTypeCustom];
    power.frame = CGRectMake(5, 5, 58, 30);
    [power setBackgroundImage:IMAGE(@"func_normal") forState:UIControlStateNormal];
    //    [power setTitle:@"Power" forState:UIControlStateNormal];_mode.text = LOCAL( @"ap_mode");
    [power setTitle:LOCAL(@"power") forState:UIControlStateNormal];
    [power setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    power.titleLabel.font = [UIFont systemFontOfSize:11];
    [power addTarget:self action:@selector(power) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:power];
    
    UIButton *charge = [UIButton buttonWithType:UIButtonTypeCustom];
    charge.frame = CGRectMake(68, 5, 58, 30);
    [charge setBackgroundImage:IMAGE(@"func_normal") forState:UIControlStateNormal];
    //    [charge setTitle:@"Charge" forState:UIControlStateNormal];
    [charge setTitle:LOCAL(@"charge") forState:UIControlStateNormal];
    [charge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    charge.titleLabel.font = [UIFont systemFontOfSize:11];
    [charge addTarget:self action:@selector(charge) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:charge];
    
    _speed = [UIButton buttonWithType:UIButtonTypeCustom];
    _speed.frame = CGRectMake(131, 5, 58, 30);
    [_speed setBackgroundImage:IMAGE(@"func_normal") forState:UIControlStateNormal];
    if (_cam.speed)
    {
        //        [_speed setTitle:@"Fast" forState:UIControlStateNormal];
        [_speed setTitle:LOCAL(@"fast") forState:UIControlStateNormal];
    }
    else
    {
        //        [_speed setTitle:@"Slow" forState:UIControlStateNormal];
        [_speed setTitle:LOCAL(@"slow") forState:UIControlStateNormal];
    }
    [_speed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _speed.titleLabel.font = [UIFont systemFontOfSize:11];
    [_speed addTarget:self action:@selector(mySpeed) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_speed];
    
    UIButton *autoClean = [UIButton buttonWithType:UIButtonTypeCustom];
    autoClean.frame = CGRectMake(194, 5, 58, 30);
    [autoClean setBackgroundImage:IMAGE(@"func_normal") forState:UIControlStateNormal];
    //    [autoClean setTitle:@"Autoclean" forState:UIControlStateNormal];
    [autoClean setTitle:LOCAL(@"autoclean") forState:UIControlStateNormal];
    [autoClean setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    autoClean.titleLabel.font = [UIFont systemFontOfSize:11];
    [autoClean addTarget:self action:@selector(autoClean) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:autoClean];
    
    UIButton *Question = [UIButton buttonWithType:UIButtonTypeCustom];
    Question.frame = CGRectMake(257, 5, 58, 30);
    [Question setBackgroundImage:IMAGE(@"func_normal") forState:UIControlStateNormal];
    //    [Question setTitle:@"Question" forState:UIControlStateNormal];
    [Question setTitle:LOCAL(@"question") forState:UIControlStateNormal];
    [Question setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Question.titleLabel.font = [UIFont systemFontOfSize:11];
    [Question addTarget:self action:@selector(Question:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:Question];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [_panelView addSubview:line];
    
    
    //中间操作栏
    UIImageView *camView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 110, 46.4, 28.888)];
    camView.image = IMAGE(@"hint_icon");
    [_panelView addSubview:camView];
    
    UIButton *camUp = [UIButton buttonWithType:UIButtonTypeCustom];
    camUp.frame = CGRectMake(60, 50, 50, 50);
    [camUp setBackgroundImage:IMAGE(@"up_normal") forState:UIControlStateNormal];
    [camUp addTarget:self action:@selector(camUp) forControlEvents:UIControlEventTouchDown];
    [camUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [camUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [_panelView addSubview:camUp];
    
    UIButton *camDown = [UIButton buttonWithType:UIButtonTypeCustom];
    camDown.frame = CGRectMake(60, 149, 50, 50);
    [camDown setBackgroundImage:IMAGE(@"down_normal") forState:UIControlStateNormal];
    [camDown addTarget:self action:@selector(camDown) forControlEvents:UIControlEventTouchDown];
    [camDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [camDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [_panelView addSubview:camDown];
    
    UILabel *camLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 110, 70, 30)];
    camLabel.backgroundColor = [UIColor clearColor];
    camLabel.textColor = TOPBARCOLOR;
    camLabel.text = LOCAL(@"camera");
    if ([currentLanguage isEqualToString:@"en"])
    {
        camLabel.font = [UIFont systemFontOfSize:14];
    }
    [_panelView addSubview:camLabel];
    
    UIButton *Up = [UIButton buttonWithType:UIButtonTypeCustom];
    Up.frame = CGRectMake(210, 50, 50, 50);
    [Up setBackgroundImage:IMAGE(@"forward_normal") forState:UIControlStateNormal];
    [Up addTarget:self action:@selector(Up) forControlEvents:UIControlEventTouchDown];
    [Up addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [Up addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [_panelView addSubview:Up];
    
    UIButton *Down = [UIButton buttonWithType:UIButtonTypeCustom];
    Down.frame = CGRectMake(210, 149, 50, 50);
    [Down setBackgroundImage:IMAGE(@"backward_normal") forState:UIControlStateNormal];
    [Down addTarget:self action:@selector(Down) forControlEvents:UIControlEventTouchDown];
    [Down addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [Down addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [_panelView addSubview:Down];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(160, 100, 50, 50);
    [left setBackgroundImage:IMAGE(@"tnleft_normal") forState:UIControlStateNormal];
    [left addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchDown];
    [left addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [left addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [_panelView addSubview:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(260, 100, 50, 50);
    [right setBackgroundImage:IMAGE(@"tnright_normal") forState:UIControlStateNormal];
    [right addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchDown];
    [right addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [right addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [_panelView addSubview:right];
    
    UILabel *moveLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 110, 50, 30)];
    moveLabel.backgroundColor = [UIColor clearColor];
    moveLabel.textColor = TOPBARCOLOR;
    moveLabel.text = LOCAL(@"move");
    if ([currentLanguage isEqualToString:@"en"])
    {
        moveLabel.font = [UIFont systemFontOfSize:14];
    }
    [_panelView addSubview:moveLabel];
    
    //底部操作栏
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49.7-69, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line2];
    
    UIButton *take_pic = [UIButton buttonWithType:UIButtonTypeCustom];
    take_pic.frame = CGRectMake(10, SCREEN_HEIGHT-43.2-69, 67.5, 43.2);
    [take_pic setBackgroundImage:IMAGE(@"snapshot_normal") forState:UIControlStateNormal];
    [take_pic addTarget:self action:@selector(take_pic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:take_pic];
    
    //    UIButton *record = [UIButton buttonWithType:UIButtonTypeCustom];
    //    record.frame = CGRectMake(87.5, SCREEN_HEIGHT-43.2-69, 67.5, 43.2);
    //    [record setBackgroundImage:IMAGE(@"remoterec_normal") forState:UIControlStateNormal];
    //    [self.view addSubview:record];
    
    UIButton *panel = [UIButton buttonWithType:UIButtonTypeCustom];
    panel.frame = CGRectMake(126.5, SCREEN_HEIGHT-43.2-69, 67.5, 43.2);
    [panel setBackgroundImage:IMAGE(@"control_normal") forState:UIControlStateNormal];
    [panel addTarget:self action:@selector(myPanel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:panel];
    
    _HD = [UIButton buttonWithType:UIButtonTypeCustom];
    _HD.frame = CGRectMake(242.5, SCREEN_HEIGHT-43.2-69, 67.5, 43.2);
    [_HD setBackgroundImage:IMAGE(@"normal_hd_normal") forState:UIControlStateNormal];
    if (_cam.resolution == IOCTRL_QUALITY_QVGA)
    {
        [_HD setBackgroundImage:IMAGE(@"normal_hd_normal") forState:UIControlStateNormal];
        [WToast showWithText:LOCAL(@"normal")];
    }
    if (_cam.resolution == IOCTRL_QUALITY_VGA)
    {
        [_HD setBackgroundImage:IMAGE(@"normal_hd_pressed") forState:UIControlStateNormal];
        [WToast showWithText:LOCAL(@"hd")];
    }
    [_HD addTarget:self action:@selector(myResolutionChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_HD];
    
    _statusView = [[StatusView alloc]initWithFrame:CGRectMake(115, 188, 90, 15.6)];
    _statusView.statusType = _cam.statusType;
    [_panelView addSubview:_statusView];
    
    if (SCREEN_HEIGHT == 480)
    {
        //3.5寸
        _panelView.frame = CGRectMake(0, 240, SCREEN_WIDTH, 209);
        power.frame = CGRectMake(5, 2, 58, 25.5);
        charge.frame = CGRectMake(68, 2, 58, 25.5);
        _speed.frame = CGRectMake(131, 2, 58, 25.5);
        autoClean.frame = CGRectMake(194, 2, 58, 25.5);
        Question.frame = CGRectMake(257, 2, 58, 25.5);
        line.frame = CGRectMake(0, 29, SCREEN_WIDTH, 0.5);
        
        camView.frame = CGRectMake(10, 75, 27.84, 17.328);
        camUp.frame = CGRectMake(50, 40,30,30);
        camDown.frame = CGRectMake(50, 100, 30,30);
        camLabel.frame = CGRectMake(50, 70, 50,30);
        camLabel.font = [UIFont systemFontOfSize:13];
        Up.frame = CGRectMake(220, 40, 30,30);
        Down.frame = CGRectMake(220, 100, 30,30);
        left.frame = CGRectMake(190, 70,30,30);
        right.frame = CGRectMake(254, 70, 30,30);
        moveLabel.frame = CGRectMake(221, 70, 50,30);
        if ([currentLanguage isEqualToString:@"zh-Hans"])
        {
            moveLabel.frame = CGRectMake(223, 70, 50,30);
        }
        moveLabel.font = [UIFont systemFontOfSize:13];
        _statusView.frame = CGRectMake(100, 115, 90, 15.6);
        
        line2.frame = CGRectMake(0, SCREEN_HEIGHT-32-68.5, SCREEN_WIDTH, 0.5);
        take_pic.frame = CGRectMake(24, SCREEN_HEIGHT-32-66, 50, 32);
        //        record.frame = CGRectMake(98, SCREEN_HEIGHT-32-66, 50, 32);
        panel.frame = CGRectMake(135, SCREEN_HEIGHT-32-66, 50, 32);
        _HD.frame = CGRectMake(246, SCREEN_HEIGHT-32-66, 50, 32);
    }
    if (iOSVERSION >=7.0)
    {
        _imageView.frame = CGRectMake(_imageView.frame.origin.x,_imageView.frame.origin.y+ADJSTHEIGHT,_imageView.frame.size.width,_imageView.frame.size.height);
        _panelView.frame = CGRectMake(_panelView.frame.origin.x,_panelView.frame.origin.y+ADJSTHEIGHT,_panelView.frame.size.width,_panelView.frame.size.height);
        line2.frame = CGRectMake(line2.frame.origin.x,line2.frame.origin.y+ADJSTHEIGHT,line2.frame.size.width,line2.frame.size.height);
        take_pic.frame = CGRectMake(take_pic.frame.origin.x,take_pic.frame.origin.y+ADJSTHEIGHT,take_pic.frame.size.width,take_pic.frame.size.height);
        //         _middleView.center = CGPointMake(_imageView.frame.size.width/2, _imageView.frame.size.height/2);
        //        record.frame = CGRectMake(record.frame.origin.x,record.frame.origin.y+ADJSTHEIGHT,record.frame.size.width,record.frame.size.height);
        panel.frame = CGRectMake(panel.frame.origin.x,panel.frame.origin.y+ADJSTHEIGHT,panel.frame.size.width,panel.frame.size.height);
        _HD.frame = CGRectMake(_HD.frame.origin.x,_HD.frame.origin.y+ADJSTHEIGHT,_HD.frame.size.width,_HD.frame.size.height);
    }
}
- (void)startTimer
{
    if(mThreadTimer==nil){
        mLockTimer=[[NSConditionLock alloc] initWithCondition:NOTDONE];
        mThreadTimer=[[NSThread alloc] initWithTarget:self selector:@selector(ThreadTimer) object:nil];
        [mThreadTimer start];
    }
}

-(void)stopTimer
{
    m_bTimer=NO;
    if(mThreadTimer!=nil){
        [mLockTimer lockWhenCondition:DONE];
        [mLockTimer unlock];
        
        mLockTimer  =nil;
        mThreadTimer=nil;
    }
}
- (void)ThreadTimer
{
    NSLog(@"    ThreadTimer going...\n");
    [mLockTimer lock];
    m_bTimer=YES;
    while(m_bTimer)
    {
        [NSThread sleepForTimeInterval:3];
    }
    [mLockTimer unlockWithCondition:DONE];
    
    NSLog(@"=== ThreadTimer exit ===");
}
- (void)myBack
{
    [drop hideDropDown:optionButton];
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)take_pic
{
     [_rjone StartShot];    //141128   EngelChen
     [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:YES];
}
- (void)myPanel
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.25];
    _panelView.hidden = !_panelView.hidden;
    [UIView commitAnimations];
}
- (void)myResolutionChange
{
    if (_cam.resolution == IOCTRL_QUALITY_QVGA)
    {
//        IOCTRLSetDevParameterReq req;
//        memset(&req, 0, sizeof(req));
//        req.bit_field = 0x02;
//        req.resolution = IOCTRL_QUALITY_VGA;
//        [_cam sendIOCtrl:IOCTRL_TYPE_SET_DEV_PARAMETER_REQ withIOData:(char *)&req withDataSize:sizeof(req)];
        
        [_cam Rjone_SetParameter:0x02 :(char)IOCTRL_QUALITY_VGA :(char)NULL :(char)NULL];
        _cam.m_delegateCam=nil;
        _resolution = IOCTRL_QUALITY_VGA;
    }
    if (_cam.resolution == IOCTRL_QUALITY_VGA)
    {
//        IOCTRLSetDevParameterReq req;
//        memset(&req, 0, sizeof(req));
//        req.bit_field = 0x02;
//        req.resolution =IOCTRL_QUALITY_QVGA;
//        [_cam sendIOCtrl:IOCTRL_TYPE_SET_DEV_PARAMETER_REQ withIOData:(char *)&req withDataSize:sizeof(req)];
        
        [_cam Rjone_SetParameter:0x02 :(char)IOCTRL_QUALITY_QVGA :(char)NULL :(char)NULL];
        
        _cam.m_delegateCam=nil;
        _resolution = IOCTRL_QUALITY_QVGA;
    }
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOCAL(@"please_wait");
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:10];
    
    _cam.cleanFifo = true;
}
- (void)mystop
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_PTZ_STOP;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_PTZ_STOP :1 :0 :0];

}
- (void)camUp
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_PTZ_UP;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_PTZ_UP :1 :0 :0];
}
- (void)camDown
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_PTZ_DOWN;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    
    [_cam Rjone_PtzControl:IOCTRL_PTZ_DOWN :1 :0 :0];
}
- (void)Up
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_PTZ_FORWARD_SHORT;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_PTZ_FORWARD_SHORT :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_FORWARD_SHORT]} repeats:YES];
}
- (void)Down
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_PTZ_BACKWARD_SHORT;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_PTZ_BACKWARD_SHORT :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_BACKWARD_SHORT]} repeats:YES];
}
- (void)left
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_PTZ_MOTO_TURN_L;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_PTZ_MOTO_TURN_L :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_MOTO_TURN_L]} repeats:YES];
}
- (void)right
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_PTZ_MOTO_TURN_R;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_PTZ_MOTO_TURN_R :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_MOTO_TURN_R]} repeats:YES];
}
- (void)longTap:(NSTimer *)timer
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = [[[timer userInfo] objectForKey:@"key"] charValue];
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:[[[timer userInfo] objectForKey:@"key"] charValue] :1 :0 :0];
}
- (void)power
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_CLEANER_POWER_ONOFF;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_POWER_ONOFF :1 :0 :0];

}
- (void)charge
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_CLEANER_CHARGE;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_CHARGE :1 :0 :0];
}
- (void)mySpeed
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_CLEANER_SPEED;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_SPEED :1 :0 :0];
}
- (void)autoClean
{
//    IOCTRLPtzCmd req;
//    memset(&req, 0, sizeof(req));
//    req.control = IOCTRL_CLEANER_AUTO_CLEAN;
//    req.speed = 1;
//    req.step = 0;
//    req.point = 0;
//    [_cam sendIOCtrl:IOCTRL_TYPE_PTZ_COMMAND withIOData:(char *)&req withDataSize:sizeof(req)];
     [_cam Rjone_PtzControl:IOCTRL_CLEANER_AUTO_CLEAN :1 :0 :0];
}
- (void)Question:(UIButton *)question
{
    _showError = !_showError;
    if (_showError)
    {
        [question setTitle:[NSString stringWithFormat:@"%02ld",(long)_cam.error] forState:UIControlStateNormal];
        question.titleLabel.font = [UIFont fontWithName:@"DS-Digital" size:25];
    }
    else
    {
        [question setTitle:LOCAL(@"question") forState:UIControlStateNormal];
        question.titleLabel.font = [UIFont systemFontOfSize:11];
    }
}
- (void)myCcontrast:(UISlider *)ContrastSlider
{
    _contrastValue.text = [NSString stringWithFormat:@"%ld",(long)ContrastSlider.value];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
//    IOCTRLSetDevParameterReq req;
//    memset(&req, 0, sizeof(req));
//    req.bit_field = 0x08;
//    req.contrast = [_contrastValue.text integerValue];
//    [_cam sendIOCtrl:IOCTRL_TYPE_SET_DEV_PARAMETER_REQ withIOData:(char *)&req withDataSize:sizeof(req)];
    
    [_cam Rjone_SetParameter:0x08 :(char)NULL :[_contrastValue.text integerValue] :(char)NULL];
    
    delegate.contrast = [_contrastValue.text integerValue];
}
- (void)myLight:(UISlider *)LightSlider
{
    _lightValue.text = [NSString stringWithFormat:@"%ld",(long)LightSlider.value];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    IOCTRLSetDevParameterReq req;
//    memset(&req, 0, sizeof(req));
//    req.bit_field = 0x10;
//    req.brightness = [_lightValue.text integerValue];
//    [_cam sendIOCtrl:IOCTRL_TYPE_SET_DEV_PARAMETER_REQ withIOData:(char *)&req withDataSize:sizeof(req)];
    [_cam Rjone_SetParameter:0x10 :(char)NULL :(char)NULL :[_lightValue.text integerValue]];
    delegate.brightness = [_lightValue.text integerValue];
}
- (void)myTap:(UITapGestureRecognizer *)tap
{
    _middleView.hidden = !_middleView.hidden;
}


-(void)myEdit{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.camDID = @"";
    
//    ifAdd = !ifAdd;
    NSArray *titleArray = [[NSArray alloc] initWithObjects:OPEN_PICTURE,FIX_DEVICE_INFO,FIX_DEVICE_PARAM,FIX_NETWORK_MODE,ABOUT_DEVICE, nil];
    if(drop == nil)
    {
        CGFloat dropDownListHeight = 64; //Set height of drop down list
        CGFloat width = 100;
        CGFloat height = 150;
        NSString *direction = @"down"; //Set drop down direction animation
        drop = [[SKDropDown alloc]showDropDown:optionButton withHeight:&dropDownListHeight withData:titleArray animationDirection:direction withFrameHeight:&height withFrameWidth:&width];
        drop.nav = self.navigationController;
        drop.cam = self.cam;
        drop.delegate = self;
    }
    else
    {
        [drop hideDropDown:optionButton];
        drop = nil;
    }

    
}

#pragma mark dropdelelgate

- (void) skDropDownDelegateMethod: (SKDropDown *) sender
{
    [self closeDropDown];
}

-(void)closeDropDown{
    drop = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark DelegateCamera
- (void) refreshFrame:(uint8_t *)imgData withVideoWidth:(NSInteger)width videoHeight:(NSInteger)height withObj:(NSObject *)obj
{
    if(m_nWidth!=width || m_nHeight!=height)
    {
        m_nWidth =width;
        m_nHeight=height;
        m_bytesPerRow =m_nWidth*3;
        m_nImgDataSize=m_nWidth*m_nHeight*3;
    }
    CGDataProviderRef provider=CGDataProviderCreateWithData(NULL, imgData, m_nImgDataSize, NULL);
    CGImageRef ImgRef=CGImageCreate(width,
                                    height,
                                    8,
                                    24,
                                    m_bytesPerRow,
                                    m_colorSpaceRGB, kCGBitmapByteOrderDefault,
                                    provider, NULL,true,kCGRenderingIntentDefault);
    if(provider!=nil) CGDataProviderRelease(provider);
    if(_imageView.contentMode!=UIViewContentModeScaleToFill) _imageView.contentMode=UIViewContentModeScaleToFill;
    _imageView.image=[UIImage imageWithCGImage:ImgRef];
    
    if (!_isSaveImg)
    {
        //退出视图时保存最后一帧会crash,改成保存首帧
        //取document目录
        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [arr objectAtIndex:0];
        NSData *data = UIImageJPEGRepresentation(_imageView.image,0.5);
        [data writeToFile:[path stringByAppendingPathComponent:_cam.nsDID] atomically:YES];
        _isSaveImg = YES;
    }
    
    if(ImgRef!=nil)   CGImageRelease(ImgRef);
}




//如果进入页面设备未连接.待设备连接成功后,后调用该方法,重新启动音视频
- (void) refreshSessionInfo:(int)infoCode withObj:(NSObject *)obj withString:(NSString *)strValue;
{
    if(obj==nil) return;
    if(infoCode==CONN_INFO_CONNECTED)
    {
        [_cam startVideo:AV_TYPE_REALAV withTime:0L];
    }
}

- (void) refreshSessionInfo:(NSInteger)mode
                   OnlineNm:(NSInteger)onlineNm
                 TotalFrame:(NSInteger)totalFrame
                       Time:(NSInteger)time_s
{
    float fFPS=0.0f;
    if(time_s>0)
        fFPS=totalFrame*1.0f/time_s;
    
    NSString *nsMode=@"Unknown";
    if(mode==CONN_MODE_P2P) nsMode=@"P2P";
    else if(mode==CONN_MODE_RLY) nsMode=@"Relay";
    _FPSLabel.text = [NSString stringWithFormat:@"N=%ld, %0.2fFPS",(long)onlineNm,fFPS];
}

- (void) updateRecvIOCtrl:(int)ioType withIOData:(char *)pIOData withSize:(int)nIODataSize withObj:(NSObject *)obj
{
    //    if(ioType==IOCTRL_TYPE_GET_STATUS_RESP)
    //    {
    //        IOCTRLGetStatusResp *pResp=(IOCTRLGetStatusResp *)pIOData;
    //        NSLog(@"UIVIewLiveVideo, updateRecvIOCtrl, bit_field=%d, isManuRec=%d", pResp->bit_field, pResp->isManuRec);
    //        if((pResp->bit_field & 0x0001)==0x0001){
    //            if(pResp->isManuRec==1){
    //                //                btnImgRemoteRecording.hidden=NO;
    //            }
    //            //            else btnImgRemoteRecording.hidden=YES;
    //        }
    //    }else if(ioType==IOCTRL_TYPE_MANU_REC_START_RESP)
    //    {
    ////        IOCTRLManuRecStartResp *pResp=(IOCTRLManuRecStartResp *)pIOData;
    //        //        if(pResp->result==0) [WToast showWithText:NSLocalizedString(@" Start remote record successfully ",nil)];
    //        //        else [WToast showWithText:NSLocalizedString(@" Failed to start remote record ",nil)];
    //    }
}


//#pragma mark - AudioSession implementations
//- (void)activeAudioSession
//{
//    if (iOSVERSION < 7.0) {
//        OSStatus error;
//        UInt32 category = kAudioSessionCategory_PlayAndRecord;
//        error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
//        if(error) printf("  couldn't set audio category!");
//        error = AudioSessionSetActive(true);
//        if(error) printf("  AudioSessionSetActive (true) failed");
//    }
//    else
//    {
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        BOOL success;
//        NSError* error;
//        success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
//                                 error:&error];
//        if (!success)  NSLog(@"AVAudioSession error setting category:%@",error);
//        
//        //set the audioSession override
//        success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
//                                             error:&error];
//        if (!success)  NSLog(@"AVAudioSession error overrideOutputAudioPort:%@",error);
//        //activate the audio session
//        success = [session setActive:YES error:&error];
//        if (!success) NSLog(@"AVAudioSession error activating: %@",error);
//        else NSLog(@"audioSession active");
//    }
//}
//
//- (void)unactiveAudioSession {
//    if (iOSVERSION <7.0)
//    {
//        AudioSessionSetActive(false);
//    }
//    else
//    {
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        NSError* error;
//        BOOL success;
//        success = [session setActive:YES error:&error];
//        if (!success) NSLog(@"unactiveAudioSession AVAudioSession error activating: %@",error);
//        else NSLog(@"unaudioSession success");
//    }
//    
//}
- (void)ChangeResolution
{
    _cam.m_delegateCam=self;
    _cam.resolution = _resolution;
    if (_cam.resolution == IOCTRL_QUALITY_QVGA)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            [_HD setBackgroundImage:IMAGE(@"normal_hd_normal") forState:UIControlStateNormal];
            [WToast showWithText:LOCAL(@"normal")];
        });
    }
    if (_cam.resolution == IOCTRL_QUALITY_VGA)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            [_HD setBackgroundImage:IMAGE(@"normal_hd_pressed") forState:UIControlStateNormal];
            [WToast showWithText:LOCAL(@"hd")];
        });
    }}
- (void)changeWork:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int result = [[[notification userInfo]objectForKey:@"key"]intValue];
        if (1 == result)
        {
            [power setTitle:LOCAL(@"power1") forState:UIControlStateNormal];
        }
        else
        {
           [power setTitle:LOCAL(@"power") forState:UIControlStateNormal];
        }
    });
    
}

- (void)ChangeStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _statusView.statusType = _cam.statusType;
        
        if (_cam.speed)
        {
            [_speed setTitle:LOCAL(@"slow") forState:UIControlStateNormal];
        }
        else
        {
            [_speed setTitle:LOCAL(@"fast") forState:UIControlStateNormal];
        }
    });
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark -
#pragma mark DelegateCamera

-(void)GetImage:(UIImage*)img
{
    if(img != nil)
    {
        if(_isSaveImgStatus == 1 || _isSaveImgStatus == 3 || _isSaveImgStatus == -1)
        {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            //查看是否具有访问相册权限
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusDenied)
            {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
                SaveImage  = -2;
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:NO];
                return;
            }
            
            if (author == ALAuthorizationStatusAuthorized)
            {
                SaveImage = 1;
                 [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:NO];
            }
        }
    }
    else  if(_isSaveImgStatus == 1 || _isSaveImgStatus == 3 || _isSaveImgStatus == -1)
    {
        SaveImage = -1;
         [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:NO];
    }
    if(img != nil)
    {
        if (!_isSaveImg && _isSaveImgStatus == 2)
        {
            //退出视图时保存最后一帧会crash,改成保存首帧
            //取document目录
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [arr objectAtIndex:0];
            NSData *data = UIImageJPEGRepresentation(img,0.5);
            [data writeToFile:[path stringByAppendingPathComponent:_cam.nsDID] atomically:YES];
            _isSaveImg = YES;
            _isSaveImgStatus = 3;
        }
        
    }
}
-(void) TimeShowImageStatus:(NSTimer*) timer
{
    if(SaveImage != 0)
    {
    if(-2 == SaveImage)
    {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:LOCAL(@"canNotAccessAlbum1") message:LOCAL(@"canNotAccessAlbum2") delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
        [alter show];

    }
    else if(-1 == SaveImage)
    {
         [WToast showWithText:LOCAL(@"screenshot_fail")];
    }
    else if(1 == SaveImage)
    {
         [WToast showWithText:LOCAL(@"screenshot_success")];
    }
        SaveImage = 0;
        [timer invalidate];
    }
}


-(void)postVideoStartResp:(int)type
{
    if(-1 == _isSaveImgStatus)
    {
        _isSaveImgStatus = 1;
    }
}

-(void)postVideoStopResp:(int) type
{
    
}


-(void) StartSaveOneImg2Doc:(NSTimer*) timer
{
    if(1 == _isSaveImgStatus)
    {
        _isSaveImgStatus = 2;
    [_rjone StartShot];
        
    [timer invalidate];
    }
}
#pragma mark -
#pragma mark DelegateCamera
-(void)postH264InitDecode:(int) type
{

}

- (void)postH264DecodeData:(unsigned char *)data anddatasize:(int)length
{
     NSLog(@"12123:%d",[_rjone RJONE_H264DecodeData:( uint8_t  *)data anddatasize:length]);
}
-(void)postH264FiniDecode:(int) type
{
    
}
@end
