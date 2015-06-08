//
//  SQLSingle.h
//  WIFISwitch
//
//  Created by MasKSJ on 14-3-11.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface SQLSingle : NSObject

@property (nonatomic,strong)FMDatabase *dataBase;
@property (nonatomic,copy)NSString *path;
+ (SQLSingle *)shareSQLSingle;
@end
