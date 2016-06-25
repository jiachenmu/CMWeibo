//
//  UserModel.h
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserModel : NSObject

typedef void(^UserModelSuccessBlock)(UserModel *);

//当前用户的信息
+ (instancetype)currentUser;
//获取用户信息，
+ (void)getUserInfoWithSuccessBlock:(UserModelSuccessBlock)successBlock;

/// 是否允许所有人对我的微博进行评论，true：是，false：否
@property (nonatomic, assign) BOOL allow_all_comment;

/// 用户头像地址（大图），180×180像素
@property (nonatomic, copy) NSString *avatar_large;

/// 用户头像地址（中图），50×50像素
@property (nonatomic, copy) NSString *profile_image_url;

/// 用户ID
@property (nonatomic, assign) long long userID;

/// 用户创建或注册时间
@property (nonatomic, copy) NSString *created_at;

/// 是否允许所有人给我发私信，true：是，false：否
@property (nonatomic, assign) BOOL allow_all_act_msg;

/// 用户备注信息，只有在查询用户关系时才返回此字段
@property (nonatomic, copy) NSString *remark;

/// 认证原因
@property (nonatomic, copy) NSString *verified_reason;

/// 用户所在地
@property (nonatomic, copy) NSString *location;

/// 是否允许标识用户的地理位置，true：是，false：否
@property (nonatomic, assign) BOOL geo_enabled;

/// 字符串型的用户UID
@property (nonatomic, copy) NSString *idstr;

/// 用户个人描述
@property (nonatomic, copy) NSString *description_text;

/// 用户博客地址
@property (nonatomic, copy) NSString *url;

/// 粉丝数量
@property (nonatomic, assign) NSInteger followers_count;

/// 该用户是否关注当前登录用户，true：是，false：否
@property (nonatomic, assign) BOOL follow_me;

/// 用户的互粉数
@property (nonatomic, assign) NSInteger bi_followers_count;

/// 用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
@property (nonatomic, copy) NSString *lang;

/// 微博数量
@property (nonatomic, assign) NSInteger statuses_count;

/// 用户头像地址（高清），高清头像原图
@property (nonatomic, copy) NSString *avatar_hd;

/// 友好显示名称
@property (nonatomic, copy) NSString *name;

/// 用户的个性化域名
@property (nonatomic, copy) NSString *domain;

/// 用户所在城市ID
@property (nonatomic, assign) NSString *city;

/// 用户的在线状态，0：不在线、1：在线
@property (nonatomic, assign) NSInteger online_status;

///
@property (nonatomic, assign) NSInteger urank;

/// 用户认证原因url
@property (nonatomic, copy) NSString *verified_reason_url;

/// 用户昵称
@property (nonatomic, copy) NSString *screen_name;

/// 所在省份
@property (nonatomic, copy) NSString *province;

/// 不知道这个属性干嘛的
@property (nonatomic, copy) NSString *verified_source;

/// 用户的微号
@property (nonatomic, copy) NSString *weihao;

/// 性别，m：男、f：女、n：未知
@property (nonatomic, copy) NSString *gender;

// 不明
@property (nonatomic, assign) NSInteger pagefriends_count;

/// 收藏数
@property (nonatomic, assign) NSInteger favourites_count;

/// 不明
@property (nonatomic, assign) NSInteger mbrank;

/// 用户的微博统一URL地址
@property (nonatomic, copy) NSString *profile_url;

// 不明
@property (nonatomic, assign) NSInteger user_ability;

// 不明
@property (nonatomic, assign) NSInteger ptype;

/// 关注数
@property (nonatomic, assign) NSInteger friends_count;

/// 是否是微博认证用户，即加V用户，true：是，false：否
@property (nonatomic, assign) BOOL verified;

//MARK: 类方法
+ (instancetype)initWithJSONString:(NSString *)jsonString ;

@end

@interface FriendsListModel : NSObject

// 关注的盆友列表
@property (strong, nonatomic) NSArray <UserModel *> *users;

// 关注的盆友总数
@property (assign, nonatomic) NSInteger total_number;

+ (instancetype)initWithJSONString:(NSString *)jsonString;

@end
