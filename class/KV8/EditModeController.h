//
//  EditModeController.h
//  KV8
//
//  Created by MasKSJ on 14-8-14.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "miscClasses/CamObj.h"
#import "SSCheckBoxView.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@interface EditModeController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong)CamObj *cam;


@end
