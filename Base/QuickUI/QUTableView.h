//
//  QUTableView.h
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QUAdaptor.h"
@interface QUTableView : UITableView
@property(nonatomic,strong)QUAdaptor* pAdaptor;

-(void)scrollSectionToTop;
@end
