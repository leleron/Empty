//
//  serviceViewController.m
//  Empty
//
//  Created by 李荣 on 15/5/14.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "serviceViewController.h"
#import "MyWebViewController.h"
#import "netPointViewController.h"
@interface serviceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnQuery;
@property (weak, nonatomic) IBOutlet UIButton *btnNetPoint;
@property (weak, nonatomic) IBOutlet UIButton *btnHints;
@property (weak, nonatomic) IBOutlet UIButton *btnTips;

@end

@implementation serviceViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"百宝箱";
    
    [super viewDidLoad];
    [self.btnPhone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.btnQuery addTarget:self action:@selector(query) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNetPoint addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)callPhone{
    NSMutableString * phone=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008878282"];
    UIWebView* phoneWeb = [[UIWebView alloc]init];
    [phoneWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
    [self.view addSubview:phoneWeb];
}

-(void)query{
    MyWebViewController* controller = [[MyWebViewController alloc]initWithNibName:@"MyWebViewController" bundle:nil];
    controller.navigationController.navigationBar.hidden = YES;
    controller.viewWeb.scrollView.scrollEnabled = NO;
    controller.url = @"http://kf2.flyco.com/new/client.php?arg=admin&style=1&m=mobile";
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)location{
    netPointViewController* controller = [[netPointViewController alloc]initWithNibName:@"netPointViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
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
