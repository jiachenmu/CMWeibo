//
//  AppDelegate.h
//  CMWeibo
//
//  Created by jiachen on 16/5/16.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

/// 左滑控制器
@property (strong, nonatomic) MMDrawerController *mainViewController;

@end

