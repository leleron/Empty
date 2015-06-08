//
//  QUButton.h
//  CaoPanBao
//
//  Created by zhuojian on 14-6-27.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QUButtonDelegate <NSObject>

@optional
-(void)QUButton:(UIButton*)button touchEvent:(UIControlEvents)event;

@end

@protocol QUBackgroundButtonDelegate <NSObject>
@end

@interface QUButton : UIButton
@end


@interface QUBackgroundButton : UIButton
@property(nonatomic,strong)UIImage* pBackgroundNormal;
@property(nonatomic,strong)UIImage* pBackgroundHighLight;

/** 更新图片状态 */
-(void)refreshImageState;

@property (nonatomic, weak) id<QUBackgroundButtonDelegate> pButtonDelegate;  // 已废弃

@end

@interface QUSwitchButton : UIButton
@property(nonatomic,strong)UIImage* pBackgroundNormal;
@property(nonatomic,strong)UIImage* pBackgroundSelected;
@property(nonatomic,assign)BOOL bChecked;

-(void)setChecked:(BOOL)checked;

@end

@interface QUImageButton : UIButton
@property(nonatomic,strong)UIImage* pBackgroundNormal;
@property(nonatomic,strong)UIImage* pBackgroundHighLight;
@end