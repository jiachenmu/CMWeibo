//
//  PublishViewController.m
//  CMWeibo
//
//  Created by jiachenmu on 16/7/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "PublishViewController.h"
#import "WeiboImageViewContainer.h"
#import "CMButton.h"
#import "SelectAtSomeOneViewController.h"
#import "CMLocationViewController.h"
#import <ELCImagePickerController.h>


#define InputContentViewLeftMargin 10
#define kBottomBarHeight           75
#define kBottomBarLeftMargin       27

@interface PublishViewController () <YYTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate>

//编写微博 功能提示label
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (strong, nonatomic) UIScrollView *editDetailView;

//微博正文输入
@property (strong, nonatomic) YYTextView *textView;

//选择查看权限   微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见
@property (strong, nonatomic) UIView *selectVisibleView;

//选择权限 按钮数组
@property (strong, nonatomic) NSMutableArray <CMButton *> *selectVisibleBtnArray;

//图片容器
@property (strong, nonatomic) WeiboImageViewContainer *imageContainer;


//键盘工具栏
@property (strong, nonatomic) UIView *bottomBar;

@property (strong, nonatomic) UIButton *addPlaceBtn;
@property (strong, nonatomic) UIButton *topicBtn;
@property (strong, nonatomic) UIButton *atSomeoneBtn;
@property (strong, nonatomic) UIButton *emoticonBtn;
@property (strong, nonatomic) UIButton *shareBtn;

@end

@implementation PublishViewController {
    //当前选择的用户查看权限
    NSInteger _currentVisibleTag;
    
    //已经添加的照片数组
    NSMutableArray <UIImage *> *photoArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = true;
        _selectVisibleBtnArray = [NSMutableArray array];
        photoArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)barCancel {
    //取消发布时 保存草稿
    [super barCancel];
}

- (void)barOK {
    [super barOK];
}

// 点击编写按钮
- (IBAction)startEditWeibo:(id)sender {
    Weakself;
    UIButton *btn = (UIButton *)sender;
    //执行缩放动画
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            btn.hidden = weakself.tipLabel.hidden = true;
            
            //弹出编辑微博页面'
            [weakself.editDetailView setHidden:false];
            [weakself.textView becomeFirstResponder];
        }
    }];
    
}

#pragma mark - Build UI

//使用懒加载
- (UIScrollView *)editDetailView {
    if (!_editDetailView) {
        _editDetailView = [self editWeiboView];
        _editDetailView.hidden = true;
        [self.view addSubview:_editDetailView];
    }
    return _editDetailView;
}

- (UIScrollView *)editWeiboView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
    
    
    //正文输入
    _textView = [[YYTextView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 100)];
    _textView.font = Font(14);
    _textView.placeholderText = @"写点什么吧，😄";
    _textView.textColor = [UIColor colorWithHex:0x969696];
    _textView.delegate = self;
    
    //键盘工具栏
    [self initBottomBar];
    _textView.extraAccessoryViewHeight = kBottomBarHeight;
    [scrollView addSubview:_textView];
    
    //选择可见权限
    _selectVisibleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame) + 10, SCREEN_WIDTH, 14)];
    NSArray <NSString *> *titleArray = [NSArray arrayWithObjects:@"所有人可见",@"仅自己可见",@"仅朋友可见", nil];
    CGFloat origin_ = (SCREEN_WIDTH - 3 * 80) / 4;
    for (int i= 0; i < 3; i++) {
        CMButton *button = [[CMButton alloc] initWithFrame:CGRectMake((i + 1) * origin_ + i * 80, 2, 80, 16)];
        
        button.tag = i;
        [button setTitleLabelFrame:CGRectMake(0, 0, 70, 14)];
        [button setImageViewFrame:CGRectMake(70, 3, 10, 10)];
        [button setTitleFont:Font(14)];
        [button setTitle:titleArray[i] forState:CMControlStateNormal];
        [button setTitleColor:Color_NavigationBar forState:CMControlStateSelected];
        [button setImage:[UIImage imageNamed:@"Selected"] forState:CMControlStateSelected];
        [button setImage:[UIImage imageNamed:@"Unselected"] forState:CMControlStateNormal];
        [_selectVisibleView addSubview:button];
        
        [button addTarget:self action:@selector(selectVisible:) forControlEvents:UIControlEventTouchUpInside];
        
        [_selectVisibleBtnArray addObject:button];
    }
    [scrollView addSubview:_selectVisibleView];
    
    //选择图片
    _imageContainer = [[WeiboImageViewContainer alloc] initWithWidth:(SCREEN_WIDTH - 40)];
    _imageContainer.frame = CGRectMake(20, CGRectGetMaxY(_selectVisibleView.frame) + 20, SCREEN_WIDTH - 40, 0);
    [scrollView addSubview:_imageContainer];
    
    return scrollView;
}

