//
//  User.h
//  CMWeibo
//
//  Created by jiachen on 16/5/16.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

/// 当前默认的用户
+ (instancetype)currentUser;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
