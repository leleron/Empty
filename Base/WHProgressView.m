//
//  WHProgressView.m
//  test
//
//  Created by 陈宏伟 on 14-7-22.
//  Copyright (c) 2014年 sunlight. All rights reserved.
//

#import "WHProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface DACircularProgressLayer : CALayer
@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic) NSInteger roundedCorners;
@property(nonatomic) CGFloat thicknessRatio;
@property(nonatomic) CGFloat progress;
@end

@implementation DACircularProgressLayer
@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic roundedCorners;
@dynamic thicknessRatio;
@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2.0f;
    CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    CGFloat radians,startRadians,endRadians;
    radians = (float)(M_PI*3/2 * progress +M_PI*3/4);
    startRadians =(float)(M_PI*3/4);
    endRadians = (float)(M_PI*3/2 +M_PI*3/4);
    UIColor *bgColor = [UIColor colorWithRed:174/255.0 green:13/255.0 blue:41/255.0 alpha:1];
    
    //画背景
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(M_PI*3/4),(float)(M_PI/4), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    //填充轨道圆
    CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(M_PI*3/4),radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    //左下角的圆
    
    CGFloat pathWidth = radius * self.thicknessRatio;
    CGFloat startXOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf(startRadians)));
    CGFloat startYOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(startRadians)));
    CGPoint startPoint = CGPointMake(startXOffset, startYOffset);
    
    if (progress == 0.0f) {
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
    }
    
    CGRect startEllipseRect = (CGRect) {
        .origin.x = startPoint.x - pathWidth / 2.0f,
        .origin.y = startPoint.y - pathWidth / 2.0f,
        .size.width = pathWidth,
        .size.height = pathWidth
    };
    CGContextAddEllipseInRect(context, startEllipseRect);
    CGContextFillPath(context);
    
    //右下角的圆
    CGFloat endXOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf(endRadians)));
    CGFloat endYOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(endRadians)));
    CGPoint endPoint = CGPointMake(endXOffset, endYOffset);
    
    CGRect endEllipseRect = (CGRect) {
        .origin.x = endPoint.x - pathWidth / 2.0f,
        .origin.y = endPoint.y - pathWidth / 2.0f,
        .size.width = pathWidth,
        .size.height = pathWidth
    };
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    if (self.progress > 0.999) {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    CGContextAddEllipseInRect(context, endEllipseRect);
    CGContextFillPath(context);
    
    if (progress != 0.0f) {
        //移动中的圆
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGFloat moveXOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf(radians)));
        CGFloat moveYOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(radians)));
        CGPoint moveEndPoint = CGPointMake(moveXOffset, moveYOffset);
        CGRect moveEllipseRect = (CGRect) {
            .origin.x = moveEndPoint.x - pathWidth / 2.0f,
            .origin.y = moveEndPoint.y - pathWidth / 2.0f,
            .size.width = pathWidth,
            .size.height = pathWidth
        };
        CGContextAddEllipseInRect(context, moveEllipseRect);
        CGContextFillPath(context);
    }

    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius * (1.0f - self.thicknessRatio);
    CGRect clearRect = (CGRect) {
        .origin.x = centerPoint.x - innerRadius,
        .origin.y = centerPoint.y - innerRadius,
        .size.width = innerRadius * 2.0f,
        .size.height = innerRadius * 2.0f
    };
    CGContextAddEllipseInRect(context, clearRect);
    CGContextFillPath(context);

}


@end

@implementation WHProgressView
+ (void) initialize
{
    if (self == [WHProgressView class]) {
        WHProgressView *whProgressView = [WHProgressView appearance];
        [whProgressView setProgressTintColor:[UIColor whiteColor]];
        [whProgressView setBackgroundColor:[UIColor clearColor]];
        [whProgressView setThicknessRatio:0.3f];
    }
}

+ (Class)layerClass
{
    return [DACircularProgressLayer class];
}

- (DACircularProgressLayer *)circularProgressLayer
{
    return (DACircularProgressLayer *)self.layer;
}

- (id)init
{
    return [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
}

#pragma mark - Progress

- (CGFloat)progress
{
    return self.circularProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self setProgress:progress animated:animated initialDelay:0.0];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
       initialDelay:(CFTimeInterval)initialDelay
{
    [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    [self.circularProgressLayer removeAnimationForKey:@"progress"];
    
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = 2;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        animation.beginTime = CACurrentMediaTime() + initialDelay;
        animation.delegate = self;
        [self.circularProgressLayer addAnimation:animation forKey:@"progress"];
    } else {
        [self.circularProgressLayer setNeedsDisplay];
        self.circularProgressLayer.progress = pinnedProgress;
    }
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    NSNumber *pinnedProgressNumber = [animation valueForKey:@"toValue"];
    self.circularProgressLayer.progress = [pinnedProgressNumber floatValue];
}


- (void)didMoveToWindow
{
    CGFloat windowContentsScale = self.window.screen.scale;
    self.circularProgressLayer.contentsScale = windowContentsScale;
    [self.circularProgressLayer setNeedsDisplay];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularProgressLayer.progressTintColor = progressTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (void)setThicknessRatio:(CGFloat)thicknessRatio
{
    self.circularProgressLayer.thicknessRatio = MIN(MAX(thicknessRatio, 0.f), 1.f);
    [self.circularProgressLayer setNeedsDisplay];
}


@end
