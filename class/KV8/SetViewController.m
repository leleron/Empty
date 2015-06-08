//
//  SetViewController.m
//  KV8
//
//  Created by RJONE on 15/4/27.
//  Copyright (c) 2015年 MasKSJ. All rights reserved.
//

#import "SetViewController.h"
#import <stdio.h>
#import "cooee.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#import "SearchController.h"

@interface SetViewController ()
{
    BOOL Send;
    NSString *wifiName;
    const char *PWD;
    const char *SSID;
    const char *KEY;
    unsigned int ip;
    NSTimer *Send_cooee;
    
    UITextField *ssidField;
    UITextField *pwdField;
    NSInteger timerNum;
    
    MBProgressHUD *HUD;
}

@end

@implementation SetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"一键配置";
    self.view.backgroundColor = BLUECOLOR;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UILabel *ssidLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 80, 60)];
    ssidLabel.text =@"SSID";
    [self.view addSubview:ssidLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 90, 80, 60)];
    pwdLabel.text = @"Password";
    [self.view addSubview:pwdLabel];
    
    ssidField = [[UITextField alloc] initWithFrame:CGRectMake(130, 30, 180, 40)];
    ssidField.text = @"";
    ssidField.userInteractionEnabled = NO;
    ssidField.layer.masksToBounds = YES;
    ssidField.layer.borderWidth = 1;
    ssidField.delegate= self;
    ssidField.layer.borderColor=TOPBARCOLOR.CGColor;
    ssidField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:ssidField];
    
    pwdField = [[UITextField alloc] initWithFrame:CGRectMake(130, 100,180 ,40)];
    pwdField.placeholder  = @"密码";
    pwdField.delegate  = self;
    pwdField.layer.masksToBounds = YES;
    pwdField.layer.borderWidth = 1;
    pwdField.layer.borderColor=TOPBARCOLOR.CGColor;
    pwdField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:pwdField];
    
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 200, 200, 40)];
    [okButton addTarget:self action:@selector(OK:) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    okButton.backgroundColor = TOPBARCOLOR;
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:okButton];
    
    if (iOSVERSION >= 7.0)
    {
        ssidLabel.frame = CGRectMake(ssidLabel.frame.origin.x, ssidLabel.frame.origin.y+ADJSTHEIGHT, ssidLabel.frame.size.width, ssidLabel.frame.size.height);
        
        pwdLabel.frame = CGRectMake(pwdLabel.frame.origin.x, pwdLabel.frame.origin.y+ADJSTHEIGHT, pwdLabel.frame.size.width, pwdLabel.frame.size.height);
        
        ssidField.frame = CGRectMake(ssidField.frame.origin.x, ssidField.frame.origin.y+ADJSTHEIGHT, ssidField.frame.size.width, ssidField.frame.size.height);
        
        pwdField.frame = CGRectMake(pwdField.frame.origin.x, pwdField.frame.origin.y+ADJSTHEIGHT, pwdField.frame.size.width, pwdField.frame.size.height);
        
        okButton.frame = CGRectMake(okButton.frame.origin.x, okButton.frame.origin.y+ADJSTHEIGHT, okButton.frame.size.width, okButton.frame.size.height);
        
    }
    
    
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"Wifi connect");
        Send = false;
        [okButton setTitle:@"Start" forState:UIControlStateNormal];
        NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
        id info = nil;
        for (NSString *ifnam in ifs) {
            info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            if(info && [info count]){
                NSDictionary *dic = (NSDictionary*)info; //取得网卡咨询
                wifiName = [dic objectForKey:@"SSID"];   //取得ssid
                break;
            }
        }
        ssidField.text = wifiName;
        
    }
    else{
        NSLog(@"No Wifi");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Wi-Fi not connected , abort"
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil, nil];
        [alert show] ;
        
    }

}

- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)OK:(id)sender {
    Send = !Send;
    [pwdField resignFirstResponder];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOCAL(@"setting");
  
    
    if (Send )
    {
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (Send)
            {
                PWD = [[pwdField text] UTF8String];
                SSID = [[ssidField text] UTF8String];
                
                KEY = [@"" UTF8String];
                struct in_addr addr;
                inet_aton([[self getIPAddress] UTF8String], &addr);
                ip = CFSwapInt32BigToHost(ntohl(addr.s_addr));
                
                NSLog(@"SSID = %s" , SSID);
                NSLog(@"strlen(SSID) = %lu" , strlen(SSID));
                NSLog(@"PWD = %s" , PWD);
                NSLog(@"strlen(PWD) = %lu" , strlen(PWD));
                NSLog(@"[self getIPAddress] = %@" , [self getIPAddress]);
                NSLog(@"ip = %08x", ip);
                
                send_cooee(SSID, (int)strlen(SSID), PWD, (int)strlen(PWD), KEY, 0, ip);
            }
        
            
        });
        Send_cooee = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerNum) userInfo:nil repeats:YES];
        
        [HUD show:YES];
        
    }
    else
    {
        [sender setTitle:@"Start" forState:UIControlStateNormal];

        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [sender setTitle:@"Start" forState:UIControlStateNormal];
        });
        [HUD hide:YES afterDelay:0];
    }
    
    
//    if (Send && timerNum <= 100)
//    {
//        [sender setTitle:@"Stop" forState:UIControlStateNormal];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            Send_cooee = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(StartCooee) userInfo:nil repeats:YES];
//        });
//    }
//    else
//    {
//        [sender setTitle:@"Start" forState:UIControlStateNormal];
//        timerNum = 0;
//        if ([Send_cooee isValid])
//        {
//            [Send_cooee invalidate];
//            Send_cooee = nil;
//        }
//        
//    }


}

//30 计时
-(void)timerNum
{
    timerNum++;
    NSLog(@"%d",(int)timerNum);
    if (timerNum > 99)
    {
        [HUD hide:YES afterDelay:0];
        SearchController *search = [[SearchController alloc] init];
        timerNum = 0;
        [Send_cooee invalidate];
        Send = NO;
        [search mySearch];
        HUD.labelText = LOCAL(@"please_wait");
        [HUD show:YES];
        [search myAllSave];
        [HUD hide:YES afterDelay:3];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
    
#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == _passwordField && SCREEN_HEIGHT == 480)
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.25];
//        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-70);
//        [UIView commitAnimations];
//    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (SCREEN_HEIGHT == 480) {
//        if (iOSVERSION <7.0) {
//            self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-32);
//            return;
//        }
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.25];
//        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        [UIView commitAnimations];
//    }
    [textField resignFirstResponder];
}

@end
