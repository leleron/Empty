//
//  QUTableView.m
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUTableView.h"

@implementation QUTableView

-(void)scrollSectionToTop{
    QUEntity* first=[self.pAdaptor.pSources.entityArray firstObject];
    
    if(first)
        [self.pAdaptor.pTableView scrollToRowAtIndexPath:first.pSection.pIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];  // 当出现偏移，返回当前页时，取消向上偏移
}

@end
