//
//  RepostViewController.m
//  CMWeibo
//
//  Created by jiachen on 16/6/6.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "RepostViewController.h"
#import "SelectAtSomeOneViewController.h"
#import <WXApiObject.h>

#define InputContentViewLeftMargin 10
#define kBottomBarHeight           75
#define kBottomBarLeftMargin       27

@interface RepostViewController() <YYTextViewDelegate, YYTextKeyboardObserver>

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) YYTextView *textView;

@property (strong, nonatomic) UIView *bottomBar;

@property (strong, nonatomic) UIButton *isAtAuthorBtn;
@property (strong, nonatomic) UIButton *topicBtn;
@property (strong, nonatomic) UIButton *atSomeoneBtn;
@property (strong, nonatomic) UIButton *emoticonBtn;
@property (strong, nonatomic) UIButton *shareBtn;

@end

@implementation RepostViewController

- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle {
    if (self = [super initWithLeftTitle:leftTitle RightTitle:rightTitle]) {
        [self initIconView];
        
        [self initTextView];
        
        [self initBottomBar];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
    
   
    
    //检查是否保存了草稿
    if ([[CMCache draftsCache] objectForKey:_model.idstr]) {
        DraftsModel *m = [[CMCache draftsCache] objectForKey:_model.idstr];
        _textView.text = m.wbContent;
        _isAtAuthorBtn.selected = m.isComment;
    }
}

#pragma mark - Build UI

- (void)initIconView {
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    _iconView.layer.cornerRadius = 33.0/2.0;
    _iconView.clipsToBounds = true;
    _iconView.layer.masksToBounds = true;
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = _iconView;
}

- (void)initTextView {
    _textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    _textView.extraAccessoryViewHeight = kBottomBarHeight;
    _textView.font = Font(16);
    _textView.delegate = self;
    _textView.textColor = Color_ContentText;
    [self.view addSubview:_textView];
}

- (void)initBottomBar {
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - kBottomBarHeight, SCREEN_WIDTH, kBottomBarHeight)];

    _isAtAuthorBtn = [self buttonWithImage:[UIImage imageNamed:@"Unselected"] SelectedImage:[UIImage imageNamed:@"Selected"] Frame:CGRectMake(10, 0, 0, 24)];
    [_isAtAuthorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _isAtAuthorBtn.titleLabel.font = Font(14);
    [_isAtAuthorBtn addTarget:self action:@selector(setIsAtAuthor) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_isAtAuthorBtn];
    
    NSMutableArray <NSValue *> *frameArray = [NSMutableArray array];
    //计算按钮间距
    CGFloat margin = (SCREEN_WIDTH - 2 * 27 -4 * 24) / 3;
    for (int i = 0; i < 4; i++) {
        CGRect frame = CGRectMake(27 + (margin + 24) * i, 41, 24, 24);
        [frameArray addObject:[NSValue valueWithCGRect:frame]];
    }
    
    _topicBtn = [self buttonWithImage:[UIImage imageNamed:@"JingHao"] SelectedImage:nil Frame:frameArray[0].CGRectValue];
    [_topicBtn addTarget:self action:@selector(addTopic) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_topicBtn];
    _atSomeoneBtn = [self buttonWithImage:[UIImage imageNamed:@"Atsomeone"] SelectedImage:nil Frame:frameArray[1].CGRectValue];
    [_atSomeoneBtn addTarget:self action:@selector(atSomeone) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_atSomeoneBtn];
    _emoticonBtn = [self buttonWithImage:[UIImage imageNamed:@"Emoticon"] SelectedImage:nil Frame:frameArray[2].CGRectValue];
    [_emoticonBtn addTarget:self action:@selector(addEmoticon) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_emoticonBtn];
    _shareBtn = [self buttonWithImage:[UIImage imageNamed:@"More"] SelectedImage:nil Frame:frameArray[3].CGRectValue];
    [_shareBtn addTarget:self action:@selector(shareThisWeibo) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_shareBtn];
    
    _textView.inputAccessoryView = _bottomBar;
}

//刷新UI
- (void)setModel:(WeiboModel *)model {
    _model = model;
    
    [_iconView yy_setImageWithURL:[NSURL URLWithString:_model.user.avatar_hd] placeholder:nil];
    NSLog(@"昵称：  %@",_model.user.screen_name);
    NSString *content = [NSString stringWithFormat:@"评论给 @%@",_model.user.screen_name];
    [_isAtAuthorBtn setTitle:content forState:UIControlStateNormal];
    [_isAtAuthorBtn sizeToFit];
}


#pragma mark - Private Method



/// 是否评论给博文作者
- (void)setIsAtAuthor {
    _isAtAuthorBtn.selected = !_isAtAuthorBtn.selected;
}

/// 添加话题
- (void)addTopic {
    //当前光标的位置 添加 两个 # 即可
    NSRange selectRange = [_textView selectedRange];
    NSMutableString *str =  [[NSMutableString alloc] initWithString:_textView.text];
    //插入两个#号
    [str insertString:@"##" atIndex:selectRange.location];
    //光标移动到#之间
    _textView.selectedRange = NSMakeRange(selectRange.location + 1, 0);
    _textView.text = str;
}

/// @某人
- (void)atSomeone {
    //弹出@某人的页面
    SelectAtSomeOneViewController  *selectAtSomeOneVC = [[SelectAtSomeOneViewController alloc] initWithLeftTitle:@"返回" RightTitle:@"确定"];
    Weakself;
    selectAtSomeOneVC.selectAtNameArrayBlock = ^(NSString *selectNameArray){
        NSRange selectRange = [weakself.textView selectedRange];
        NSMutableString *str =  [[NSMutableString alloc] initWithString:weakself.textView.text];
        //插入两个#号
        [str insertString:selectNameArray atIndex:selectRange.location];
        weakself.textView.text = str;
    };
    CMBaseNavigationController *nav = [[CMBaseNavigationController alloc] initWithRootViewController:selectAtSomeOneVC];
    [self presentViewController:nav animated:true completion:nil];
}

/// emoticon
- (void)addEmoticon {
    //这里没有做 emoticon库  所以更改键盘类型输入emoji字符
    [SVProgressHUD showSuccessWithStatus:@"sorry，暂时没有做emoji库匹配,请切换到系统自带的emoji键盘输入即可"];
}

/// 分享
- (void)shareThisWeibo {
    
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:true];
}

- (void)barCancel {
    [self.view endEditing:true];
    //取消转发时 保存草稿 对应的key 为该条微博的ID
    DraftsModel *m = [[DraftsModel alloc] init];
    m.wbContent = _textView.text;
    m.isComment = _isAtAuthorBtn.isSelected;
    
    [[CMCache draftsCache] setObject:m forKey:_model.idstr];
    
    // 告知 用户已经保存草稿
    [SVProgressHUD showSuccessWithStatus:@"已保存草稿咯~"];
    
    [super barCancel];
}

- (void)barOK {
    [self.view endEditing:true];
    
    //点击发送
    [super barOK];
    [CMNetwork POST:kURL_RepostWeibo parameters:@{@"access_token" : [User currentUser].wbtoken , @"id" : @(_model.idstr.longLongValue) ,@"status" : _textView.text} success:^(NSString * _Nonnull jsonString) {
        
        [SVProgressHUD showSuccessWithStatus:@"转发成功👌"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"转发失败，是否转发过啦？"];
    }];

}

@end
