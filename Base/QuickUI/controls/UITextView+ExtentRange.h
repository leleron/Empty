//
//  UITextView+ExtentRange.h
//  CaoPanBao
//
//  Created by zhuojian on 14-8-15.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextView (ExtentRange)


/** 上次输入的文本（不含拼音候选词） */
@property(nonatomic,strong)NSString* prevInputText;

/**
 限制文本框输入长度
 @param textField 文本框
 @param limitInputLength 限制文本输入长度
 */
-(BOOL)limitInputLength:(int)limitLength;

/**
 返回文本长度(不含候选词)
 @param textField 文本框
 */
-(int)lengthWithoutCandidate;
@end
