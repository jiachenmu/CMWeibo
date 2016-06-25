//
//  ImageCache.h
//  CMWeibo
//
//  Created by jiachen on 16/5/30.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYDiskCache.h"

@interface CMCache : NSObject

//微博中的大图图片缓存
+ (YYMemoryCache *)imageCache;

/// 草稿保存 包括： 转发草稿、微博草稿 等等
+ (YYMemoryCache *)draftsCache;


/**
 *  使用情况：
 1.用户手动请求离线数据
 2.程序退出，将已经请求的数据缓存到本地，下次请求失败的时候可以解析本地数据
 *
 *  @return 本地数据
 */
+ (YYDiskCache *)offlineCache;


@end
