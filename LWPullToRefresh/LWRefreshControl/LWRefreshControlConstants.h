//
//  LWRefreshControlConstants.h
//  LWPullToRefresh
//
//  Created by LiYonghui on 14-10-16.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#ifndef LWPullToRefresh_LWRefreshControlConstants_h
#define LWPullToRefresh_LWRefreshControlConstants_h

typedef NS_ENUM(NSUInteger, LWPullToRefreshState) {
    LWPullToRefreshStateNormal = 0, // 正常状态
    LWPullToRefreshStateTriggered,  // 拖动距离到达可触发loading的状态
    LWPullToRefreshStateLoading,    // 加载状态
};


#endif
