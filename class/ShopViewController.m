//
//  ShopViewController.m
//  Empty
//
//  Created by 李荣 on 15/5/12.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"商城";
    [super viewDidLoad];
    self.viewWeb.delegate = self;
    NSURL* url = [NSURL URLWithString:@"http://test.flyco.com"];
    NSURLRequest* request=[NSURLRequest requestWithURL:url];
    [self.viewWeb loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
