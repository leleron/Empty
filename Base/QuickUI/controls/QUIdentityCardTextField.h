//
//  QUIdentityCardTextField.h
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-8-15.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUTextField.h"

@interface QUIdentityCardTextField : QUTextField

//添加X按钮
+ (void)addXButtonToKeyboard:(UITextField*)pText;
//移除X按钮
+ (void)removeButtonFromKeyboard;
@end
