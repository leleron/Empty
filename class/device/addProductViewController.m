//
//  addProductViewController.m
//  Empty
//
//  Created by leron on 15/6/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "addProductViewController.h"
#import "addProductSection.h"
#import "SetViewController.h"
@interface addProductViewController ()

@end

@implementation addProductViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"选择设备";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)initQuickUI{
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"addProductSection"] delegate:self];
    QUFlatEntity* e1 = [QUFlatEntity entity];
    e1.lineBottomColor = QU_FLAT_COLOR_LINE;
    e1.tag = 0;
    [self.pAdaptor.pSources addEntity:e1 withSection:[addProductSection class]];
    QUFlatEntity* e2 = [QUFlatEntity entity];
    e2.lineBottomColor = QU_FLAT_COLOR_LINE;
    e2.tag = 1;
    [self.pAdaptor.pSources addEntity:e2 withSection:[addProductSection class]];
    QUFlatEntity* e3 = [QUFlatEntity entity];
    e3.lineBottomColor = QU_FLAT_COLOR_LINE;
    e3.tag = 2;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    if ([entity isKindOfClass:[QUFlatEntity class]]) {
        QUFlatEntity* e = (QUFlatEntity*)entity;
        addProductSection* s = (addProductSection*)section;
        if (e.tag == 0) {
            s.lblProductionName.text = @"扫地机器人";
        }
        if (e.tag == 1) {
            s.lblProductionName.text = @"空气净化器";
        }
        if (e.tag == 2) {
            s.lblProductionName.text = @"蓝牙秤";
        }
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    QUFlatEntity* e = (QUFlatEntity*)entity;
    if (e.tag == 0) {
        SetViewController* controller = [[SetViewController alloc]init];
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
