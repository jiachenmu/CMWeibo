//
//  CMWeiboCellFrames.m
//  CMWeibo
//
//  Created by jiachen on 16/5/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMWeiboCellFrames.h"
#import "WeiboModel.h"
#import "WeiboList.h"
#import "WeiboAttributerString.h"

#define ContentTopMargin   10
#define ContentLeftMargin  59
#define ContentRightMargin 16

#define ImageViewContainerTopMargin 10
/// 容器左右边距
#define ImageViewMargin 5

#define NameLabelTopMargin 13

#define PublishRightMargin 10
#define PublishTopMargin   15

#define RetweetedLeftMargin 10
#define RetweetedTopMargin 13
#define RetweetedBottomMargin 12

#define OperationBarRightMargin  15
#define OperationBarTopMargin    12
#define OperationBarBottomMargin 16

@implementation CMWeiboCellFrames


//计算各个控件的frame
- (void)calculateFrame {
    
    CGSize size = CGSizeZero;
    
    //用户名称label frame
    NSString *name = _model.user.screen_name;
    size = CM_TEXTSIZE(name, Font(14));
    _nameLabelFrame = CGRectMake(ContentLeftMargin, NameLabelTopMargin, size.width, size.height);
    
    //发表时间label frame计算
    NSString *publishTime = [DateTools dateWithString:_model.created_at];
    size = CM_TEXTSIZE(publishTime, Font(12));
    _publishTimeFrame = CGRectMake(SCREEN_WIDTH - size.width - PublishRightMargin, PublishTopMargin, size.width, size.height);
    
    //正文计算 ********(重点)********
    /*
     此处微博分为两种：
     1. 原创微博
     2. 转发微博
     */
    NSString *contentText = _model.text;
    
    size = CM_MULTILINE_TEXTSIZE(contentText, Font(16), CGSizeMake((SCREEN_WIDTH - ContentLeftMargin - ContentRightMargin), CGFLOAT_MAX), 0);
    _contentFrame = CGRectMake(ContentLeftMargin, CGRectGetMaxY(_nameLabelFrame) + ContentTopMargin, size.width, size.height);
    
    //图片容器 **********************
    if (_model.pic_urls.count > 0) {
        NSInteger line_num = _model.pic_urls.count <= 3 ? 1 : ceil(_model.pic_urls.count / 3.0);
        //图片宽度高度
        CGFloat imageWidth = (SCREEN_WIDTH - ContentLeftMargin - ContentRightMargin - 2 * ImageViewMargin) / 3;
        _imageViewContainerFrame = CGRectMake(ContentLeftMargin, CGRectGetMaxY(_contentFrame) + ImageViewContainerTopMargin, SCREEN_WIDTH - ContentLeftMargin - ContentRightMargin, line_num * imageWidth + (line_num + 1) * ImageViewMargin);
    }else {
        _imageViewContainerFrame = CGRectZero;
    }
    
    //回复、转发的微博 **********************
    if (_model.retweeted_status) {
        NSString *str = [_model.retweeted_status.text stringByAppendingString:[NSString stringWithFormat:@"\n转发(%ld) | 评论(%ld)",_model.reposts_count,_model.comments_count]];
        size = CM_MULTILINE_TEXTSIZE(_model.retweeted_status.text, Font(16), CGSizeMake((SCREEN_WIDTH - ContentLeftMargin - ContentRightMargin), CGFLOAT_MAX), 0);
        _retweetedTextFrame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    
    //Bar ********************
//    _operationBarOrigin =
    OperationBar *bar = [[OperationBar alloc] init];
    bar.countArray =  @[@(_model.attitudes_count),@(_model.reposts_count),@(_model.comments_count)];
    _operationBarOrigin = CGPointMake(SCREEN_WIDTH - bar.frame.size.width - OperationBarRightMargin, CGRectGetMaxY(_model.pic_urls.count > 0 ? _imageViewContainerFrame : _contentFrame) + OperationBarTopMargin);
    
    
    _cellHeight = _operationBarOrigin.y + 20 + OperationBarBottomMargin;
    
    //ToolBar origin
    _operationToolBarOrigin = CGPointMake(SCREEN_WIDTH/2 - 125, _cellHeight - 40 - 8);
    
    size = CM_TEXTSIZE(_model.source, Font(12));
    _sourceFrame = CGRectMake(ContentLeftMargin, _cellHeight - 16 - 12, size.width, size.height);
}

- (void)setModel:(WeiboModel *)model {
    _model = model;
    
    //开始计算高度
    [self calculateFrame];
}


#pragma mark - 调用方法


+ (instancetype)cellFramesWithWeiboModel:(WeiboModel *)model {
    CMWeiboCellFrames *cellFrames = [[CMWeiboCellFrames alloc] init];
    cellFrames.model = model;
    return cellFrames;
}


+ (NSArray *)frameArrayWithWeiboList:(WeiboList *)list {
    NSMutableArray *frameArray = [[NSMutableArray alloc] initWithCapacity:list.statuses.count];
    for (int i = 0; i < list.statuses.count; i++) {
        CMWeiboCellFrames *frame = [[CMWeiboCellFrames alloc] init];
        frame.model = [list.statuses objectAtIndex:i];
        [frameArray addObject:frame];
    }
    
    return frameArray;
}
@end
