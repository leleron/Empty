//
//  QUEntity.h
//  WeiPay
//
//  Created by zhuojian on 14-3-17.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QUGroupEntity;
@class QUSection;
@interface QUEntity : NSObject
+(instancetype)entity;
-(NSUInteger)count;
-(NSUInteger)index;
//-(void)parse:(id)content;

@property(nonatomic,strong)QUGroupEntity* group;
@property(nonatomic,assign)UITableViewCellAccessoryType accessoryType; // 箭头
@property(nonatomic,strong)UIColor* borderLineColor;
@property(nonatomic,strong)UIColor* selectedBgColor;
@property(nonatomic,assign)UITableViewCellSelectionStyle selectionStyle; // 选中样式
@property(nonatomic,assign)UIEdgeInsets separatorInset  NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
@property(nonatomic,assign) int pIndentLevel;  // 缩进方式
@property(nonatomic,strong)NSString* key;
//@property(nonatomic,strong)UIColor* LineColor;
//@property(nonatomic,strong)UIColor* headerLineColor;
@property(nonatomic,strong)UIColor* LineTopColor;
@property(nonatomic,strong)UIColor* lineBottomColor;

@property(nonatomic,assign)CGRect* pFrame;

@property(nonatomic,strong)Class lineTopColorClass;

@property(nonatomic,strong)Class lineBottomColorClass;

@property(nonatomic,assign)int tag;

@property(nonatomic,strong)id data;

@property(nonatomic,weak)  QUSection* pSection;

-(void)parse:(id)content NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

+(instancetype)parse:(id)content targetClass:(Class)cls;

+(instancetype)parse:(id)content;

-(void)empty;

+(instancetype)entityWithLine:(UIColor*)lineBottom;

+(instancetype)entityWithLine:(UIColor *)lineBottom tag:(int)tag;

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom;

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom tag:(int)tag;

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom lineTopClass:(Class)topClass lineBottomClass:(Class)bottomClass tag:(int)tag;

+(instancetype)entityWithLineTop:(UIColor*)lineTop lineBottom:(UIColor*)lineBottom lineTopClass:(Class)topClass lineBottomClass:(Class)bottomClass selectedBgColor:(UIColor*)selectedBgColor tag:(int)tag;

//磁盘存取
//CPBGlobalHelper  会自动掉用相应的方法
-(void)store:(NSString *)key;
+(instancetype)restore:(NSString *)key content:(NSString *)content;

@end


@interface QUGroupEntity : QUEntity
@property(nonatomic,strong)NSMutableArray* pList;
-(void)addEntity:(QUEntity*)entity;
-(void)addEntity:(QUEntity *)entity index:(NSUInteger)index;
-(QUEntity*)entityAtIndex:(NSUInteger)index;
-(NSUInteger)indexAtEntity:(QUEntity*)entity;
-(void)removeEntity:(QUEntity*)entity;
-(void)removeEntityByTag:(int)tag;
-(NSUInteger)countAtIndex:(NSUInteger)index;
-(NSArray*)subEntity;
-(QUEntity*)entityByTag:(int)tag;
-(void)changeNewEntity:(QUEntity*)newEntity oldEntity:(QUEntity*)oldEntity;
@end