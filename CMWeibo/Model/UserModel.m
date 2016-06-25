//
//  UserModel.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

static UserModel *instance;

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserModel alloc] init];
        [UserModel getUserInfoWithSuccessBlock:nil];
    });
    return instance;
}

+ (void)setUp {
    [UserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"description_text" : @"description",
                 @"userID" : @"id"
                 };
    }];
}

+ (instancetype)userModelWithObject:(id)obj {
    UserModel *model = [[UserModel alloc] init];
    model = [UserModel mj_objectWithKeyValues:[obj mj_keyValues]];

    return model;
}

+ (instancetype)initWithJSONString:(NSString *)jsonString {
    
    [UserModel setUp];
    UserModel *user = [UserModel mj_objectWithKeyValues:jsonString];
    return user;
}

//获取用户信息，
+ (void)getUserInfoWithSuccessBlock:(UserModelSuccessBlock)successBlock {
    [CMNetwork GET:kURL_UserInfo parameters:@{@"access_token" : [User currentUser].wbtoken, @"uid" : @([User currentUser].wbCurrentUserID.longLongValue)} success:^(NSString * _Nonnull jsonString) {
        
        UserModel *usermodel = [UserModel initWithJSONString:jsonString];
        instance = usermodel;;
        NSLog(@"用户昵称： %@",usermodel.screen_name);
        NSLog(@"用户大头像：%@",usermodel.avatar_large);
        
        if (successBlock) {
            successBlock(usermodel);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        
    }];
}

@end



@implementation FriendsListModel

+ (void)setup {
    [FriendsListModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"user" : @"UserModel",
                 };
    }];
}

+ (instancetype)initWithJSONString:(NSString *)jsonString {
    [FriendsListModel setup];
    [UserModel setUp];
    
    FriendsListModel *list = [[FriendsListModel alloc] init];
    list.users = [NSArray array];
    
    
    list = [FriendsListModel mj_objectWithKeyValues:jsonString];
    
    NSMutableArray <UserModel *> *array = [[NSMutableArray alloc] initWithCapacity:list.users.count];
    for (UserModel *model in list.users) {
        UserModel *m = [UserModel userModelWithObject:model];
        [array addObject:m];
    }
    list.users = array;
    
    return list;
}

@end