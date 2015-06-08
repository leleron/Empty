//
//  WpUpdateView.h
//  WeiboPay
//
//  Created by Mark.Mu on 12-9-14.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "BYDialog.h"

@protocol WpUpdateViewDelegate <NSObject>
- (void)wpUpdateViewDelegateYesButtonClick:(id)sender;
- (void)wpUpdateViewDelegateNoButtonClick:(id)sender;
- (void)wpUpdateViewDelegateConfirmButtonClick:(id)sender;
@end

@interface WpUpdateView : BYDialog

@property (nonatomic, assign) id<WpUpdateViewDelegate> delegate;
@property (nonatomic, strong) NSString* url;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UILabel *updateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

- (void)setControlStatus:(NSInteger)type;
- (IBAction)yesButtonClick:(id)sender;
- (IBAction)noButtonClick:(id)sender;
- (IBAction)confirmButtonClick:(id)sender;

@end
