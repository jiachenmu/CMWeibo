//
//  WeiboImageViewContainer.m
//  CMWeibo
//
//  Created by jiachen on 16/5/26.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "WeiboImageViewContainer.h"

/// 容器左右边距
#define ImageViewMargin 5

/// 这里最多显示9张图片

@interface WeiboImageViewContainer()

/// 容器宽度
@property (assign, nonatomic) CGFloat viewWidth;

/// 图片宽度
@property (assign, nonatomic) CGFloat imageWidth;

@property (strong, nonatomic) YYAnimatedImageView *imgView0;
@property (strong, nonatomic) YYAnimatedImageView *imgView1;
@property (strong, nonatomic) YYAnimatedImageView *imgView2;
@property (strong, nonatomic) YYAnimatedImageView *imgView3;
@property (strong, nonatomic) YYAnimatedImageView *imgView4;
@property (strong, nonatomic) YYAnimatedImageView *imgView5;
@property (strong, nonatomic) YYAnimatedImageView *imgView6;
@property (strong, nonatomic) YYAnimatedImageView *imgView7;
@property (strong, nonatomic) YYAnimatedImageView *imgView8;

@property (strong, nonatomic) NSMutableArray <YYAnimatedImageView *> *imgViewArray;

@end

@implementation WeiboImageViewContainer

- (instancetype)initWithWidth:(CGFloat)viewWidth
{
    self = [super init];
    if (self) {
        self.clipsToBounds = true;
        _viewWidth = viewWidth;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    _imageCount = 0;
    _imgViewArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    _imgView0 = [[YYAnimatedImageView alloc] init];
    _imgView1 = [[YYAnimatedImageView alloc] init];
    _imgView2 = [[YYAnimatedImageView alloc] init];
    _imgView3 = [[YYAnimatedImageView alloc] init];
    _imgView4 = [[YYAnimatedImageView alloc] init];
    _imgView5 = [[YYAnimatedImageView alloc] init];
    _imgView6 = [[YYAnimatedImageView alloc] init];
    _imgView7 = [[YYAnimatedImageView alloc] init];
    _imgView8 = [[YYAnimatedImageView alloc] init];
    
    [_imgViewArray addObject:_imgView0];
    [_imgViewArray addObject:_imgView1];
    [_imgViewArray addObject:_imgView2];
    [_imgViewArray addObject:_imgView3];
    [_imgViewArray addObject:_imgView4];
    [_imgViewArray addObject:_imgView5];
    [_imgViewArray addObject:_imgView6];
    [_imgViewArray addObject:_imgView7];
    [_imgViewArray addObject:_imgView8];
    
    _imageWidth = (_viewWidth - 2 * ImageViewMargin) / 3;
    
    CGFloat originX = 0;
    CGFloat originY = 5;
    for (int i = 0; i < _imgViewArray.count; i++) {
        if (i == 3 || i == 6) {
            originX = 0;
            originY += _imageWidth+5;
        }
        _imgViewArray[i].frame = CGRectMake(originX, originY, _imageWidth, _imageWidth);
        _imgViewArray[i].autoPlayAnimatedImage = true;
        _imgViewArray[i].userInteractionEnabled = true;
        _imgViewArray[i].clipsToBounds = true;
        _imgViewArray[i].contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgViewArray[i]];
        //对每个iageView 上添加一个UIControl
        UIControl *control = [[UIControl alloc] initWithFrame:_imgViewArray[i].bounds];
        control.tag = i;
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        [_imgViewArray[i] addSubview:control];
        
        
        originX += _imageWidth+5;
    }
}

//显示微博列表图片
- (void)setImageUrls:(NSArray *)imageUrls {
    _imageUrls = imageUrls;
    _imageCount = imageUrls.count;
    if (_imageUrls.count > 0 ) {
        [_imgViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YYAnimatedImageView *imgView = (YYAnimatedImageView *)obj;
            if (idx > _imageUrls.count - 1) {
                imgView.hidden = true;
            }else {
                imgView.hidden = false;
                PicModel *pic = [PicModel picModelWithObject:_imageUrls[idx]];
                
                [imgView yy_setImageWithURL:[NSURL URLWithString:pic.large_pic] placeholder:nil options:YYWebImageOptionUseNSURLCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    //CMCache 缓存下已经请求的图片
                    [[CMCache imageCache] setObject:image forKey:pic.large_pic];
                }];
            }
        }];
    }
}

//显示相册中选择的图片
- (void)setImageSources:(NSArray *)imageSources {
    _imageCount = imageSources.count;
    _imageSources = imageSources;
    if (imageSources.count == 0) {
        [_imgViewArray enumerateObjectsUsingBlock:^(YYAnimatedImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YYAnimatedImageView *imgView = (YYAnimatedImageView *)obj;
            imgView.hidden = true;
        }];
        return;
    }else {
        [_imgViewArray enumerateObjectsUsingBlock:^(YYAnimatedImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YYAnimatedImageView *imgView = (YYAnimatedImageView *)obj;
            if (idx > _imageSources.count - 1) {
                imgView.hidden = true;
            }else {
                imgView.hidden = false;
                [imgView setImage:imageSources[idx]];
            }
        }];
    }
}

#pragma mark - 事件处理

- (void)clickImage:(UIControl *)ctrl {
    if (_clickImageBlock) {
        _clickImageBlock(ctrl.tag);
    }
}


@end
