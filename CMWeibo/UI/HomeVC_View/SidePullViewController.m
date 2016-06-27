//
//  SidePullView.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "SidePullViewController.h"
#import "UserModel.h"
#import "CMButton.h"
#import "CMBrowserViewController.h"
#import "WeiboList.h"
#import "CMSharpCornerView.h"
#import "ManangeAccountViewController.h"
#import "UIImage+GIF.h"

@interface SidePullViewController()

@property (strong, nonatomic) UIImageView *iconView;
//背景图片显示
@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UIButton *detailInfoBtn;

/// 尖角View
@property (strong, nonatomic) CMSharpCornerView *cornerView;
/// 管理帐号按钮
@property (strong, nonatomic) CMButton *manageBtn;
/// 添加帐号按钮
@property (strong, nonatomic) CMButton *addAccountBtn;


@property (strong, nonatomic) CMButton *offlineBtn; //离线按钮
@property (strong, nonatomic) CMButton *showBtn; //显示按钮
@property (strong, nonatomic) CMButton *themeBtn; //主题按钮
@property (strong, nonatomic) CMButton *nightBtn; //夜晚模式按钮

@property (strong, nonatomic) UserModel *currentUser;

@property (strong, nonatomic) NSArray <CMButton *> *buttonArr;
@property (strong, nonatomic) NSArray <NSString *> *buttonTitleArr;
@property (strong, nonatomic) NSArray <UIImage *> *buttonImageArr;

@end

const CGFloat IconViewTopMargin  = 56;
const CGFloat IconViewHeight     = 83;
const CGFloat TableViewTopMargin = 35;
const CGFloat TableViewBottomMargin = 85;
const CGFloat BottomBtnWidth     = 36;

const CGFloat CornerViewWidth = SidePullViewWidth - 20;
const CGFloat CornerViewHeight = 50;

