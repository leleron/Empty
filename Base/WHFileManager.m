//
//  IYFileManager.m
//  IWithYou
//
//  Created by zhuo jian on 13-8-13.
//
//

#import "WHFileManager.h"
#import "NSString+MD5.h"
#define CACHE_FILE_KEY @"CACHE_FILE_KEY"

@implementation WHFileManager
+(NSString*)defaultFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(NSString*)documentFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(NSString*)appFilePath{
    return [[NSBundle mainBundle] resourcePath];
}

+(NSString*)pictureFilePath{
    NSString* path=[NSString stringWithFormat:@"/%@",@"wh_pic/"];
    return [[self defaultFilePath] stringByAppendingString:path];
}

+(NSString*)filePath{
    return [[self defaultFilePath] stringByAppendingString:@"/wh_files/"];
}

+(NSString*)uniqueFileName:(NSString*)withFileName{
    
    NSAssert(withFileName!=nil, @"uniqueFilewithExt 传入的withFileName is nil");
    
    
    NSString* uniquid=[NSString stringWithFormat:@"%@",withFileName];
    return uniquid;
}



+(NSString*)filePathByCacheType:(IYFileCacheType)type{
    NSString* path;
    if(type==IYFileCacheTypePicture)
        path=[WHFileManager pictureFilePath];
    
    else if(type==IYFileCacheTypeFile)
        path=[WHFileManager filePath];
    
    
    
    return path;
}



/** 获取文件路径，根据key */
+(NSString*)cacheFilePathWithKey:(NSString*)key{
    
    NSString* newKey=[key md5];
    
    NSString* file=nil;
    NSString* result=nil;
    
    NSString* destPath=[self filePathByCacheType:IYFileCacheTypeFile];
    file=[NSString stringWithFormat:@"%@%@",destPath,[WHFileManager uniqueFileName:newKey]];
    
    if(file)
    {
        BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:file];
        if(isExist) // 如果缓存文件被清除，则返回空
            result=file;
        
    }
    
    return result;
}

/** 获取文件内容，根据key */
+(NSData*)cacheFileWithKey:(NSString*)key{
    
    if(!key) // 无效的键值
        return nil;
    
    NSString* newKey=[key md5];
    
    NSString* file=nil;
    NSData* result=nil;
    
    NSString* destPath=[self filePathByCacheType:IYFileCacheTypeFile];
    
    file=[NSString stringWithFormat:@"%@%@",destPath,[WHFileManager uniqueFileName:newKey]];
    
    if(file)
    {
        BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:file];
        if(!isExist) // 如果缓存文件被清除，则返回空
        {
            //            [dict removeObjectForKey:key];
        }
        else{
            result=[NSData dataWithContentsOfFile:file];
        }
    }
    
    return result;
}

/** 获取文件内容，根据key */
+(UIImage*)cacheImageFileWithKey:(NSString*)key{
    if(!key) // 无效的键值
        return nil;
    
    NSString* newKey=[key md5];
    
    NSString* file=nil;
    NSData* result=nil;
    UIImage* image;
    
    NSString* destPath=[self filePathByCacheType:IYFileCacheTypeFile];
    file=[NSString stringWithFormat:@"%@%@",destPath,[WHFileManager uniqueFileName:newKey]];
    
    if(file)
    {
        BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:file];
        if(!isExist) // 如果缓存文件被清除，则返回空
        {
            //            [dict removeObjectForKey:key];
        }
        else{
            result=[NSData dataWithContentsOfFile:file];
            image=[UIImage imageWithData:result scale:2.f];
        }
    }
    
    return image;
}


+(void)setCacheFileWithKey:(NSString*)key WithValue:(NSData*)value withFileExt:(NSString*)fileExt withCacheType:(IYFileCacheType)cacheType{
    [self setCacheFileWithKey:key WithValue:value withFileName:nil withFileExt:fileExt withCacheType:cacheType  encryptType:IYFileEncryptTypeNone];
}

+(void)setCacheFileWithKey:(NSString*)key WithValue:(NSData*)value withFileName:(NSString*)withFileName withFileExt:(NSString*)fileExt withCacheType:(IYFileCacheType)cacheType encryptType:(IYFileEncryptType)encryptType{
    
    IYFileCacheType newCacheType=IYFileCacheTypeFile;
    
    NSString* newKey=[key md5];
    
    
    NSString* destPath=[self filePathByCacheType:newCacheType];
    
    NSError* error;
    if(![[NSFileManager defaultManager] fileExistsAtPath:destPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSString* filePath=[NSString stringWithFormat:@"%@%@",destPath,[WHFileManager uniqueFileName:newKey]];
    
    //    if(encryptType==IYFileEncryptTypeAES256)
    //        value=[value AES256EncryptWithKey:AES256_KEY];
    
    BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(isExist) // 如果文件已经存在则先删除
    {
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    }
    
    [value writeToFile:filePath atomically:YES];
    
    
}


/** 删除文件
 @param 键值
 */
+(BOOL)removeCacheFileWithKey:(NSString*)key{
    NSString* filePath= [self cacheFilePathWithKey:key];
    if(!filePath)
        return NO;
    
    [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    
    
    return YES;
    
}



@end
