//
//  CMBaseViewController.h
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCache.h"

@interface CMBaseViewController : UIViewController

/// 弹出视图 初始化方法
- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle;

- (void)barCancel;

-(void)barOK;

- (void)userAuthorizeSuccess:(NSNotification *)notify;


#pragma mark - quick method
// 快速构建button
- (UIButton *)buttonWithImage:(UIImage *)normaleImage SelectedImage:(nullable UIImage *)selectedImage Frame:(CGRect)frame;


@end
