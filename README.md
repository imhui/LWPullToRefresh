LWPullToRefresh
===============

LWPullToRefresh


## Usage
```
__weak typeof(_tableView) weakTableView = _tableView;
[_tableView setPullToRefreshWithActionHandler:^{
	[weakTableView performSelector:@selector(endRefreshLoading) withObject:nil afterDelay:5];
}];
	
[_tableView setInfiniteScrollingWithActionHandler:^{
	[weakTableView performSelector:@selector(endInfiniteLoading) withObject:nil afterDelay:5];
}];


// programmatically trigger
[_tableView triggerPullToRefresh]
[_tableView triggerInfiniteScrolling]


// programmatically finish
[_tableView endRefreshLoading]
[_tableView endInfiniteLoading]


```