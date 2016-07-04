//
//  WeiboModel.h
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  每条微博的model

#import <Foundation/Foundation.h>
#import "CMWeiboCellFrames.h"
#import "WeiboAttributerString.h"
#import "UserModel.h"

#pragma mark - 微博整体Model -----------------------------------------------------
@class RetweetedModel;
@class GeoModel;
@class PicModel;

@interface WeiboModel : NSObject

/// 表态数量
@property (assign, nonatomic) NSInteger attitudes_count;

/// 微博来源
@property (strong, nonatomic) NSString *source;

/// 是否被截断，true：是，false：否
@property (assign, nonatomic) BOOL truncated;

/// 来源type
@property (assign, nonatomic) NSInteger source_type;

/// 微博id
@property (copy, nonatomic) NSString *idstr;

/// 微博id
@property (assign, nonatomic) long long id;

/// 微博mid
@property (assign, nonatomic) long long mid;

/// 来源是否允许点击
@property (assign, nonatomic) NSInteger source_allowclick;

/// 被转发的原微博信息字段，当该微博为转发微博时返回
@property (strong, nonatomic) RetweetedModel *retweeted_status;

/// 评论数
@property (assign, nonatomic) NSInteger comments_count;

/// 图片数组
@property (strong, nonatomic) NSArray <PicModel *> *pic_urls;


/// 缩略图片地址，没有时不返回此字段
@property (copy, nonatomic) NSString *thumbnail_pic;

/// 中等尺寸图片地址，没有时不返回此字段
@property (copy, nonatomic) NSString *bmiddle_pic;

/// 原始图片地址，没有时不返回此字段
@property (copy, nonatomic) NSString *original_pic;;

/// 转发数
@property (assign, nonatomic) NSInteger reposts_count;

/// 是否为长文本
@property (assign, nonatomic) BOOL isLontText;

/// 是否已收藏，true：是，false：否
@property (assign, nonatomic) BOOL favorited;

/// 用户类型
@property (assign, nonatomic) NSInteger userType;

/// 不明
@property (strong, nonatomic) id text_tag_tips;

/// 用户地理信息字段
@property (strong, nonatomic) GeoModel *geo;

/// 用户ID
@property (assign, nonatomic) NSInteger ID;

/// 用户对象
@property (strong, nonatomic) UserModel *user;

/// 评论内容
@property (copy, nonatomic) NSString *text;

/// 创建时间
@property (copy, nonatomic) NSString *created_at;

/// 微博的可见性及指定可见分组信息
@property (copy, nonatomic) id visible;

// -MARK: frame
@property (strong, nonatomic) CMWeiboCellFrames *cellFrames;
// -MARK: 正文富文本设置
@property (strong, nonatomic) NSAttributedString *attributeStr;
// _MARK: 回复的微博富文本
@property (strong, nonatomic) NSAttributedString *retweetedStatusAttributeStr;

// -MARK: 富文本中的点击事件
@property (copy, nonatomic) YYTextAction tapAction;

+ (void)setup;

@end

#pragma mark - 公开设置Model -----------------------------------------------------
/// 公开设置Model
@interface VisibleModel : NSObject

/**
 *  type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博
 */
@property (assign, nonatomic) NSInteger type;

/**
 *  list_id为分组的组号
 */
@property (assign, nonatomic) long long list_id;

@end

#pragma mark - 图片模型 -----------------------------------------------------
@interface PicModel : NSObject

/// 缩略图片地址
@property (copy, nonatomic) NSString *thumbnail_pic;

/// 大图片地址
@property (copy, nonatomic) NSString *large_pic;

+ (instancetype)picModelWithObject:(id)obj;

@end

#pragma mark - 地理信息模型 -----------------------------------------------------

@interface GeoModel : NSObject

/// 经度坐标
@property (copy, nonatomic) NSString *longitude;

/// 纬度坐标
@property (copy, nonatomic) NSString *latitude;

/// 所在城市的城市代码
@property (copy, nonatomic) NSString *city;

/// 所在省份的省份代码
@property (copy, nonatomic) NSString *province;

/// 所在城市的城市名称
@property (copy, nonatomic) NSString *city_name;

/// 所在省份的省份名称
@property (copy, nonatomic) NSString *province_name;

/// 所在的实际地址，可以为空
@property (copy, nonatomic) NSString *address;

/// 地址的汉语拼音，不是所有情况都会返回该字段
@property (copy, nonatomic) NSString *pinyin;

/// 更多信息，不是所有情况都会返回该字段
@property (copy, nonatomic) NSString *more;

@end

#pragma mark - 转发微博模型 -----------------------------------------------------

@interface RetweetedModel : WeiboModel

@property (assign, nonatomic) long expire_time;

/// 扩展，是否广告？
@property (strong, nonatomic) id extend_info;

/// 文本消息长度
@property (assign, nonatomic) NSInteger textLength;

+ (instancetype)initWithobject:(id)obj;

@end

#pragma mark - 微博缓存模型 -----------------------------------------------------
// 微博草稿保存
@interface DraftsModel : NSObject

//正文、文字类信息
@property (strong, nonatomic) NSString *wbContent;

//转发时 顺便评论给上一个user
@property (assign, nonatomic) BOOL isComment;


@end