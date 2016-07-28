//
//  WeiboImageViewContainer.h
//  CMWeibo
//
//  Created by jiachen on 16/5/26.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  微博cell中的图片容器

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

typedef void(^ClickImageBlock)(NSInteger imageTag);

@interface WeiboImageViewContainer : UIView

//显示微博列表中的微博图片
@property (strong, nonatomic) NSArray<PicModel *> *imageUrls;

//填写微博正文选择的图片
@property (strong, nonatomic) NSArray <UIImage *> *imageSources;

- (instancetype)initWithWidth:(CGFloat)viewWidth;

@property (copy, nonatomic) ClickImageBlock clickImageBlock;

@property (assign, readonly, nonatomic) NSInteger imageCount;

@end