- (void)initBottomBar {
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - kBottomBarHeight, SCREEN_WIDTH, kBottomBarHeight)];
    _bottomBar.backgroundColor = [UIColor whiteColor];
    
    _addPlaceBtn = [self buttonWithImage:[UIImage imageNamed:@"Unselected"] SelectedImage:[UIImage imageNamed:@"Selected"] Frame:CGRectMake(10, 0, 80, 24)];
    [_addPlaceBtn setTitle:@"添加位置" forState:UIControlStateNormal];
    [_addPlaceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addPlaceBtn setTitleColor:Color_NavigationBar forState:UIControlStateSelected];
    _addPlaceBtn.titleLabel.font = Font(14);
    [_addPlaceBtn addTarget:self action:@selector(addPlace) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_addPlaceBtn];
    
    //添加图片按钮
    UIButton *addImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 24, 0, 24, 24)];
    [addImageBtn setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [addImageBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:addImageBtn];
    
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

#pragma mark - Delegate

#pragma mark -- TextViewDelegate

// 140字限制，好尴尬，我也不想
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 140) {
        [SVProgressHUD showErrorWithStatus:@"可怜的140字限制~"];
        return false;
    }
    return true;
}

#pragma mark --  ScrllDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:true];
}

#pragma mark --  ImagePickViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    
    [picker dismissViewControllerAnimated:true completion:nil];
    if (_imageContainer.imageCount == 9) {
        [SVProgressHUD showInfoWithStatus:@"已经添加9张了哦~继续添加会覆盖最后一张"];
        [photoArray replaceObjectAtIndex:8 withObject:image];
    }else {
        [photoArray addObject:image];
    }
    
    [self updateImageContainerFrame];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    
    [picker dismissViewControllerAnimated:true completion:nil];
    
    NSMutableArray <UIImage *> *imageArray = [NSMutableArray array];
    [info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArray addObject:[obj objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
    [photoArray removeAllObjects];
    [photoArray addObjectsFromArray:imageArray];
    
    [self updateImageContainerFrame];
}

- (void)updateImageContainerFrame {
    //刷新imageContainer
    _imageContainer.imageSources = photoArray;
    NSInteger line_num = photoArray.count <= 3 ? 1 : ceil(photoArray.count / 3.0);
    CGFloat imageWidth = (SCREEN_WIDTH - 40 - 2 * 5) / 3;
    CGRect frame = _imageContainer.frame;
    frame.size.height = line_num * imageWidth + (line_num + 1) * 5;
    _imageContainer.frame = frame;
}

#pragma mark - handle event

//选择查看权限
- (void)selectVisible:(CMButton *)sender {
    _currentVisibleTag = sender.tag;
    [sender setControlState:CMControlStateSelected];
    [_selectVisibleBtnArray enumerateObjectsUsingBlock:^(CMButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag != sender.tag) {
            [obj setControlState:CMControlStateNormal];
        }
    }];
}

/// 添加位置
- (void)addPlace {
    //添加位置
    CMLocationViewController *locationVC = [[CMLocationViewController alloc] initWithLeftTitle:@"返回" RightTitle:@""];
    Weakself;
    locationVC.selectPlaceBlock = ^(NSString *place){
        [weakself.addPlaceBtn setTitle:place forState:UIControlStateNormal];
        [weakself.addPlaceBtn sizeToFit];
        weakself.addPlaceBtn.selected = ![place isEqualToString:@""];
    };
    [self.navigationController pushViewController:locationVC animated:true];
}

/// 添加图片
- (void)addImage:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"添加图片" message:@"选择从相册中或者拍照获取一张图片" preferredStyle:UIAlertControllerStyleActionSheet];
    Weakself;
    UIAlertAction *action_TakeingPhotos = [UIAlertAction actionWithTitle:@"拍一张啦☺️" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = weakself;
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakself presentViewController:imagePicker animated:true completion:nil];
        }else {
            [SVProgressHUD showErrorWithStatus:@"亲，换真机调试吧😢"];
        }
    }];
    UIAlertAction *action_ReadFromPhotos = [UIAlertAction actionWithTitle:@"从相册获取啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ELCImagePickerController *picker = [[ELCImagePickerController alloc] init];
        picker.maximumImagesCount = 9;
        picker.imagePickerDelegate = weakself;
        [weakself presentViewController:picker animated:true completion:nil];
        
    }];
    
    UIAlertAction *action_removeAllPhoto = [UIAlertAction actionWithTitle:@"移除添加的图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [photoArray removeAllObjects];
        [self updateImageContainerFrame];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消咯~" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action_TakeingPhotos];
    [alertVC addAction:action_ReadFromPhotos];
    [alertVC addAction:action_removeAllPhoto];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:true completion:nil];
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
        [weakself.textView becomeFirstResponder];
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

@end
