//
//  WeiboList.m
//  CMWeibo
//
//  Created by jiachen on 16/5/24.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "WeiboList.h"
#import "WeiboModel.h"
#import "WeiboAttributerString.h"

NSString * const k_interval = @"k_interval";
NSString * const k_statuses = @"k_statuses";
NSString * const k_total_number = @"k_total_number";

@implementation WeiboList

#pragma mark - 解档 归档


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _interval = [coder decodeIntegerForKey:k_interval];
        _statuses = [coder decodeObjectForKey:k_statuses];
        _total_number = [coder decodeIntegerForKey:k_total_number];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_interval forKey:k_interval];
    [aCoder encodeObject:_statuses forKey:k_statuses];
    [aCoder encodeInteger:_total_number forKey:k_total_number];
}


+ (void)setup {
    [WeiboList mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"statuses" : @"WeiboModel",
                 };
    }];
    [WeiboModel setup];
}

+ (instancetype)initWithJSONString:(NSString *)jsonString {
    [WeiboList setup];
    
    WeiboList *list = [[WeiboList alloc] init];
    list.statuses = [NSArray array];
    
    
    list = [WeiboList mj_objectWithKeyValues:jsonString];
    
    //这里给每个model，计算frame
    for (WeiboModel *model in list.statuses) {
        model.cellFrames = [CMWeiboCellFrames cellFramesWithWeiboModel:model];
    
        //获取到的 微博来源字符串是HTML形式的 <a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>
        //需要抽取出来
        model.source = [WeiboAttributerString weiboSourceWithString:model.source];
    }
    return list;
}

@end
