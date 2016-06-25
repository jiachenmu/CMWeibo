//
//  DataTools.m
//  CMWeibo
//
//  Created by jiachen on 16/5/26.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "DateTools.h"

@implementation DateTools

static DateTools *instance;

+(instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DateTools alloc] init];
    });
    return instance;
}

/// 返回当前时间
+ (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    return dateString;
}

/// 返回最后一次刷新的时间
+ (NSString *)lastRefreshDate {
    if ([DateTools shareInstance].lastRefreshDateString == nil || [DateTools shareInstance].lastRefreshDateString.length == 0) {
        [DateTools shareInstance].lastRefreshDateString = [DateTools currentDate];
    }
    return [DateTools shareInstance].lastRefreshDateString;
}

+ (NSString *)dateWithString:(NSString *)dateString {
//    NSLog(@"要转换的日期: %@",dateString);
    NSDateFormatter *inputFormatter = [NSDateFormatter new];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDate *inputDate = [inputFormatter dateFromString:dateString];
    
    //计算发表日期与当前日期的差值
    NSTimeInterval timeInterval = [inputDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if( (temp = timeInterval/60) < 60 ) {
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if ( (temp = temp/60) < 24 ) {
        result = [NSString stringWithFormat:@"%ld个小时前",temp];
    }else if ( (temp = temp/24) < 30 ) {
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else if ( (temp = temp/30) < 12 ) {
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }else{
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        result = [outputFormatter stringFromDate:inputDate];
    }
    
    return result;
}
@end
