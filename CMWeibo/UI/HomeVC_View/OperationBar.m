//
//  OperationBar.m
//  CMWeibo
//
//  Created by jiachen on 16/5/24.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "OperationBar.h"

#define ViewHeight 20

#define ButtonHeight 13

#define Color_Title [UIColor colorWithHex:0xcccccc]

#define BUttonIterval 12

#define Button_OriginY (ViewHeight - ButtonHeight)/2

#define ShowButtonLeftMargin 14

@interface OperationBar()

//赞
@property (strong, nonatomic) UIButton *praiseBtn;
//转发
@property (strong, nonatomic) UIButton *relayBtn;
//评论
@property (strong, nonatomic) UIButton *commentBtn;

@property (strong, nonatomic) UIButton *showButton;
@end

@implementation OperationBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildButton];
    }
    return self;
}



- (void)buildButton {
    _praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, Button_OriginY, 44, ButtonHeight)];
    _praiseBtn.enabled = false;
    _praiseBtn.titleLabel.font = Font(13);
    [_praiseBtn setTitleColor:Color_Title forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:@"Praise"] forState:UIControlStateNormal];
    
    [self addSubview:_praiseBtn];
    
    _relayBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_praiseBtn.frame) + BUttonIterval, Button_OriginY, 44, ButtonHeight)];
    _relayBtn.enabled = false;
    [_relayBtn setImage:[UIImage imageNamed:@"Forward"] forState:UIControlStateNormal];
    [_relayBtn setTitleColor:Color_Title forState:UIControlStateNormal];
    _relayBtn.titleLabel.font = Font(13);
    [self addSubview:_relayBtn];
    
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_relayBtn.frame) + BUttonIterval, Button_OriginY, 44, ButtonHeight)];
    [_commentBtn setTitleColor:Color_Title forState:UIControlStateNormal];
    _commentBtn.enabled = false;
    [_commentBtn setImage:[UIImage imageNamed:@"CommentBTn"] forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = Font(13);
    [self addSubview:_commentBtn];
    
    _showButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_commentBtn.frame) + ShowButtonLeftMargin, 0, 26, 20)];
    [_showButton addTarget:self action:@selector(showOperationButtons) forControlEvents:UIControlEventTouchUpInside];
    [_showButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    _showButton.layer.borderColor = Color_Title.CGColor;
    _showButton.layer.borderWidth = 0.5;
    _showButton.layer.cornerRadius = 7.0;
    [self addSubview:_showButton];
    
    CGRect frame = self.frame;
    frame.size.width = CGRectGetMaxX(_showButton.frame);
    self.frame = frame;
}

// MARK: 更新UI
- (void)setCountArray:(NSArray *)countArray {
    _countArray = countArray;
    
    float praiseBtnCount = ((NSNumber *)(_countArray[0])).floatValue;
    [_praiseBtn setTitle: praiseBtnCount > 99.0 ? [NSString stringWithFormat:@"%.1fk",praiseBtnCount/1000] : [NSString stringWithFormat:@"%0.0f",praiseBtnCount] forState:UIControlStateNormal];
    [_praiseBtn sizeToFit];
    
    float relayCount = ((NSNumber *)(_countArray[1])).floatValue;
    [_relayBtn setTitle: relayCount > 99.0 ? [NSString stringWithFormat:@"%.1fk",relayCount/1000] : [NSString stringWithFormat:@"%.0f",relayCount] forState:UIControlStateNormal];
    [_relayBtn sizeToFit];
    
    float commentCount = ((NSNumber *)(_countArray[2])).floatValue;
    [_commentBtn setTitle: commentCount > 99.0 ? [NSString stringWithFormat:@"%.1fk",commentCount/1000] : [NSString stringWithFormat:@"%0.0f",commentCount] forState:UIControlStateNormal];
    [_commentBtn sizeToFit];
    
    _commentBtn.frame = CGRectMake(CGRectGetMinX(_showButton.frame) - ShowButtonLeftMargin - 44, Button_OriginY, 44, 13);
    
    _relayBtn.frame = CGRectMake(CGRectGetMinX(_commentBtn.frame) - BUttonIterval - 44, Button_OriginY, 44, 13);
    
    _praiseBtn.frame = CGRectMake(CGRectGetMinX(_relayBtn.frame) - BUttonIterval - 44, Button_OriginY, 44, 13);
    
    CGRect frame = self.frame;
    frame.size.width = CGRectGetMaxX(_showButton.frame) - CGRectGetMinX(_praiseBtn.frame);
    frame.size.height = ViewHeight;
    self.frame = frame;
}

#pragma mark - 事件处理

- (void)showOperationButtons {
    OperationBarEvent event = _showButton.selected ? OperationBarEvent_Close : OperationBarEvent_Show;
    if (_showOperationButtonBlock) {
        _showOperationButtonBlock(event);
    }
    _showButton.selected = !_showButton.selected;
}

@end
