//
//  DeviceViewController.h
//  Empty
//
//  Created by 李荣 on 15/5/12.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "deviceCell.h"
#import "SKDropDown.h"
@interface DeviceViewController : MyViewController <UICollectionViewDelegate,UICollectionViewDataSource,SKDropDownDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
+(DeviceViewController *)share;
@end
