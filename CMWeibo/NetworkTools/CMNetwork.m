//
//  CMNetwork.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMNetwork.h"

@implementation CMNetwork


+ (AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.securityPolicy.allowInvalidCertificates = true;
    });
    
    return manager;
}

+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.securityPolicy.allowInvalidCertificates = true;

    return manager;
}


+ (void)GET:(nullable NSString *)URLString
 parameters:(nullable id)parameters
    success:(nullable void (^ )( NSString * _Nonnull))success
    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
//    [SVProgressHUD showWithStatus:@"正在拼命请求中..."];
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        //(status == AFNetworkReachabilityStatusUnknown) ||
        [SVProgressHUD showErrorWithStatus:@"网络连接失败~"];
        
        return;
    }
    [CMNetwork shareManager].requestSerializer = [AFJSONRequestSerializer serializer];
    [CMNetwork shareManager].responseSerializer = [AFJSONResponseSerializer serializer];
    [[CMNetwork shareManager].requestSerializer setTimeoutInterval:2.0];
    [[CMNetwork shareManager] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (success) {
            //服务器中获取到数据是字典形式的，这里习惯使用json字符串，进行解析
            NSError *error = nil;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (error != nil) {
                [SVProgressHUD showErrorWithStatus:@"数据解析失败，请重新尝试"];
                return;
            }
            success(jsonString);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请检查网络,或者刷新频率过快"];
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)spec_GET:(nullable NSString *)URLString
      parameters:(nullable id)parameters
         success:(nullable void (^ )( NSString * _Nonnull))success
         failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    //    [SVProgressHUD showWithStatus:@"正在拼命请求中..."];
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        //(status == AFNetworkReachabilityStatusUnknown) ||
        [SVProgressHUD showErrorWithStatus:@"网络连接失败~"];
        
        return;
    }
    [CMNetwork shareManager].requestSerializer = [AFHTTPRequestSerializer serializer];
    [CMNetwork shareManager].responseSerializer = [AFJSONResponseSerializer serializer];
    [[CMNetwork shareManager].requestSerializer setTimeoutInterval:3.0];
    [[CMNetwork shareManager] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            //服务器中获取到数据是字典形式的，这里习惯使用json字符串，进行解析
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (error != nil) {
                [SVProgressHUD showErrorWithStatus:@"数据解析失败，请重新尝试"];
                return;
            }
            success(jsonString);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败，请检查网络,或者刷新频率过快"];
        if (failure) {
            failure(task,error);
        }
    }];
}


+ (void)async_GET:(nullable NSString *)URLString
       parameters:(nullable id)parameters
          success:(nullable void (^ )( NSString * _Nonnull))success
          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    //    [SVProgressHUD showWithStatus:@"正在拼命请求中..."];
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        //(status == AFNetworkReachabilityStatusUnknown) ||
        [SVProgressHUD showErrorWithStatus:@"网络连接失败~"];
        
        return;
    }
    [CMNetwork manager].requestSerializer = [AFJSONRequestSerializer serializer];
    [CMNetwork manager].responseSerializer = [AFJSONResponseSerializer serializer];
    [[CMNetwork manager].requestSerializer setTimeoutInterval:2.0];
    [[CMNetwork manager] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (success) {
            //服务器中获取到数据是字典形式的，这里习惯使用json字符串，进行解析
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (error != nil) {
                [SVProgressHUD showErrorWithStatus:@"数据解析失败，请重新尝试"];
                return;
            }
            success(jsonString);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请检查网络,或者刷新频率过快"];
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)POST:(nullable NSString *)URLString
 parameters:(nullable id)parameters
    success:(nullable void (^ )( NSString * _Nonnull))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = true;

    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (success) {
            //服务器中获取到数据是字典形式的，这里习惯使用json字符串，进行解析
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (error != nil) {
                [SVProgressHUD showErrorWithStatus:@"数据解析失败，请重新尝试"];
                return;
            }
            success(jsonString);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"请求失败，请检查网络"];
        if (failure) {
            failure(task,error);
        }
    }];
}


#pragma mark - 微博请求

/// 添加收藏
+ (void)addFavoriteWithWeiboID:(NSString *)weiboIDstr
                       success:(void (^)(NSString * _Nonnull))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    [CMNetwork POST:kURL_AddToFavorite parameters:@{@"access_token" : [User currentUser].wbtoken , @"id" : @(weiboIDstr.longLongValue)} success:^(NSString * _Nonnull jsonString) {
        NSLog(@"收藏成功");
        [SVProgressHUD showSuccessWithStatus:@"收藏成功👏"];
        if (success) {
            success(jsonString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"收藏失败，请检查网络或者已经收藏"];
        NSLog(@"responser : %@",task.response);
        if (failure) {
            failure(task,error);
        }
    }];
}

/// 取消收藏
+ (void)cancelFavoriteWithWeiboID:(NSString *)weiboIDstr
                       success:(void (^)(NSString * _Nonnull))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    [CMNetwork POST:kURL_CancelFavorite parameters:@{@"access_token" : [User currentUser].wbtoken , @"id" : @(weiboIDstr.longLongValue)} success:^(NSString * _Nonnull jsonString) {
        NSLog(@"取消成功");
        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        if (success) {
            success(jsonString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"取消失败，请检查网络或者已经取消"];
        NSLog(@"responser : %@",task.response);
        if (failure) {
            failure(task,error);
        }
    }];
}


@end
