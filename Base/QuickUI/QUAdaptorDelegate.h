//
//  QUAdaptorProtocol.h
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QUAdaptor;
@class QUSection;
@class QUEntity;
@class QUTextField,UITextView,UIView;

@protocol QUAdaptorDelegate <NSObject>


@optional

-(void)QUAdaptor:(QUAdaptor*)adaptor forSection:(QUSection*)section forEntity:(QUEntity*)entity;

/** 选中某项Section时触发 */
-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity;


/** 文本框离开焦点触发 */
-(void)QUAdaptor:(QUAdaptor *)adaptor willChangeSection:(QUSection *)section willChangeTextField:(QUTextField *)textField;



/** 文本框进入焦点触发 */
-(void)QUAdaptor:(QUAdaptor *)adaptor textFieldBeginEditing:(QUTextField *)textField;

/** 文本框进入焦点，返回偏移高度 */
-(float)QUAdaptor:(QUAdaptor*)adaptor willOffsetForTextField:(QUTextField*)textField;

/** 文本框内容已更改 */
-(void)QUAdaptor:(QUAdaptor *)adaptor textFieldEditChanged:(QUTextField *)textField;

/** 文本框内容是否需要变更 */
- (BOOL)QUAdaptor:(QUAdaptor*)adaptor textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

/** 过滤点击手势,返回NO表示不做拦截，YES=》拦截手势 */
-(BOOL)QUAdaptor:(QUAdaptor*)adaptor shouldTapView:(UIView*)tapView;

/** 单击tableview 任意位置触发手势(未做拦截的手势) */
-(void)QUAdaptor:(QUAdaptor *)adaptor tapView:(UIView *)tapView;

/** 手势拦截触发后，是否取消正在进行的触摸事件(YES 取消当前触摸，NO 继续触摸) */
-(BOOL)QUAdaptorShouldCancelsTouchesInView:(QUAdaptor*)adaptor;

/** 自定义构造初始化Section */
-(QUSection*)QUAdaptor:(QUAdaptor*)adaptor initSectionClass:(Class)cls;



/**
 首次初始化构造Section
 @param willDidLoadSection 初始化Section
 @param willDidLoadEntity 初始化Entity
 */
-(void)QUAdaptor:(QUAdaptor*)adaptor willDidLoadSection:(QUSection*)section willDidLoadEntity:(QUEntity*)entity;
@end

