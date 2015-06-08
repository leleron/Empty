//
//  QUKeyboardToolbar.h
//  WeiPay
//
//  Created by zhuojian on 14-3-28.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QUTextField;
@interface QUKeyboardToolbar : UIView
@property(nonatomic,strong)IBOutlet UIButton* btnFinish;
+(id)keyboardToolbar;
//-(void)setFinishAction:(id)target action:(SEL)selector;
@property(nonatomic,weak)QUTextField* textField;
@end
