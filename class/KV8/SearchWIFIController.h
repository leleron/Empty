//
//  SearchWIFIController.h
//  KV8
//
//  Created by MasKSJ on 14-8-21.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "miscClasses/CamObj.h"
@interface SearchWIFIController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong)CamObj *cam;
@end
