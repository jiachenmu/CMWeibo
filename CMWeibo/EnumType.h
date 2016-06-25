//
//  EnumType.h
//  CMWeibo
//
//  Created by jiachen on 16/5/20.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#ifndef EnumType_h
#define EnumType_h

#pragma mark - 用户相关

//用户与数据中的匹配枚举
typedef NS_ENUM(NSUInteger, UserSaveType) {
    UserSaveType_NoUser = 0,//数据库中没有用户
    UserSaveType_TokenInvalid, //该用户 token失效，重新获取token，更新数据库
    UserSaveType_TokenVaild,  //该用户token 还有效，剩余授权时间还比较多
};

/// 认证方式
typedef NS_ENUM(NSUInteger, WBUserVerifyType){
    WBUserVerifyTypeNone = 0,     ///< 没有认证
    WBUserVerifyTypeStandard,     ///< 个人认证，黄V
    WBUserVerifyTypeOrganization, ///< 官方认证，蓝V
    WBUserVerifyTypeClub,         ///< 达人认证，红星
};


/// 图片标记
typedef NS_ENUM(NSUInteger, WBPictureBadgeType) {
    WBPictureBadgeTypeNone = 0, ///< 正常图片
    WBPictureBadgeTypeLong,     ///< 长图
    WBPictureBadgeTypeGIF,      ///< GIF
};

/// 微博正文中的点击事件
typedef NS_ENUM(NSUInteger, WBClickEventType) {
    WBClickEventTypeAtSomeOne = 0,  ///< @某人
    WBClickEventTypeHttpURl,        ///< http链接
    WBClickEventTypeTopic,          ///< 话题
    WBClickEventTypeFavorite,       ///< 收藏
    WBClickEventTypeOptIn,          ///< 点赞
    WBClickEventTypeRepost,         ///< 转发
    WBClickEventTypeComment,        ///< 评论
};

/// 微博@某人中选中与不选中
typedef NS_ENUM(NSUInteger,WBAtSomeOneType) {
    WBAtSomeOneTypeSelect = 0,
    WBAtSomeOneTypeCancel = 1,
};

/// 微博侧拉框View中的点击事件
typedef NS_ENUM(NSUInteger,WBSideEventType) {
    WBSideEventTypeLookGroup = 0,
    WBSideEventTypeOther = 1,
};

#endif /* EnumType_h */
