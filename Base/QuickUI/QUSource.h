//
//  QUSource.h
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QUEntity.h"
@interface QUSource : NSObject
@property(nonatomic,strong)NSMutableArray* pEntityList;

//@property(nonatomic,strong)NSMutableArray* pSectionClsList;
@property(nonatomic,strong)NSMutableDictionary* pSectionDict;
@property(nonatomic,strong)NSMutableArray* pSectionList;

+(instancetype)source;

-(void)addEntity:(QUEntity*)entity withSection:(Class)sectionClass;
-(void)addEntity:(QUEntity *)entity index:(NSUInteger)index group:(QUGroupEntity*)group withSection:(Class)sectionClass;
-(void)clear;

-(NSUInteger)count;
-(QUEntity*)entityAtIndex:(NSUInteger)index;
-(QUEntity*)entityWithTag:(int)tag;
-(QUSection*)sectionWithTag:(int)tag;
-(QUEntity*)entityAtSection:(NSUInteger)section rows:(NSUInteger)rows;
//-(NSString*)sectionAtIndex:(NSUInteger)index;
-(void)removeEntity:(QUEntity*)entity;
-(void)removeAtSection:(NSUInteger)section rows:(NSUInteger)rows;
-(NSArray*)entityArrayByClass:(Class)cls;
-(NSArray*)entityArray;
-(void)removeEntityByTag:(int)tag;
-(void)addEntity:(QUEntity*)entity withSection:(Class)sectionClass afterEntity:(QUEntity*)afterEntity;
-(void)addEntityArray:(NSArray *)entityArray withLine:(UIColor *)bottomLine withSection:(Class)sectionClass;
-(void)addEntityArray:(NSArray *)entityArray withLine:(UIColor *)bottomLine withSelBgClr:(UIColor*)bgColor withSection:(Class)sectionClass;
-(void)addEntityArray:(NSArray*)entityArray withLine:(UIColor*)bottomLine withSelBgClr:(UIColor*)bgColor withLineCls:(Class)lineCls withSection:(Class)sectionClass;
-(NSString*)sectionAtKey:(NSString*)key;
/** 替换Entity与Section映射关系
                                                                                                                                      
 @param newEntity 新的实体类
 @param sectionClass 新的Section
 @param oldEntityTag 被替换的Entity tag
 */
-(void)replaceNewEntity:(QUEntity*)newEntity withNewSectionClass:(Class)sectionClass oldEntityTag:(int)oldEntityTag;
@end