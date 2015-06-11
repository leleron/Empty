//
//  identifyCodeMock.m
//  Empty
//
//  Created by leron on 15/6/10.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "identifyCodeMock.h"
@implementation identifyCodeParam
@end
@implementation identifyCodeMock
-(NSString*)getOperatorType{
    return @"/user/identifycode";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
