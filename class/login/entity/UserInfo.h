//
//  UserInfo.h
//  Empty
//
//  Created by leron on 15/6/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//
//用户信息类
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface UserInfo : NSObject
@property(nonatomic,strong)NSString* nickName;
@property(nonatomic,strong)UIImage* headImg;
@property(nonatomic,strong)NSString* phoneNum;
@property(nonatomic,strong)NSString* password;
@property(nonatomic,strong)NSString* tokenID;
@property(nonatomic,strong)NSString* userID;
@property(nonatomic,assign)loginType userLoginType;
@property(nonatomic,strong)NSString* qqUserID;
@property(nonatomic,strong)NSString* qqTokenID;
@property(nonatomic,strong)NSString* wxUserID;
@property(nonatomic,strong)NSString* wxTokenID;
@property(nonatomic,strong)NSString* wbUserID;
@property(nonatomic,strong)NSString* wbTokenID;
@end
