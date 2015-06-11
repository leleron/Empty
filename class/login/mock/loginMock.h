//
//  loginMock.h
//  Empty
//
//  Created by leron on 15/6/9.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "loginEntity.h"
@interface loginParam : QUMockParam
@property(strong,nonatomic)NSString* LOGINID;
@property(strong,nonatomic)NSString* PASSWORD;
@end
@interface loginMock : QUMock

@end
