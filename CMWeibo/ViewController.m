//
//  ViewController.m
//  CMWeibo
//
//  Created by jiachen on 16/5/16.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface ViewController ()<WBHttpRequestDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //先做请求
    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable array) {
        for (User *user in array) {
            [kManagedObjectContext deleteObject:user];
        }
    }];
    
    //监听通知 - 用户授权成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthorizeSuccess:) name:kNotification_AuthorizeSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(userAuthorizeFailure:) name:kNotification_AuthorizeFailure object:nil];
    
    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * array) {
        if (array == nil || array.count == 0) {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            [request setRedirectURI:kRedirectURI];
            [request setScope:@"all"];
            [WeiboSDK sendRequest:request];
        }else {
            NSLog(@"存储的 %@ 对象有 %lu 个 ",NSStringFromClass([User class]),(unsigned long)array.count);
            for (User *user in array) {
                NSLog(@"user.id = %@",user.wbCurrentUserID);
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handle

//监听通知 － 用户授权成功
- (void)userAuthorizeSuccess:(NSNotification *)notify {
    /*处理思路：
     1.用户授权成功后，检查是否数据库中已存在该对象，或者数据库中用户对应的token已过期，通过userID判断
     2.对上述情景做相应的处理
     */
    NSLog(@"用户授权成功！");
    //先在这里保存一下用户授权数据
    WBAuthorizeResponse *result = ( WBAuthorizeResponse *)notify.object;
    User *user = [CoreDataManager modelWithClassName:@"User"];
    user.wbCurrentUserID = result.userID;
    user.wbRefreshToken = result.refreshToken;
    user.wbtoken = result.accessToken;
    user.expirationDate = result.expirationDate;
    [kManagedObjectContext save:nil];
    
    NSLog(@"认证过去");
    //保存完成后 试着请求一下数据
//    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable userArr) {
//        if (userArr && userArr.count > 0 ) {
//            BOOL isExistThisUser = false;
//            for (User *_user in userArr) {
//                if ([_user.wbCurrentUserID isEqualToString:user.wbCurrentUserID]) {
//                    [kManagedObjectContext deleteObject:_user];
//                    isExistThisUser = true;
//                }
//            }
//            if (isExistThisUser) {
//                NSLog(@"更新UI");
//                [kManagedObjectContext save:nil];
//            }
//            
//        }
//    }];
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = true;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"https://api.weibo.com/2/statuses/user_timeline.json" parameters:@{@"access_token" : user.wbtoken, @"count" : @1, @"uid" : [NSNumber numberWithLong:user.wbCurrentUserID.longLongValue]} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回最新的公共微博 请求成功！");
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        if (error == nil) {
            NSLog(@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
            [SVProgressHUD dismiss];
        }else {
            NSLog(@"格式解析错误");
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"返回最新的公共微博 请求失败 ");
    }];
    
}

//用户授权失败
- (void)userAuthorizeFailure:(NSNotification *)notify {
    
}

//用户收藏知道
- (void)userFavoriteSuccess:(NSNotification *)notify {
    
}

@end
