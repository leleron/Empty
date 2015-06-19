//
//  MyWebViewController.m
//  CaoPanBao
//
//  Created by zhuojian on 14-4-30.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "MyWebViewController.h"
#import "ViewControllerManager.h"

@interface MyWebViewController ()

@end

@implementation MyWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(instancetype)controllerWithUrl:(NSString *)url{
    MyWebViewController* controller=[[self alloc] initWithNibName:@"MyWebViewController" bundle:nil];
    controller.url=url;
    
    return controller;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor blackColor];
    self.viewWeb.backgroundColor=[UIColor blackColor];
    
    [super viewDidLoad];
    
    self.viewWeb.delegate=self;
    //
    [[ViewControllerManager sharedManager] showWaitView:self.navigationController.view];
    //
    //
    NSURL* website=[NSURL URLWithString:self.url];
    NSURLRequest* request=[NSURLRequest requestWithURL:website];
    [self.viewWeb loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webview delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[ViewControllerManager sharedManager] hideWaitView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (_fontScale) {
        NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",_fontScale*100];
        [webView stringByEvaluatingJavaScriptFromString:str];
    }
    [[ViewControllerManager sharedManager] hideWaitView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[ViewControllerManager sharedManager] showWaitView:self.navigationController.view];
}

-(void)dealloc{
    [[ViewControllerManager sharedManager] hideWaitView];
}

//该表网页的字体大小
- (void)changeWeb:(UIWebView *)webView FontSize:(NSString *)size
{
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"testapp"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert from Cocoa Touch" message:[components objectAtIndex:2]
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
        return NO;
    }
    return YES;
}

@end
