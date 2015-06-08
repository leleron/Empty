//
//  CPBRotateImageView.h
//  CaoPanBao
//
//  Created by zhuojian on 14-5-14.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBRotateImageView : UIImageView
{
    float angle;
    BOOL bRotate;
}

//@property(nonatomic,assign)BOOL isInit;

@property(nonatomic,assign)BOOL bVisible;

- (void)startAnimationRotate;

@end
