//
//  CMLocationViewController.h
//  CMWeibo
//
//  Created by jiachenmu on 16/7/26.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  获取位置，发表微博是添加位置

#import "CMBaseViewController.h"

typedef void(^SelectPlaceBlock)(NSString *place);

@interface CMLocationViewController : CMBaseViewController

@property (copy, nonatomic) SelectPlaceBlock selectPlaceBlock;

@end
