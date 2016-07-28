//
//  AppDelegate.m
//  CMWeibo
//
//  Created by jiachenmu on 5/15/16.
//  Copyright (c) 2013 SINA iOS Team. All rights reserved.
//  欢迎查看ManoBoo的开源项目 <CMWeibo>
//  简书文章地址：
//  Github

#import "AppDelegate.h"
#import "User.h"
#import <WeiboSDK.h>

#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import "ViewController.h"

#import "HomeViewController.h"
#import "SidePullViewController.h"
#import "MessageViewController.h"
#import "SearchViewController.h"
#import "PersonCenterViewController.h"

@interface WBBaseRequest ()
- (void)debugPrint;
@end

@interface WBBaseResponse ()
- (void)debugPrint;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:AppKey];
    
    [self setUMSocialDataAppkey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self buildViewControllers];

    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WBAuthorizeResponse *result = (WBAuthorizeResponse *)response;
        //如果授权成功,发出通知
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AuthorizeSuccess object:result];
        }else if(response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
            NSLog(@"授权失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AuthorizeFailure object:result];
        }

    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}


#pragma mark - Build ViewController

- (void)buildViewControllers {
    _tabBarController = [[UITabBarController alloc] init];
    
    
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"home_tab_icon_1"] selectedImage:[UIImage imageNamed:@"home_tab_icon_1_selected"]];
    CMBaseNavigationController *homeNav = [[CMBaseNavigationController alloc] initWithRootViewController:homeViewController];
    
    SidePullViewController *sideVC = [[SidePullViewController alloc] init];
    
    
    
    
    
    
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
    messageViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"home_tab_icon_2"] selectedImage:[UIImage imageNamed:@"home_tab_icon_2_selected"]];
    CMBaseNavigationController *messageNav = [[CMBaseNavigationController alloc] initWithRootViewController:messageViewController];
    
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    searchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"home_tab_icon_3"] selectedImage:[UIImage imageNamed:@"home_tab_icon_3_selected"]];
    CMBaseNavigationController *searchNav = [[CMBaseNavigationController alloc] initWithRootViewController:searchViewController];
    
    PersonCenterViewController *mineViewController = [[PersonCenterViewController alloc] init];
    mineViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人" image:[UIImage imageNamed:@"home_tab_icon_4"] selectedImage:[UIImage imageNamed:@"home_tab_icon_4_selected"]];
    CMBaseNavigationController *mineNav = [[CMBaseNavigationController alloc] initWithRootViewController:mineViewController];
    
    _tabBarController.viewControllers = [NSArray arrayWithObjects:homeNav,messageNav,searchNav,mineNav, nil];
    
    _mainViewController = [[MMDrawerController alloc] initWithCenterViewController:_tabBarController leftDrawerViewController:sideVC];
    [_mainViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [_mainViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    _mainViewController.maximumLeftDrawerWidth = SidePullViewWidth;
    _mainViewController.showsShadow = false;
    
    self.window.rootViewController = _mainViewController;
}

#pragma mark - UMengSocialSDK configure

- (void)setUMSocialDataAppkey {
    [UMSocialData setAppKey:UMengSocialKey];
    
    //设置微信appid
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:@"http://www.umeng.com/social"];
    
    /*这里并没有去腾讯开放平台申请应用接入，所以暂时并未接入QQ分享*/
}

@end
