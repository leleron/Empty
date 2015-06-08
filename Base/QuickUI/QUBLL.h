//
//  QUBLL.h
//  CaoPanBao
//
//  Created by zhuojian on 14-6-20.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QUBLL : NSObject<QUAdaptorDelegate,QUMockDelegate>

+(instancetype)bll;
+(instancetype)bllWithController:(MyViewController *)controller  tableView:(QUTableView*)tableView;
-(void)loadBll;

- (void)hide;
- (void)show;

-(void)initQuickUI:(QUTableView*)tableView;
-(void)initQuickMock;
//-(void)mockCallBack;/**mock的回调方法*/

@property(nonatomic,strong)QUFlatAdaptor* pAdaptor;
@property(nonatomic,strong)QUMock* mock;

@property(nonatomic,weak)QUTableView* pTableView;

@property(nonatomic,weak)MyViewController* controller;



@end
