//
//  QUFlatEntity.h
//  CaoPanBao
//
//  Created by zhuojian on 14-7-17.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUEntity.h"

@interface QUFlatEntity : QUEntity
@end

@interface QUFlatTitleEntity : QUFlatEntity
@property(nonatomic,strong) NSString* pTitle;
@end

@interface QUFlatIconEntity : QUFlatEntity
@property(nonatomic,strong) NSString* pIcon;
@end

@interface QUFlatIconTextEntity : QUFlatIconEntity
@property(nonatomic,strong) NSString* pTitle;
@property(nonatomic,strong) NSString* pTitlePlaceHold;
@end