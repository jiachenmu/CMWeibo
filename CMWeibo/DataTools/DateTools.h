//
//  DataTools.h
//  CMWeibo
//
//  Created by jiachen on 16/5/26.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTools : NSObject

@property (strong, nonatomic) NSString *lastRefreshDateString;

+ (instancetype)shareInstance;

/// 返回当前系统时间
+ (NSString *)currentDate;

/// 上次刷新时间
+ (NSString *)lastRefreshDate;

/**
 *  将服务器返回的时间转换为 当前时间
 *
 *  @param dateString <#dateString description#>
 *
 *  @return <#return value description#>
 */

+ (NSString *)dateWithString:(NSString *)dateString;

@end
