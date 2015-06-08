//
//  QUIdentityCardTextField.m
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-8-15.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUIdentityCardTextField.h"

@implementation QUIdentityCardTextField

+(void)addXButtonToKeyboard:(UITextField*)pText{
    [[WHGlobalHelper shareGlobalHelper] put:pText key:@"PassdentityCardTextField"];
    [self performSelector:@selector(addXButtonToKeyboard) withObject:nil afterDelay:0.1];
}

+(void)addXButtonToKeyboard{
    [self addButtonToKeyboardWithSelector:@selector(xButton) normal:[UIImage imageNamed:@"XUp.png"] highlight:[UIImage imageNamed:@"XDown.png"]];
}

+(void)addButtonToKeyboardWithSelector:(SEL)sel normal:(UIImage*)nimg highlight:(UIImage*)himg{
	// create custom button
	UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xButton.tag=888;
	xButton.adjustsImageWhenHighlighted = NO;
	
    [xButton setImage:nimg forState:UIControlStateNormal];
    [xButton setImage:himg forState:UIControlStateHighlighted];
	[xButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
    int cnt=[[UIApplication sharedApplication] windows].count;
	UIWindow* keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt-1];
    xButton.frame = CGRectMake(0,keyboardWindow.frame.size.height, 106, 53);
    
    //动画
    [UIView animateWithDuration:0.248f animations:^{
        xButton.frame = CGRectMake(0, keyboardWindow.frame.size.height-53, 106, 53);
        [keyboardWindow addSubview:xButton];
    } completion:^(BOOL finished) {

    }];

}

+(void) xButton {
    UITextField *pText = [[WHGlobalHelper shareGlobalHelper] get:@"PassdentityCardTextField"];
    if (pText.text.length <= 17) {
        pText.text=[pText.text stringByAppendingString:@"X"];
    }
}

+(void)removeButtonFromKeyboard {
    // locate keyboard view
    int cnt=[[UIApplication sharedApplication] windows].count;
	UIWindow* keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt-1];
    [[keyboardWindow viewWithTag:888] removeFromSuperview];
}

@end
