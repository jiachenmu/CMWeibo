//
//  ImageCache.m
//  CMWeibo
//
//  Created by jiachen on 16/5/30.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  图片缓存类

#import "CMCache.h"

@implementation CMCache

+ (NSString *)documentsPath {
    static NSString *documentDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentDirectory = [paths objectAtIndex:0];
        NSLog(@"documentDirectory : %@",documentDirectory);
    });
    
    return documentDirectory;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *imageCache;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        imageCache = [YYMemoryCache new];
        imageCache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        imageCache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        imageCache.name = @"WeiboImageCache";
    });
    
    return imageCache;
}

/// 草稿保存 包括： 转发草稿、微博草稿 等等
+ (YYMemoryCache *)draftsCache {
    static YYMemoryCache *draftsCache;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        draftsCache = [YYMemoryCache new];
        draftsCache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        draftsCache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        draftsCache.name = @"WeiboDraftsCache";
    });
    
    return draftsCache;
}


/**
 *  使用情况：
 1.用户手动请求离线数据
 2.程序退出，将已经请求的数据缓存到本地，下次请求失败的时候可以解析本地数据
 *
 *  @return 本地数据
 */
+ (YYDiskCache *)offlineCache {
    static YYDiskCache *offlineCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        offlineCache = [[YYDiskCache alloc] initWithPath:[[CMCache documentsPath] stringByAppendingString:@"/offline"]];
        offlineCache.name = kString_offline;
    });
    
    return offlineCache;
}


@end
