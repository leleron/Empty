//
//  IYFileManager.h
//  IWithYou
//
//  Created by zhuo jian on 13-8-13.
//
//

#import <Foundation/Foundation.h>
#define AES256_KEY @"abcdeffsdfggegaojijiami12355448!@#$%%^*()"

typedef enum _IYFileCacheType{
    IYFileCacheTypePicture=0,
    IYFileCacheTypeFile=1
}IYFileCacheType;

typedef enum _IYFileEncryptType{
    IYFileEncryptTypeNone=0,
    IYFileEncryptTypeAES256=1
}IYFileEncryptType;

@interface WHFileManager : NSObject
+(NSString*)defaultFilePath;
+(NSString*)pictureFilePath;
+(NSString*)filePath;
/** 获得缓存文件名 */
+(NSData*)cacheFileWithKey:(NSString*)key;

+(UIImage*)cacheImageFileWithKey:(NSString*)key;

+(NSString*)filePathByCacheType:(IYFileCacheType)type;

+(void)setCacheFileWithKey:(NSString*)key WithValue:(NSData*)value withFileExt:(NSString*)fileExt withCacheType:(IYFileCacheType)cacheType;

+(void)setCacheFileWithKey:(NSString*)key WithValue:(NSData*)value withFileName:(NSString*)withFileName withFileExt:(NSString*)fileExt
             withCacheType:(IYFileCacheType)cacheType;

+(void)setCacheFileWithKey:(NSString*)key WithValue:(NSData*)value withFileName:(NSString*)withFileName withFileExt:(NSString*)fileExt withCacheType:(IYFileCacheType)cacheType encryptType:(IYFileEncryptType)encryptType;

/** 删除文件
 @param 键值
 */
+(BOOL)removeCacheFileWithKey:(NSString*)key;
@end
