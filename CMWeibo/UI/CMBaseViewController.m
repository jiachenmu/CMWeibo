//
//  CMBaseViewController.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "CMBaseViewController.h"

@implementation CMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthorizeSuccess:) name:kNotification_AuthorizeSuccess object:nil];
}

- (void)dealloc {
    //画面销毁前移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法


- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle {
    self = [super init];
    if (self) {
        [self setupNavigationItemsWithLeftTitle:leftTitle RightTitle:rightTitle];
    }
    
    return self;
}

- (void)setupNavigationItemsWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle {
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(barCancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    if (rightTitle.length == 0) {
        return;
    }
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(barOK)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}


#pragma mark - Handle Event

//左侧按钮
- (void)barCancel {
    //这里不确定是 push来的或者present过来的，为了方便就这么写了
    [self.navigationController popViewControllerAnimated:true];
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

//右侧按钮
-(void)barOK {
    [self.navigationController popViewControllerAnimated:true];
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

//用户授权成功 － 通知
- (void)userAuthorizeSuccess:(NSNotification *)notify {
    /*处理思路：
     1.用户授权成功后，检查是否数据库中已存在该对象，存在则替换，通过userID判断
     2.对上述情景做相应的处理
     */
    NSLog(@"用户授权成功！");
    WBAuthorizeResponse *result = ( WBAuthorizeResponse *)notify.object;
    
    //1.检查数据库中是否已存在该对象
    __block BOOL isExist = false;
    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable array) {
        [array enumerateObjectsUsingBlock:^(User *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([result.userID isEqualToString:obj.wbCurrentUserID]) {
                isExist = true;
                // 替换信息
                obj.wbCurrentUserID = result.userID;
                obj.wbRefreshToken = result.refreshToken;
                obj.wbtoken = result.accessToken;
                obj.expirationDate = result.expirationDate;
                [kManagedObjectContext save:nil];
            }
        }];
    }];
    //2.数据库中并没有存储该信息
    if (!isExist) {
        User *user = [CoreDataManager modelWithClassName:@"User"];
        user.wbCurrentUserID = result.userID;
        user.wbRefreshToken = result.refreshToken;
        user.wbtoken = result.accessToken;
        user.expirationDate = result.expirationDate;
        [kManagedObjectContext save:nil];
    }
}

@end
