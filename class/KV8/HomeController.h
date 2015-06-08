//
//  HomeController.h
//  KV8
//
//  Created by MasKSJ on 14-8-12.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKDropDown.h"

@interface HomeController : UIViewController<UITableViewDataSource,UITableViewDelegate,SKDropDownDelegate>
@property (nonatomic,assign) BOOL ifPush; //判断是否可以Push
+(HomeController *)share;
@end
