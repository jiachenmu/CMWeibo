//
//  UITableView+CustomRefresh.m
//  CMWeibo
//
//  Created by jiachen on 16/5/31.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "UITableView+CustomRefresh.h"
#import "DateTools.h"

@implementation UITableView (CustomRefresh)

- (void)setCustomRefreshType {
    [self.pullToRefreshView setSubtitle:@"刷新查看更多" forState:SVPullToRefreshStateStopped];
    [self.pullToRefreshView setTitle:@"刷新中👀" forState:SVPullToRefreshStateLoading];
    [self.pullToRefreshView setTitle:@"刷刷刷刷🏃" forState:SVPullToRefreshStateTriggered];
    [self.pullToRefreshView setSubtitle:[NSString stringWithFormat:@"上次刷新时间：%@",[DateTools shareInstance].lastRefreshDateString] forState:SVPullToRefreshStateLoading];
}
@end
