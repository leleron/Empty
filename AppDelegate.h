//
//  AppDelegate.h
//  Empty
//
//  Created by 李荣 on 15/5/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)MyViewController* topController;
@property (nonatomic,strong)NSString *camDID;
@property (nonatomic,strong)NSString *WIFISSID;
@property (nonatomic,assign)NSInteger contrast;
@property (nonatomic,assign)NSInteger brightness;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger Auth_isok;
@property(nonatomic,assign)loginType login_type;

- (id)fetchSSIDInfo;

@end

