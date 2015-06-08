//
//  QUSection.h
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *iPhone4上可以滑动，按照iPhone5的尺寸布局
 */
#define kWindowHeightiPhone5 568
#define kWindowHeightIPhone6 667

@class QUAdaptor;
@class QUSection;
@class QUFlatLine;
@interface QUSectionInfo : NSObject
@property(nonatomic,assign)CGRect frame;
//@property(nonatomic,weak)QUSection* section;
//-(CGRect)sectionRect;
@end

@class QUEntity;

@interface QUSection : UIView
-(NSUInteger)count;
@property(nonatomic,assign)NSUInteger section;
@property(nonatomic,assign)NSUInteger rows;
@property(nonatomic,weak)QUAdaptor* pAdaptor;
@property(nonatomic,assign)NSUInteger pScrollOffset;

@property(nonatomic,weak)QUEntity* entity;

@property(nonatomic,strong)QUFlatLine* line_top;
@property(nonatomic,strong)QUFlatLine* line_bottom;

@property(nonatomic,strong)NSMutableArray* pButtonArray;

@property(nonatomic,strong)NSIndexPath* pIndexPath;
/**是否在iPhone4上可以滑动*/
@property (nonatomic,assign) BOOL isSlideOniPhone4;

-(void)fillParent;

-(NSIndexPath*)indexPath;
-(void)layoutSection;

-(void)sectionDidLoad;

-(CGRect)rectSection;

+(instancetype)section;

-(void)sectionWillLoad;

-(void)inflate:(QUEntity*)entity;

-(NSArray*)viewWithClass:(Class)viewClass;

@end