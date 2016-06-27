//
//  WeiboAttributerString.m
//  CMWeibo
//
//  Created by jiachen on 16/5/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  核心是正则表达式
/*
 这里推荐一个网站，可能需要翻，  http://regexkit.sourceforge.net/RegexKitLite/index.html#RegexKitLiteCookbook 
 这是对于OC语法的 一套正则表达式的网站，OC中的正则表达式基于ICU，与其他语言的差别仅在对于转义字符的处理上，详情请看上面的网站
 */

#import "WeiboAttributerString.h"

@implementation WeiboAttributerString

// 微博中 正文 富文本
+ (NSAttributedString *)attributeStringWithWeiboModel:(WeiboModel *)model TapAction:(YYTextAction )tapAction {
    //先判断模型中是不是已经设置好富文本,富文本只创建一次
    if (model.attributeStr == nil && model.text.length > 0 ) {
        model.attributeStr = [WeiboAttributerString attributeStringWithString:model.text TapAction:tapAction];
    }
    return model.attributeStr;
}

// 微博中 回复的微博 富文本
+ (NSAttributedString *)retweetedStatusAttributeStrWithWeiboModel:(WeiboModel *)model TapAction:(YYTextAction )tapAction {
    //先判断模型中是不是已经设置好富文本,富文本只创建一次
    if (model.retweetedStatusAttributeStr == nil && model.retweeted_status && model.retweeted_status.text.length > 0 ) {
        model.retweetedStatusAttributeStr = [WeiboAttributerString attributeStringWithString:model.retweeted_status.text TapAction:tapAction];
    }
    return model.retweetedStatusAttributeStr;
}

+ (NSAttributedString *)attributeStringWithString:(NSString *)str TapAction:(YYTextAction )tapAction{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr yy_setFont:Font(16) range:NSMakeRange(0, str.length)];
    // 1. 将所有的话题 例如 #ManoBoo# 这样的字符标记为蓝色
    if ([str containsString:@"#"]) {
        NSArray  *rangeArr = [WeiboAttributerString rangeArrayWithString:str];
        [rangeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = ( (NSValue *)obj ).rangeValue;
            [attributeStr yy_setColor:Color_NavigationBar range:range];
            YYTextHighlight *highLight = [YYTextHighlight new];
            [highLight setTapAction:tapAction];
            [attributeStr yy_setTextHighlight:highLight range:range];
            
        }];
    }
    
    //设置 http链接的样式
    [WeiboAttributerString handleHttpURlWithWeiboContentString:attributeStr tapaction:tapAction];
   
    //设置 "点击全文" 的样式
    if ([str containsString:@"全文"]) {
        NSRange range = [WeiboAttributerString rangeOfClickAllContentWithString:str];
        [attributeStr yy_setColor:Color_NavigationBar range:range];
        YYTextHighlight *highLight = [YYTextHighlight new];
        [highLight setTapAction:tapAction];
        [attributeStr yy_setTextHighlight:highLight range:range];
    }
    
    //显示emoji字符
    [WeiboAttributerString changeEmojyOfAttributeString:attributeStr];
    
    //显示@对象
    [WeiboAttributerString handleAtSomeOneStringOfAttributeString:attributeStr tapaction:tapAction];
    
    return attributeStr;
}

/// 返回 微博正文中所有的 话题 range
+ (NSArray *)rangeArrayWithString:(NSString *)str {
    NSMutableArray <NSValue *> *rangeArray = [NSMutableArray array];
    NSMutableArray <NSNumber *> *temp = [NSMutableArray array];
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:str];
    
    for (int i = 0; i < mStr.length; i++) {
        //记录起始 #的位置
        NSRange range1 = [mStr rangeOfString:@"#"];
        
        if (range1.location < str.length) {
            [temp addObject:[NSNumber numberWithInteger:range1.location + temp.lastObject.integerValue  + 1]];
            mStr = [[NSMutableString alloc] initWithString: [mStr substringFromIndex:range1.location + 1] ];
        }
    }
    
    //将所有的 #坐标记录到数组中后
    if (temp.count %2 != 0) {
        [temp removeObjectAtIndex:rangeArray.count-1];
    }
    for (int i = 0; i < temp.count; i+=2) {
        NSRange range = NSMakeRange(temp[i].integerValue-1, temp[i+1].integerValue - temp[i].integerValue + 1);
        [rangeArray addObject:[NSValue valueWithRange:range]];
    }
    
    return rangeArray;
}

