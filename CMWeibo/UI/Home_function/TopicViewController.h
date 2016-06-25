//
//  TopicViewController.h
//  CMWeibo
//
//  Created by jiachen on 16/6/15.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  话题

/*
 tips：这里本来有原生的接口，但是由于应用未通过审核，需要高级权限，所以只能用拼接url的方法显示该页面了
 */

#import "CMBaseViewController.h"

@interface TopicViewController : CMBaseViewController

- (instancetype)initWithTopic:(NSString *)topic;

@end
