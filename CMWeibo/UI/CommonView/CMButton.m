//
//  CMButton.m
//  CMWeibo
//
//  Created by jiachen on 16/6/17.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//  自定义Button 非常好实现，整体构造为：
/*
    父view      -------子View---------
    UIControl   UIImageView + UILabel
 */


#import "CMButton.h"
const CGFloat kDefaultFontScale = 20;

@interface CMButton()

@property (assign, nonatomic) CMControlState controlState;

/// 记录各个情况下的Title
@property (strong, nonatomic) NSMutableDictionary *titleStateDict;
/// 记录各个情况下的文字颜色
@property (strong, nonatomic) NSMutableDictionary *titleColorDict;
/// 记录各个情况下的Image
@property (strong, nonatomic) NSMutableDictionary *imageStateDict;
/// 记录各个情况的Event
@property (strong, nonatomic) NSMutableDictionary *eventDict;

@end

@implementation CMButton {
    CMButton *weakSelf;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self buildUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self buildUI];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)dealloc {
//    NSLog(@"CMButton - dealloc");
}

//    UIControlEvents
/*
 UIControlEventTouchDown                                         = 1 <<  0,      // on all touch downs
 UIControlEventTouchDownRepeat                                   = 1 <<  1,      // on multiple touchdowns (tap count > 1)
 UIControlEventTouchDragInside                                   = 1 <<  2,
 UIControlEventTouchDragOutside                                  = 1 <<  3,
 UIControlEventTouchDragEnter                                    = 1 <<  4,
 UIControlEventTouchDragExit                                     = 1 <<  5,
 UIControlEventTouchUpInside                                     = 1 <<  6,
 UIControlEventTouchUpOutside                                    = 1 <<  7,
 UIControlEventTouchCancel
 */

//

/**
 *  return event String for UIControlEvent
 *
 *  @return event String for UIControlEvent
 */
- (NSDictionary *)eventMap {
    static NSDictionary *eventMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventMap = @{@(UIControlEventTouchDown) : @"UIControlEventTouchDown",
                      @(UIControlEventTouchDownRepeat) : @"UIControlEventTouchDownRepeat",
                      @(UIControlEventTouchDragInside) : @"UIControlEventTouchDragInside",
                      @(UIControlEventTouchDragOutside) : @"UIControlEventTouchDragOutside",
                      @(UIControlEventTouchDragEnter) : @"UIControlEventTouchDragEnter",
                      @(UIControlEventTouchDragExit) : @"UIControlEventTouchDragExit",
                      @(UIControlEventTouchUpInside) : @"UIControlEventTouchUpInside",
                      @(UIControlEventTouchUpOutside) : @"UIControlEventTouchUpOutside",
                      @(UIControlEventTouchCancel) : @"UIControlEventTouchCancel",
                      @(UIControlEventAllTouchEvents) : @"UIControlEventAllTouchEvents",};
    });
    
    return eventMap;
}

- (void)buildUI {
    /// configure
    __weak typeof(self) weakself = self;
    weakSelf = weakself;
    _titleStateDict = [NSMutableDictionary dictionary];
    _titleColorDict = [NSMutableDictionary dictionary];
    _imageStateDict = [NSMutableDictionary dictionary];
    _eventDict = [NSMutableDictionary dictionary];
    self.userInteractionEnabled = true;
    
    /// ui
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    
}

- (void)setTitle:(NSString *)title forState:(CMControlState)state {
    if (!title) {
        title = @"";
    }
    [_titleStateDict setObject:title forKey:@(state)];
    [self refreshTitle];
}

- (void)setTitleFont:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:kDefaultFontScale];
    }
    _titleLabel.font = font;
}

- (void)setTitleColor:(UIColor *)titleColor forState:(CMControlState)state {
    if (!titleColor) {
        titleColor = [UIColor blackColor];
    }
    [_titleColorDict setObject:titleColor forKey:@(state)];
    [self refreshTitle];
}
- (void)setImage:(UIImage *)image forState:(CMControlState)state {
    if (!image) {
        return;
    }
    [_imageStateDict setObject:image forKey:@(state)];
    [self refreshImage];
}

