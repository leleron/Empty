//
//  WHApplication.m
//  WeiCaiFu
//
//  Created by QDS on 14-9-23.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "WHApplication.h"

@implementation WHApplication


- (void)sendEvent:(UIEvent *)event {
    
    [super sendEvent:event];
    
    // 当用户有操作时，使得当前处于活动状态
    
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count] > 0)
    {
        // allTouchescount 似乎只会是 1, 因此 anyObject 总是可用的
        
        UITouchPhase phase =((UITouch *)[allTouches anyObject]).phase;
        
        if (phase ==UITouchPhaseBegan)
        {
            WCFGestureTimer *gestureTimer = [WCFGestureTimer sharedTimer];
            
            // 当前页面不在手势密码页 && 存在用户的登录状态
            if (!gestureTimer.isGestureController && [WpCommonFunction getCookiesAndMemberIDFromLocal])
            {
                [gestureTimer createTime];
            }
            
            // 这里不能做定时器的销毁，若销毁，当前处于手势密码验证页时会引起其他的问题
            /*
            else
            {
                [gestureTimer invalidateTime];
            }
             */
        }
    }
}


@end
