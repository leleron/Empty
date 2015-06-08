//
//  CPBRotateImageView.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-14.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "CPBRotateImageView.h"

@interface CPBRotateImageView()
@property(nonatomic,assign)BOOL isInit;
@end

@implementation CPBRotateImageView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(!self.isInit)
    {
        //        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.isInit=YES;
        //        [self startAnimationRotate];
        //        [self performSelectorOnMainThread:@selector(startAnimationRotate) withObject:nil waitUntilDone:NO];
    }
}




- (void)startAnimationRotate
{
    
    QUSection* section=(QUSection*)[self superview];
    
    UITableViewCell* currentCell=(UITableViewCell*)[[section superview] superview];
    
    self.bVisible=NO;
    for (UITableViewCell* cell in section.pAdaptor.pTableView.visibleCells) {
        if([currentCell isEqual:cell])
        {
            self.bVisible=YES;
            break;
        }
    }
    
    if(!self.bVisible)
        return;
    
    
    if(angle>360.f)
    {
        angle=0.f;
    }
    
    bRotate = YES;
    //
    //    [UIView animateWithDuration:0.03f animations:^{
    //
    //        self.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    //
    //    } completion:^(BOOL finished) {
    //
    //        angle += 10;
    //
    //        [self startAnimationRotate];
    //
    //    }];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.03];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

- (void)endAnimation
{
    
    angle += 10;
    
    if (bRotate)
    {
        [self performSelectorOnMainThread:@selector(startAnimationRotate) withObject:nil waitUntilDone:NO];
    }
}


//CABasicAnimation* rotationAnimation;
//rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//rotationAnimation.duration = 2;
//rotationAnimation.RepeatCount = 1000;//你可以设置到最大的整数值
//rotationAnimation.cumulative = NO;
//rotationAnimation.removedOnCompletion = NO;
//rotationAnimation.fillMode = kCAFillModeForwards;
//[self.layer addAnimation:rotationAnimation forKey:@"Rotation"];
//[self endAnimation];


@end
