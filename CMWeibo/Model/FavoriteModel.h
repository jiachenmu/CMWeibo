//
//  FavoriteModel.h
//  CMWeibo
//
//  Created by jiachen on 16/6/3.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  收藏模型

#import <Foundation/Foundation.h>

@class WeiboModel;
@interface FavoriteModel : NSObject

@property (strong, nonatomic) WeiboModel *status;

@property (strong, nonatomic) NSArray *tags;

@property (strong, nonatomic) NSString *favorited_time;

@end


@interface FavoriteList : NSObject

/// 收藏的微博列表
@property (copy, nonatomic) NSArray <FavoriteModel *> *favorites;

/// 收藏总数
@property (assign, nonatomic) NSInteger total_number;

+ (instancetype)initWithJsonString:(NSString *)jsonString;

+ (instancetype)currentFavoriteList;

/// 检测该微博ID是否已经收藏
// true 收藏 , false 未收藏
+ (BOOL)isHasFavoritedWithWeiboID:(NSString *)weiboID;

@end