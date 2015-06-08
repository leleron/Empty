//
//  MJRefreshFooterView.m
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  上拉加载更多

#import "MJRefreshFooterView.h"
#import "MJRefreshConst.h"

@interface MJRefreshFooterView()
//{
//    BOOL _withoutIdle;
//}
{
    int _lastRefreshCount;
}
@end

@implementation MJRefreshFooterView

+ (instancetype)footer
{
    return [[MJRefreshFooterView alloc] init];
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        // 移除刷新时间
		[_lastUpdateTimeLabel removeFromSuperview];
        _lastUpdateTimeLabel = nil;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat h = frame.size.height;
    if (_statusLabel.center.y != h * 0.5) {
        CGFloat w = frame.size.width;
        _statusLabel.center = CGPointMake(w * 0.5, h * 0.5);
    }
}

#pragma mark - UIScrollView相关
#pragma mark 重写设置ScrollView
- (void)setScrollView:(UIScrollView *)scrollView
{
    // 1.移除以前的监听器
    [_scrollView removeObserver:self forKeyPath:MJRefreshContentSize context:nil];
    // 2.监听contentSize
    [scrollView addObserver:self forKeyPath:MJRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
    
    // 3.父类的方法
    [super setScrollView:scrollView];
    
    // 4.重新调整frame
    [self adjustFrame];
    
    // 5.调整标题栏
    [self updateRefreshLabelSize];
}

#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    if ([MJRefreshContentSize isEqualToString:keyPath]) {
        [self adjustFrame];
    }
}

#pragma mark 重写调整frame
- (void)adjustFrame
{
    // 内容的高度
    CGFloat contentHeight = _scrollView.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = _scrollView.frame.size.height - _scrollViewInitInset.top - _scrollViewInitInset.bottom;
    CGFloat y = MAX(contentHeight, scrollHeight);
    // 设置边框
    self.frame = CGRectMake(0, y, _scrollView.frame.size.width, MJRefreshViewHeight);
}

#pragma mark - 状态相关
#pragma mark 设置状态
- (void)setState:(MJRefreshState)state
{
    if (_state == state) return;
    MJRefreshState oldState = _state;
    
    [super setState:state];
    
	switch (state)
    {
		case MJRefreshStatePulling:
        {
            _statusLabel.text = MJRefreshFooterReleaseToRefresh;
            
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.bottom = _scrollViewInitInset.bottom;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case MJRefreshStateNormal:
        {
            _statusLabel.text = MJRefreshFooterPullToRefresh;
            
            // 刚刷新完毕
            CGFloat animDuration = MJRefreshAnimationDuration;
            CGFloat deltaH = [self contentBreakView];
            CGPoint tempOffset;
            
            int currentCount = [self totalDataCountInScrollView];
            if (MJRefreshStateRefreshing == oldState && deltaH > 0 && currentCount != _lastRefreshCount) {
                tempOffset = _scrollView.contentOffset;
                animDuration = 0;
            }
            
            [UIView animateWithDuration:animDuration animations:^{
                _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.bottom = _scrollViewInitInset.bottom;
                _scrollView.contentInset = inset;
            }];
            
            if (animDuration == 0) {
                _scrollView.contentOffset = tempOffset;
            }
			break;
        }
            
        case MJRefreshStateRefreshing:
        {
            // 记录刷新前的数量
            _lastRefreshCount = [self totalDataCountInScrollView];
            
            _statusLabel.text = MJRefreshFooterRefreshing;
            _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                UIEdgeInsets inset = _scrollView.contentInset;
                CGFloat bottom = MJRefreshViewHeight + _scrollViewInitInset.bottom;
                CGFloat deltaH = [self contentBreakView];
                if (deltaH < 0) { // 如果内容高度小于view的高度
                    bottom -= deltaH;
                }
                inset.bottom = bottom;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
        default:
            break;
	}
    
    [self updateRefreshLabelSize];
}

/** 更新刷新栏目 */
-(void)updateRefreshLabelSize{
    
//    [_arrowImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin];
//    [_statusLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    
    // 3.跳转状态栏文字坐标便宜
    CGRect mainFrame=[[[UIApplication sharedApplication] keyWindow] frame];
    [_statusLabel sizeToFit];
    CGRect frame=_statusLabel.frame;
    frame.origin.x=(mainFrame.size.width-_statusLabel.frame.size.width+_arrowImage.frame.size.width-10.f)/2.f;
    _statusLabel.frame=frame;
    
    // 4.跳转箭头坐标
    frame=_arrowImage.frame;
    frame.origin.x=_statusLabel.frame.origin.x-frame.size.width-5.f;
    _arrowImage.frame=frame;
    
    
    frame=_activityView.frame;
    frame.origin.x=_statusLabel.frame.origin.x-frame.size.width-5.f;
    _activityView.frame=frame;
    
    UIView* parentView=[_statusLabel superview];
//    WPNSLOG(@"parentview:%@",parentView);
//    WPNSLOG(@"subsview:%@",[parentView subviews]);

}

//- (void)endRefreshingWithoutIdle
//{
//    _withoutIdle = YES;
//    [self endRefreshing];
//    _withoutIdle = NO;
//}

#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)contentBreakView
{
    CGFloat h = _scrollView.frame.size.height - _scrollViewInitInset.bottom - _scrollViewInitInset.top;
    return _scrollView.contentSize.height - h;
}

#pragma mark - 在父类中用得上
// 合理的Y值(刚好看到上拉刷新控件时的contentOffset.y，取相反数)
- (CGFloat)validY
{
    CGFloat deltaH = [self contentBreakView];
    if (deltaH > 0) {
        return deltaH -_scrollViewInitInset.top;
    } else {
        return -_scrollViewInitInset.top;
    }
}

// view的类型
- (int)viewType
{
    return MJRefreshViewTypeFooter;
}

- (void)free
{
    [super free];
    [_scrollView removeObserver:self forKeyPath:MJRefreshContentSize];
}
@end