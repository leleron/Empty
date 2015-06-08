//
//  UITextView+ExtentRange.m
//  CaoPanBao
//
//  Created by zhuojian on 14-8-15.
//  Copyright (c) 2014年 weihui. All rights reserved.
//
#import <objc/runtime.h>

#import "UITextView+ExtentRange.h"

#define kPrevInputTextKey @"kPrevInputTextKey"

@implementation UITextView (ExtentRange)
@dynamic prevInputText;

-(void)setPrevInputText:(NSString *)prevInputText{
//    mPrevInputText=prevInputText;
    objc_setAssociatedObject(self, kPrevInputTextKey, prevInputText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)prevInputText{
    return objc_getAssociatedObject(self, kPrevInputTextKey);
//    return mPrevInputText;
}

/**
 限制文本框输入长度
 @param textField 文本框
 @param limitInputLength 限制文本输入长度
 @return YES
 
 适用场景
 textFieldEditChanged 时调用下面方法
 [self limitTextField:textField limitInputLength:50];
 */
-(BOOL)limitInputLength:(int)limitLength
{
    BOOL beOverLimit=NO;  // yes 超出限制，no 没有超出
    
    NSString *toBeString = self.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [self markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > limitLength) {
                self.text = [toBeString substringToIndex:limitLength];
                
                beOverLimit=YES;  // 超出限制
            }
            
            self.prevInputText=self.text;
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > limitLength) {
            self.text = [toBeString substringToIndex:limitLength];
            
            beOverLimit=YES;     // 超出限制
        }
        
        self.prevInputText=self.text;

    }
    
    return YES;
}


/**
 返回文本长度(不含候选词)
 @param textField 文本框
 */
-(int)lengthWithoutCandidate
{
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"]) { // 简体/繁体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [self markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            self.prevInputText=self.text;
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        self.prevInputText=self.text;
    }
    
    if(!self.prevInputText) // 如果当前没有定义则赋予空
        self.prevInputText=@"";
    
    return [self.prevInputText length];
}


@end
