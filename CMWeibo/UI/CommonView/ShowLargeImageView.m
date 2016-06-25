//
//  ShowLargeImageView.m
//  CMWeibo
//
//  Created by jiachen on 16/5/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "ShowLargeImageView.h"
#import "AppDelegate.h"


#pragma mark - 在这里自定义一个collectionView

typedef void(^TapGesture)(void);

@interface ShowLargeImageCell: UICollectionViewCell

@property (strong, nonatomic) YYAnimatedImageView *imgView;
@property (copy, nonatomic) TapGesture tapGesture;

@end

@implementation ShowLargeImageCell

#define ShowImageCellID @"ShowImageCellIdentifier"

- (void)buildImageView {
    _imgView = [[YYAnimatedImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _imgView.userInteractionEnabled = true;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    //添加点击手势
    [self addOperationGesture];
    [self.contentView addSubview:_imgView];
}

/// 添加 单击返回手势。双指放大手势
- (void)addOperationGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureOperation:)];
    [_imgView addGestureRecognizer:tapGesture];
}

- (void)gestureOperation:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        //点击手势
        if (_tapGesture != nil) {
            _tapGesture();
        }
    }
}

/// ShowLargeImageCell类方法
+ (instancetype)imageCollectionCellWithCollectioView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath imageSource:(NSString *)imageURl {
    ShowLargeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShowImageCellID forIndexPath:indexPath];
    
    BOOL isExistImgView = false;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            isExistImgView = true;
        }
    }
    if (!isExistImgView) {
        [cell buildImageView];
    }
    
//    imageURl = @"http://img.t.sinajs.cn/t35/style/images/common/face/ext/normal/eb/smile.gif";
    [cell.imgView yy_setImageWithURL:[NSURL URLWithString:imageURl] placeholder:nil];

    return cell;
}

@end



// --------------------------------------------------------------------------------------------------------------------------------------------

#define ToolBarHeight  46
#define OperationButtonHeight 23
#define OperationButtonMargin 16

@interface ShowLargeImageView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/// 图片容器
@property (strong, nonatomic) UICollectionView *showCollectionView;

/// 底部工具栏
@property (strong, nonatomic) UIView *bar;

@end

@implementation ShowLargeImageView
{
    UIButton *saveImageButton;    //保存图片
    UIButton *shareImageButton;   //分享按钮
}

//这里做成单例
static ShowLargeImageView *_instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil)
        {
            _instance = [[ShowLargeImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [_instance buildUI];
            [_instance buildToolBar];
        }
    });
    
    return _instance;
}

/// build toolBar
- (void)buildToolBar {
    _bar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - ToolBarHeight, SCREEN_WIDTH, ToolBarHeight)];
    _bar.backgroundColor = [UIColor colorWithHex:0x141414];
    [self addSubview:_bar];
    
    saveImageButton = [[UIButton alloc] initWithFrame:CGRectMake(OperationButtonMargin, ToolBarHeight/2 - OperationButtonHeight/2, OperationButtonHeight, OperationButtonHeight)];
    [saveImageButton setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
    saveImageButton.tag = 1;
    [saveImageButton addTarget:self action:@selector(clickCenter:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:saveImageButton];
    
    shareImageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - OperationButtonMargin - OperationButtonHeight, ToolBarHeight/2 - OperationButtonHeight/2, OperationButtonHeight, OperationButtonHeight)];
    shareImageButton.tag = 2;
    [shareImageButton addTarget:self action:@selector(clickCenter:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:shareImageButton];
}

- (void)clickCenter:(UIButton *)sender {
    if (sender.tag == 1) {
        PicModel *pic = [PicModel picModelWithObject:_imageArray[(NSInteger)(_showCollectionView.contentOffset.x / SCREEN_WIDTH)]];
        NSString *key = pic.large_pic;
        NSLog(@"key : %@",key);
        if (![[CMCache imageCache] objectForKey:key]) {
            NSLog(@"并没有缓存");
        }
        UIImage *img = (UIImage *)[[CMCache imageCache] objectForKey:key];
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else {
        
    }
}

//保存图片成功的回调

- (void) image:(UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo:(void *) contextInfo {
    if (error == nil) {
        NSLog(@"success");
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }else {
        NSLog(@"错误信息： %@",error);
        [SVProgressHUD showErrorWithStatus:@"图片保存失败😂"];
    }
    
}


/// build collectionView
- (void)buildUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setSectionInset:UIEdgeInsetsZero];
    [layout setItemSize:[UIScreen mainScreen].bounds.size];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _showCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    _showCollectionView.delegate = self;
    _showCollectionView.dataSource = self;
    _showCollectionView.pagingEnabled = true;
    [_showCollectionView registerClass:[ShowLargeImageCell class] forCellWithReuseIdentifier:ShowImageCellID];
    [self addSubview:_showCollectionView];
}

#pragma mark - CollectioViewDataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _imageArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PicModel *pic = [PicModel picModelWithObject:_imageArray[indexPath.section]];
    ShowLargeImageCell *cell = [ShowLargeImageCell imageCollectionCellWithCollectioView:collectionView IndexPath:indexPath imageSource:pic.large_pic];
    Weakself;
    cell.tapGesture = ^(){
        [weakself removeFromSuperview];
    };
    return cell;
}

///  刷新UI
- (void)setImageArray:(NSArray <PicModel *> *)imageArray {
    _imageArray = imageArray;
    [_showCollectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [_showCollectionView setContentOffset:CGPointMake(SCREEN_WIDTH * _currentIndex, 0) animated:false];
}

#pragma mark - 调用方法


- (void)showWithImageSource:(NSArray *)imageArray {
    [ShowLargeImageView shareInstance].imageArray = imageArray;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:[ShowLargeImageView shareInstance]];
}
@end
