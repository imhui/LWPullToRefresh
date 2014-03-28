//
//  UIScrollView+LWPullToRefresh.m
//  LWPullToRefresh
//
//  Created by LiYonghui on 14-3-28.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "UIScrollView+LWPullToRefresh.h"
#import "LWRefreshControl.h"
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshControl;
static char UIScrollViewPullInfiniteControl;


@implementation UIScrollView (LWPullToRefresh)
@dynamic refreshControl;
@dynamic infiniteControl;


#pragma mark
- (void)setPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    
    if (self.refreshControl == nil) {
        LWRefreshControl *refreshControl = [[LWRefreshControl alloc] initWithScrollView:self position:LWPullToRefreshPositionTop];
        self.refreshControl = refreshControl;
    }
    self.refreshControl.actionHandler = actionHandler;
}

- (void)setInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    
    if (self.infiniteControl == nil) {
        LWRefreshControl *refreshControl = [[LWRefreshControl alloc] initWithScrollView:self position:LWPullToRefreshPositionBottom];
        self.infiniteControl = refreshControl;
    }
    self.infiniteControl.actionHandler = actionHandler;
}

- (void)removePullToRefreshActionHandler {
    if (self.refreshControl != nil) {
        self.refreshControl.actionHandler = nil;
    }
    self.refreshControl = nil;
}

- (void)removeInfiniteScrollingActionHandler {
    
    if (self.infiniteControl != nil) {
        self.infiniteControl.actionHandler = nil;
    }
    self.infiniteControl = nil;
}


- (void)endRefreshLoading {
    [self.refreshControl endLoading];
}

- (void)endInfiniteLoading {
    [self.infiniteControl endLoading];
}



#pragma mark - Property
- (void)setRefreshControl:(LWRefreshControl *)refreshControl {
    [self willChangeValueForKey:@"LWPullToRefreshControl"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshControl, refreshControl, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LWPullToRefreshControl"];
}

- (LWRefreshControl *)refreshControl {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshControl);
}

- (void)setInfiniteControl:(LWRefreshControl *)infiniteControl {
    [self willChangeValueForKey:@"LWInfiniteControl"];
    objc_setAssociatedObject(self, &UIScrollViewPullInfiniteControl, infiniteControl, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LWInfiniteControl"];
}

- (LWRefreshControl *)infiniteControl {
    return objc_getAssociatedObject(self, &UIScrollViewPullInfiniteControl);
}



@end
