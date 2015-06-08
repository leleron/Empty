//
//  QUSource.m
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUSource.h"

@implementation QUSource

+(instancetype)source{
    return [[self alloc] init];
}

-(id)init{
    self=[super init];
    
    self.pEntityList=[[NSMutableArray alloc] init];
//    self.pSectionClsList=[[NSMutableArray alloc] init];
    self.pSectionDict=[[NSMutableDictionary alloc]init];
    
    self.pSectionList=[[NSMutableArray alloc] init];
    return self;
}


-(NSUInteger)count{
    return [self.pEntityList count];
}

-(QUEntity*)entityAtIndex:(NSUInteger)index{
    return [self.pEntityList objectAtIndex:index];
}

//-(NSString*)sectionAtIndex:(NSUInteger)index{
//    
//    NSString* clsName= [self.pSectionClsList objectAtIndex:index];
//    
//    return clsName;
//    
//}

-(NSString*)sectionAtKey:(NSString*)key{
    return [self.pSectionDict objectForKey:key];
}

-(void)removeSectionAtKey:(NSString*)key{
    [self.pSectionDict removeObjectForKey:key];
}

-(QUEntity*)entityAtSection:(NSUInteger)section rows:(NSUInteger)rows{
    QUEntity* et=[self entityAtIndex:section];
    if([et isKindOfClass:[QUGroupEntity class]])
    {
        et=[(QUGroupEntity*)et entityAtIndex:rows];
    }
    return et;
}

/** 替换Entity与Section映射关系
 @param newEntity 新的实体类
 @param sectionClass 新的Section
 @param oldEntityTag 被替换的Entity tag
 */
-(void)replaceNewEntity:(QUEntity*)newEntity withNewSectionClass:(Class)sectionClass oldEntityTag:(int)oldEntityTag
{
     [self.pSectionDict setObject:NSStringFromClass(sectionClass) forKey:newEntity.key]; // 保存当前Section与Entity关联
    
     QUEntity* entity= [self entityWithTag:oldEntityTag];
    
    [[entity group] changeNewEntity:newEntity oldEntity:entity]; // 替换为新数据
    
}

-(void)addEntity:(QUEntity *)entity withSection:(Class)sectionClass{
   
    QUGroupEntity* list=(QUGroupEntity*)entity;
    if([entity isMemberOfClass:NSClassFromString(@"WCFDiscoverPhoneOwnerTipEntity")])
    {
        
    }
    
    NSString* key;
    /** 包装为list方式添加 (类似于tableView排列方式)*/
    if(![entity isMemberOfClass:[QUGroupEntity class]])
        {
           QUGroupEntity *lis=[[QUGroupEntity alloc] init];
            [lis addEntity:entity];
            key=entity.key;
            [self.pSectionDict setObject:NSStringFromClass(sectionClass) forKey:key];
            [self.pEntityList addObject:lis];
            return;
        }
    
    [self.pEntityList addObject:list];
}

/** 批量添加entity
 @param entityArray 添加的entity数组
 @param sectionClass 映射的Section
 */
-(void)addEntityArray:(NSArray*)entityArray withLine:(UIColor*)bottomLine withSelBgClr:(UIColor*)bgColor withLineCls:(Class)lineCls withSection:(Class)sectionClass
{
    for (QUEntity* e in entityArray) {
        e.lineBottomColor=bottomLine;
        e.lineBottomColorClass=lineCls;
        e.selectedBgColor=bgColor;
        [self addEntity:e withSection:sectionClass];
    }
}

-(void)addEntityArray:(NSArray *)entityArray withLine:(UIColor *)bottomLine withSection:(Class)sectionClass
{
    [self addEntityArray:entityArray withLine:bottomLine withSelBgClr:nil withLineCls:nil withSection:sectionClass];
}

