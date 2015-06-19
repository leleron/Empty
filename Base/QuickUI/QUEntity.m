//
//  QUEntity.m
//  WeiPay
//
//  Created by zhuojian on 14-3-17.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUEntity.h"
#import "QUJsonParse.h"

@interface QUEntity()
{
    NSString* _key;
}
@end

@implementation QUEntity
+(instancetype)entity{
    return [[self alloc] init];
}

-(id)init{
    self=[super init];
    
    self.accessoryType=UITableViewCellAccessoryNone;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0);

    _key=[NSString stringWithFormat:@"%f",[[[NSDate alloc]init] timeIntervalSince1970]];
    return self;
}

-(NSString *)description{
    return nil;
}

-(NSString *)debugDescription{
    return nil;
}

-(NSUInteger)hash{
    return 0;
}

-(NSString*)superclass{
    return nil;
}

-(NSUInteger)index{
    if(!self.group)
        return 0;

    return [self.group indexAtEntity:self];
}

/** 返回实体数据的行数，默认1 */
-(NSUInteger)count{
    return 1;
}

-(NSString*)key{
    return _key;
}

-(void)setKey:(NSString *)key{
    
}

+(instancetype)entityWithLine:(UIColor *)lineBottom{
    return [self entityWithLineTop:nil lineBottom:lineBottom];
}

+(instancetype)entityWithLine:(UIColor *)lineBottom tag:(int)tag
{
    return [self entityWithLineTop:nil lineBottom:lineBottom tag:tag];
}

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom{
    return [self entityWithLineTop:lineTop lineBottom:lineBottom tag:0];
}

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom tag:(int)tag{
    QUEntity* e=[self entity];
    e.lineBottomColor=lineBottom;
    e.LineTopColor=lineTop;
    e.tag=tag;
    return (id)e;
}

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom lineTopClass:(Class)topClass lineBottomClass:(Class)bottomClass tag:(int)tag{
    
    QUEntity* e=[self entity];
    e.lineBottomColor=lineBottom;
    e.LineTopColor=lineTop;
    e.tag=tag;
    
    if(topClass)
        e.lineTopColorClass=topClass;
    
    if(bottomClass)
        e.lineBottomColorClass=bottomClass;
    
    return (id)e;
}

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom lineTopClass:(Class)topClass lineBottomClass:(Class)bottomClass selectedBgColor:(UIColor*)selectedBgColor tag:(int)tag{
    
    QUEntity* e=[self entity];
    e.lineBottomColor=lineBottom;
    e.LineTopColor=lineTop;
    e.tag=tag;
    e.selectedBgColor=selectedBgColor;
    
    if(topClass)
        e.lineTopColorClass=topClass;
    
    if(bottomClass)
        e.lineBottomColorClass=bottomClass;
    
    return (id)e;
}

//-(NSString*)description{
//    return (NSString*)[[[QUJsonParse alloc] init] dictionaryFromObjc:self];
//}

#pragma mark - 磁盘存取数据
-(void)store:(NSString *)key{
    NSString* jsonString =[[[QUJsonParse alloc] init] stringFromObjc:self];
    
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(instancetype)restore:(NSString *)key content:(NSString *)content{
    NSString* jsonString=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return [[[QUJsonParse alloc] init] objFromString:jsonString withClass:[self class]];
}



@end

@implementation QUGroupEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pList=[NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

-(void)addEntity:(QUEntity *)entity{
    if (!entity)return;
    entity.group=self;
    [self.pList addObject:entity];
}

-(void)addEntity:(QUEntity *)entity index:(NSUInteger)index{
    entity.group=self;
    [self.pList insertObject:entity atIndex:index];
}

/** 返回实体列表行数 */
-(NSUInteger)count{
    return [self.pList count];
}

-(NSUInteger)countAtIndex:(NSUInteger)index{
    return [self.pList[index] count];
}


-(QUEntity*)entityAtIndex:(NSUInteger)index{
    return [self.pList objectAtIndex:index];
}

-(NSUInteger)indexAtEntity:(QUEntity*)entity{
    return [self.pList indexOfObject:entity];
}

-(void)removeEntity:(QUEntity*)entity{
    [self.pList removeObject:entity];
}

-(QUEntity*)entityByTag:(int)tag{
    for (QUEntity* e in self.pList) {
        if(e.tag==tag)
            return e;
    }
    
    return nil;
}

/** 交换entity
 @param newEntity
 @param oldEntity
 */
-(void)changeNewEntity:(QUEntity*)newEntity oldEntity:(QUEntity*)oldEntity{
    for (QUEntity* e in self.pList) {
        if(oldEntity==e)
        {
            int index=[self.pList indexOfObject:oldEntity];
            newEntity.group=self;
            self.pList[index]=newEntity;
        }
    }
}

-(void)removeEntityByTag:(int)tag{
    QUEntity* byRemoved=nil;
    for (QUEntity* e in self.pList) {
        if(e.tag==tag)
            byRemoved=e;
    }
    
    [self.pList removeObject:byRemoved];
}

-(NSArray*)subEntity{
    return self.pList;
}

-(void)parse:(id)content{
    
}

+(instancetype)parse:(id)content{
    return nil;
}

+(instancetype)parse:(id)content targetClass:(Class)cls
{
    @synchronized(self)
    {
        return [[[QUJsonParse alloc] init] objFromString:content withClass:cls];
    }
}

-(void)empty{
    
}





@end