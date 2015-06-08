//
//  cleanerCell.h
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "miscClasses/CamObj.h"
@interface cleanerCell : UITableViewCell
@property (nonatomic,assign)BOOL DevConnectSSID;  //20141203 Engelchen
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)NSString *nsName;
@property (nonatomic,strong)NSString *nsDID;
@property (nonatomic,assign)E_CAM_STATE mCamState;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,strong)UIButton *b;
@end
