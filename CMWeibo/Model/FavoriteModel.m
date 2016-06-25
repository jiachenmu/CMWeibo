//
//  FavoriteModel.m
//  CMWeibo
//
//  Created by jiachen on 16/6/3.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "FavoriteModel.h"
#import "WeiboModel.h"

@implementation FavoriteModel

@end


@implementation FavoriteList

static FavoriteList *instance;

+ (instancetype)currentFavoriteList {
    [CMNetwork GET:kURL_MyFavoriteList parameters:@{@"access_token" : [User currentUser].wbtoken} success:^(NSString * _Nonnull jsonString) {
        
        instance = [FavoriteList initWithJsonString:jsonString];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    return instance;
}

#pragma mark - 检测当前微博是不是已经收藏过

+ (BOOL)isHasFavoritedWithWeiboID:(NSString *)weiboID {
    __block BOOL isExist = false;
    NSLog(@"收藏微博的个数：%lu",(unsigned long)[FavoriteList currentFavoriteList].favorites.count);
    [[FavoriteList currentFavoriteList].favorites enumerateObjectsUsingBlock:^(FavoriteModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weiboID isEqualToString:obj.status.idstr]) {
            //检测到该微博ID
            isExist = true;
            *stop = true;
        }
    }];
    
    return isExist;
}



#pragma mark - 收藏列表
+ (void)setup {
    [FavoriteList mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"favorites" : @"FavoriteModel"};
    }];
}

+ (instancetype)initWithJsonString:(NSString *)jsonString {
    [FavoriteList setup];
    FavoriteList *list = [[FavoriteList alloc] init];
    list.favorites = [NSArray array];
    list = [FavoriteList mj_objectWithKeyValues:jsonString];

    return list;
}



@end