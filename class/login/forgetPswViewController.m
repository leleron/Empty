//
//  forgetPswViewController.m
//  Empty
//
//  Created by leron on 15/6/15.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "forgetPswViewController.h"

@interface forgetPswViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textVertifyCode;
@property (weak, nonatomic) IBOutlet UITextField *textPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@end

@implementation forgetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnGetCode addTarget:self action:@selector(gotoGetCode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSubmit addTarget:self action:@selector(gotoSubmit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoGetCode{
    
}

-(void)gotoSubmit{
    
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
