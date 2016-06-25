//
//  WeiboCell.m
//  CMWeibo
//
//  Created by jiachen on 16/5/24.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "WeiboCell.h"
#import "OperationBar.h"

#import "CMWeiboCellFrames.h"
#import "WeiboImageViewContainer.h"
#import "WeiboAttributerString.h"
#import "ShowLargeImageView.h"

// MARK: 尺寸标注
#define UserImgViewLeftMargin 5
#define UserImgViewTopMargin  10
#define UserImgViewWidth      42

#define OperationBarRightMargin 15
#define OperationBarBottomMargin 16

#define ContentLeftmargin 12

#define NameLabelTopMargin 13

@interface WeiboCell()

// - MARK: 控件

/// 头像
@property (strong, nonatomic) UIImageView *imgView;

/// 姓名
@property (strong, nonatomic) UILabel *nameLabel;

/// 发布时间
@property (strong, nonatomic) UILabel *publishTimeLabel;

/// 正文内容
@property (strong, nonatomic) YYLabel *contentLabel;

/// 图片容器
@property (strong, nonatomic) WeiboImageViewContainer *imgViewContainer;

/// 来源label
@property (strong, nonatomic) UILabel *soureceLabel;

/// 评论、转发、参与数
@property (strong, nonatomic) OperationBar *bar;
/// 点击评论、转发微博、赞按钮工具栏显示
@property (strong, nonatomic) OperationToolBar *toolBar;

// -MARK: frame
@property (strong, nonatomic) CMWeiboCellFrames *cellFrames;

@end


@implementation WeiboCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(UserImgViewLeftMargin, UserImgViewTopMargin, UserImgViewWidth, UserImgViewWidth)];
    _imgView.layer.cornerRadius = UserImgViewWidth/2;
    _imgView.clipsToBounds = true;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imgView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = Font(14);
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _publishTimeLabel = [[UILabel alloc] init];
    _publishTimeLabel.font = Font(12);
    _publishTimeLabel.textColor = [UIColor colorWithHex:0x9a9a9a];
    [self.contentView addSubview:_publishTimeLabel];
    
    _contentLabel = [[YYLabel alloc] init];
    _contentLabel.displaysAsynchronously = true;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = Color_ContentText;
    _contentLabel.font = Font(16);
    [self.contentView addSubview:_contentLabel];
    
    _imgViewContainer = [[WeiboImageViewContainer alloc] initWithWidth:(SCREEN_WIDTH - 59 - 16)];
    Weakself;
    _imgViewContainer.clickImageBlock = ^(NSInteger imageTag){
        NSLog(@"点击是第 %ld 张图片",imageTag);
        [[ShowLargeImageView shareInstance] showWithImageSource:weakself.model.pic_urls];
        [ShowLargeImageView shareInstance].currentIndex = imageTag;
    };
    [self.contentView addSubview:_imgViewContainer];
    
    _bar = [[OperationBar alloc] init];
    _bar.showOperationButtonBlock = ^(OperationBarEvent event){
        //event 分为两种 显示工具栏 / 隐藏工具栏
        if (event == OperationBarEvent_Show) {
            [weakself.toolBar showWithWeiModel:weakself.model];
        }else {
            [weakself.toolBar close];
        }
    };
    [self.contentView addSubview:_bar];
    
    _toolBar = [[OperationToolBar alloc] init];
    _toolBar.hidden = true;
    _toolBar.eventHandleBlock = ^(WBClickEventType type){
        if (weakself.eventHandleBlock) {
            weakself.eventHandleBlock(type);
        }
    };
    [self.contentView addSubview:_toolBar];
    
    _soureceLabel = [[UILabel alloc] init];
    _soureceLabel.textColor = Color_ContentText;
    _soureceLabel.font = Font(12);
    [self.contentView addSubview:_soureceLabel];
}


#pragma mark - 更新UI

- (void)setModel:(WeiboModel *)model {
    _model = model;

    _bar.countArray = @[@(_model.attitudes_count),@(_model.reposts_count),@(_model.comments_count)];
    
    [_imgView yy_setImageWithURL:[NSURL URLWithString:_model.user.avatar_hd] placeholder:nil options:YYWebImageOptionIgnoreAnimatedImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        //CMCache 缓存下已经请求的头像
        [[CMCache imageCache] setObject:image forKey:_model.user.avatar_hd];
    }];
    
    _nameLabel.text = _model.user.screen_name;
    _publishTimeLabel.text = [DateTools dateWithString:_model.created_at];
    _contentLabel.text = _model.text;
    
    _contentLabel.attributedText = [WeiboAttributerString attributeStringWithWeiboModel:_model TapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSString *str = [text.string substringWithRange:range];
        NSLog(@"点击的文本 :%@",str);
        WBClickEventType eventType;
        if ([str containsString:@"#"]) {
            eventType = WBClickEventTypeTopic;
        }else if([str containsString:@"http"]) {
            eventType = WBClickEventTypeHttpURl;
        }else {
            eventType = WBClickEventTypeAtSomeOne;
        }
            
        if ([_delegate respondsToSelector:@selector(cm_weiboCellContentClickEventHandleWithContainerView:Text:Rect:EventType:)]) {
            [_delegate cm_weiboCellContentClickEventHandleWithContainerView:containerView Text:str Rect:rect EventType:eventType];
        }
    }];
    
    _imgViewContainer.imageUrls = _model.pic_urls;
    
    _soureceLabel.text = _model.source;
}

- (void)setCellFrames:(CMWeiboCellFrames *)cellFrames {
    _cellFrames = cellFrames;
    
    _nameLabel.frame = _cellFrames.nameLabelFrame;
    _publishTimeLabel.frame = _cellFrames.publishTimeFrame;
    _contentLabel.frame = _cellFrames.contentFrame;
    
    _imgViewContainer.frame = _cellFrames.imageViewContainerFrame;
    
    CGRect frame = _bar.frame;
    frame.origin = _cellFrames.operationBarOrigin;
    _bar.frame = frame;
    
    frame = _toolBar.frame;
    frame.origin = _cellFrames.operationToolBarOrigin;
    _toolBar.frame = frame;
    
    _soureceLabel.frame = _cellFrames.sourceFrame;
}

#pragma mark - 类方法返回cell

#define WeiboCellID @"WeiboCellIdentifier"

+ (instancetype)cellWithTableView:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath WeiboModel:(WeiboModel *)model{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:WeiboCellID];
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = model;
    cell.cellFrames = model.cellFrames;
    
    return cell;
}
@end
