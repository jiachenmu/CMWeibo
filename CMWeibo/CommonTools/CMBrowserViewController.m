//
//  CMBrowserViewController.m
//  CMWeibo
//
//  Created by jiachen on 16/6/15.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMBrowserViewController.h"

@interface CMBrowserViewController()

@property (copy, nonatomic) NSString *url;

@end

@implementation CMBrowserViewController {
    UIWebView *showWebView;
}


- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = true;
        self.url = url;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    showWebView.scalesPageToFit = true;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [showWebView loadRequest:urlRequest];
    [self.view addSubview:showWebView];
    
    
}

@end
