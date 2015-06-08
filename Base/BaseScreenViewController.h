//
//  BaseScreenViewController.h
//  CaoPanBao
//
//  Created by QDS on 14-4-29.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "MyViewController.h"
#import "WpScrollView.h"

/**
 *  增加scollView
 *  增加触摸事件
 *  各种隐藏键盘
 */

@interface BaseScreenViewController : MyViewController <UIScrollViewDelegate, WpScrollViewDelegate>
{
    WpScrollView* backgroundScrollView; // 高度位417.0的背景ScrollView
    WpScrollView* backgroundScrollView2;// 高度不定的背景ScrollView
}

@end
