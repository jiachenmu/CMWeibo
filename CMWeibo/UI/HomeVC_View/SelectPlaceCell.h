//
//  SelectPlaceCell.h
//  CMWeibo
//
//  Created by jiachenmu on 16/7/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  定位后 选择当前位置cell

#import <UIKit/UIKit.h>
#import "CMLocationModel.h"

@interface SelectPlaceCell : UITableViewCell

@property (strong, nonatomic) PoistionNearByModel *poisInfo;

@property (strong, nonatomic) CMLocationModel *model;

@end
