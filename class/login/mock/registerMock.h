//
//  registerMock.h
//  Empty
//
//  Created by leron on 15/6/15.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "loginEntity.h"
@interface registerParam : QUMockParam
@property(strong,nonatomic)NSString* USER_NAME;
@property(strong,nonatomic)NSString* MOBILE;
@property(strong,nonatomic)NSString* PASSWORD;
@property(strong,nonatomic)NSString* IDENTIFY_CODE;
@property(strong,nonatomic)NSString* SECURITYCODE;
@end
@interface registerMock : QUMock

@end
