//
//  WpUpdateView.m
//  WeiboPay
//
//  Created by Mark.Mu on 12-9-14.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "WpUpdateView.h"

@implementation WpUpdateView

@synthesize delegate;
@synthesize url;

@synthesize titleLabel;
@synthesize yesButton;
@synthesize noButton;
@synthesize confirmButton;
@synthesize updateLabel;
@synthesize bgImageView;
@synthesize buttonView;

- (void)loadContentView
{
    [[NSBundle mainBundle] loadNibNamed:@"WpUpdateView" 
                                  owner:self
                                options:nil]; 
    
}

- (void)willPresentDialog
{
    [super willPresentDialog];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setControlStatus:(NSInteger)type
{
    // 非强制升级
    if (type == 0) 
    {
        yesButton.hidden = NO;
        noButton.hidden = NO;
        confirmButton.hidden = YES;
    }
    // 强制升级
    else
    {
        yesButton.hidden = YES;
        noButton.hidden = YES;
        confirmButton.hidden = NO;
    }
    
    // 设置更新信息和调整页面
    updateLabel.text = url;
    
    CGFloat width = 281.0;
    CGFloat height1 = 33.0;
    CGFloat height3 = 50.0;
    CGFloat offsetHeight = 10.0;
    
    CGSize constraintSize = CGSizeMake(246.0, [UIScreen mainScreen].bounds.size.height - height1 - height3 - (2 * offsetHeight));
    CGSize labelSize = [updateLabel.text sizeWithFont:updateLabel.font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByTruncatingTail];//UILineBreakModeTailTruncation
    CGFloat height = height1 + height3 + labelSize.height + 2 * offsetHeight;
    
    CGRect rect = self.frame;
    rect.origin.x = ([UIScreen mainScreen].bounds.size.width - width) / 2.0;
    rect.origin.y = ([UIScreen mainScreen].bounds.size.height - height) / 2.0;
    rect.size.width = width;
    rect.size.height = height;
    self.frame = rect;
    
    rect = self.contentView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = width;
    rect.size.height = height;
    self.contentView.frame = rect;
    
    rect = buttonView.frame;
    rect.origin.y = height - height3;
    buttonView.frame = rect;
    
    rect = bgImageView.frame;
    rect.size.height = height - height3 - height1;
    bgImageView.frame = rect;
    
    rect = updateLabel.frame;
    rect.origin.x = 17.0;
    rect.origin.y = height1 + offsetHeight;
    rect.size.width = 246.0;
    rect.size.height = labelSize.height;
    updateLabel.frame = rect;
}

- (IBAction)yesButtonClick:(id)sender
{
    if ([delegate respondsToSelector:@selector(wpUpdateViewDelegateYesButtonClick:)])
    {
        [delegate wpUpdateViewDelegateYesButtonClick:self];
    }
}

- (IBAction)noButtonClick:(id)sender 
{
    [self dismissAnimated:NO];
    if ([delegate respondsToSelector:@selector(wpUpdateViewDelegateNoButtonClick:)])
    {
        [delegate wpUpdateViewDelegateNoButtonClick:self];
    }
}

- (IBAction)confirmButtonClick:(id)sender 
{
    if ([delegate respondsToSelector:@selector(wpUpdateViewDelegateConfirmButtonClick:)])
    {
        [delegate wpUpdateViewDelegateConfirmButtonClick:self];
    }
}

@end
