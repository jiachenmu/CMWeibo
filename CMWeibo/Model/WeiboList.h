//
//  WeiboList.h
//  CMWeibo
//
//  Created by jiachen on 16/5/24.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiboModel;
@interface WeiboList : NSObject<NSCoding>

//间隔。。应该是这么翻译吧
@property (assign, nonatomic) NSInteger interval;

//
@property (strong, nonatomic) NSArray *statuses;

//微博数量总计
@property (assign, nonatomic) NSInteger total_number;

+ (instancetype)initWithJSONString:(NSString *)jsonString ;


//往一个list添加数据
- (instancetype)addDataFromJson:(NSString *)jsonString;

- (instancetype)addDataFromOtherList:(WeiboList *)list;

@end
