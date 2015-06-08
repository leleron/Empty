//
//  MyNoNetController.h
//  CaoPanBao
//
//  Created by zhuojian on 14-9-1.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "MyViewController.h"
#import "MyNoNetControllerDelegate.h"


@interface MyNoNetController : MyViewController
@property(nonatomic,weak)id<MyNoNetControllerDelegate> pDelegate;

+(BOOL)beShowWithTargetController:(UIViewController*)controller;

+(instancetype)controllerWithTargetController:(UIViewController*)targetController;
@end
