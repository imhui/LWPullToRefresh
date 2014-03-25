//
//  LWTableView.h
//  LWTableView
//
//  Created by LiYonghui on 14-3-25.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWRefreshControl;
@interface LWTableView : UITableView

@property (nonatomic, readonly) LWRefreshControl *refreshControl;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerPullToRefresh;
- (void)stopAnimating;

@end
