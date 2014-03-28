//
//  LWRefreshControl.h
//  LWRefreshControl
//
//  Created by LiYonghui on 14-3-25.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LWPullToRefreshState) {
    LWPullToRefreshStateNormal = 0, // 正常状态
    LWPullToRefreshStateTriggered,  // 拖动距离到达可触发loading的状态
    LWPullToRefreshStateLoading,    // 加载状态
};

typedef NS_ENUM(NSUInteger, LWPullToRefreshPosition) {
    LWPullToRefreshPositionTop = 0, // ScrollView顶部，下拉刷新
    LWPullToRefreshPositionBottom   // ScrollView底部，上拉加载更多
};

typedef void(^LWRefreshControlActionHandler)();


/**
 *  UIScrollView 下拉刷新/上拉加载更多控件
 */
@interface LWRefreshControl : UIControl


/**
 *  处理触发加载状态后回调block
 */
@property (nonatomic, strong) LWRefreshControlActionHandler actionHandler;

/**
 *  初始化操作
 *
 *  @param scrollView 指定的scrollView
 *  @param position   位置
 *
 *  @return 返回一个LWRefreshControl对象
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView position:(LWPullToRefreshPosition)position;

/**
 *  触发拖动刷新/加载更多操作
 */
- (void)triggerPullToLoading;

/**
 *  结束刷新/加载操作
 */
- (void)endLoading;


/**
 *  设置不同状态下的标题文字
 *
 *  @param title 标题
 *  @param state 状态
 */
- (void)setTitle:(NSString *)title forState:(LWPullToRefreshState)state;

/**
 *  设置不同状态下的副标题文字
 *
 *  @param subtitle 副标题
 *  @param state    状态
 */
- (void)setSubtitle:(NSString *)subtitle forState:(LWPullToRefreshState)state;


@end
