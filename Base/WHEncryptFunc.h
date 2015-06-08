//
//  WPEncryptLib.h
//  WpSecurityLib
//
//  Created by Mark on 12-12-26.
//  Copyright (c) 2012年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

// 加密相关
@interface WHEncryptFunc : NSObject

// 加密支付密码
+ (NSString*)getPayPwdForCreate:(NSString*)pwd andKey:(NSString*)key;
//+ (NSString*)getPayPwdForSinaCreate:(NSString*)pwd andKey:(NSString*)key andXuid:(NSString*)xuid;
+ (NSString*)getPayPwdForUse:(NSString*)pwd andKey:(NSString*)key;
//+ (NSString*)getPayPwdForSinaUse1:(NSString*)pwd andKey:(NSString*)key andXuid:(NSString*)xuid;
//+ (NSString*)getPayPwdForSinaUse2:(NSString*)pwd andKey:(NSString*)key andXuid:(NSString*)xuid;
+ (NSMutableString*)sha2Hex:(unsigned char*)sha andLength:(NSInteger)length;

@end
