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
@class CMButton;

//CMButton点击事件的处理
typedef void(^CMButtonClickBlock)(NSInteger tag);

//CMButton各种state的Block
typedef void(^CMButtonStateBlock)(NSInteger tag, CMButton *sender);

//CMButton的文字位置
typedef NS_ENUM(NSInteger, CMButtonTitleType) {
    CMButtonTitleTypeLeft = 0,
    CMButtonTitleTypeCenter,
    CMButtonTitleTypeRight = 0
};



/* 系统按钮自带的状态
typedef NS_OPTIONS(NSUInteger, UIControlState) {
    UIControlStateNormal       = 0,
    UIControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
    UIControlStateDisabled     = 1 << 1,
    UIControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
    UIControlStateFocused NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 3, // Applicable only when the screen supports focus
    UIControlStateApplication  = 0x00FF0000,              // additional flags available for application use
    UIControlStateReserved     = 0xFF000000               // flags reserved for internal framework use
};
 */

/// : CMButton的按钮状态
typedef NS_ENUM(NSInteger, CMControlState) {
    CMControlStateNormal       = 0,
    CMControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
    CMControlStateDisabled     = 1 << 1,
    CMControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
    CMControlStateFocused NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 3, // Applicable only when the screen supports focus
    CMControlStateApplication  = 0x00FF0000,              // additional flags available for application use
    CMControlStateReserved     = 0xFF000000,               // flags reserved for internal framework use
    
    CMControlStateNetworkRequest = 10001,               //正在进行网络请求。。
    CMControlStateRequestSuccess = 10002,               //网络请求成功
    CMControlStateRequestFaliure = 10003,               //网络请求失败
    
    //tip: 可以添加很多相应的状态，显示对应的文字或图片
};

@interface CMButton : UIControl

/** imageView */
@property (strong, nonatomic) UIImageView *imageView;

/** titleLabel */
@property (strong, nonatomic) UILabel *titleLabel;

/** 点击事件处理 */
@property (copy, nonatomic) CMButtonClickBlock clickBlock;


///  title
- (void)setTitle:(NSString * )title forState:(CMControlState)state;

- (void)setTitleColor:(UIColor *)titleColor forState:(CMControlState)state;

- (void)setTitleFont:(UIFont *)font;

- (void)setTitleLabelFrame:(CGRect)labelFrame;

/// event
- (void)setAction:(CMButtonClickBlock)cmButtonClickBlock forControlEvents:(UIControlEvents)event;

- (void)setControlState:(CMControlState)state;



/** setControlState...WithAction:... */
- (void)setControlState:(CMControlState)state Duration:(NSTimeInterval)delay WithAction:(CMButtonStateBlock)block;

/// image
- (void)setImage:(UIImage *)image forState:(CMControlState)state;
- (void)setImageViewFrame:(CGRect)imgFrame;



@end
