//
//  CMSharpCornerView.h
//  CMWeibo
//
//  Created by jiachen on 16/6/22.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  有尖角的view

/*
 tips: .m文件中对各个属性有解释 
 */

#import <UIKit/UIKit.h>


@interface CMSharpCornerView : UIView


- (instancetype)initWithFrame:(CGRect)frame BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat )borderWidth FillColor:(UIColor *)fillColor AngleLeftMargin:(CGFloat)angleLeftMargin AngleWidth:(CGFloat)angleWidth AngleHeight:(CGFloat)angleHeight;

- (instancetype)initWithFrame:(CGRect)frame AngleLeftMargin:(CGFloat)angleLeftMargin AngleWidth:(CGFloat)angleWidth AngleHeight:(CGFloat)angleHeight;

- (void)setFillColor:(UIColor *)fillColor;

@end
