//
//  WCFFavoriteCacheManager.m
//  CaoPanBao
//
//  Created by zhuojian on 14-7-9.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "WCFFavoriteCacheManager.h"

static WCFFavoriteCacheManager* _favoriteCacheManager;
@implementation WCFFavoriteCacheManager
+(WCFFavoriteCacheManager*)shareFavoriteCacheManager{
    if(!_favoriteCacheManager)
    {
        _favoriteCacheManager=[[WCFFavoriteCacheManager alloc] init];
    }
    return _favoriteCacheManager;
}

@end
