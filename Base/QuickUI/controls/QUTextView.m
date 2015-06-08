//
//  QUTextView.m
//  CaoPanBao
//
//  Created by zhuojian on 14-7-31.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUTextView.h"
#import "QUKeyboardToolbar.h"
#import "QUAdaptor.h"
#import "QUSection.h"
#import "QUTableView.h"
#import "UITextView+APSUIControlTargetAction.h"

@implementation QUTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bInit=NO;
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    
    if(self.bInit==NO)
    {
        self.bInit=YES;
        QUSection* section=(QUSection*)[self superview];
        
        //        self.delegate=section.pAdaptor;
        [self addTarget:section.pAdaptor action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        
        [self addTarget:section.pAdaptor action:@selector(textFieldShouldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        
        [self addTarget:section.pAdaptor action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        
        //        self.delegate=self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QUTableSelectedCellNoticication:) name:QU_TABLE_CELL_SELECTED_NOTIFY object:nil];
        
        self.delegate=self;
    }
    [super layoutSubviews];
}



-(void)QUTableSelectedCellNoticication:(NSNotification*)notification{
    [self resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QU_TABLE_CELL_SELECTED_NOTIFY object:nil];
    
    QUSection* section=(QUSection*)[self superview];
    
    [self removeTarget:section.pAdaptor action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self removeTarget:section.pAdaptor action:@selector(textFieldShouldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self removeTarget:section.pAdaptor action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    QUSection* section=(QUSection*)[self superview];
   return  [section.pAdaptor textView:self shouldChangeTextInRange:range replacementText:text];
}

@end
