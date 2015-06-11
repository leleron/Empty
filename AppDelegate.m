//
//  AppDelegate.m
//  Empty
//
//  Created by 李荣 on 15/5/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "ShopViewController.h"
#import "DeviceViewController.h"
#import "FindViewController.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#import "TencentOAuth.h"
#import "WeiboSDK.h"
#import "WXApi.h"
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSMutableArray *itemViewControllers = [NSMutableArray arrayWithCapacity:4];
    // Override point for customization after application launch.
    UITabBarController* tabBarController = [[UITabBarController alloc]init];
    self.window.rootViewController = tabBarController;
    ShopViewController* controller1 = [[ShopViewController alloc]init];
    UINavigationController* nav1 = [[UINavigationController alloc]initWithRootViewController:controller1];
    nav1.navigationBar.tintColor = [UIColor colorWithRed:200/255.0f green:200/255.0f  blue:184/255.0f alpha:1.0f];
    [itemViewControllers addObject:nav1];
    DeviceViewController* controller2 = [[DeviceViewController alloc]initWithNibName:@"DeviceViewController" bundle:nil];
    UINavigationController* nav2 = [[UINavigationController alloc]initWithRootViewController:controller2];
    [itemViewControllers addObject:nav2];
    FindViewController* controller3 = [[FindViewController alloc]initWithNibName:@"FindViewController" bundle:nil];
    UINavigationController* nav3 = [[UINavigationController alloc]initWithRootViewController:controller3];
    [itemViewControllers addObject:nav3];
    UserViewController* controller4 = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    UINavigationController* nav4 = [[UINavigationController alloc]initWithRootViewController:controller4];
    [itemViewControllers addObject:nav4];
    tabBarController.viewControllers = itemViewControllers;
    UITabBarItem* item1 = [tabBarController.tabBar.items objectAtIndex:0];

    item1.image = [UIImage imageNamed:@"shop-blue"];
    item1.title = @"商城";
    UITabBarItem* item2 = [tabBarController.tabBar.items objectAtIndex:1];
//    item2.image = [UIImage imageNamed:@"device"];
    item2.title = @"设备";
    UITabBarItem* item3 = [tabBarController.tabBar.items objectAtIndex:2];
    item3.image = [UIImage imageNamed:@"find-blue"];
    item3.title = @"发现";
    UITabBarItem* item4 = [tabBarController.tabBar.items objectAtIndex:3];
    item4.image = [UIImage imageNamed:@"user-blue"];
    item4.title = @"我的";
    

    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SinaAppKey];
    [WXApi registerApp:@"wx3023e5007ad774d3"];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if (self.login_type == LOGIN_QQ) {
        return [TencentOAuth HandleOpenURL:url];
    }
    if (self.login_type == LOGIN_WEIBO) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if (self.login_type == LOGIN_WECHAT) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if (self.login_type == LOGIN_QQ) {
        return [TencentOAuth HandleOpenURL:url];
    }
    if (self.login_type == LOGIN_WEIBO) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if (self.login_type == LOGIN_WECHAT) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}


-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
