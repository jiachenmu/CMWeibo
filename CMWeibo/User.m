//
//  User.m
//  CMWeibo
//
//  Created by jiachen on 16/5/16.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "User.h"

@implementation User

// Insert code here to add functionality to your managed object subclass

static User *instance;
+ (instancetype)currentUser {
    [[CoreDataManager shareInstance ]arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable userArray) {
        instance = [userArray lastObject];
    }];

    return instance;
}

@end
