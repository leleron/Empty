//
//  EditInfoController.h
//  KV8
//
//  Created by MasKSJ on 14-8-14.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "miscClasses/CamObj.h"
#import "MBProgressHUD.h"
//#import "AVSTREAM_IO_Proto.h"
#import "SSCheckBoxView.h"
#import "UIHelpers.h"
@interface EditInfoController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong)CamObj *cam;
@end
