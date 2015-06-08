//
//  WpScrollView.h
//  WeiboPay
//
//  Created by Mark.Mu on 12-7-30.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WpScrollViewDelegate <NSObject>
@optional
- (void)wpScrollViewDelegateTap:(id)sender;
@end

@interface WpScrollView : UIScrollView

@property (nonatomic, weak) id<WpScrollViewDelegate> wpScrollViewDelegate;

@end
