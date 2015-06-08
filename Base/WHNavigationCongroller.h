//
//  WHNavigationCongroller.h
//  翻页demo
//
//  Created by sunlight on 14-6-5.
//  Copyright (c) 2014年 chenhongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
//extern CGImageRef UIGetScreenImage();

@interface WHNavigationCongroller : UINavigationController<UINavigationControllerDelegate>

@property(nonatomic,strong)UIImageView *useImage;
@property(nonatomic,strong)UIView *useView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,assign)BOOL ispush;
-(id)initWithRootViewController:(UIViewController *)rootViewController;

@property(nonatomic,strong)UIViewController* pSavePrevController; // 保存上一个控制器

@end


@interface UINavigationController (PrevController)
- (void)restorePrevController;//自定义恢复上一级页面Controller

@end