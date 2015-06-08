//
//  getCodeMock.m
//  Empty
//
//  Created by leron on 15/6/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "getCodeMock.h"
@implementation getCodeParam
@end
@implementation getCodeMock


-(NSString*)getOperatorType{
    return @"/user/check";
}


-(Class)getEntityClass{
    return [getCodeEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
