//
//  ShowLargeImageView.h
//  CMWeibo
//
//  Created by jiachen on 16/5/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  显示大图

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface ShowLargeImageView : UIView

@property (copy, nonatomic) NSArray <PicModel *> *imageArray;

+ (instancetype)shareInstance;
- (void)showWithImageSource:(NSArray *)imageArray;

@property (assign, nonatomic) NSInteger currentIndex;

@end
