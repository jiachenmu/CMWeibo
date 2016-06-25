//
//  CMView.m
//  CMWeibo
//
//  Created by 贾宸穆 on 16/6/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMView.h"

@implementation CMView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewWithBackgroundColor:(UIColor *)color {
    CMView *view = [CMView new];
    view.backgroundColor = color;
    
    return view;
}

@end
