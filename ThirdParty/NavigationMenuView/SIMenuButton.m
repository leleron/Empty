//
//  SAMenuButton.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuButton.h"
#import "SIMenuConfiguration.h"

@implementation SIMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self defaultGradient]) {
            
        } else {
            [self setSpotlightCenter:CGPointMake(frame.size.width/2, frame.size.height*(-1)+10)];
            [self setBackgroundColor:[UIColor clearColor]];
            [self setSpotlightStartRadius:0];
            [self setSpotlightEndRadius:frame.size.width/2];
        }
        
        frame.origin.y -= 2.0;
        self.title = [[UILabel alloc] initWithFrame:frame];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        self.title.textColor = currentStyle[UITextAttributeTextColor];
        self.title.font = [UIFont boldSystemFontOfSize:18.0f];
        self.title.shadowColor = currentStyle[UITextAttributeTextShadowColor];
        NSValue *shadowOffset = currentStyle[UITextAttributeTextShadowOffset];
        self.title.shadowOffset = shadowOffset.CGSizeValue;
        [self addSubview:self.title];

        self.arrow = [[UIImageView alloc] initWithImage:[SIMenuConfiguration arrowImage]];
        [self addSubview:self.arrow];
    }
    return self;
}

- (UIImageView *)defaultGradient
{
    return nil;
}

- (void)layoutSubviews
{
    [self.title sizeToFit];
    self.title.center = CGPointMake(self.frame.size.width/2 - 5, (self.frame.size.height-2.0)/2);
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.title.frame) + [SIMenuConfiguration arrowPadding], self.frame.size.height / 2);
}

#pragma mark -
#pragma mark Handle taps
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isActive = !self.isActive;
    return YES;
}



#pragma mark - Deallocation

- (void)dealloc
{
}

@end
