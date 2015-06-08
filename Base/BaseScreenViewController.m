//
//  BaseScreenViewController.m
//  CaoPanBao
//
//  Created by QDS on 14-4-29.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "BaseScreenViewController.h"

@interface BaseScreenViewController ()

@end

@implementation BaseScreenViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置通用背景ScrollView
    if (backgroundScrollView)
    {
        backgroundScrollView.delegate = self;
        backgroundScrollView.wpScrollViewDelegate = self;
        [backgroundScrollView setBackgroundColor:Color_Bg_f2f2f2];
        
        if (iPhone5)
        {
            backgroundScrollView.contentSize = CGSizeMake(320.0, 504.0);
        }
        else
        {
            backgroundScrollView.frame = CGRectMake(0, 0, 320.0, 416.0);
            
            backgroundScrollView.contentSize = CGSizeMake(320.0, 416.0);
        }
    }
    if (backgroundScrollView2)
    {
        backgroundScrollView2.delegate = self;
        backgroundScrollView2.wpScrollViewDelegate = self;
        [backgroundScrollView2 setBackgroundColor:Color_Bg_f2f2f2];
    }
    
//    NSLog(@"originY:%f; sizeHeight:%f", backgroundScrollView.frame.origin.y, backgroundScrollView.frame.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (backgroundScrollView)
    {
        [WpCommonFunction hideKeyboardWithScrollView:backgroundScrollView];
    }
    if (backgroundScrollView2)
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - WpScrollViewDelegate

- (void)wpScrollViewDelegateTap:(id)sender
{
    if (backgroundScrollView)
    {
        [WpCommonFunction hideKeyboardWithScrollView:backgroundScrollView];
    }
    if (backgroundScrollView2)
    {
        [self.view endEditing:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
