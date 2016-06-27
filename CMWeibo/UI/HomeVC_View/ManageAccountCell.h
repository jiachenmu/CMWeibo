//
//  ManageAccountCell.h
//  CMWeibo
//
//  Created by 贾宸穆 on 16/6/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  管理已保存的帐号Cell

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef void(^SelectUserBlock)(void);

@interface ManageAccountCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tablewView Model:(UserModel *)model;

@property (copy, nonatomic) SelectUserBlock selectUserBlock;

@end
