//
//  UIViewController+HelpDeviceController.m
//  KV8
//
//  Created by MasKSJ on 14/12/6.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "HelpDeviceController.h"


@interface HelpDeviceController ()
{
    
}
@property (nonatomic,strong) UIScrollView *myscrollview;
@property(nonatomic,strong) UIImageView *myimage;

@end

@implementation  HelpDeviceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMode) name:@"refreshMode" object:nil];
    }
    return self;
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
    
    //    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 180)];
    //    backView.backgroundColor = UIColorFromRGB(0x009AD3);
    //    backView.layer.cornerRadius = 8;
    //    [self.view addSubview:backView];
    
    if (SCREEN_HEIGHT == 480)
    {
        _myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,320, 460)];
    }
    else if (SCREEN_HEIGHT == 568)
    {
        _myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,320, 548)];
    }
    _myscrollview.directionalLockEnabled = YES; //只能一个方向滑动
    _myscrollview.pagingEnabled = YES; //是否翻页
    _myscrollview.contentSize = CGSizeMake(SCREEN_WIDTH*100+100, 0);
    _myscrollview.showsHorizontalScrollIndicator = NO;
    _myscrollview.bounces = NO;
    _myscrollview.delegate = self;
    //获取本地语言 适配
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    NSLog(@"my lan:%@",preferredLang);
    for (int i=0; i<100; i++)
    {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
        if ([preferredLang isEqualToString:@"zh-Hans"])
        {
            self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"IP%d_Chinese",i%3+1]];
        }
        else if ([preferredLang isEqualToString:@"en"])
        {
            self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"IP%d_English",i%3+1]];
        }
        
        [_myscrollview addSubview:self.imageView];
    }
    [self.view addSubview:_myscrollview];

}

- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIScrollViewDelegate


//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    //    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    //    if (scrollView.contentOffset.x >= SCREEN_WIDTH*2+100)
    //    {
    //        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isSelect] forKey:@"notShowWelcome"];
    //        [[NSUserDefaults standardUserDefaults]synchronize];
    //
    //        HomeController *home = [[HomeController alloc]init];
    //        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
    //        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //        [self presentViewController:nav animated:YES completion:nil];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