@implementation SidePullViewController {
    /// 是否正在请求
    BOOL isRequesting;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        isRequesting = false;
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SidePullViewWidth, SCREEN_HEIGHT)];
    _backView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backView];
    
    //iOS8 新增加的一个具体特效，或者称之为滤镜的View，详细属性看里面的定义
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithFrame:_backView.bounds];
    [effectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.alpha = 0.5;
    [_backView addSubview:effectView];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(SidePullViewWidth/2 - IconViewHeight/2, IconViewTopMargin, IconViewHeight, IconViewHeight)];
    _iconView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrCloseCornerView)];
    [_iconView addGestureRecognizer:tap];
    _iconView.layer.cornerRadius = IconViewHeight/2;
    _iconView.layer.masksToBounds = true;
    [self.view addSubview:_iconView];
    
    _cornerView = [[CMSharpCornerView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_iconView.frame), CornerViewWidth, CornerViewHeight + 6) AngleLeftMargin:CornerViewWidth/2 - 5 AngleWidth:10 AngleHeight:6];
    _cornerView.alpha = 0.0;
    _cornerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cornerView];
    
    _manageBtn = [[CMButton alloc] initWithFrame:CGRectMake(11, 6 + CornerViewHeight/2 - 8, CornerViewWidth/2 - 10, 16)];
    [_manageBtn setTitleFont:Font(16)];
    [_manageBtn setTitle:@"管理" forState:CMControlStateNormal];
    [_manageBtn setTitleColor:Color_NavigationBar forState:CMControlStateNormal];
    Weakself;
    [_manageBtn setAction:^(NSInteger tag) {
        NSLog(@"管理我的帐号～");
        ManangeAccountViewController *manageVC = [[ManangeAccountViewController alloc] initWithLeftTitle:@"取消" RightTitle:@""];
        CMBaseNavigationController *nav = [[CMBaseNavigationController alloc] initWithRootViewController:manageVC];
        [weakself presentViewController:nav animated:true completion:nil];
              
    } forControlEvents:UIControlEventTouchUpInside];
    [_cornerView addSubview:_manageBtn];
    
    _addAccountBtn = [[CMButton alloc] initWithFrame:CGRectMake(CornerViewWidth/2 - 10, 6 + CornerViewHeight/2 - 8, CornerViewWidth/2, 16)];
    [_addAccountBtn setTitleLabelFrame:_addAccountBtn.bounds];
    [_addAccountBtn setTitle:@"新帐号" forState:CMControlStateNormal];
    [_addAccountBtn setTitleFont:Font(16)];
    [_addAccountBtn setTitleColor:Color_NavigationBar forState:CMControlStateNormal];
    _addAccountBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_addAccountBtn setAction:^(NSInteger tag) {
        NSLog(@"添加新的帐号");
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        [request setRedirectURI:kRedirectURI];
        [request setScope:@"all"];
        [WeiboSDK sendRequest:request];
    } forControlEvents:UIControlEventTouchUpInside];
    [_cornerView addSubview:_addAccountBtn];
    
    _detailInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SidePullViewWidth/2 - 90, SCREEN_HEIGHT/2, 180, 45)];
    [_detailInfoBtn setTitle:@"点击去查看我的分组" forState: UIControlStateNormal];
    _detailInfoBtn.titleLabel.font = Font(20);
    [_detailInfoBtn setTitleColor:Color_ContentText forState:UIControlStateNormal];
    [_detailInfoBtn addTarget:self action:@selector(lookupMyGroupList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_detailInfoBtn];
    
    _offlineBtn = [[CMButton alloc] init];
    _showBtn = [[CMButton alloc] init];
    _themeBtn = [[CMButton alloc] init];
    _nightBtn = [[CMButton alloc] init];
    
    _buttonArr = [NSArray arrayWithObjects:_offlineBtn,_showBtn,_themeBtn,_nightBtn, nil];
    _buttonTitleArr = [NSArray arrayWithObjects:@"离线",@"显示",@"主题",@"夜晚",nil];
    _buttonImageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"Offline"],[UIImage imageNamed:@"font"],[UIImage imageNamed:@"theme"],[UIImage imageNamed:@"night"], nil];
    
    CGFloat margin = ( SidePullViewWidth - 4 * BottomBtnWidth ) / 5;
    CGFloat origin_y = SCREEN_HEIGHT - BottomBtnWidth - 17 - 3;
    [_buttonArr enumerateObjectsUsingBlock:^(CMButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(margin + (margin + BottomBtnWidth) * idx, origin_y, BottomBtnWidth, BottomBtnWidth + 17);
        obj.tag = idx;
        if (obj.tag == 0) {
            [obj setTitle:@"正在缓存" forState:CMControlStateNetworkRequest];
            [obj setImage:[UIImage imageNamed:@"DownloadSuccess"] forState:CMControlStateNetworkRequest];
            [obj setTitle:@"缓存失败" forState:CMControlStateRequestFaliure];
            [obj setImage:[UIImage imageNamed:@"DownloadFaliure"] forState:CMControlStateRequestFaliure];
            
        }
        [obj setTitleLabelFrame:CGRectMake(0, BottomBtnWidth + 7, BottomBtnWidth, 10)];
        [obj setImageViewFrame:CGRectMake(0, 0, BottomBtnWidth, BottomBtnWidth)];
        
        [obj setTitle:_buttonTitleArr[idx] forState:CMControlStateNormal];
        obj.titleLabel.textAlignment = NSTextAlignmentCenter;
        [obj setTitleColor:Color_ContentText forState:CMControlStateNormal];
        [obj setImage:_buttonImageArr[idx] forState:CMControlStateNormal];
        obj.titleLabel.font = Font(10);
        
        Weakself;
        [obj setAction:^(NSInteger tag) {
            NSLog(@"tag : %ld",tag);
            switch (tag) {
                case 0:
                    /// 请求100条微博数据缓存到本地
                    [weakself requestMuchDataToOffline];
                    break;
                case 1:
                    [SVProgressHUD showErrorWithStatus:@"功能木有做哦~"];
                    break;
                case 2:
                    [SVProgressHUD showErrorWithStatus:@"功能木有做哦~"];
                    break;
                case 3:
                    [SVProgressHUD showErrorWithStatus:@"功能木有做哦~"];
                    break;
                default:
                    break;
            }
        } forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:obj];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //currentUser不存在的时候 请求数据
    if(!_currentUser || !_currentUser.avatar_large ) {
        Weakself;
        [UserModel getUserInfoWithSuccessBlock:^(UserModel *model) {
            weakself.currentUser = model;
            [weakself refreshUI];
        }];
        
    }
}

//刷新页面
- (void)refreshUI {
    
    [_iconView yy_setImageWithURL:[NSURL URLWithString:_currentUser.avatar_large] placeholder:[UIImage imageNamed:@"DefaultUserIcon"] options:YYWebImageOptionProgressiveBlur manager:[YYWebImageManager sharedManager] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return [image yy_imageByRoundCornerRadius:IconViewHeight/2];
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    [_backView yy_setImageWithURL:[NSURL URLWithString:_currentUser.avatar_hd] placeholder:nil];
    
}

/// build select user Button


#pragma mark - Event Handle

/// 添加新的帐号－－ 用户授权成功

- (void)userAuthorizeSuccess:(NSNotification *)notify {
    //调用父类方法，即可处理新的帐号
    [super userAuthorizeSuccess:notify];
    //处理完毕之后，刷新当前View
    Weakself;
    [UserModel getUserInfoWithSuccessBlock:^(UserModel *model) {
        weakself.currentUser = model;
        [weakself refreshUI];
    }];
    
}

/// 展示or隐藏帐号管理view
- (void)showOrCloseCornerView {
    CGPoint center = CGPointZero;
    CGFloat alpha = 0.0;
    if (_cornerView.alpha == 1.0) {
        //隐藏cornerView
        center = CGPointMake(SidePullViewWidth/2, _iconView.center.y+CornerViewHeight/2 + 3);
        alpha = 0.0;
    }else {
        //显示cornerView
        center = CGPointMake(SidePullViewWidth/2, CGRectGetMaxY(_iconView.frame) + CornerViewHeight/2 + 3);
        alpha = 1.0;
    }
    Weakself;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.cornerView.center = center;
        weakself.cornerView.alpha = alpha;
    }];
    
}


