//
//  MyViewController.m
//  CaoPanBao
//
//  Created by zhuojian on 14-4-18.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "MyViewController.h"
#import "MyNoNetController.h"
#import "UIImage+RTTint.h"
#import "AppDelegate.h"
//#import "CPBSTOSearchStockController.h"

#define kTagLeftArrowView 1  // 左边按钮箭头
#define kTagLeftLabelView 2  // 左边按钮标题

#define kNavRightButonOffsetIOS7 16 // 导航条右边按钮向右偏移值
#define kNavRightButonTextOffsetIOS7 8 // 导航条右边文字按钮向右偏移值
#define kNavLeftButonTextOffsetIOS7 10 // 导航条左边文字按钮向左偏移值
#define kNavLeftLabelTextOffsetIOS7 8 // 导航条左边文字按钮向左偏移值


#define kNavRightButonOffset IOS7_OR_LATER?kNavRightButonOffsetIOS7:0
#define kNavRightButonTextOffset IOS7_OR_LATER?kNavRightButonTextOffsetIOS7:0

#define kNavLeftButonTextOffset IOS7_OR_LATER?kNavLeftButonTextOffsetIOS7:0 // 导航条左边文字按钮向左偏移值
#define kNavLeftLabelTextOffset IOS7_OR_LATER?kNavLeftLabelTextOffsetIOS7:kNavLeftLabelTextOffsetIOS7+12 // 导航条左边文字按钮向左偏移值

#define kNavigationBarHighLightColor [UIColor colorWithRed:136.f/255.f green:136.f/255.f blue:136.f/255.f alpha:1.f]

@interface MyViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSString* leftNormalImageName;
@end

@implementation MyViewController

+(instancetype)controller{
    NSString* nibName=NSStringFromClass([self class]);
    MyViewController* controller=[[self alloc] initWithNibName:nibName bundle:nil];
    
    
    return controller;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    self.leftButtonType = kNav_Left_Button_Back;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    if([self isMemberOfClass:[WCFDiscoverPhoneChargeController class]])
    //    {
    //        MyNoNetController* controller=[[MyNoNetController alloc] initWithNibName:@"MyNoNetController" bundle:nil];
    //        [self.navigationController pushViewController:controller animated:NO];
    //        return;
    //    }
    
    [self initNavigationBar];
    
    if(self.leftButtonType == kNav_Left_Button_Cancel)
        [self showCancelButton];
    else if (self.leftButtonType == kNav_Left_Button_None)
        self.navigationItem.hidesBackButton = YES;
//    else
//        [self showBackButton];
    
    
    [self initQuickUI];
    
    [self initQuickMock];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 若当前无用户登录数据，则不做定时器
    
//    if ([self isMemberOfClass:[CPBSTOSearchStockController class]])
//    {
//        // CPBSTOSearchStockController 不在navCtrlArray中，不做topController的保存
//    }
//    else
//    {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;

        delegate.topController = self;
 //   }
    
    if ([WpCommonFunction getCookiesAndMemberIDFromLocal])
    {
//        if ([self isMemberOfClass:[WHDrawPswViewController class]])
//        {
//            // 当用户当前处于手势密码页，不做保存本地时间的更新
//            [WCFGestureTimer sharedTimer].isInvalidateTimerMark = NO;
//            
//        }
        
        // 初始化弹出手势密码的计时器
        [[WCFGestureTimer sharedTimer] createTime];
    }
    
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // 显示导航条
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
 self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:200/255.0f green:200/255.0f  blue:184/255.0f alpha:1.0f];}


