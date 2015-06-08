//
//  WHSegmentView.h
//  CaoPanBao
//
//  Created by 陈宏伟 on 14-7-4.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHSegmentView;
@protocol WHSegmentViewDelegate <NSObject>

-(void)changeCustomSegmentSelectIndex:(NSInteger) index OnSegment:(WHSegmentView *)segment;

@end


@interface WHSegmentView : UIView
@property(nonatomic,assign)id<WHSegmentViewDelegate> delegate;
//初始化
- (id)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArray;
@end
