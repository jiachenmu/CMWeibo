//
//  WeiboAttributerString.h
//  CMWeibo
//
//  Created by jiachen on 16/5/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  将后台获取到的文本 转换为富文本

#import <Foundation/Foundation.h>
#import "WeiboModel.h"

@interface WeiboAttributerString : NSObject


+ (NSAttributedString *)attributeStringWithWeiboModel:(WeiboModel *)model TapAction:(YYTextAction )tapAction;

/**
 *  微博cell中所需要的富文本
 *
 *  @param str 源文本
 *
 *  @return 富文本
 */
+ (NSAttributedString *)attributeStringWithString:(NSString *)str TapAction:(YYTextAction )tapAction;



///  微博来源字符串处理
+ (NSString *)weiboSourceWithString:(NSString *)sourceString;


@end