-(void)addEntityArray:(NSArray *)entityArray withLine:(UIColor *)bottomLine withSelBgClr:(UIColor*)bgColor withSection:(Class)sectionClass
{
    [self addEntityArray:entityArray withLine:bottomLine withSelBgClr:bgColor withLineCls:nil withSection:sectionClass];
}

-(void)addEntity:(QUEntity *)entity index:(NSUInteger)index group:(QUGroupEntity*)group withSection:(Class)sectionClass{
    
   
//
//    [group addEntity:entity index:index];
//    
//    [self.pSectionClsList addObject:NSStringFromClass(sectionClass)];
////    [self.pEntityList addObject:group];
    
//    QUGroupEntity* list=group;
    
    [group addEntity:entity index:index];
    
//    [self.pSectionClsList addObject:@{entity.key: NSStringFromClass(sectionClass)}];
//    [self.pEntityList addObject:group];
    [self.pSectionDict setObject:NSStringFromClass(sectionClass) forKey:entity.key];
//    [self.pEntityList insertObject:list atIndex:index];
}

/**
 @param entity 带插入的实体
 @param sectionClass 映射的sectionClass
 @param afterEntity 插入在某个entity之后
 */
-(void)addEntity:(QUEntity*)entity withSection:(Class)sectionClass afterEntity:(QUEntity*)afterEntity
{
    
    QUGroupEntity* list=(QUGroupEntity*)entity;
    
    NSString* key;
    /** 包装为list方式添加 */
    if(![entity isMemberOfClass:[QUGroupEntity class]])
    {
        list=[[QUGroupEntity alloc] init];
        
        [list addEntity:entity];
        
        key=entity.key;
        
        [self.pSectionDict setObject:NSStringFromClass(sectionClass) forKey:key];
    }
    
    NSInteger index=[self.pEntityList indexOfObject:afterEntity.group];
    
    if(index>=0)
        index++;
    
    [self.pEntityList insertObject:list atIndex:index];
    
}

-(void)removeEntity:(QUEntity*)entity{
    [entity.group removeEntity:entity];
    
    if([entity.group count]==0)
        [self.pEntityList removeObject:entity.group];

    [self removeSectionAtKey:entity.key];
}


-(QUEntity*)entityWithTag:(int)tag
{
    
    for (QUEntity* e in self.pEntityList) {
        if([e isMemberOfClass:[QUGroupEntity class]])
        {
            QUGroupEntity* ge=(QUGroupEntity*)e;
            QUEntity* et=[ge entityByTag:tag];
            if(et)
                return et;
        }
    }
    
    return nil;
}

-(QUSection*)sectionWithTag:(int)tag{
    QUEntity* e=[self entityWithTag:tag];
    return e.pSection;
}

-(void)removeEntityByTag:(int)tag{
    QUEntity* et=[self entityWithTag:tag];
    
    if(et)
        [self removeEntity:et];
    
}

-(void)removeAtSection:(NSUInteger)section rows:(NSUInteger)rows{
    QUEntity* et=[self entityAtSection:section rows:rows];
    [et.group removeEntity:et];
}

-(NSArray*)entityArrayByClass:(Class)cls{
    NSMutableArray* array=[NSMutableArray array];
    for (QUGroupEntity* group in self.pEntityList) {
        if([group isMemberOfClass:[QUGroupEntity class]])
        {
            for (QUEntity* et in group.pList) {
                if([et isMemberOfClass:cls])
                    [array addObject:et];
            }
        }
    }
    return array;
}

-(NSArray*)entityArray{
    NSMutableArray* array=[NSMutableArray array];
    for (QUGroupEntity* group in self.pEntityList) {
        if([group isMemberOfClass:[QUGroupEntity class]])
        {
            for (QUEntity* et in group.pList) {
                    [array addObject:et];
            }
        }
    }
    return array;
}

-(void)clear{
//    [self.pSectionClsList removeAllObjects];
    [self.pEntityList removeAllObjects];
    [self.pSectionDict removeAllObjects];
}

@end
