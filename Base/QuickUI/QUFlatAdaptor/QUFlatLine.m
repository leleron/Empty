//
//  QUFlatLine.m
//  CaoPanBao
//
//  Created by zhuojian on 14-6-26.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUFlatLine.h"
#import "QuickUI.h"
#import "QUFlatAdaptor.h"
@implementation QUFlatLine

- (void)drawRect:(CGRect)rect
{
    
    self.backgroundColor=[UIColor clearColor];
    
    UIColor* clr=nil;
    if(self.lineColor)
        clr=self.lineColor;
    else
        clr=QU_FLAT_COLOR_LINE;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, clr.CGColor);
    
    
    if(self.tag==0) // top
        CGContextFillRect(ctx, CGRectMake(0, 0.f, self.bounds.size.width, 0.5f));
    else  // bottom
        CGContextFillRect(ctx, CGRectMake(0, 0.0f, self.bounds.size.width, 0.5f));
    
    

}

/** 设置线条缩进效果
 @param indentLevel 设置缩进的倍数(indentLevel*15px)
 */
-(void)indentLineLevel:(int)indentLevel{
    
    
    if(indentLevel<0)
        QULog(@"缩进必须大于等于0");
    
    CGRect frame=self.frame;
    frame.origin.x=15*indentLevel;
    frame.size.width=self.superview.frame.size.width;
    self.frame=frame;
}

@end

/** 虚线条 */
@implementation QUFlatLineDash

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor=[UIColor clearColor];
    
    UIColor* clr=nil;
    if(self.lineColor)
        clr=self.lineColor;
    else
        clr=QU_FLAT_COLOR_LINE;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    const CGFloat *components = CGColorGetComponents(clr.CGColor);
    
    CGContextSetRGBStrokeColor(ctx,components[0], components[1], components[2], 1);//线条颜色
    
    const CGFloat dashArray1[] = {5, 1};
//    CGFloat dashArray1[] = {5, 1};
    
    CGContextSetLineDash(ctx, 0, dashArray1, 2);//画虚线,可参考http://blog.csdn.net/zhangao0086/article/details/7234859
    
    CGContextMoveToPoint(ctx, 0, 0);//开始画线, x，y 为开始点的坐标
    
    CGContextAddLineToPoint(ctx, self.bounds.size.width, 0.5f);//画直线, x，y 为线条结束点的坐标
    
    CGContextStrokePath(ctx);//开始画线
    
}

@end
