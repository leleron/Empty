//
//  WpPickerView.h
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-17.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "BYDialog.h"

@protocol WpPickerViewDelegate <NSObject>
- (void)wpPickerViewDelegateConfirmButtonClick:(UIPickerView*)pickerView;
@end

@interface WpPickerView : BYDialog

@property (nonatomic, weak) id<WpPickerViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

- (void)setMyPickerViewDelegate:(id)_delegate andDefaultSelect:(NSInteger)index;
- (void)setMyPickerViewDelegate:(id)_delegate andDefaultSelectList:(NSArray*)indexList;
- (IBAction)confirmButton2Click:(id)sender;
+ (void)closeCurrentPickerView;

@end
