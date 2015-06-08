//
//  FindViewController.m
//  Empty
//
//  Created by 李荣 on 15/5/12.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FindViewController.h"
#import "listSection.h"
#import "serviceViewController.h"
@interface FindViewController ()

@end

@implementation FindViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"发现";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initQuickUI{

    QUTableView* myTableview = [[QUTableView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:myTableview];
    self.pTableView = myTableview;
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"listSection"] delegate:self];
    self.pAdaptor.delegate = self;
    QUFlatEntity* entity1 = [QUFlatEntity entity];
    entity1.tag = 0;
    entity1.lineBottomColor = QU_FLAT_COLOR_LINE;
    entity1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.pAdaptor.pSources addEntity:entity1 withSection:[listSection class]];
    QUFlatEntity* entity0 = [QUFlatEntity entity];
    entity0.tag = 3;
    [self.pAdaptor.pSources addEntity:entity0 withSection:[QUFlatEmptySection class]];
    
    QUFlatEntity* entity2 = [QUFlatEntity entity];
    entity2.tag = 1;
    entity2.lineBottomColor = QU_FLAT_COLOR_LINE;
    entity2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.pAdaptor.pSources addEntity:entity2 withSection:[listSection class]];
    [self.pAdaptor notifyChanged];
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    if ([entity isKindOfClass:[QUFlatEntity class]]) {
        listSection* s = (listSection*)section;
        if (entity.tag == 0) {
            s.lblTitle.text = @"活动";
        }
        if (entity.tag == 1) {
            s.lblTitle.text = @"服务";
        }
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    if ([entity isKindOfClass:[QUFlatEntity class]]) {
        QUFlatEntity* e = (QUFlatEntity*)entity;
        if (e.tag == 1) {
            serviceViewController* controller = [[serviceViewController alloc]initWithNibName:@"serviceViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
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
