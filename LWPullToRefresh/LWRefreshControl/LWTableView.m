//
//  LWTableView.m
//  LWTableView
//
//  Created by LiYonghui on 14-3-25.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "LWTableView.h"
#import "LWRefreshControl.h"

typedef void(^LWRefreshActionHandler)();


@interface LWTableView () {
    LWRefreshControl *_refreshControl;
    NSMutableArray *_refreshActionBlocks;
}

@end

@implementation LWTableView


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _refreshControl = [[LWRefreshControl alloc] initWithScrollView:self];
        [_refreshControl addTarget:self action:@selector(refreshControlStateChanged:) forControlEvents:UIControlEventValueChanged];
        _refreshActionBlocks = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}


- (LWRefreshControl *)refreshControl {
    return _refreshControl;
}


- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [_refreshActionBlocks addObject:actionHandler];
}

- (void)refreshControlStateChanged:(id)sender {
    
    if (_refreshControl.refreshControlState == LWRefreshControlStateRefresh) {
        for (LWRefreshActionHandler actionHandler in _refreshActionBlocks) {
            actionHandler();
        }
    }
    
}

#pragma mark
- (void)triggerPullToRefresh {
    [_refreshControl beginRefreshing];
}

- (void)stopAnimating {
    [_refreshControl endRefreshing];
}

@end
