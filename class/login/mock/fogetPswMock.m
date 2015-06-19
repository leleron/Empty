//
//  fogetPswMock.m
//  Empty
//
//  Created by leron on 15/6/15.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "fogetPswMock.h"

@implementation fogetPswMock
-(NSString*)getOperatorType{
    return @"/user/reset";
}
-(Class)getEntityClass{
    return [forgetPswEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
