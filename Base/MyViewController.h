//
//  MyViewController.h
//  CaoPanBao
//
//  Created by zhuojian on 14-4-18.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNoNetControllerDelegate.h"
#import "userValidate.h"
#import "SINavigationMenuView.h"

@class MyViewController;

@protocol MyViewControllerDelegate <NSObject>

@optional

-(void)MyViewControllerOnBack;

-(void)MyViewController:(MyViewController*)controller onRightButton:(id)sender;

@end

typedef enum
{
    kNav_Left_Button_Back = 1,      // 返回按钮
    kNav_Left_Button_Cancel = 2,    // 取消按钮
    kNav_Left_Button_None = 3       // 无
} NavLeftButtonType ;


@interface MyViewController : UIViewController<MyNoNetControllerDelegate,QUAdaptorDelegate,QUFlatSubmitSectionDelegate,userValidateOperation,QUMockDelegate,MJRefreshBaseViewDelegate>

@property(nonatomic,assign)id<MyViewControllerDelegate> delegate;

@property(nonatomic,assign)NavLeftButtonType leftButtonType;

@property (nonatomic, strong) NSString *navigationBarTitle;

@property(nonatomic,assign)BOOL isBackAction;

@property(nonatomic,strong)IBOutlet QUTableView* pTableView;

@property(nonatomic,strong)QUMock* mock;

@property(nonatomic,strong)QUAdaptor* pAdaptor;

-(IBAction)goBack:(id)sender;

/**nav title view*/
@property (nonatomic,strong) SINavigationMenuView *menuView;

+(instancetype)controller;

/** 点击TabBar触发的操作 */
- (void) clickTabBarItem;

/** 设置nav title */
- (void) setNavigationTitle;

/**
 * 自定义左边返回按钮
 * @param normalImageName 默认的按钮背景图
 * @param highLightImageName 高亮时显示的按钮背景图
 * @param tagSelector 触发按钮执行的方法
 */
-(void)showLeftNormalButton:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector;

/**
 * 自定义右边功能按钮
 * @param normalImageName 默认的按钮背景图
 * @param highLightImageName 高亮时显示的按钮背景图
 * @param tagSelector 触发按钮执行的方法
 */
-(void)showRightButtonNormalImage:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector;


/**
 * 自定义右边功能按钮
 * @param normalImageName 默认的按钮背景图
 * @param highLightImageName 高亮时显示的按钮背景图
 * @param tagSelector 触发按钮执行的方法
 * @param beTintColor yes支持高亮,no 非高亮
 */
-(void)showRightButtonNormalImage:(NSString *)normalImageName highLightImage:(NSString*)highLightImageName selector:(SEL)tagSelector beTintColor:(BOOL)beTintColor;

/**
 * 根据文字自定义右边功能按钮
 * @param title button title
 * @param tagSelector 触发按钮执行的方法
 */
-(void)showRightButtonTitle:(NSString *)title andSelector:(SEL)tagSelector;

/**
 * 根据文字自定义左边功能按钮
 * @param title button title
 * @param tagSelector 触发按钮执行的方法
 */
-(void)showLeftButtonTitle:(NSString*)title;

/**
 *  设置navgation多个tetle
 *
 *  @param itmes      需要展示的子标题item
 *  @param controller 展示的控制器
 */
- (void)displayNavigationTitleItmes:(NSArray *)itmes withController:(MyViewController *)controller;


#pragma mark - QuickUI - LifeCycle

-(void)initQuickUI;

-(void)initQuickMock;

- (void)viewWillAppearTodoSomeThing;
- (void)viewDidDisappearTodoSomeThing;

@end



