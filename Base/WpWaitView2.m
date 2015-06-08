//
//  WpWaitView2.m
//  WeiboPay
//
//  Created by Mark on 13-11-12.
//  Copyright (c) 2013年 WeiboPay. All rights reserved.
//

#import "WpWaitView2.h"
#import "WpCommonFunction.h"

@interface WpWaitView2 ()
{
    CGFloat angle;
    BOOL bRotate;
    
    UIImageView* cBkImageView;
    UIImageView* cShieldImageView;
    UIImageView* cCircleImageView;
}

@end

@implementation WpWaitView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        
        CGFloat x1 = (screenWidth - 80.0) / 2.0;
        CGFloat y1 = (screenHeight - 80.0) / 2.0;
        cBkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x1, y1, 80.0, 80.0)];
        cBkImageView.image = [UIImage imageNamed:@"wait_bg"];
        cBkImageView.alpha = 0.8;
        [WpCommonFunction setView:cBkImageView cornerRadius:6.0];
        [self addSubview:cBkImageView];
        
        
        CGFloat x2 = (screenWidth - 33.0) / 2.0;
        CGFloat y2 = (screenHeight - 33.0) / 2.0;
        cShieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x2, y2, 33.0, 33.0)];
        cShieldImageView.image = [UIImage imageNamed:@"loading_against"];
        [self addSubview:cShieldImageView];
        
        CGFloat x3 = (screenWidth - 50.0) / 2.0;
        CGFloat y3 = (screenHeight - 50.0) / 2.0;
        cCircleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x3, y3, 50.0, 50.0)];
        cCircleImageView.image = [UIImage imageNamed:@"loading"];
        [self addSubview:cCircleImageView];
        
        [self startAnimation];
    }
    return self;
}

- (void)startAnimation
{
    bRotate = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    cCircleImageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    cShieldImageView.transform = CGAffineTransformMakeRotation(-angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

- (void)endAnimation
{
    angle += 10;
    
    if (bRotate)
    {
        [self startAnimation];
    }
}

- (void)closeView
{
    bRotate = NO;
}

@end
