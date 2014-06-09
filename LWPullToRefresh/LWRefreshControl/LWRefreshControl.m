//
//  LWRefreshControl.m
//  LWRefreshControl
//
//  Created by LiYonghui on 14-3-25.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "LWRefreshControl.h"


#pragma mark - LWRefreshControlIndicatorView
/**
 *  下拉刷新控件指示器
 */
@interface LWRefreshControlIndicatorView : UIView {
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}

/**
 *  轨迹颜色
 */
@property (nonatomic, strong) UIColor *trackColor;
/**
 *  进度颜色
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 *  进度值，0.0 ~ 1.0
 */
@property (nonatomic) CGFloat progress;

/**
 *  进度条线宽
 */
@property (nonatomic) CGFloat progressLineWidth;

/**
 *  开始旋转
 */
- (void)startAnimating;

/**
 *  停止旋转
 */
- (void)stopAnimating;

@end

@implementation LWRefreshControlIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        _trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;
        
        _progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;
        
        self.progressLineWidth = 2;
        self.progress = 0.0;
    }
    return self;
}

- (void)setTrack
{
    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0) radius:(self.bounds.size.width - _progressLineWidth)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress
{
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0) radius:(self.bounds.size.width - _progressLineWidth)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
}


- (void)setProgressLineWidth:(float)progressWidth
{
    _progressLineWidth = progressWidth;
    _trackLayer.lineWidth = _progressLineWidth;
    _progressLayer.lineWidth = _progressLineWidth;
    
    [self setTrack];
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setProgress];
}


#pragma mark
- (void)startAnimating {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform" ];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0) ];
    rotationAnimation.duration = .3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSNotFound;
    [_progressLayer addAnimation:rotationAnimation forKey:@"360RotationAnimation"];
    
}

- (void)stopAnimating {
    
    [_progressLayer removeAnimationForKey:@"360RotationAnimation"];
}

@end


#pragma mark - LWRefreshControl
static const CGFloat kTriggerLoadingDefaultHeight = 80.0;

@interface LWRefreshControl () {
    
    BOOL _isKVORegistered;
    UIScrollView *_scrollView;
    
    LWRefreshControlIndicatorView *_indicatorView;
    
    UILabel *_textLabel;
    UILabel *_detailTextLabel;
    
    
    LWPullToRefreshState _refreshState;
    LWPullToRefreshPosition _position;
    
}

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *subtitles;


@end


@implementation LWRefreshControl


- (void)dealloc
{
    [self removeScrollViewObserver];
}


- (instancetype)initWithScrollView:(UIScrollView *)scrollView position:(LWPullToRefreshPosition)position
{
    NSAssert([scrollView isKindOfClass:[UIScrollView class]], NSLocalizedString(@"scrollView must be a instance of <UIScrollView>", nil));
    
    self = [self initWithFrame:scrollView.bounds];
    if (self) {
        
        _scrollView = scrollView;
        [_scrollView addSubview:self];
        [_scrollView sendSubviewToBack:self];
        
        _position = position;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.size.height = kTriggerLoadingDefaultHeight;
    self = [super initWithFrame:rect];
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshState = LWPullToRefreshStateNormal;
        
        self.titles = [@[NSLocalizedString(@"Pull to refresh...",), NSLocalizedString(@"Release to refresh...",), NSLocalizedString(@"Loading...",)] mutableCopy];
        self.subtitles = [@[@"", @"", @""] mutableCopy];
        
        [self initIndicatorView];
        [self initTitleLables];
    }
    return self;
}


- (void)initIndicatorView {
    
    if (_indicatorView != nil) {
        return;
    }
    
    CGRect rect = self.bounds;
    rect.size = CGSizeMake(20.0, 20.0);
    rect.origin.x = 20;
    rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2.0;
    
    _indicatorView = [[LWRefreshControlIndicatorView alloc] initWithFrame:rect];
    _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_indicatorView];
    _indicatorView.trackColor = [UIColor clearColor];
    _indicatorView.progressColor = [UIColor grayColor];
    _indicatorView.progress = 0.0;
    _indicatorView.progressLineWidth = 2;
    
}