/// 查看我的分组
- (void)lookupMyGroupList {
    NSLog(@"查看我的分组");
    //发出通知，首页取消左滑通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LookUpMyGroup object:nil];
}

/// 请求多条数据缓存本地
- (void)requestMuchDataToOffline {
    if (isRequesting) {
        //如果正在请求，则返回
        return;
    }
    //设置为网络请求状态
//    [_buttonArr[0] setControlState:CMControlStateNetworkRequest];

    if ([[CMCache offlineCache] objectForKey:kString_offline]) {
        //这里可以对缓存频率做一定限制,比如说每天缓存的次数限制等，这里我就不做限制了
        NSLog(@"缓存的path: %@",[CMCache offlineCache].path);
    }
    Weakself;
    [CMNetwork GET:kURL_NewPublicWeibo parameters:@{@"access_token" : [User currentUser].wbtoken, @"count" : kOfflineReqCount} success:^(NSString * _Nonnull jsonString) {
        dispatch_queue_t t = dispatch_queue_create("kString_offline", NULL);
        dispatch_async(t, ^{
            //tips:这里转成model缓存到本地更好，下次进来就不用再进行json解析了，但是自定义对象需要遵从 <NSCoding> 协议才能归档存到本地，所以就偷个懒。。😝
            [[CMCache offlineCache] setObject:jsonString forKey:kString_offline withBlock:^{
                [weakself.buttonArr[0] setControlState:CMControlStateNetworkRequest Duration:1.0 WithAction:^(NSInteger tag, CMButton *sender) {
                    [sender setControlState:CMControlStateNormal];
                    [SVProgressHUD showSuccessWithStatus:@"数据缓存成功😬"];
                }];
            }];
            isRequesting = false;
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        isRequesting = false;
        [weakself.buttonArr[0] setControlState:CMControlStateRequestFaliure Duration:1.0 WithAction:^(NSInteger tag, CMButton *sender) {
            [sender setControlState:CMControlStateNormal];
        }];
    }];
}

@end
