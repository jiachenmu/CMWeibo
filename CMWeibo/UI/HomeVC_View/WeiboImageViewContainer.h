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

@property (strong, nonatomic) NSArray<PicModel *> *imageUrls;

- (instancetype)initWithWidth:(CGFloat)viewWidth;

@property (copy, nonatomic) ClickImageBlock clickImageBlock;

@end
