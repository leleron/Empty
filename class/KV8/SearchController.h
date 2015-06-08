//
//  SearchController.h
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface SearchController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
- (void)myAllSave;
- (void)mySearch;
@end
