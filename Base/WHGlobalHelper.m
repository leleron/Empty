//
//  CPBGlobalHelper.m
//  CaoPanBao
//
//  Created by zhuojian on 14-5-8.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "WHGlobalHelper.h"
#import "Constant.h"

@interface WHGlobalHelper()<UITextFieldDelegate>

@end

@implementation WHGlobalHelper
static WHGlobalHelper* globalHelper;

+(WHGlobalHelper*)shareGlobalHelper{
    if(!globalHelper)
        globalHelper=[[WHGlobalHelper alloc] init];
    
    return globalHelper;
}

-(id)init{
    self=[super init];
    dict=[[NSMutableDictionary alloc] init];
    return self;
}

-(void)put:(id)obj key:(NSString *)key{
    [dict setObject:obj forKey:key];
    
    [self saveToDisk:obj key:key];
}

-(id)get:(NSString *)key{
    return [self get:key defValue:nil];
}

-(id)get:(NSString*)key defValue:(id)defValue
{
    id obj= [dict objectForKey:key];
    
    if(obj) // 如果内存有数据，则返回内存数据
        return obj;
    
    obj=[self readFromDisk:key]; // 否则返回磁盘数据
    
    if(obj)
        return obj;
//    if (obj) {
//        dict[key]=obj;
//    }
    
    return defValue;
}

/**
 保存到磁盘
 @param obj 待保存的对象
 @param key 对象键值
 */
-(void)saveToDisk:(id)obj key:(NSString*)key
{
    if(!obj)
        return;
    
    if(!key)
        return;    
    
    if([obj conformsToProtocol:@protocol(WHGlobalHelperDelegate)])
    {
        [obj store:key];
    }
}

+(NSString*)key:(NSString*)key prefix:(NSString*)prefix{
    return [NSString stringWithFormat:@"%@_%@",key,prefix];
}

/**
 从磁盘读取
 */
-(id)readFromDisk:(NSString*)key{
    
//    return nil; // 暂时注销缓存
    
    id content=[[NSUserDefaults standardUserDefaults]valueForKey:key];
    
    if(!content)
        return nil;
    
    if(!key)
        return nil;
    
    NSString* className=key;
    
    if(!className)
    {
        WPNSLOG(@"无效的序列化类名");
        return nil;
    }
    
    Class cls=NSClassFromString(className);
    
    id obj=nil;
//    id obj=[[cls alloc] init];
//    
//    if(!obj)
//        return nil;
    
    if([cls conformsToProtocol:@protocol(WHGlobalHelperDelegate)])
    {
        obj=[cls restore:key content:content];
    }
    
    
    return obj;
}

-(void)removeAll{
    [dict removeAllObjects];
}

-(void)removeByKey:(NSString*)key{
    [dict removeObjectForKey:key];
}

#pragma mark - 
- (BOOL)textField                       :(UITextField *)textField
        shouldChangeCharactersInRange   :(NSRange)range
        replacementString               :(NSString *)string
{
    return YES;
}

@end
