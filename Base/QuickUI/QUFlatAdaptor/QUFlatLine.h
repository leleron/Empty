//
//  QUFlatLine.h
//  CaoPanBao
//
//  Created by zhuojian on 14-6-26.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QUFlatLine : UIView
@property(nonatomic,strong)UIColor* lineColor;

/** 设置线条缩进效果
 @param indentLevel 设置缩进的倍数(indentLevel*15px)
 */
-(void)indentLineLevel:(int)indentLevel;
@end

/** 虚线 */
@interface QUFlatLineDash : QUFlatLine

@end