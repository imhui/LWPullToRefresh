//
//  UIScrollView+LWPullToRefresh.h
//  LWPullToRefresh
//
//  Created by LiYonghui on 14-3-28.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWRefreshControl;

@interface UIScrollView (LWPullToRefresh)

@property (nonatomic, strong, readonly) LWRefreshControl *refreshControl;
@property (nonatomic, strong, readonly) LWRefreshControl *infiniteControl;


/**
 *  设置一个下拉刷新的操作block
 *
 *  @param actionHandler 调用的block
 */
- (void)setPullToRefreshWithActionHandler:(void (^)(void))actionHandler;


/**
 *  设置一个上拉加载更多的操作block
 *
 *  @param actionHandler 调用的block
 */
- (void)setInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;


/**
 *  取消下拉刷新的操作
 */
- (void)removePullToRefreshActionHandler;

/**
 *  取消上拉加载更多的操作
 */
- (void)removeInfiniteScrollingActionHandler;


/**
 *  触发下拉刷新操作
 */
- (void)triggerPullToRefresh;


/**
 *  触发上拉加载操作
 */
- (void)triggerInfiniteScrolling;


/**
 *  结束下拉刷新操作
 */
- (void)endRefreshLoading;

/**
 *  结束上拉加载操作
 */
- (void)endInfiniteLoading;

/**
 *  设置下拉刷新控件是否起作用
 */
- (void)setPullToRefreshEnable:(BOOL)enable;

/**
 *  设置上拉加载更多控件是否起作用
 */
- (void)setInfiniteLoadingEnable:(BOOL)enable;


@end
