//
//  ManageAccountCell.h
//  CMWeibo
//
//  Created by 贾宸穆 on 16/6/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  管理已保存的帐号Cell

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ManageAccountCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tablewView Model:(UserModel *)model;

@end
