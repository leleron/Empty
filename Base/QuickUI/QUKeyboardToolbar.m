//
//  QUKeyboardToolbar.m
//  WeiPay
//
//  Created by zhuojian on 14-3-28.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUKeyboardToolbar.h"
#import "QUTextField.h"
@implementation QUKeyboardToolbar

+(id)keyboardToolbar{
  
    
    NSArray* array= [[NSBundle mainBundle] loadNibNamed:@"QUKeyboardToolbar" owner:nil options:nil];
    
    UIView* view=[array objectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:view selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return view;
    
    
}

//-(void)setFinishAction:(id)target action:(SEL)selector{
//    [self.btnFinish addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//}

-(IBAction)clickFinish:(id)sender
{
    if(self.textField)
    {
        [self.textField resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
  
    
//    NSDictionary *userInfo = [notification userInfo];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
//    NSDictionary* userInfo = [notification userInfo];
 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
