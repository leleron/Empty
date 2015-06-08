//
//  QUBLL+CATAimation.h
//  CaoPanBao
//
//  Created by 余龙 on 14/11/6.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUBLL.h"

//简单动画枚举

//动画变换类型
typedef enum {
    kBllCATransitionFade , //淡化
    kBllCATransitionPush,//推挤
    kBllCATransitionReveal,//解开
    kBllCATransitionMoveIn,//覆盖
    kBllCATransitionCube,//立方体
    kBllCATransitionSuckEffect,//吸收
    kBllCATransitionOglFlip,//翻转
    kBllCATransitionrippleEffect,//波纹
    kBllCATransitionPageCurl,//翻页
    kBllCATransitionpageUnCurl,//反翻页
    kBllCATransitioncameraIrisHollowOpen,//镜头开
    kBllCATransitioncameraIrisHollowClose//镜头关
    
}kBllAnimationType;

//动画过滤方向
typedef enum {
    kBllCATransitionFromTop,//上
    kBllCATransitionFromLeft,//左
    kBllCATransitionFromBottom,//下
    kBllCATransitionFromRight//右
}kBllAnimationSubType;

/**针对bll隐藏切换动画*/
@interface QUBLL (CATAimation)

- (void)showBllWithAnimationType:(kBllAnimationType)type subType:(kBllAnimationSubType)subType duration:(CFTimeInterval)duration;

- (void)hideBllWithAnimationType:(kBllAnimationType)type subType:(kBllAnimationSubType)subType duration:(CFTimeInterval)duration;

- (void)animationShowBll:(QUBLL *)bll withHideBll:(QUBLL *)nextbll;
- (void)animationShowBll:(QUBLL *)bll withHideBll:(QUBLL *)nextbll animationType:(kBllAnimationType)type subType:(kBllAnimationSubType)subType duration:(CFTimeInterval)duration;

@end
