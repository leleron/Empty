//
//  WpWaitViewController.h
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-19.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _WaitType {
    LoadingWaitType = 0,
    AlertWaitType = 1
} WaitType;
@interface WpWaitViewController : UIViewController
{
    NSString* _tips;
    WaitType _waitType;
    int type;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tips:(NSString*)tips
WaitType:(WaitType)waitType;
@property(nonatomic,retain)IBOutlet UILabel* lblTips;
@property(nonatomic,retain)IBOutlet UIImageView* imgIcon;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView* aniIcon;
@end
