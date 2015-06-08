//
//  QUBankCardTextField.h
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-8-8.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUTextField.h"
@interface QUBankCardTextFieldHelper : NSObject

@end

@interface QUBankCardTextField : QUTextField
-(void)setupFormat;
+(NSString*)removeFormat:(NSString*)string;

/** 是否输入完整内容 */
@property(nonatomic,assign)BOOL bInputCompletedContent;

/** 当前删除是否为空格 */
@property(nonatomic,assign)BOOL bCurrentDelededBlank;

/** 委托 */
@property(nonatomic,weak)id<UITextFieldDelegate> pDelegate;
@end
