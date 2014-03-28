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
 *  添加一个下拉刷新的操作block
 *
 *  @param actionHandler 调用的block
 */
- (void)setPullToRefreshWithActionHandler:(void (^)(void))actionHandler;


/**
 *  添加一个上拉加载更多的操作block
 *
 *  @param actionHandler 调用的block
 */
- (void)setInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;

/**
 *  结束下拉刷新操作
 */
- (void)endRefreshLoading;

/**
 *  结束上拉加载操作
 */
- (void)endInfiniteLoading;


@end
