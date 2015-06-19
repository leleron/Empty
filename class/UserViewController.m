//
//  UserViewController.m
//  Empty
//
//  Created by 李荣 on 15/5/12.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "UserViewController.h"
#import "ItemListSection.h"
#import "listEntity.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "UserInfo.h"
#import "UserInfoViewController.h"
@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;   //头像点击按钮
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserHeadImg;

@end

@implementation UserViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"用户";
    [super viewDidLoad];
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"ItemListSection"] delegate:self];
    listEntity* e1 = [listEntity entity];
    e1.image = [UIImage imageNamed:@""];
    e1.title = @"个人商城";
    e1.tag = 1;
    e1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e1.lineBottomColor = QU_FLAT_COLOR_LINE;
    [self.pAdaptor.pSources addEntity:e1 withSection:[ItemListSection class]];
    listEntity* e2 = [listEntity entity];
    e2.image = [UIImage imageNamed:@""];
    e2.title = @"设备管理";
    e2.tag = 2;
    e2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e2.lineBottomColor = QU_FLAT_COLOR_LINE;
    [self.pAdaptor.pSources addEntity:e2 withSection:[ItemListSection class]];

    listEntity* e3 = [listEntity entity];
    e3.image = [UIImage imageNamed:@"mymesssage"];
    e3.title = @"我的消息";
    e3.tag = 3;
    e3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e3.lineBottomColor = QU_FLAT_COLOR_LINE;
    [self.pAdaptor.pSources addEntity:e3 withSection:[ItemListSection class]];
    
    listEntity* e4 = [listEntity entity];
    e4.image = [UIImage imageNamed:@"mysetting"];
    e4.title = @"我的设置";
    e4.tag = 4;
    e4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e4.lineBottomColor = QU_FLAT_COLOR_LINE;
    [self.pAdaptor.pSources addEntity:e4 withSection:[ItemListSection class]];
    listEntity* e5 = [listEntity entity];
    e5.image = [UIImage imageNamed:@"advice"];
    e5.title = @"意见反馈";
    e5.tag = 5;
    e5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e5.lineBottomColor = QU_FLAT_COLOR_LINE;
    [self.pAdaptor.pSources addEntity:e5 withSection:[ItemListSection class]];

    listEntity* e6 = [listEntity entity];
    e6.image = [UIImage imageNamed:@"aboutus"];
    e6.title = @"关于我们";
    e6.tag = 6;
    e6.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e6.lineBottomColor = QU_FLAT_COLOR_LINE;
    [self.pAdaptor.pSources addEntity:e6 withSection:[ItemListSection class]];
    [self.pAdaptor notifyChanged];
    
    
    [self.btnLogin addTarget:self action:@selector(clickHead) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    if (myUserInfo) {
        self.imgUserHeadImg.image = myUserInfo.headImg;
        self.labName.text = myUserInfo.nickName;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    if ([entity isKindOfClass:[listEntity class]]) {
        listEntity* e = (listEntity*)entity;
        ItemListSection* s = (ItemListSection*)section;
        s.imgIcon.image = e.image;
        s.lblTitle.text = e.title;
    }
}

-(void)clickHead{
    
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    if (myUserInfo) {
        UserInfoViewController* controller = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
    LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    }
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
