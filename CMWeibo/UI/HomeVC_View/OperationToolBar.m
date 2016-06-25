//
//  OperationToolBar.m
//  CMWeibo
//
//  Created by jiachen on 16/5/31.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "OperationToolBar.h"
#import "User.h"
#import "FavoriteModel.h"
#import "DateTools.h"

#define kToolBarWidth  250
#define kToolBarHeight 40

#define kButtonWidth 18

@interface OperationToolBar()

@property (strong, nonatomic) WeiboModel *model;

@end

@implementation OperationToolBar {
    UIButton *favoriteBtn;
    UIButton *optInBtn;
    UIButton *repostBtn;
    UIButton *commentBtn;
    NSArray <UIButton *> *btnArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kToolBarWidth, kToolBarHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 16.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        [self buildToolbar];
        
        //在这里直接请求收藏列表
        [FavoriteList currentFavoriteList];
    }
    return self;
}
- (void)buildToolbar {
    favoriteBtn = [[UIButton alloc] init];
    [favoriteBtn setImage:[UIImage imageNamed:@"CellFavorite"] forState:UIControlStateNormal];
    [favoriteBtn setImage:[UIImage imageNamed:@"CellFavorite_selected"] forState:UIControlStateSelected];
    
    optInBtn = [[UIButton alloc] init];
    [optInBtn setImage:[UIImage imageNamed:@"WeiboCellOptIn"] forState:UIControlStateNormal];
    [optInBtn setImage:[UIImage imageNamed:@"WeiboCellOptIn_selected"] forState:UIControlStateSelected];
    
    repostBtn = [[UIButton alloc] init];
    [repostBtn setImage:[UIImage imageNamed:@"WeiBoCellRepost"] forState:UIControlStateNormal];
    
    commentBtn = [[UIButton alloc] init];
    [commentBtn setImage:[UIImage imageNamed:@"WeiboCellComment"] forState:UIControlStateNormal];
    
    btnArray = [NSArray arrayWithObjects:favoriteBtn,optInBtn,repostBtn,commentBtn, nil];
    
    //计算按钮间距
    CGFloat margin = (kToolBarWidth - 4 *kButtonWidth - 2 * 16 - 2 * 15) / 3;
    CGFloat originX = 16 + 15;
    [btnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(originX + (kButtonWidth + margin) * idx, 11, kButtonWidth, kButtonWidth);
        obj.tag = idx;
        [obj addTarget:self action:@selector(clickEventHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:obj];
    }];
}

#pragma mark - 点击事件处理
- (void)clickEventHandle:(UIButton *)sender {
    WBClickEventType type = WBClickEventTypeFavorite;
    switch (sender.tag) {
        case 0:
            type = WBClickEventTypeFavorite;
            if (sender.selected == true) {
                //取消收藏
                [self cancelMyFavorite];
            }else {
                //添加收藏
                [self addToMyfavorite];
            }
            break;
        case 1:
            type = WBClickEventTypeOptIn;
            [SVProgressHUD showErrorWithStatus:@"暂时没有找到这个接口~"];
            break;
        case 2:
            /// 转发微博
            type = WBClickEventTypeRepost;
            break;
        case 3:
            type = WBClickEventTypeComment;
            break;
        default:
            break;
    }
    sender.selected = !sender.selected;
    self.hidden = true;
    if (_eventHandleBlock) {
        _eventHandleBlock(type);
    }
}

/// 添加收藏
- (void)addToMyfavorite {
    Weakself;
    [CMNetwork addFavoriteWithWeiboID:_model.idstr success:^(NSString * _Nonnull jsonString) {
        //收藏成功 刷新tableview
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FavoriteSuccess object:weakself.model.idstr];
        btnArray[0].selected = true;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        btnArray[0].selected = false;
    }];
}

/// 取消收藏
- (void)cancelMyFavorite {
//    Weakself;
    [CMNetwork cancelFavoriteWithWeiboID:_model.idstr success:^(NSString * _Nonnull jsonString) {
        //取消成功 更新收藏列表
        [FavoriteList currentFavoriteList];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/// 更新UI
- (void)setModel:(WeiboModel *)model {
    _model = model;
    //检测当前微博有没有被收藏
    if ([FavoriteList isHasFavoritedWithWeiboID:_model.idstr]) {
        btnArray[0].selected = true;
    }else {
        btnArray[0].selected = false;
    }
}

#define ViewBottomMargin 8

- (void)showWithWeiModel:(WeiboModel *)model {
    self.hidden = false;
    self.model = model;
}


- (void)close {
    self.hidden = true;
}

@end
