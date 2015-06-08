//
//  WpWaitViewController.m
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-19.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "WpWaitViewController.h"

@interface WpWaitViewController ()

@end

@implementation WpWaitViewController
@synthesize lblTips;
@synthesize imgIcon;
@synthesize aniIcon;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tips:(NSString*)tips
 WaitType:(WaitType)waitType {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tips=tips;
        _waitType=waitType;

        // Custom initialization
    }
    return self;
}
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
    lblTips.text=_tips;
    if(_waitType==LoadingWaitType)
        {
        self.aniIcon.hidden=NO;
        self.imgIcon.hidden=YES;
        }
    else{
        self.aniIcon.hidden=YES;
        self.imgIcon.hidden=NO;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