- (void) dealloc
{
    [[ViewControllerManager sharedManager] hideWaitView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationBar{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    UIImage *backgroundImage = nil;
    if (version >= 5.0 && version<7.0) {
        backgroundImage = [UIImage imageNamed:@"navibar_bg_ios6"];
        
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    else if(version>=7.0)
    {
        backgroundImage = [UIImage imageNamed:@"navibar_bg"];
        
        UINavigationBar* bar=self.navigationController.navigationBar;
//        [bar setBackgroundImage:backgroundImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    bar.barTintColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self setNavigationTitle];
}

-(void)setNavigationTitle{
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    //    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.backgroundColor = [UIColor clearColor];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.text = self.navigationBarTitle ? self.navigationBarTitle :@"操盘宝";
    //    [self.navigationItem setTitleView:titleLabel];
    
    
    UIColor *titleColor = [UIColor whiteColor];
    
    UIFont  *titleFont = [UIFont boldSystemFontOfSize:18];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:titleColor,UITextAttributeTextColor,titleFont, UITextAttributeFont, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    if (self.navigationBarTitle) self.navigationItem.title = self.navigationBarTitle;
    
}

-(void)showBackButton
{
//    [self showLeftButtonTitle:fLocalStr(@"MyViewController_back")];
    
    
     [self showLeftNormalButton:@"navibar_btn_back_normal" highLightImage:nil selector:nil];
}

////  创建取消按钮
//-(void) showCancelButton
//{
//    [self showLeftNormalButton:@"navibar_btn_cancel_normal" highLightImage:nil selector:nil];
//}
//
//-(void)showLeftNormalButton:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector
//{
//    UIImage* normalImage = [UIImage imageNamed:normalImageName];
//
//    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    backButton.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
//
//    [backButton setImage:normalImage forState:UIControlStateNormal];
//
//    if (highLightImageName)
//    {
//         UIImage* highLightImage = [UIImage imageNamed:highLightImageName];
//
//        [backButton setImage:highLightImage forState:UIControlStateHighlighted];
//    }
//
//    if (!tagSelector) {
//        tagSelector = @selector(goBack:);
//    }
//
//    [backButton addTarget:self action:tagSelector forControlEvents:UIControlEventTouchUpInside];
//
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
//}


//  创建取消按钮
-(void) showCancelButton
{
    [self showLeftNormalButton:@"navibar_btn_cancel_normal" highLightImage:nil selector:nil];
}




-(void)showRightButtonNormalImage:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector
{
    
    [self showRightButtonNormalImage:normalImageName highLightImage:highLightImageName selector:tagSelector beTintColor:YES];
    
}

-(void)showRightButtonNormalImage:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector beTintColor:(BOOL)beTintColor
{
    //    beTintColor=NO;
    //    normalImageName=@"my_message_unread";//@"my_message";
    if(IOS7_OR_LATER)
    {
        [self showRightButtonNormalImageIos7Above:normalImageName beTintColor:beTintColor selector:tagSelector];
    }
    else{
        [self showRightButtonNormalImageIos6:normalImageName highLightImage:highLightImageName selector:tagSelector];
    }
    
}


-(void)showRightButtonNormalImageIos7Above:(NSString *)normalImageName beTintColor:(BOOL)beTintColor selector:(SEL)tagSelector{
    
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    if(beTintColor==NO)
        normalImage=[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem* item;
    
    if(tagSelector) // 内置的选择器实现，否则通过委托方式触发事件
        item=[[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleDone target:self action:tagSelector];
    
    if(self.delegate)
        item=[[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleDone target:self action:@selector(goRight:)];
    
    
    item.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    
    flexSpacer.width = -12.f;
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:flexSpacer,item, nil]];
    
    //    [self.navigationItem setRightBarButtonItem:item];
}

-(void)showRightButtonNormalImageIos6:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector{
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    
    rightButton.frame = CGRectMake(kNavRightButonOffset, 0, normalImage.size.width+25, normalImage.size.height);
    rightButton.backgroundColor=[UIColor clearColor];
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    
    if(highLightImageName)
    {
        [rightButton setImage:[UIImage imageNamed:highLightImageName] forState:UIControlStateHighlighted];
    }
    
    if(tagSelector) // 内置的选择器实现，否则通过委托方式触发事件
        [rightButton addTarget:self action:tagSelector forControlEvents:UIControlEventTouchUpInside];
    
    if(self.delegate)
        [rightButton addTarget:self action:@selector(goRight:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* mainView=[[UIView alloc] initWithFrame: CGRectMake(0, 0, rightButton.frame.size.width-5, rightButton.frame.size.height)];
    [mainView addSubview:rightButton];
    
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:mainView]];
    
}

-(void)showRightButtonTitle:(NSString *)title andSelector:(SEL)tagSelector
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(kNavRightButonTextOffset, 0, title.length * 17, 44);
    
    [rightButton setTitle:title forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:kNavigationBarHighLightColor forState:UIControlStateHighlighted];
    
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    if(tagSelector)// 内置的选择器实现，否则通过委托方式触发事件
        [rightButton addTarget:self action:tagSelector forControlEvents:UIControlEventTouchUpInside];
    
    if(self.delegate)
        [rightButton addTarget:self action:@selector(goRight:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* mainView=[[UIView alloc] initWithFrame: CGRectMake(0, 0,title.length * 17, 44)];
    [mainView addSubview:rightButton];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:mainView]];
}

-(void)showLeftNormalButton:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector
{
    self.leftNormalImageName=normalImageName;
    UIImage* normalImage = [UIImage imageNamed:normalImageName];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImageView* leftView=[[UIImageView alloc] initWithImage:normalImage];
    CGRect leftViewFrame=leftView.frame;
    
    leftViewFrame.origin.x-=kNavLeftButonTextOffset;
    leftViewFrame.origin.x-=8.f;
    
    leftView.frame=leftViewFrame;
    leftView.tag=kTagLeftArrowView;
    
    
    backButton.frame = CGRectMake(0.f, 0, normalImage.size.width, normalImage.size.height);
    backButton.backgroundColor=[UIColor clearColor];
    //    [backButton setImage:normalImage forState:UIControlStateNormal];
    
    if (highLightImageName)
    {
        UIImage* highLightImage = [UIImage imageNamed:highLightImageName];
        
        [backButton setImage:highLightImage forState:UIControlStateHighlighted];
    }
    
    if (!tagSelector) {
        tagSelector = @selector(goBack:);
    }
    
    
    
    [backButton addTarget:self action:tagSelector forControlEvents:UIControlEventTouchUpInside];
    
    [backButton addSubview:leftView];
    
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(goBackHightLight:) forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self action:@selector(goBackNormal:) forControlEvents:UIControlEventTouchUpOutside];
    [backButton addTarget:self action:@selector(goBackNormal:) forControlEvents:UIControlEventTouchCancel];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

-(void)showLeftButtonTitle:(NSString *)title
{
    
    // title=[NSString stringWithFormat:@"%@",title];
    
    // self.pLeftTitle=title;
    
    UIImage* image=[UIImage imageNamed:@"navigation_bar_back_normal"];
    
    UIImageView* leftView=[[UIImageView alloc] initWithImage:image];
    
    
    CGRect leftViewFrame=leftView.frame;
    
    leftViewFrame.origin.x-=kNavLeftButonTextOffset;
    leftViewFrame.origin.x+=2.f;
    leftViewFrame.origin.y+=10;
    
    leftView.frame=leftViewFrame;
    //    leftView.backgroundColor=[UIColor blueColor];
    
    leftView.tag=kTagLeftArrowView;
    
    UIButton* mainView=[UIButton buttonWithType:UIButtonTypeCustom];
    mainView.frame=CGRectMake(2, 0, title.length * 17, 44);
    mainView.backgroundColor=[UIColor clearColor];
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(kNavLeftLabelTextOffset, -1, title.length * 17, 44)];
    label.tag=kTagLeftLabelView;
    label.text=title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    CGRect rectLabel=label.frame;
    rectLabel.size.width+=16;
    rectLabel.origin.x+=2.f;
    label.frame=rectLabel;
    
    
    CGRect mainFrame=mainView.frame;
    mainFrame.size.width=label.frame.size.width;
    mainView.frame=mainFrame;
    
    [mainView addSubview:label];
    [mainView addSubview:leftView];
    
    [mainView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addTarget:self action:@selector(goBackHightLight:) forControlEvents:UIControlEventTouchDown];
    [mainView addTarget:self action:@selector(goBackNormal:) forControlEvents:UIControlEventTouchUpOutside];
    [mainView addTarget:self action:@selector(goBackNormal:) forControlEvents:UIControlEventTouchCancel];
    
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:mainView]];
    
    
}

#pragma mark - action

-(IBAction)goBackHightLight:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    UIImageView* arrowView=(UIImageView*)[btn viewWithTag:kTagLeftArrowView];
    
    UILabel* labelView=(UILabel*)[btn viewWithTag:kTagLeftLabelView];
    
    
    UIImage* hoverImage=[UIImage imageNamed:@"navigation_bar_back_hover"];
    
    if(self.leftNormalImageName)
        hoverImage= [[UIImage imageNamed:self.leftNormalImageName] rt_darkenWithLevel:0.5f];
    
    [arrowView setImage:hoverImage];
    [arrowView setHighlightedImage:hoverImage];
    [arrowView setHighlighted:YES];
    
    labelView.textColor=kNavigationBarHighLightColor;
}

-(IBAction)goBackNormal:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    UIImageView* arrowView=(UIImageView*)[btn viewWithTag:kTagLeftArrowView];
    
    UILabel* labelView=(UILabel*)[btn viewWithTag:kTagLeftLabelView];
    
    UIImage* hoverImage=[UIImage imageNamed:@"navigation_bar_back_normal"];
    if(self.leftNormalImageName)
        hoverImage= [UIImage imageNamed:self.leftNormalImageName];
    
    [arrowView setImage:hoverImage];
    
    [arrowView setHighlighted:NO];
    
    labelView.textColor=[UIColor whiteColor];
    
}

-(IBAction)goBack:(id)sender{
    
    [self goBackNormal:sender];
    
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(MyViewControllerOnBack)])
        {
            [self.delegate MyViewControllerOnBack];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(IBAction)goRight:(id)sender
{
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(MyViewController:onRightButton:)])
        {
            [self.delegate MyViewController:self onRightButton:sender];
            return;
        }
    }
}
- (void) clickTabBarItem
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView* subView in [self.view subviews]) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }
    }
}


#pragma mark - QuickUI - LifeCycle

-(void)initQuickUI{
    
}

-(void)initQuickMock{
    
}

@end
