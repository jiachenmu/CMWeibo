//
//  CMSharpCornerView.m
//  CMWeibo
//
//  Created by jiachen on 16/6/22.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMSharpCornerView.h"

@interface CMSharpCornerView()

/// 边框颜色
@property (strong, nonatomic) UIColor *borderColor;

/// 边框宽度
@property (assign, nonatomic) CGFloat borderWidth;

/// 填充颜色
@property (strong, nonatomic) UIColor *fillColor;

/// 尖角的左间距
@property (assign, nonatomic) CGFloat leftMargin;

/// 尖角的高度
@property (assign, nonatomic) CGFloat angleHeight;

/// 尖角的宽度
@property (assign, nonatomic) CGFloat angleWidth;

@end

@implementation CMSharpCornerView

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat )borderWidth FillColor:(UIColor *)fillColor AngleLeftMargin:(CGFloat)angleLeftMargin AngleWidth:(CGFloat)angleWidth AngleHeight:(CGFloat)angleHeight{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderColor = borderColor;
        self.borderWidth = borderWidth;
        self.fillColor = fillColor;
        self.leftMargin = angleLeftMargin;
        self.angleHeight = angleHeight;
        self.angleWidth = angleWidth;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame AngleLeftMargin:(CGFloat)angleLeftMargin AngleWidth:(CGFloat)angleWidth AngleHeight:(CGFloat)angleHeight {
    return [[CMSharpCornerView alloc] initWithFrame:frame BorderColor:[UIColor colorWithHex:0x969696] BorderWidth:0.5 FillColor:[UIColor colorWithHex:0xF1F1F1] AngleLeftMargin:angleLeftMargin AngleWidth:angleWidth AngleHeight:angleHeight];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

//绘制边框
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    
    //
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    CGContextSetLineWidth(context, _borderWidth);//  线宽
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGPoint sPoint[7];//    坐标点
    sPoint[0] = CGPointMake(0, _angleHeight);
    sPoint[1] = CGPointMake(sPoint[0].x + _leftMargin, _angleHeight);
    sPoint[2] = CGPointMake(sPoint[1].x + _angleWidth/2, 0.0);
    sPoint[3] = CGPointMake(sPoint[2].x + _angleWidth/2, _angleHeight);
    sPoint[4] = CGPointMake(width - 0, _angleHeight);
    sPoint[5] = CGPointMake(sPoint[4].x, height - 0);
    sPoint[6] = CGPointMake(0, sPoint[5].y);
    
    CGContextAddLines(context, sPoint, 7);//    添加线
    CGContextClosePath(context);//  封起来
    
    
    CGContextSetFillColorWithColor(context, _fillColor.CGColor); //  填充颜色
    CGContextDrawPath(context, kCGPathFillStroke);  //  根据坐标绘制路径
}


@end
