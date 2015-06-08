//
//  QUTextField.m
//  WeiPay
//
//  Created by zhuojian on 14-3-28.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "QUTextField.h"
#import "QUKeyboardToolbar.h"
#import "QUAdaptor.h"
#import "QUSection.h"
#import "QUTableView.h"


@implementation QUTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.delegate=self;
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
        
        if([section isKindOfClass:[QUSection class]])
        {
        [self addTarget:section.pAdaptor action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        
        [self addTarget:section.pAdaptor action:@selector(textFieldShouldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        
        [self addTarget:section.pAdaptor action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QUTableSelectedCellNoticication:) name:QU_TABLE_CELL_SELECTED_NOTIFY object:nil];

    }
    [super layoutSubviews];
}


-(void)QUTableSelectedCellNoticication:(NSNotification*)notification{
    [self resignFirstResponder];
}

-(void)dealloc{
    
    QUSection* section=(QUSection*)[self superview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QU_TABLE_CELL_SELECTED_NOTIFY object:nil];

    if([section isKindOfClass:[QUSection class]])
    {

    [self removeTarget:section.pAdaptor action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self removeTarget:section.pAdaptor action:@selector(textFieldShouldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self removeTarget:section.pAdaptor action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
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
