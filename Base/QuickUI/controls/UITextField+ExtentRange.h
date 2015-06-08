//
//  UITextField+ExtentRange.h
//  CaoPanBao
//
//  Created by zhuojian on 14-8-15.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)
/** 获取选定范围 */
- (NSRange) selectedRange;

/** 设置选中范围 */
- (void) setSelectedRange:(NSRange) range;

/** 设置光标位置 */
- (void) insertSelectedRange:(NSRange) range;
@end

