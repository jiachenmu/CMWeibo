//
//  WeiboCell.h
//  CMWeibo
//
//  Created by jiachen on 16/5/24.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  重头戏- 微博展示cell

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "OperationToolBar.h"

@class CMWeiboCellFrames;

@protocol WeiboCellDelegate <NSObject>

/// 微博正文中的点击事件
- (void)cm_weiboCellContentClickEventHandleWithContainerView:(UIView *)containerView Text:(NSString * )text Rect:(CGRect)rect EventType:(WBClickEventType)clickType;

@end


@interface WeiboCell : UITableViewCell

@property (strong, nonatomic) WeiboModel *model;

@property (weak, nonatomic) id <WeiboCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath WeiboModel:(WeiboModel *)model;

@property (copy, nonatomic) EventHandleBlock eventHandleBlock;

@end
