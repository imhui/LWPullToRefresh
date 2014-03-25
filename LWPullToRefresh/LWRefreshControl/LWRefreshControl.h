//
//  LWRefreshControl.h
//  LWTableView
//
//  Created by LiYonghui on 14-3-25.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LWRefreshControlState) {
    LWRefreshControlStateNormal = 0,
    LWRefreshControlStateRefresh,
};

@interface LWRefreshControl : UIControl

@property (nonatomic, readonly) LWRefreshControlState refreshControlState;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;
- (void)endRefreshing;

@end