#define kRegexHttp @"\\b(https?)://([a-zA-Z0-9\\-.]+)((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"

/// 找到微博正文中的链接 http开头的
+ (void)handleHttpURlWithWeiboContentString:(NSMutableAttributedString *)weiboString tapaction:(YYTextAction)action{
    static NSRegularExpression *httpRegular;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        httpRegular = [NSRegularExpression regularExpressionWithPattern: kRegexHttp options:kNilOptions error:NULL];
    });
    
    NSArray <NSTextCheckingResult *> *httpResult = [httpRegular matchesInString:weiboString.string options:kNilOptions range:weiboString.yy_rangeOfAll];
    if (httpResult == nil || httpResult.count == 0) {
        return;
    }
    for (NSTextCheckingResult *result in httpResult) {
        if (result.range.location == NSNotFound && result.range.length <= 1) {
            //排除无用结果
            __block BOOL containBindingRange = false;
            [weiboString enumerateAttribute:YYTextBindingAttributeName inRange:result.range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                if (value != nil) {
                    containBindingRange = true;
                    *stop = true;
                }
            }];
            if (containBindingRange) {
                continue;
            }
        }
        
        //添加点击动作
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setTapAction:action];
        [weiboString yy_setColor:Color_NavigationBar range:result.range];
        [weiboString yy_setTextHighlight:highlight range:result.range];
    }
}

/// 设置点击全文的样式
+ (NSRange)rangeOfClickAllContentWithString:(NSString *)weiboString {
    NSRange range = [weiboString rangeOfString:@"全文"];
    
    return range;
}

/// 更改文字中的emoji 字符为 表情图
+ (void)changeEmojyOfAttributeString:(NSMutableAttributedString *)attributeStr {
    NSRange range = [attributeStr.string rangeOfString:@"[睡]"];
    if (range.location != NSNotFound && range.length < attributeStr.string.length) {
        [attributeStr replaceCharactersInRange:range withString:@"😴"];
    }
}

/*
 -------------------------这里每次都遍历截取字符串，很麻烦，所以还是改用正则表达式了-----------------------------------
 */

#define kRegexAtSomeOne @"@[-_a-zA-Z0-9\u4E00-\u9FA5]+"
+ (NSRegularExpression *)atSomeOne {
    static NSRegularExpression *atSomeone;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        atSomeone = [NSRegularExpression regularExpressionWithPattern:kRegexAtSomeOne options:kNilOptions error:NULL];
    });
    
    return atSomeone;
}

+ (void)handleAtSomeOneStringOfAttributeString:(NSMutableAttributedString *)attributeStr tapaction:(YYTextAction)action{
    //找到匹配的结果
    NSArray <NSTextCheckingResult *> *atSomeoneResult = [[WeiboAttributerString atSomeOne] matchesInString:attributeStr.string options:kNilOptions range:attributeStr.yy_rangeOfAll];
    for (NSTextCheckingResult *result in atSomeoneResult) {
        if (result.range.location == NSNotFound && result.range.length <= 1) {
            //排除无用结果
            __block BOOL containBindingRange = false;
            [attributeStr enumerateAttribute:YYTextBindingAttributeName inRange:result.range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                if (value != nil) {
                    containBindingRange = true;
                    *stop = true;
                }
            }];
            if (containBindingRange) {
                continue;
            }
        }
        
        //添加点击动作
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setTapAction:action];
        [attributeStr yy_setColor:Color_NavigationBar range:result.range];
        [attributeStr yy_setTextHighlight:highlight range:result.range];
    }
}

///  微博来源字符串处理
+ (NSString *)weiboSourceWithString:(NSString *)sourceString {
    NSMutableString *str = [[NSMutableString alloc] initWithString:sourceString];
    NSRange range1 = [sourceString rangeOfString:@">"];
    if (range1.location + range1.length > sourceString.length) {
        return @"微博";
    }
    str = [[NSMutableString alloc] initWithString: [str substringFromIndex:range1.location + 1] ];
    
    NSRange range2 = [str rangeOfString:@"<"];

    return [str substringWithRange:NSMakeRange(0, range2.location)];
}




@end
