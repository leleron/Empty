//
//  WPEncryptLib.m
//  WpSecurityLib
//
//  Created by Mark on 12-12-26.
//  Copyright (c) 2012年 Mark. All rights reserved.
//

#import "WHEncryptFunc.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation WHEncryptFunc

// 加密支付密码
+ (NSString*)getPayPwdForCreate:(NSString*)pwd andKey:(NSString*)key
{
    // SHA256
    const char* pwdMessage = [pwd cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char sha256[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256((unsigned char*)pwdMessage, strlen(pwdMessage), sha256);
    NSMutableString* shaStr = [WHEncryptFunc sha2Hex:sha256 andLength:CC_SHA256_DIGEST_LENGTH];
    
    // AES256
    const char* shaMessage = [shaStr cStringUsingEncoding:NSUTF8StringEncoding];
    const char* keyMessage = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = strlen(shaMessage);
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    unsigned char* buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCrypt(kCCEncrypt,
            kCCAlgorithmAES128,
            kCCOptionPKCS7Padding | kCCOptionECBMode,
            keyMessage,
            kCCKeySizeAES256,
            NULL,
            shaMessage,
            dataLength,
            buffer,
            bufferSize,
            &numBytesEncrypted);
    
    NSMutableString* aesStr = [WHEncryptFunc sha2Hex:buffer andLength:numBytesEncrypted];
    
    free(buffer);
    
    return aesStr;
}

//+ (NSString*)getPayPwdForSinaCreate:(NSString*)pwd andKey:(NSString*)key andXuid:(NSString*)xuid
//{
//    // 用于修正新付通密码
//    // 如果
//    if ([xuid isEqualToString:@""]) {
//        return @"";
//    }
//    
//    return [WpEncryptFunc getPayPwdForCreate:pwd andKey:key];
//}

+ (NSString*)getPayPwdForUse:(NSString*)pwd andKey:(NSString*)key
{
    if ([key isEqualToString:@""])
    {
        return @"";
    }
    
    // SHA256 - 1
    const char* pwdMessage = [pwd cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char sha256_1[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256((unsigned char*)pwdMessage, strlen(pwdMessage), sha256_1);
    NSMutableString* salt = [WHEncryptFunc sha2Hex:sha256_1 andLength:CC_SHA256_DIGEST_LENGTH];
    
    // SALT
    [salt appendString:key];
    const char* saltMessage = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    
    // SHA256 - 2
    unsigned char sha256_2[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256((unsigned char*)saltMessage, strlen(saltMessage), sha256_2);
    NSMutableString* cipher = [WHEncryptFunc sha2Hex:sha256_2 andLength:CC_SHA256_DIGEST_LENGTH];
    
    return cipher;
}


/*
+ (NSString*)getPayPwdForSinaUse1:(NSString*)pwd andKey:(NSString*)key andXuid:(NSString*)xuid
{
    if ([key isEqualToString:@""] ||
        [xuid isEqualToString:@""])
    {
        return @"";
    }
    
    // 使用新付通的加密方式1
    // SHA1
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char* pwdMessage = [[NSString stringWithFormat:@"%@CjrioeBXcuP8JyCf%@", pwd, xuid] cStringUsingEncoding:enc];
    unsigned char sha1[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1((unsigned char*)pwdMessage, strlen(pwdMessage), sha1);
    NSMutableString* salt = [WpEncryptFunc sha2Hex:sha1 andLength:CC_SHA1_DIGEST_LENGTH];
    
    // SALT
    [salt appendString:key];
    const char* saltMessage = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    
    // SHA256
    unsigned char sha256_2[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256((unsigned char*)saltMessage, strlen(saltMessage), sha256_2);
    NSMutableString* cipher = [WpEncryptFunc sha2Hex:sha256_2 andLength:CC_SHA256_DIGEST_LENGTH];
    
    return cipher;
}

+ (NSString*)getPayPwdForSinaUse2:(NSString*)pwd andKey:(NSString*)key andXuid:(NSString*)xuid
{
    if ([key isEqualToString:@""] ||
        [xuid isEqualToString:@""])
    {
        return @"";
    }
    
    // 使用新付通的加密方式2
    // SHA1
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char* pwdMessage = [[NSString stringWithFormat:@"%@BjrioeCWcuO8JyBf", pwd] cStringUsingEncoding:enc];
    unsigned char sha1[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1((unsigned char*)pwdMessage, strlen(pwdMessage), sha1);
    NSMutableString* salt = [WpEncryptFunc sha2Hex:sha1 andLength:CC_SHA1_DIGEST_LENGTH];
    
    // SALT
    [salt appendString:key];
    const char* saltMessage = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    
    // SHA256
    unsigned char sha256_2[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256((unsigned char*)saltMessage, strlen(saltMessage), sha256_2);
    NSMutableString* cipher = [WpEncryptFunc sha2Hex:sha256_2 andLength:CC_SHA256_DIGEST_LENGTH];
    
    return cipher;
}
*/

+ (NSMutableString*)sha2Hex:(unsigned char*)sha andLength:(NSInteger)length
{
    NSMutableString* shaStr = [[NSMutableString alloc] init];
    
    for (NSInteger index = 0; index < length; ++index)
    {
        [shaStr appendFormat:@"%02x", sha[index]];
    }
    
    return shaStr;
}

@end
