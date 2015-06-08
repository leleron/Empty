//
//  WpPickerView.m
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-17.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "WpPickerView.h"

static WpPickerView* currentWeiboPayPickerView = nil;

@implementation WpPickerView

@synthesize delegate;
@synthesize myPickerView;

- (void)loadContentView
{
    [[NSBundle mainBundle] loadNibNamed:@"WpPickerView" 
                                  owner:self
                                options:nil]; 
    
}

- (void)willPresentDialog
{
    [super willPresentDialog];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setMyPickerViewDelegate:(id)_delegate andDefaultSelect:(NSInteger)index
{
    myPickerView.delegate = _delegate;
    myPickerView.dataSource = _delegate;
    self.delegate = _delegate;
    [myPickerView selectRow:index inComponent:0 animated:NO];
    
    currentWeiboPayPickerView = self;
}

- (void)setMyPickerViewDelegate:(id)_delegate andDefaultSelectList:(NSArray*)indexList
{
    myPickerView.delegate = _delegate;
    myPickerView.dataSource = _delegate;
    self.delegate = _delegate;
    
    for (int component = 0; component < [indexList count]; ++component)
    {
        [myPickerView selectRow:[[indexList objectAtIndex:component] intValue] inComponent:component animated:NO];
    }
    
    currentWeiboPayPickerView = self;
}

- (IBAction)confirmButton2Click:(id)sender 
{
    [self dismissAnimated:NO];
    [delegate wpPickerViewDelegateConfirmButtonClick:myPickerView];
    
    currentWeiboPayPickerView = nil;
}

+ (void)closeCurrentPickerView
{
    if (currentWeiboPayPickerView)
    {
        [currentWeiboPayPickerView dismissAnimated:NO];
        currentWeiboPayPickerView = nil;
    }
}

@end
