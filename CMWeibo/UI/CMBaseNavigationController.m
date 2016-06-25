//
//  CMBaseNavigationController.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMBaseNavigationController.h"

@implementation CMBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self configureNavigationController];
    }
    return self;
}

- (void)configureNavigationController {
    [self.navigationBar setBarTintColor:Color_NavigationBar];
    [self.navigationBar setTintColor:Color_White];
    //关闭半透明
    self.navigationBar.translucent = false;
}
@end
