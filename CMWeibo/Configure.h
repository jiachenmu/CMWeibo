//
//  Configure.h
//  CMWeibo
//
//  Created by jiachen on 16/5/16.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#ifndef Configure_h
#define Configure_h

#pragma mark - 微博配置相关 --------------------------------------------------------
#import <WeiboSDK.h>
#define AppKey    @"2229636908"
#define AppSecret @"bb125e932a86d5e5bfb917545eab3143"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

//友盟shareSDK配置
#define UMengSocialKey @"575f635867e58ee31c001ece"

#define WXAppID     @"wx818610eb304dca09"
#define WXAppSecret @"ccead335083923c72a384e9104657d67"

//百度地图api key
#define BaiduMapKey @"OTZHm7DueF4SvDgwUWqr2TVD4Snt0Cwb"

#pragma mark - 网络请求相关 --------------------------------------------------------
#import <AFNetworking.h>
#import "CMNetwork.h"




//https访问要求
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#pragma mark - 存储相关 --------------------------------------------------------
#import <MJExtension.h>
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#define kManagedObjectContext [CoreDataManager shareInstance].managedObjectContext

#pragma mark - 通知相关
#define kNotification_AuthorizeSuccess  @"kNotification_AuthorizeSuccess"  //授权登录成功
#define kNotification_AuthorizeFailure  @"kNotification_AuthorizeFalure"   //授权失败
#define kNotification_FavoriteSuccess   @"kNotification_FavoriteSuccess"   //收藏成功
#define kNotification_LookUpMyGroup     @"kNotification_LookUpMyGroup"     //查看我的分组

#pragma mark - 展示相关 --------------------------------------------------------
#import <SVProgressHUD.h>
#import <SVPullToRefresh.h>
#import "UITableView+CustomRefresh.h"
#import <YYWebImage.h>
#import <UMSocial.h>
#import <YYText.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIColor+HexColor.h"
#import "CMBaseNavigationController.h"
#define Color_NavigationBar [UIColor colorWithHex:0x3581f4]

#pragma mark - 编码相关 --------------------------------------------------------

#define Weakself __weak typeof(self) weakself = self
#import "User.h"
#import "AppDelegate.h"
#define App ( (AppDelegate *)[[UIApplication sharedApplication] delegate] )
#define Font(o) [UIFont systemFontOfSize:o]
#define DefaultIcon [UIImage imageNamed:@"DefaultIcon"]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define VIEW_HEIGHT (SCREEN_HEIGHT - 64)
//默认一次请求数据个数
#define kRequestCount @(40)

/// 离线请求一次的最大数量
#define kOfflineReqCount @(100)
/// 离线请求的本地缓存名称
#define kString_offline @"kString_offline"

//常用颜色
#define Color_Black [UIColor blackColor] //黑色
#define Color_White [UIColor whiteColor] //白色
#define Color_ContentText [UIColor colorWithHex:0x404040]

//常用宏定义
#define CM_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

#define CM_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

#import "CMBaseViewController.h"
#import <MMDrawerController.h>

#pragma mark - 枚举类型 --------------------------------------------------------

#import "EnumType.h"

#pragma mark - 请求URL地址 --------------------------------------------------------

/// 获取某个用户最新发表的微博列表
#define kURL_UserTimeline @"https://api.weibo.com/2/statuses/user_timeline.json"

/// 获取当前登录用户及其所关注（授权）用户的最新微博
#define kURL_FriendsTimeline @"https://api.weibo.com/2/statuses/friends_timeline.json"

/// 返回最新的公共微博
#define kURL_NewPublicWeibo    @"https://api.weibo.com/2/statuses/public_timeline.json"

/// 用户信息
#define kURL_UserInfo          @"https://api.weibo.com/2/users/show.json"

/// 添加一条微博到收藏里
#define kURL_AddToFavorite     @"https://api.weibo.com/2/favorites/create.json"

/// 取消一条微博
#define kURL_CancelFavorite    @"https://api.weibo.com/2/favorites/destroy.json"

/// 转发一条微博
#define kURL_RepostWeibo       @"https://api.weibo.com/2/statuses/repost.json"

/// 获取当前登录用户的收藏列表  
#define kURL_MyFavoriteList    @"https://api.weibo.com/2/favorites.json"

/// 获取用户的关注列表 参数中加入用户昵称，可以获取该昵称用户的关注列表
#define kURL_FriendsList       @"https://api.weibo.com/2/friendships/friends.json"

/// 获取某一话题下的所有微博
#define kURL_Topics            @"https://api.weibo.com/2/search/topics.json"

/// 获取指定用户的标签
#define kURL_UserTags          @"https://api.weibo.com/2/tags.json"

/// 编辑我的分组
#define kURL_EditMyGroup       @"http://m.weibo.cn/home/groupList"

#endif /* Configure_h */
