//
//  OperationBar.h
//  CMWeibo
//
//  Created by jiachen on 16/5/24.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  微博cell，最下方操作栏，显示 赞的数量、转发的数量、评论的数量，显示操作栏的button

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OperationBarEvent_Show,
    OperationBarEvent_Close,
} OperationBarEvent;

typedef void(^ShowOperationButtonBlock)(OperationBarEvent);

@interface OperationBar : UIView

@property (strong, nonatomic) NSArray *countArray;

@property (copy, nonatomic) ShowOperationButtonBlock showOperationButtonBlock;

@end
