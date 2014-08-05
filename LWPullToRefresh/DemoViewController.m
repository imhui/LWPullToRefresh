//
//  DemoViewController.m
//  LWRefreshControl
//
//  Created by LiYonghui on 14-3-25.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "DemoViewController.h"
#import "UIScrollView+LWPullToRefresh.h"

@interface DemoViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_dataList;
}

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(triggerToRefresh)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"LoadMore"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(triggerInfiniteScrolling)];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.bounds), 64)];
    headerView.backgroundColor = [UIColor yellowColor];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.tableHeaderView = headerView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = headerView.bounds;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [headerView addSubview:button];
    [button setTitle:@"Hit me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(_tableView)weakTableView = _tableView;
    [_tableView setPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(refreshDataList) withObject:nil afterDelay:5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableView setInfiniteLoading:YES];
        });
    }];
    
    [_tableView setInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableView setInfiniteLoading:NO];
        });
    }];
    
    
    for (NSInteger i = 0; i < 20; i++) {
        [_dataList addObject:[NSDate date]];
    }
    
}


- (void)buttonAction:(id)sender {
    BOOL hidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
}


- (void)triggerToRefresh {
    [_tableView triggerPullToRefresh];
    
}

- (void)triggerInfiniteScrolling {
    [_tableView triggerInfiniteScrolling];
}

- (void)refreshDataList {
    [_dataList insertObject:[NSDate date] atIndex:0];
    [_tableView reloadData];
    [_tableView endRefreshLoading];
}

- (void)loadMoreData {
    [_dataList addObject:[NSDate date]];
    [_tableView reloadData];
    [_tableView endInfiniteLoading];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [_dataList[indexPath.row] description];
    return cell;
}



@end
