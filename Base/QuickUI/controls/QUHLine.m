//
//  QUHLine.m
//  CaoPanBao
//
//  Created by zhuojian on 14-4-23.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "QUHLine.h"

@implementation QUHLine

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    self.backgroundColor=[UIColor clearColor];
    
    UIColor* clr=nil;
    if(self.lineColor)
        clr=self.lineColor;
    else
        clr=[UIColor colorWithRed:200.f/255.f green:200.f/255.f blue:200.f/255.f alpha:1.f];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, clr.CGColor);
    
    if(self.tag==0) // top
        CGContextFillRect(ctx, CGRectMake(0, 0.f, self.bounds.size.width, 0.5f));
    else  // bottom
        CGContextFillRect(ctx, CGRectMake(0, 0.5f, self.bounds.size.width, 0.5f));


}

-(void)shortLine{
    CGRect frame=self.frame;
    frame.origin.x=15;
    frame.size.width=self.superview.frame.size.width;
    self.frame=frame;

}
@end
