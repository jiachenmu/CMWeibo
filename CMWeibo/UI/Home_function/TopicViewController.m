//
//  TopicViewController.m
//  CMWeibo
//
//  Created by jiachen on 16/6/15.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "TopicViewController.h"
#import "WeiboList.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "RepostViewController.h"
#import "CMBrowserViewController.h"

@interface TopicViewController()

@property (copy, nonatomic) NSString *topic;

@end

@implementation TopicViewController {
    UIWebView *showWebView;
}



- (instancetype)initWithTopic:(NSString *)topic
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = true;
        self.title = topic;
        self.topic = topic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self buildUI];
}

- (void)buildUI {
    showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    showWebView.scalesPageToFit = true;
    
    NSString *topic = [_topic substringWithRange:NSMakeRange(1, _topic.length - 2)];
    NSLog(@"查找的话题：%@",topic);
    NSString *topic_UTF8Encode = [topic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@",topic_UTF8Encode];
    NSLog(@"url :   %@",urlStr);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [showWebView loadRequest:urlRequest];
    [self.view addSubview:showWebView];
    
    
}


/*
 -  京城事    http://weibo.com/p/1008086e6ad9e42c4961408469310d03b9221c?k=%E4%BA%AC%E5%9F%8E%E4%BA%8B&from=501&_from_=huati_topic
 - 摇滚  http://weibo.com/p/100808a0516b8e3d78686eaccae26efe7ff57d?k=%E6%91%87%E6%BB%9A%E8%97%8F%E7%8D%92%E5%AE%9A%E6%A1%A37.8&from=501&_from_=huati_topic
 */
@end
