//
//  WpAlertViewCommon.m
//  WeiboPay
//
//  Created by Mark on 12-12-25.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "WpAlertViewCommon.h"
#import "Constant.h"
static WpAlertViewCommon* currentAlertViewCommon = nil;

@implementation WpAlertViewCommon

@synthesize delegate;
@synthesize alertView;
@synthesize payload;

- (void)showAlertType:(NSInteger)type andText:(NSString*)message andTitle:(NSString*)title andYesButton:(NSString*)yesText_ andNoButton:(NSString*)noText_ andDelegate:(id)delegate_ andTag:(NSInteger)tag_
{
    _alertType = type;
    
    if (_alertType == WPALERTCOMMON_TYPE_ONE_BUTTON)
    {
        NSString* yesText = yesText_;
        if (yesText == nil) {
            yesText = NSLocalizedString(@"AlertView_ConfirmButton_Text", @"");
        }
        
        self.alertView = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:[WpAlertViewCommonCallback shareWPAlertViewCallback]
                          cancelButtonTitle:nil
                          otherButtonTitles:yesText, nil];
    }
    else
    {
        NSString* yesText = yesText_;
        NSString* noText = noText_;
        if (yesText == nil) {
            yesText = NSLocalizedString(@"AlertView_YesButton_Text", @"");
        }
        if (noText == nil) {
            noText = NSLocalizedString(@"AlertView_NoButton_Text", @"");
        }
        
        self.alertView = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:[WpAlertViewCommonCallback shareWPAlertViewCallback]
                          cancelButtonTitle:noText
                          otherButtonTitles:yesText, nil];
    }
    
    self.alertView.tag = tag_;
    self.delegate = delegate_;
    currentAlertViewCommon = self;
    
    [[WpAlertViewCommonCallback shareWPAlertViewCallback] addAlertView:self.alertView type:type delegate:delegate_ payload:self.payload];
    
    [alertView show];
}

+ (void)closeCurrentAlertView
{
    [currentAlertViewCommon.alertView dismissWithClickedButtonIndex:-1 animated:NO];
}

+ (BOOL)isShowAlertView
{
    if (currentAlertViewCommon)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
- (void)alertView:(UIAlertView *)alertView_ clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        if (_alertType == WPALERTCOMMON_TYPE_ONE_BUTTON)
        {
            if(!delegate)
            {
                WPNSLOG(@"%@",delegate);
            }
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateConfirmButtonClick:)])
            {
                [delegate wpAlertViewDelegateConfirmButtonClick:alertView];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateNoButtonClick:)])
            {
                [delegate wpAlertViewDelegateNoButtonClick:alertView];
            }
        }
    }
    else if (buttonIndex == 1)
    {
        if (_alertType == WPALERTCOMMON_TYPE_ONE_BUTTON)
        {
            
        }
        else
        {
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateYesButtonClick:)])
            {
                [delegate wpAlertViewDelegateYesButtonClick:alertView];
            }
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateYesButtonClick:andPayload:)])
            {
                [delegate wpAlertViewDelegateYesButtonClick:alertView andPayload:payload];
            }
        }
    }
    
    currentAlertViewCommon = nil;
}
*/
-(void)dealloc{
    // WPNSLOG(@"%@",self);
}

@end




@implementation WpAlertViewCommonCallback
static WpAlertViewCommonCallback* shareWpAlertViewCommonCallback;

+(id)shareWPAlertViewCallback{
    if(!shareWpAlertViewCommonCallback)
        shareWpAlertViewCommonCallback=[[WpAlertViewCommonCallback alloc] init];
    
    return shareWpAlertViewCommonCallback;
}

-(id)init{
    self=[super init];
    
    self.alertDict=[[NSMutableDictionary alloc] initWithCapacity:50];
    
    return self;
}


-(void)addAlertView:(UIAlertView*)alertView type:(NSInteger)type delegate:(id<WpAlertViewCommonDelegate>)delegate payload:(id)payload
{
    if(!payload)
        payload=[NSNull null];
    
    NSDictionary* dict=nil;
    
    if(delegate)
        dict=@{@"view": alertView,@"delegate":delegate,@"type":@(type),@"payload":payload};
    else
        dict=@{@"view": alertView,@"type":@(type),@"payload":payload};
    
    NSString* key=[NSString stringWithFormat:@"%ld",alertView.hash];
    [self.alertDict setObject:dict forKey:key];
}


-(void)remove:(NSString*)key{
    [self.alertDict removeObjectForKey:key];
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* key=[NSString stringWithFormat:@"%ld",alertView.hash];
    NSDictionary* dict=self.alertDict[key];
    
    id delegate=[dict objectForKey:@"delegate"];
    NSNumber* numberType=[dict objectForKey:@"type"];
    NSInteger _alertType=[numberType integerValue];
    id payload=[dict objectForKey:@"payload"];
    
    if([payload isKindOfClass:[NSNull class]])
        payload=nil;
    
    if (buttonIndex == 0)
    {
        if (_alertType == WPALERTCOMMON_TYPE_ONE_BUTTON)
        {
            if(!delegate)
            {
                // WPNSLOG(@"%@",delegate);
            }
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateConfirmButtonClick:)])
            {
                [delegate wpAlertViewDelegateConfirmButtonClick:alertView];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateNoButtonClick:)])
            {
                [delegate wpAlertViewDelegateNoButtonClick:alertView];
            }
        }
    }
    else if (buttonIndex == 1)
    {
        if (_alertType == WPALERTCOMMON_TYPE_ONE_BUTTON)
        {
            
        }
        else
        {
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateYesButtonClick:)])
            {
                [delegate wpAlertViewDelegateYesButtonClick:alertView];
            }
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateYesButtonClick:andPayload:)])
            {
                [delegate wpAlertViewDelegateYesButtonClick:alertView andPayload:payload];
            }
        }
    }
    
    
    
    //    currentAlertViewCommon = nil;
    //
    //    [self remove:key];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* key=[NSString stringWithFormat:@"%lu",(unsigned long)alertView.hash];
    NSDictionary* dict=self.alertDict[key];
    
    id delegate=[dict objectForKey:@"delegate"];
    NSNumber* numberType=[dict objectForKey:@"type"];
    NSInteger _alertType=[numberType integerValue];
    id payload=[dict objectForKey:@"payload"];
    
    if([payload isKindOfClass:[NSNull class]])
        payload=nil;
    
    
    if (buttonIndex == 0)
    {
        if (_alertType == WPALERTCOMMON_TYPE_ONE_BUTTON)
        {
            
        }
        else
        {
            
        }
    }
    else if (buttonIndex == 1)
    {
        if (_alertType == WPALERTCOMMON_TYPE_ONE_BUTTON)
        {
            
        }
        else
        {
            if ([delegate respondsToSelector:@selector(wpAlertViewDelegateDidDismissYesButtonClick:)])
            {
                [delegate wpAlertViewDelegateDidDismissYesButtonClick:alertView];
            }
        }
    }
    
    currentAlertViewCommon = nil;
    
    [self remove:key];
}


@end
