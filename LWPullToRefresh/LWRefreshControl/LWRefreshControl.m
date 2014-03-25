//
//  LWRefreshControl.m
//  LWTableView
//
//  Created by LiYonghui on 14-3-25.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "LWRefreshControl.h"
#import "LWTableView.h"


static const CGFloat kRefreshControlDefaultHeight = 70.0;
static const CGFloat kRefreshControlAnimateTimeInterval = 0.25;

@interface LWRefreshControl () {
    
    UIActivityIndicatorView *_indicatorView;
    UIScrollView *_scrollView;
    BOOL _isKVOWorked;
    
    LWRefreshControlState _refreshState;
}


@end


@implementation LWRefreshControl


- (void)dealloc
{
    [self removeScrollViewObserver];
}


- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
{
    self = [self initWithFrame:scrollView.bounds];
    if (self) {
        
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        [_scrollView sendSubviewToBack:self];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height = kRefreshControlDefaultHeight;
    self = [super initWithFrame:rect];
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor redColor];
        self.layer.borderWidth = 0.5;
        
        _refreshState = LWRefreshControlStateNormal;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        CGPoint indicatorCenter = _indicatorView.center;
        indicatorCenter.x = CGRectGetWidth(self.bounds) / 2.0;
        indicatorCenter.y = CGRectGetHeight(self.bounds) / 2.0;
        _indicatorView.center = indicatorCenter;
        [self addSubview:_indicatorView];
        [_indicatorView startAnimating];

    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [self addScrollViewObserver];
    [super willMoveToSuperview:newSuperview];
}


- (void)removeFromSuperview {
    
    [self removeScrollViewObserver];
    [super removeFromSuperview];
}


#pragma mark - Property
- (LWRefreshControlState)refreshControlState {
    return _refreshState;
}

#pragma mark
- (void)beginRefreshing {
    
    if (_refreshState == LWRefreshControlStateRefresh) {
        return;
    }
    
    if (!_scrollView.isDragging && _refreshState == LWRefreshControlStateNormal) {
        
        CGFloat realOffset = _scrollView.contentOffset.y + _scrollView.contentInset.top;
        if (realOffset <= -kRefreshControlDefaultHeight) {
            
            UIEdgeInsets insets = _scrollView.contentInset;
            insets.top += kRefreshControlDefaultHeight;
            _refreshState = LWRefreshControlStateRefresh;
            
            __weak typeof(_scrollView) weakScrollView = _scrollView;
            [UIView animateWithDuration:kRefreshControlAnimateTimeInterval delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakScrollView.contentInset = insets;
            } completion:^(BOOL finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }];
        }
        
    }
    
}


- (void)endRefreshing {
    
    if (_refreshState == LWRefreshControlStateNormal) {
        return;
    }
    
    UIEdgeInsets insets = _scrollView.contentInset;
    insets.top -= kRefreshControlDefaultHeight;
    _refreshState = LWRefreshControlStateNormal;
    
    __weak typeof(_scrollView) weakScrollView = _scrollView;
    [UIView animateWithDuration:kRefreshControlAnimateTimeInterval delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakScrollView.contentInset = insets;
    } completion:nil];
    
    
}



#pragma mark - KVO Method
- (void)addScrollViewObserver {
    
    if (_isKVOWorked) {
        return;
    }
    
    [_scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:NULL];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    
    _isKVOWorked = YES;
}

- (void)removeScrollViewObserver {
    
    if (!_isKVOWorked) {
        return;
    }
    
    [_scrollView removeObserver:self forKeyPath:@"contentInset" context:NULL];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
    
    _isKVOWorked = NO;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object != _scrollView) {
        return;
    }
    
    NSLog(@"key path: %@", keyPath);
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        NSLog(@"inset top: %f", _scrollView.contentInset.top);
    }
    else if ([keyPath isEqualToString:@"contentOffset"]) {
        //        NSLog(@"offset y: %f", _scrollView.contentOffset.y);
        
        [self adjustPosition];
    }
    
}

- (void)adjustPosition {
    
    //    NSLog(@"inset: %f, offset: %f", _scrollView.contentInset.top, _scrollView.contentOffset.y);
    
    CGRect rect = self.frame;
    if (_refreshState == LWRefreshControlStateNormal) {
        rect.origin.y = _scrollView.contentOffset.y + _scrollView.contentInset.top;
    }
    else {
        rect.origin.y = _scrollView.contentOffset.y + _scrollView.contentInset.top - kRefreshControlDefaultHeight;
    }
    
    self.frame = rect;
    
    [self beginRefreshing];
}


@end
