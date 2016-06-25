//
//  User+CoreDataProperties.h
//  CMWeibo
//
//  Created by jiachen on 16/5/20.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *wbCurrentUserID;
@property (nullable, nonatomic, retain) NSString *wbRefreshToken;
@property (nullable, nonatomic, retain) NSString *wbtoken;
@property (nullable, nonatomic, retain) NSDate *expirationDate;

@end

NS_ASSUME_NONNULL_END
