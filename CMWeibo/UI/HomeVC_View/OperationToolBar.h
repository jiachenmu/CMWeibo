//
//  OperationToolBar.h
//  CMWeibo
//
//  Created by jiachen on 16/5/31.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  点击cell中的 向做箭头 弹出这个toolBar 进行赞、 收藏、转发、评论

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

typedef void(^EventHandleBlock)(WBClickEventType);

@interface OperationToolBar : UIView


- (void)showWithWeiModel:(WeiboModel *)model;

- (void)close;

@property (copy, nonatomic) EventHandleBlock eventHandleBlock;

@end