- (void)setAction:(CMButtonClickBlock)cmButtonClickBlock forControlEvents:(UIControlEvents)event{
    NSString *actionString = (NSString *)[[self eventMap] objectForKey:@(event)];

    SEL action = NSSelectorFromString(actionString);
    [self addTarget:self action:action forControlEvents:event];
    
    [_eventDict setObject:cmButtonClickBlock forKey:@(event)];
}

- (void)setControlState:(CMControlState)state {
    _controlState = state;
    [self refreshImage];
    [self refreshTitle];
//    [self refreshFrame];
}

- (void)setControlState:(CMControlState)state Duration:(NSTimeInterval)delay WithAction:(CMButtonStateBlock)block{
    _controlState = state;
    [self refreshImage];
    [self refreshTitle];
    if (block) {
        if (delay < 0) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            block(weakSelf.tag,weakSelf);
        });
    }
}

#pragma mark - Refresh UI

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        
        [self refreshImage];
        [self refreshTitle];
    }else if ([keyPath isEqualToString:@"frame"]) {
        
    }
}


- (void)setImageViewFrame:(CGRect)imgFrame {
    _imageView.frame = imgFrame;
}

- (void)setTitleLabelFrame:(CGRect)labelFrame {
    _titleLabel.frame = labelFrame;
    
}

- (void)refreshTitle {
    if ([_titleStateDict objectForKey:@(_controlState)]) {
        _titleLabel.text = [_titleStateDict objectForKey:@(_controlState)];
    }
    if ([_titleColorDict objectForKey:@(_controlState)]) {
        _titleLabel.textColor = [_titleColorDict objectForKey:@(_controlState)];
    }
    if (_titleLabel.frame.size.height == 0) {
        //titlelabel没有给frame
        if (_imageView.frame.size.height == 0) {
            //没有给image
            _titleLabel.frame = self.bounds;
            [_titleLabel sizeToFit];
        }
    }
    
}

- (void)refreshImage {
    if ([_imageStateDict objectForKey:@(_controlState)]) {
        _imageView.image = (UIImage *)[_imageStateDict objectForKey:@(_controlState)];
    }
}

/// 自动计算frame
- (void)refreshFrame {
    //分为几种情况
    //1.纯文字
    if (_imageView.image == nil && _titleLabel.text.length > 0) {
        _titleLabel.frame = self.bounds;
    }
    //2.纯图片
    else if (_imageView.image != nil && _titleLabel.text.length == 0) {
        _imageView.frame = self.bounds;
    }
    //3.图文
    else {
        //图文情况下，需要单独设置imageView和titleLabel的frame
    }
}

#pragma mark - Handle Event for every state


- (void)UIControlEventTouchDown {
    if ([_eventDict objectForKey:@(UIControlEventTouchDown)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchDown)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchDownRepeat {
    if ([_eventDict objectForKey:@(UIControlEventTouchDownRepeat)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchDownRepeat)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchDragInside {
    if ([_eventDict objectForKey:@(UIControlEventTouchDragInside)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchDragInside)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchDragOutside {
    if ([_eventDict objectForKey:@(UIControlEventTouchDragOutside)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchDragOutside)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchDragEnter {
    if ([_eventDict objectForKey:@(UIControlEventTouchDragEnter)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchDragEnter)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchDragExit {
    if ([_eventDict objectForKey:@(UIControlEventTouchDragExit)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchDragExit)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchUpInside {
    if ([_eventDict objectForKey:@(UIControlEventTouchUpInside)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchUpInside)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchUpOutside {
    if ([_eventDict objectForKey:@(UIControlEventTouchUpOutside)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchUpOutside)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventTouchCancel {
    if ([_eventDict objectForKey:@(UIControlEventTouchCancel)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventTouchCancel)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

- (void)UIControlEventAllTouchEvents {
    if ([_eventDict objectForKey:@(UIControlEventAllTouchEvents)]) {
        CMButtonClickBlock cmButtonClickBlock = [_eventDict objectForKey:@(UIControlEventAllTouchEvents)];
        cmButtonClickBlock(weakSelf.tag);
    }
}

#pragma mark - UIControl event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setControlState:CMControlStateHighlighted];
    
    return true;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setControlState:CMControlStateNormal];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self setControlState:CMControlStateNormal];
}

@end
