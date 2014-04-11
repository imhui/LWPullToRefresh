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
    [_tableView setPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(refreshDataList) withObject:nil afterDelay:5];
    }];
    
    [_tableView setInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:5];
    }];
    
    
    for (NSInteger i = 0; i < 20; i++) {
        [_dataList addObject:[NSDate date]];
    }
    
}


- (void)buttonAction:(id)sender {
    BOOL hidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
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
