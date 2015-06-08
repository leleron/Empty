//
//  QUFlatEntity.h
//  CaoPanBao
//
//  Created by zhuojian on 14-7-1.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUEntity.h"

@interface QUFlatSubEntity : QUEntity
+(instancetype)entityWithTargetEntity:(QUEntity*)entity withTag:(int)tag;
+(instancetype)entityWithTargetEntity:(QUEntity *)entity withTag:(int)tag withBottomLine:(UIColor*)bottomLine;
+(instancetype)entityWithTargetEntity:(QUEntity *)entity withTag:(int)tag withBottomLine:(UIColor*)bottomLine withSelectedBgColor:(UIColor*)selBGColor;
@property(nonatomic,strong) QUEntity* targetEntity; // 目标Entity
@end
