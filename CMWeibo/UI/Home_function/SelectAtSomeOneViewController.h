//
//  SelectAtSomeOneViewController.h
//  CMWeibo
//
//  Created by jiachen on 16/6/7.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  转发微博时，选择@的对象，正文中 "@某人"

#import "CMBaseViewController.h"

typedef void (^SelectAtNameArrayBlock)(NSString *);

@interface SelectAtSomeOneViewController : CMBaseViewController

@property (copy, nonatomic) SelectAtNameArrayBlock selectAtNameArrayBlock;

@end
