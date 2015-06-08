//
//  WpAlertViewCommon.h
//  WeiboPay
//
//  Created by Mark on 12-12-25.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WPALERTCOMMON_TYPE_ONE_BUTTON  0
#define WPALERTCOMMON_TYPE_TWO_BUTTON  1

@protocol WpAlertViewCommonDelegate <NSObject>
@optional
- (void)wpAlertViewDelegateYesButtonClick:(id)sender;
- (void)wpAlertViewDelegateNoButtonClick:(id)sender;
- (void)wpAlertViewDelegateConfirmButtonClick:(id)sender;
- (void)wpAlertViewDelegateYesButtonClick:(id)sender andPayload:(id)payload;



//QDS
- (void)wpAlertViewDelegateDidDismissYesButtonClick:(UIAlertView *)alertView;
@end

@interface WpAlertViewCommon : NSObject
{
    NSInteger _alertType;
}

@property (nonatomic, weak) id<WpAlertViewCommonDelegate> delegate;
@property (nonatomic, strong) UIAlertView* alertView;
@property (nonatomic, strong) id payload;

- (void)showAlertType:(NSInteger)type andText:(NSString*)message andTitle:(NSString*)title andYesButton:(NSString*)yesText_ andNoButton:(NSString*)noText_ andDelegate:(id)delegate_ andTag:(NSInteger)tag_;
+ (void)closeCurrentAlertView;
+ (BOOL)isShowAlertView;

@end

@interface WpAlertViewCommonCallback : NSObject
+(id)shareWPAlertViewCallback;
-(void)addAlertView:(UIAlertView*)alertView type:(NSInteger)type delegate:(id<WpAlertViewCommonDelegate>)delegate payload:(id)payload;
@property(nonatomic,strong)NSMutableDictionary* alertDict;
@end
