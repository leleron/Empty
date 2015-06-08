//
//  QUBLL+CATAimation.m
//  CaoPanBao
//
//  Created by 余龙 on 14/11/6.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUBLL+CATAimation.h"

@implementation QUBLL (CATAimation)


- (void)animationShowBll:(QUBLL *)bll withHideBll:(QUBLL *)nextbll
{
    [bll showBllWithAnimationType:kBllCATransitionPush subType:kBllCATransitionFromRight duration:.3f];
    [nextbll hideBllWithAnimationType:kBllCATransitionPush subType:kBllCATransitionFromRight duration:0.6f];
}
- (void)animationShowBll:(QUBLL *)bll withHideBll:(QUBLL *)nextbll animationType:(kBllAnimationType)type subType:(kBllAnimationSubType)subType duration:(CFTimeInterval)duration
{
    [bll showBllWithAnimationType:type subType:subType duration:duration];
    [nextbll hideBllWithAnimationType:type subType:subType duration:duration];
}

- (void)showBllWithAnimationType:(kBllAnimationType)type subType:(kBllAnimationSubType)subType duration:(CFTimeInterval)duration
{
    
    [self CATransitionAimationType:type subType:subType duration:duration];
    [self.pTableView setHidden:NO];
    
}

- (void)hideBllWithAnimationType:(kBllAnimationType)type subType:(kBllAnimationSubType)subType duration:(CFTimeInterval)duration
{
    [self.pTableView setHidden:YES];
    [self CATransitionAimationType:type subType:subType duration:duration];
    
    
}

- (void)CATransitionAimationType:(kBllAnimationType)type subType:(kBllAnimationSubType)subType duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    switch (type) {
        case kBllCATransitionFade:
            animation.type = kCATransitionFade;
            break;
        case kBllCATransitionPush:
            animation.type = kCATransitionPush;
            break;
        case kBllCATransitionReveal:
            animation.type = kCATransitionReveal;
            break;
        case kBllCATransitionMoveIn:
            animation.type = kCATransitionMoveIn;
            break;
        case kBllCATransitionCube:
            animation.type = @"cube";
            break;
        case kBllCATransitionSuckEffect:
            animation.type = @"suckEffect";
            break;
        case kBllCATransitionOglFlip:
            animation.type = @"oglFlip";
            break;
        case kBllCATransitionrippleEffect:
            animation.type = @"rippleEffect";
            break;
        case kBllCATransitionPageCurl:
            animation.type = @"pageCurl";
            break;
        case kBllCATransitionpageUnCurl:
            animation.type = @"pageUnCurl";
            break;
        case kBllCATransitioncameraIrisHollowOpen:
            animation.type = @"cameraIrisHollowOpen";
            break;
        case kBllCATransitioncameraIrisHollowClose:
            animation.type = @"cameraIrisHollowClose";
            break;
        default:
            break;
    }
    
    switch (subType) {
        case kBllCATransitionFromLeft:
            animation.subtype = kCATransitionFromLeft;
            break;
        case kBllCATransitionFromBottom:
            animation.subtype = kCATransitionFromBottom;
            break;
        case kBllCATransitionFromRight:
            animation.subtype = kCATransitionFromRight;
            break;
        case kBllCATransitionFromTop:
            animation.subtype = kCATransitionFromTop;
            break;
        default:
            break;
    }
    
    [[self.pTableView layer] addAnimation:animation forKey:@"animation"];
    
}


@end
