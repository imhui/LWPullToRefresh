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
    
    __weak typeof(_tableView) weakTableView = _tableView;
    [_tableView setPullToRefreshWithActionHandler:^{
        [weakTableView performSelector:@selector(endRefreshLoading) withObject:nil afterDelay:5];
    }];
    
    [_tableView setInfiniteScrollingWithActionHandler:^{
        [weakTableView performSelector:@selector(endInfiniteLoading) withObject:nil afterDelay:5];
    }];
}


- (void)buttonAction:(id)sender {
    BOOL hidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}



@end
