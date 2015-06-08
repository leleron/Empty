//
//  SQLSingle.m
//  WIFISwitch
//
//  Created by MasKSJ on 14-3-11.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import "SQLSingle.h"
static SQLSingle *SQL = nil;
@implementation SQLSingle
- (void)dealloc
{
    [_dataBase close];
}

+ (SQLSingle *)shareSQLSingle
{
    @synchronized(self)
    {
        if (SQL == nil ) {
            SQL = [[SQLSingle alloc]init];
        }
    }
    return SQL;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        //创建,打开数据库
        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [arr objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"KV8.db"];
        NSLog(@"path is %@",path);
        _path = path;
        _dataBase = [FMDatabase databaseWithPath:path];
        if (![_dataBase open])
        {
            NSLog(@"can not open dataBase");
        }
    }
    return self;
}
@end