- (void)initTitleLables {
    
    CGRect rect = CGRectZero;
    rect.origin.x = CGRectGetMaxX(_indicatorView.frame) + 10;
    rect.origin.y = CGRectGetMinY(_indicatorView.frame);
    rect.size.width = CGRectGetWidth(self.bounds) - CGRectGetMaxX(rect) - 10;
    rect.size.height = CGRectGetHeight(_indicatorView.frame);
    _textLabel = [[UILabel alloc] initWithFrame:rect];
    _textLabel.textColor = [UIColor grayColor];
    _textLabel.font = [UIFont systemFontOfSize:18];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.text = self.titles[LWPullToRefreshStateNormal];
    [self addSubview:_textLabel];
    
    rect.origin.y = CGRectGetMaxY(rect) + 5;
    rect.size.height = 14;
    _detailTextLabel = [[UILabel alloc] initWithFrame:rect];
    _detailTextLabel.textColor = [UIColor lightGrayColor];
    _detailTextLabel.font = [UIFont systemFontOfSize:12];
    _detailTextLabel.textAlignment = NSTextAlignmentLeft;
    _detailTextLabel.text = self.subtitles[LWPullToRefreshStateNormal];
    [self addSubview:_detailTextLabel];
    
    
}


#pragma mark
- (void)setTitlesWhenRefreshStateChanged {
    
    _textLabel.text = self.titles[_refreshState];
    _detailTextLabel.text = self.subtitles[_refreshState];
    
}

- (void)setTitle:(NSString *)title forState:(LWPullToRefreshState)state {
    self.titles[state] = title;
}

- (void)setSubtitle:(NSString *)subtitle forState:(LWPullToRefreshState)state {
    self.subtitles[state] = subtitle;
}


#pragma mark - Property
- (LWPullToRefreshState)refreshControlState {
    return _refreshState;
}

#pragma mark 
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [self registerScrollViewObserver];
    [super willMoveToSuperview:newSuperview];
}


- (void)removeFromSuperview {
    
    [self removeScrollViewObserver];
    [super removeFromSuperview];
}


#pragma mark - KVO Method
- (void)registerScrollViewObserver {
    
    if (_isKVORegistered) {
        return;
    }
    
    [_scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:NULL];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    [_scrollView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:NULL];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    
    _isKVORegistered = YES;
}

- (void)removeScrollViewObserver {
    
    if (!_isKVORegistered) {
        return;
    }
    
    [_scrollView removeObserver:self forKeyPath:@"contentInset" context:NULL];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
    [_scrollView removeObserver:self forKeyPath:@"pan.state" context:NULL];
    [_scrollView removeObserver:self forKeyPath:@"contentSize" context:NULL];
    
    _isKVORegistered = NO;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object != _scrollView) {
        return;
    }
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        [self scrollViewDidScroll];
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll];
    }
    else if ([keyPath isEqualToString:@"pan.state"]) {
        [self scrollViewPanGestureRecognizerStateChanged];
    }
    else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeChanged];
    }
    
}


#pragma mark
- (void)scrollViewContentSizeChanged {
    
    if (_position == LWPullToRefreshPositionBottom) {
        self.enabled = (_scrollView.contentSize.height + _scrollView.contentInset.top) >= CGRectGetHeight(_scrollView.bounds);
        self.hidden = !self.enabled;
    }
    
}

- (void)scrollViewDidScroll {

    if (!self.enabled) {
        return;
    }
    
    CGRect rect = self.frame;
    
    if (_position == LWPullToRefreshPositionTop) {
        if (_refreshState == LWPullToRefreshStateLoading) {
            rect.origin.y = _scrollView.contentOffset.y + _scrollView.contentInset.top - kTriggerLoadingDefaultHeight;
        }
        else {
            rect.origin.y = _scrollView.contentOffset.y + _scrollView.contentInset.top;
        }
    }
    else {
        rect.origin.y = _scrollView.contentSize.height;
    }
    
    self.frame = rect;
    
    
    if (_position == LWPullToRefreshPositionTop) {
        if (_refreshState != LWPullToRefreshStateLoading) {
            CGFloat realOffset = _scrollView.contentOffset.y + _scrollView.contentInset.top;
            [self updateIndicatorProgressWithOffset:realOffset];
            _refreshState = (realOffset <= -kTriggerLoadingDefaultHeight) ? LWPullToRefreshStateTriggered : LWPullToRefreshStateNormal;
        }
    }
    else {
        if (_refreshState != LWPullToRefreshStateLoading) {
            CGFloat realOffset = _scrollView.contentOffset.y + CGRectGetHeight(_scrollView.bounds) - _scrollView.contentSize.height - _scrollView.contentInset.bottom;
            [self updateIndicatorProgressWithOffset:realOffset];
            _refreshState = (realOffset > kTriggerLoadingDefaultHeight) ? LWPullToRefreshStateTriggered : LWPullToRefreshStateNormal;
                
        }
    }
    
    [self setTitlesWhenRefreshStateChanged];
}

