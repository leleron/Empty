//
//  QUKeyboard.h
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-6-25.
//  Copyright (c) 2014年 weihui. All rights reserved.
//
// 左下角带X的数字键盘

#import <UIKit/UIKit.h>

@protocol QUKeyboardDelegate <NSObject>

@optional
-(void)numberKeyboardInput:(NSString *)number;
- (void) numberKeyboardBackspace;
- (void) changeKeyboardType;
@end

@interface QUKeyboard : UIView

@property (nonatomic,assign) id<QUKeyboardDelegate> delegate;

@end
