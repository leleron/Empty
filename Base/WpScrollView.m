//
//  WpScrollView.m
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-30.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "WpScrollView.h"

@implementation WpScrollView

@synthesize wpScrollViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
        
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.showsVerticalScrollIndicator = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
    
    if ([wpScrollViewDelegate respondsToSelector:@selector(wpScrollViewDelegateTap:)])
    {
        [wpScrollViewDelegate wpScrollViewDelegateTap:self];
    }
}

@end
