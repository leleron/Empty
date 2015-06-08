//
//  SplashViewController.h
//  fishPhone
//
//  Created by SUNFLOWER on 8/7/13.
//  Copyright (c) 2013 com.awe.ifish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UINavigationController
{
    UIImageView *imagetitle;
    UIImageView * image;
}


- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition;
- (id)initWithViewController:(UIViewController *)controller animation:(UIModalTransitionStyle)transition delay:(NSTimeInterval)seconds;
@end
