//
//  registerMock.m
//  Empty
//
//  Created by leron on 15/6/15.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "registerMock.h"
@implementation registerParam

@end
@implementation registerMock
-(NSString*)getOperatorType{
    return @"/user/new";
}

-(Class)getEntityClass{
    return [loginEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
