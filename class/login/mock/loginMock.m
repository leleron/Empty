//
//  loginMock.m
//  Empty
//
//  Created by leron on 15/6/9.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "loginMock.h"
@implementation loginParam
@end

@implementation loginMock
-(NSString*)getOperatorType{
    return @"/user/loginIn";
}

-(Class)getEntityClass{
    return [loginEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
