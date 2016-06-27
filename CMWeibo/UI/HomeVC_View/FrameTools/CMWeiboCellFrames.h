//
//  CMWeiboCellFrames.h
//  CMWeibo
//
//  Created by jiachen on 16/5/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  布局微博Cell
/*
 将富文本在这里创建的目的是 ，富文本创建和更改比较耗时，所以放在这里
 */

#import <Foundation/Foundation.h>
#import "DateTools.h"
#import "OperationBar.h"


@class WeiboList;
@class WeiboModel;

@interface CMWeiboCellFrames : NSObject

// MARK:参数
@property (strong, nonatomic) WeiboModel *model;

// MARK:返回值

/// cell高度
@property (assign, nonatomic) CGFloat cellHeight;

/// 名称frame计算
@property (assign, nonatomic) CGRect nameLabelFrame;

@property (assign, nonatomic) CGRect publishTimeFrame;

/// 正文frame 计算
@property (assign, nonatomic) CGRect contentFrame;

/** 回复、转发的微博 父控件Frame */
@property (assign, nonatomic) CGRect cornerViewFrame;

/** 回复、转发的微博 富文本Frame*/
@property (assign, nonatomic) CGRect retweetedTextFrame;

//@property (assign, nonatomic) CGRect 

/// 图片容器大小
@property (assign, nonatomic) CGRect imageViewContainerFrame;

@property (assign, nonatomic) CGPoint operationBarOrigin;

@property (assign, nonatomic) CGPoint operationToolBarOrigin;

/// 微博来源label
@property (assign, nonatomic) CGRect sourceFrame;
//

// MARK:调用方法

/**
 *  返回单个model对应的Frames
 *
 *  @param model 微博model
 *
 *  @return 对应的frames
 */
+ (instancetype)cellFramesWithWeiboModel:(WeiboModel *)model;

/**
 *  请求一次，获取多条微博的cellFrames
 *
 *  @param list 微博列表
 *
 *  @return 微博列表中的model对应的cellFrames 放到一个数组里面
 */
+ (NSArray *)frameArrayWithWeiboList:(WeiboList *)list;



@end
