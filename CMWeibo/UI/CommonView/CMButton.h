//
//  CMButton.h
//  CMWeibo
//
//  Created by jiachen on 16/6/17.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  用UIView封装一个button
/*
    使用方法与button没有区别
 */

#import <UIKit/UIKit.h>

//CMButton点击事件的处理
typedef void(^CMButtonClickBlock)(NSInteger tag);

//CMButton的文字位置
typedef NS_ENUM(NSInteger, CMButtonTitleType) {
    CMButtonTitleTypeLeft = 0,
    CMButtonTitleTypeCenter,
    CMButtonTitleTypeRight = 0
};

@interface CMButton : UIControl

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

/// 点击事件处理
@property (copy, nonatomic) CMButtonClickBlock clickBlock;


///  title
- (void)setTitle:(NSString *)title forState:(UIControlState)state;

- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state;

- (void)setTitleFont:(UIFont *)font;

- (void)setTitleLabelFrame:(CGRect)labelFrame;

/// event
- (void)setAction:(CMButtonClickBlock)cmButtonClickBlock forControlEvents:(UIControlEvents)event;

- (void)setControlState:(UIControlState)state;

/// image
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setImageViewFrame:(CGRect)imgFrame;



@end
