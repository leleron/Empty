//
//  QUFlatEntity.m
//  CaoPanBao
//
//  Created by zhuojian on 14-7-1.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUFlatSubEntity.h"

@interface QUFlatSubEntity()
@end

@implementation QUFlatSubEntity

+(instancetype)entityWithTargetEntity:(QUEntity *)entity withTag:(int)tag{
    return [self entityWithTargetEntity:entity withTag:tag withBottomLine:nil withSelectedBgColor:nil];
}

+(instancetype)entityWithTargetEntity:(QUEntity *)entity withTag:(int)tag withBottomLine:(UIColor*)bottomLine;
{
    return [self entityWithTargetEntity:entity withTag:tag withBottomLine:bottomLine withSelectedBgColor:nil];
}

+(instancetype)entityWithTargetEntity:(QUEntity *)entity withTag:(int)tag withBottomLine:(UIColor*)bottomLine withSelectedBgColor:(UIColor*)selBGColor{
    QUFlatSubEntity* obj=[self entityWithLineTop:nil lineBottom:bottomLine lineTopClass:nil lineBottomClass:nil selectedBgColor:selBGColor tag:tag];
    
    [obj setTargetEntity:entity];
    
    return obj;
}

@end
