//
//  QUAdaptor.h
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QUAdaptorDelegate.h"
#import "MJRefresh/MJRefresh.h"

#import "QuickUI.h"

@class QUTableView;
@class QUSource;
@class QUKeyboardToolbar;
@class QUEntity;
@class QUSection;
@class QUNibHelper;
@class QUTextField;

@interface QUAdaptor : NSObject<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
//    QUKeyboardToolbar* toolbar;
}
@property(nonatomic,strong)QUSource* pSources;
@property(nonatomic,weak)QUTableView* pTableView;
@property(nonatomic,assign)id<QUAdaptorDelegate> delegate;
@property(nonatomic,strong)NSString* pNibName;
@property(nonatomic,strong)NSArray* pNibNameArray;
@property(nonatomic,strong)NSMutableDictionary* pSectionInfo;
@property(nonatomic,strong)MJRefreshHeaderView* refreshHeaderView;
@property(nonatomic,strong)MJRefreshFooterView* refreshFooterView;
@property(nonatomic,strong)QUNibHelper* pNibHelper;

/** 键盘是否已隐藏
 YES 显示状态
 NO  隐藏状态
 */
@property(nonatomic,assign)BOOL pKeyBoardVisible;

//@property(nonatomic,strong)QUKeyboardToolbar* pKeyboardToolbar;

-(void)bindSource:(QUSource *)sources andTableView:(QUTableView *)tableView nibName:(NSString*)nibName;

-(void)bindSource:(QUSource *)sources andTableView:(QUTableView *)tableView nibArray:(NSArray *)nibArray;

-(void)notifyChanged;

//-(QUKeyboardToolbar*)getKeyboardtoolbar;
-(void)setRefreshDelegateHeader:(id<MJRefreshBaseViewDelegate>)refreshDelegate;
-(void)setRefreshDelegateFooter:(id<MJRefreshBaseViewDelegate>)refreshDelegate;

+(instancetype)adaptor;

+(id)adaptorWithTableView:(QUTableView*)tableView nibArray:(NSArray*)array delegate:(id<QUAdaptorDelegate>)delegate;

#pragma mark - notify
-(void)postChangedWithEntity:(QUEntity *)entity;
-(void)postChangedWithEntity:(QUEntity *)entity section:(QUSection*)section;

#pragma mark - Helper
-(void)hideKeyboard;

-(void)scrollSectionToTop;

-(void)notifyChangedForSectionClass:(Class)cls;

-(void)notifyChangedForSectionClass:(Class)cls withTag:(NSNumber*)tag;

-(void)notifyChangedForSectionClass:(Class)cls withAnimation:(UITableViewRowAnimation)animation;

-(void)notifyChangedForSectionClass:(Class)cls withTag:(NSNumber*)tag withAnimation:(UITableViewRowAnimation)animation;

-(void)removeGestureRecognizer;

-(void)addGestureRecognizer:(UIView*)gestureView;

//-(void)restoreGestureRecognizer;


-(void)setSectionFrame:(CGRect)frame sectionClassName:(NSString*)sectionClassName;

#pragma mark - textview
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

#pragma mark - textFiled
//-(BOOL)textField:(QUTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

#define QU_TABLE_CELL_SELECTED_NOTIFY @"QU_TABLE_CELL_SELECTED_NOTIFY"

#define QU_TABLE_CELL_SELECTED_RELOAD_NOTIFY @"QU_TABLE_CELL_SELECTED_RELOAD_NOTIFY" // 重载单元格


