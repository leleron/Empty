//
//  WHNavigationCongroller.h
//  翻页demo
//
//  Created by sunlight on 14-6-5.
//  Copyright (c) 2014年 chenhongwei. All rights reserved.
//

#import "WHNavigationCongroller.h"




@interface WHNavigationCongroller ()
@property(nonatomic,assign)BOOL supportAnimation;
@end

@implementation WHNavigationCongroller
@synthesize ispush,useImage,useView,topView;

#pragma mark - 重写initWithRootViewController方法
-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self=[super initWithRootViewController:rootViewController];
    
    self.delegate=self;
    
    
    
    return self;
}

#pragma mark - 重写push方法

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(![viewController isMemberOfClass:[MyNoNetController class]]) // 特殊处理，不记录存档
    {
        self.pSavePrevController=viewController;
    }
    
    MyNoNetController* noNetController=[MyNoNetController controllerWithTargetController:viewController];
    
    self.supportAnimation = animated;
    if (animated) {
        ispush=YES;
        [self initImage];
        [self getBackImage];
    }
    
    if(noNetController)
        [super pushViewController:noNetController animated:NO];
    else
        [super pushViewController:viewController animated:NO];
}

#pragma mark - 重写pop方法
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.supportAnimation = animated;
    
    if (animated) {
        ispush=NO;
        [self initImage];
        [self getBackImage];
    }
    return [super popViewControllerAnimated:NO];
}




#pragma mark - 重写pop方法3
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.supportAnimation = animated;
    if (animated) {
        ispush=NO;
        [self initImage];
        [self getBackImage];
    }
    [super popToViewController:viewController animated:NO];
    
    return self.viewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - navigationController代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
     if (!self.supportAnimation)
         return;
         
    CGSize size=CGSizeMake(320, kCurrentDeciceHeight);
    float scaleWidth = (size.width - 50)/size.width;
    float scaleHeight = (size.height - 50)/size.height;
    
    //在push的状态下
    if (ispush)
    {
        NSArray *viewArray=[navigationController viewControllers];
        
        if (viewArray.count>=2)
        {
            //添加将要消失的图片
            [navigationController.view.superview insertSubview:useView belowSubview:navigationController.view];
            
            //新的control 的起始位置
            [navigationController.view setFrame:CGRectMake(size.width, 0, size.width, size.height)];
            
            //动画
            [UIView animateWithDuration:0.4 animations:^{
                
                useView.transform = CGAffineTransformMakeScale(scaleWidth,scaleHeight);
                
                [useView setFrame:CGRectMake(25, 25, size.width - 50, size.height - 50)];
                
                [navigationController.view setFrame:CGRectMake(0, 0, size.width, size.height)];
                
            } completion:^(BOOL finished) {
                
                if (finished)
                {
                    [useView removeFromSuperview];
                }
            }];
        }
    }
    else
    {
        navigationController.view.transform = CGAffineTransformMakeScale(scaleWidth,scaleHeight);
        
        [navigationController.view setFrame:CGRectMake(25, 25, size.width - 50, size.height - 50)];
        
        [navigationController.view.superview insertSubview:useView aboveSubview:navigationController.view];
        
        //动画
        [UIView animateWithDuration:0.4 animations:^{
            
            [useView setFrame:CGRectMake(size.width, 0, size.width, size.height)];
            
            navigationController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
            [navigationController.view setFrame:CGRectMake(0, 0, size.width, size.height)];
            
        } completion:^(BOOL finished) {
            if (finished)
            {
                [useView removeFromSuperview];
            }
        }];
    }
    
}

- (UIImage *)getScreenImage {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kCurrentDeviceWidth*2, kCurrentDeciceHeight*2), YES, 0);
    
    //设置截屏大小
    
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    
    CGRect rect = CGRectMake(0, 0, kCurrentDeviceWidth*2, kCurrentDeciceHeight*2);//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *returnImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    CGImageRelease(imageRefRect);
    
    return returnImage;
    
}


#pragma mark - 截图
-(void)getBackImage
{
    //    CGImageRef cgScreen = UIGetScreenImage();
    //    CGRect rect = CGRectMake(0,30, 320*2, kCurrentDeciceHeight*2);//创建要剪切的矩形框
    //    CGImageRef cgimage=CGImageCreateWithImageInRect(cgScreen, rect);
    //    //CGImageRelease(cgScreen);
    //    UIImage *res = [UIImage imageWithCGImage:cgimage];
    //    CGImageRelease(cgimage);
    
    [useImage setImage:[self getScreenImage]];
}

#pragma mark - 初始化图片背景
-(void)initImage{
    useView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kCurrentDeciceHeight)];
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    if (IOS7_OR_LATER) {
        topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bar_bg"]];
    }
    else{
        topView.backgroundColor = [UIColor blackColor];
    }
    [useView addSubview:topView];
    
    useImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, kCurrentDeciceHeight)];
    [useView addSubview:useImage];
}

@end

@implementation UINavigationController (PrevController)
#pragma mark - 自定义恢复上一级页面Controller
- (void)restorePrevController
{
    [self popViewControllerAnimated:YES];
    
    WHNavigationCongroller* navigation=(WHNavigationCongroller*)self;
    
    [self pushViewController:navigation.pSavePrevController animated:NO];
}

@end
