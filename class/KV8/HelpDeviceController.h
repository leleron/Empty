//
//  UIViewController+HelpDeviceController.h
//  KV8
//
//  Created by MasKSJ on 14/12/6.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "miscClasses/CamObj.h"
#import "HomeController.h"

@interface HelpDeviceController :UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong)CamObj *cam;
@property (nonatomic,assign) CGFloat lastScale;
@property (nonatomic,strong) UIImageView *imageView;
@end