- (void)scrollViewPanGestureRecognizerStateChanged {
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self pullToLoading];
    }
}

- (void)updateIndicatorProgressWithOffset:(CGFloat)offset {
    
    CGFloat progress = ABS(offset) / kTriggerLoadingDefaultHeight;
    progress = progress >= 0.96 ? 0.96 : progress;
    if (_position == LWPullToRefreshPositionTop) {
        _indicatorView.progress = offset <= 0 ? progress : 0;
        
        CGFloat alpha = offset / kTriggerLoadingDefaultHeight;
        alpha = alpha <= 0 ? ABS(alpha) : 0;
        alpha = alpha >= 1 ? 1 : alpha;
        self.alpha = alpha;
        
    }
    else {
        _indicatorView.progress = progress;
    }
}



#pragma mark
- (void)triggerPullToLoading {
    
    if (_refreshState == LWPullToRefreshStateLoading) {
        return;
    }
    
    CGPoint offset = _scrollView.contentOffset;
    if (_position == LWPullToRefreshPositionTop) {
        offset.y = -_scrollView.contentInset.top - kTriggerLoadingDefaultHeight;
    }
    else {
        offset.y = _scrollView.contentSize.height - CGRectGetHeight(_scrollView.bounds) + kTriggerLoadingDefaultHeight;
    }
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                     animations:^{
                         _scrollView.contentOffset = offset;
                     } completion:^(BOOL finished) {
                         [self pullToLoading];
                     }];
}


- (void)pullToLoading {
    
    if (!self.enabled) {
        return;
    }
    
    if (_refreshState != LWPullToRefreshStateLoading) {
        
        if (_position == LWPullToRefreshPositionTop) {
            
            CGFloat realOffset = _scrollView.contentOffset.y + _scrollView.contentInset.top;
            if (realOffset <= -kTriggerLoadingDefaultHeight) {
                
                UIEdgeInsets insets = _scrollView.contentInset;
                insets.top += kTriggerLoadingDefaultHeight;
                _refreshState = LWPullToRefreshStateLoading;
                
                [self setTitlesWhenRefreshStateChanged];
                __weak typeof(_scrollView) weakScrollView = _scrollView;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    weakScrollView.contentInset = insets;
                } completion:^(BOOL finished) {
                    [_indicatorView startAnimating];
                    [weakSelf triggerEventValueChanged];
                }];
            }
            
        }
        else {
            
            CGFloat realOffset = _scrollView.contentOffset.y + CGRectGetHeight(_scrollView.bounds) - _scrollView.contentSize.height;
            if (realOffset >= kTriggerLoadingDefaultHeight) {
                
                UIEdgeInsets insets = _scrollView.contentInset;
                insets.bottom += kTriggerLoadingDefaultHeight;
                _refreshState = LWPullToRefreshStateLoading;
                
                __weak typeof(_scrollView) weakScrollView = _scrollView;
                __weak typeof(self) weakSelf = self;
                [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    weakScrollView.contentInset = insets;
                } completion:^(BOOL finished) {
                    [_indicatorView startAnimating];
                    [weakSelf triggerEventValueChanged];
                }];
                
            }
        }
    }
    
}


- (void)endLoading {
    
    if (_refreshState != LWPullToRefreshStateLoading) {
        return;
    }
    
    UIEdgeInsets insets = _scrollView.contentInset;
    if (_position == LWPullToRefreshPositionTop) {
        insets.top -= kTriggerLoadingDefaultHeight;
    }
    else {
        insets.bottom -= kTriggerLoadingDefaultHeight;
    }
    
    _refreshState = LWPullToRefreshStateNormal;
    
    __weak typeof(_scrollView) weakScrollView = _scrollView;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakScrollView.contentInset = insets;
        [_indicatorView stopAnimating];
    } completion:^(BOOL finished) {
        
    }];
    
    
}


- (void)triggerEventValueChanged {
    if (self.actionHandler) {
        self.actionHandler();
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


@end

