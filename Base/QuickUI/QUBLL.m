//
//  QUBLL.m
//  CaoPanBao
//
//  Created by zhuojian on 14-6-20.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUBLL.h"


#define kDuration 1



@interface QUBLL ()

@property (nonatomic,strong)UISearchDisplayController *strongSearchDisplayController;
@end
@implementation QUBLL
+(instancetype)bll{
    return [[self alloc] init];
}

+(instancetype)bllWithController:(MyViewController*)controller tableView:(QUTableView*)tableView{
    QUBLL* selfBll=[self bll];
    selfBll.controller=controller;
    selfBll.pTableView=tableView;
    
    [selfBll loadBll];
    
    return selfBll;
}

-(void)loadBll
{
    [self initQuickUI:self.pTableView];
    [self initQuickMock];
}

-(void)initQuickUI:(QUTableView*)tableView
{
}

-(void)initQuickMock
{
    
}




-(void)hide
{
    [self.pTableView setHidden:YES];
}

- (void)show
{
    [self.pTableView setHidden:NO];
    
}





-(void)dispatchEvent:(QUBLL*)bll userInfo:(NSDictionary*)dict{
    if(self==bll)
    {
        
    }
}

-(void)dealloc{
    
}

+(void)postNotifyBll:(QUBLL*)bll userInfo:(NSDictionary*)dict{
    
}
/**--------------------------------------------*/



@end
