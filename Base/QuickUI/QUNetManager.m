//
//  QUNetworkManager.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-27.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUNetManager.h"
#import "QUNetAdaptor.h"

@interface QUNetManager()
@property(nonatomic,strong)NSMutableDictionary* pClassNameDict;
@end

@implementation QUNetManager
static QUNetManager* _shareNetworkManager;


+(QUNetManager*)shareNetworkManager{
    if(!_shareNetworkManager){
        _shareNetworkManager=[[QUNetManager alloc] init];
    }
    
    return _shareNetworkManager;
}

-(id)init{
    self=[super init];
    
    self.pClassNameDict=[[NSMutableDictionary alloc] initWithCapacity:5];
    
    return self;
}


+(QUNetAdaptor*)createAdaptor:(Class)cls
{
    return [[cls alloc] init];
}




@end
