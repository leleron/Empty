//
//  GYBankCardFormatTextField.h
//  GYBankCardFormat
//
//  Created by Gary on 14-5-29.
//  Copyright (c) 2014年 蒲晓涛. All rights reserved.
//

#import <UIKit/UIKit.h>

// 开始编辑
#define  kBeginSetTextField(x) if(IOS6_OR_LATER){} else{[self removeTarget:self action:@selector(x:) forControlEvents:UIControlEventEditingChanged];}

// 结束编辑
#define kEndSetTextField(x) if(IOS6_OR_LATER){} else{[self addTarget:self action:@selector(x:) forControlEvents:UIControlEventEditingChanged];}

@interface QUPhoneTextFieldHelper : NSObject

@end

@interface QUPhoneTextField : QUTextField
-(void)setupFormat;
+ (NSString *)formatMobile:(NSString *)string;
+(NSString*)removeFormat:(NSString*)string;

/** 是否输入完整内容 */
@property(nonatomic,assign)BOOL bInputCompletedContent;

/** 当前删除是否为空格 */
@property(nonatomic,assign)BOOL bCurrentDelededBlank;

/** 委托 */
@property(nonatomic,weak)id<UITextFieldDelegate> pDelegate;
@end
