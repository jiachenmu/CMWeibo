//
//  HomeViewController.m
//  CMWeibo
//
//  Created by jiachen on 16/5/23.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "HomeViewController.h"
#import "User.h"
#import "UserModel.h"
#import "WeiboList.h"

#import "WeiboCell.h"
#import "CMWeiboCellFrames.h"
#import "WeiboImageViewContainer.h"
#import "RepostViewController.h"
#import "CMBrowserViewController.h"
#import "TopicViewController.h"

typedef NS_ENUM(NSInteger, HomeRequestType) {
    HomeRequestTypeRefresh = 0,
    HomeRequestTypeMore
};


@interface HomeViewController()<UITableViewDataSource,UITableViewDelegate,WeiboCellDelegate>

//@property (strong, nonatomic) SidePullView *sidePullView;

@property (strong, nonatomic) UITableView *showTableView;

//----数据
@property (strong, nonatomic) WeiboList *list;
@property (assign, nonatomic) NSInteger requestCount;
//----cell布局
@property (strong, nonatomic) NSMutableArray *frameArray;

@property (strong, nonatomic) User *currentUser;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _requestCount = 0;
    
    //监听通知 - 用户授权失败
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(userAuthorizeFailure:) name:kNotification_AuthorizeFailure object:nil];
    //监听通知 - 收藏微博成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFavoriteSuccess:) name:kNotification_FavoriteSuccess object:nil];
    //监听通知 - 查看我的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookupMyGroupList) name:kNotification_LookUpMyGroup object:nil];
    
    
    [self buildNavigationItems];
    
    [self buildTableView];
    
    [self checkIsUserDataNil];
    if (_currentUser != nil) { //@"uid" : @(_currentUser.wbCurrentUserID.longLongValue)
//        [CMNetwork GET:kURL_UserInfo parameters:@{@"access_token" : _currentUser.wbtoken,@"uid" : @([User currentUser].wbCurrentUserID.longLongValue)} success:^(NSString * _Nonnull jsonString) {
//            
//            UserModel *usermodel = [UserModel initWithJSONString:jsonString];
//            NSLog(@"用户昵称： %@ id:%lld",usermodel.name,usermodel.userID);
//            NSLog(@"用户大头像：%@",usermodel.avatar_large);
//            NSLog(@"用户详细描述：%@",usermodel.description_text);
//            NSLog(@"所在地:%@",usermodel.location);
//            NSLog(@"粉丝数量 :%ld",usermodel.followers_count);
//        } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//        }];
        
        [self loadDataWithRequestType:HomeRequestTypeRefresh];
    }
    
}


#pragma mark - 用户帐号相关

/**
 *  检查用户数据库中是否有存储的user，如果数据库为空，则请求授权
 */
- (void)checkIsUserDataNil {
//    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable array) {
//        for (User *user in array) {
//            [kManagedObjectContext deleteObject:user];
//        }
//    }];

    Weakself;
    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * array) {
        if (array == nil || array.count == 0) {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            [request setRedirectURI:kRedirectURI];
            [request setScope:@"all"];
            [WeiboSDK sendRequest:request];
        }else {
            NSLog(@"存储的 %@ 对象有 %lu 个 ",NSStringFromClass([User class]),(unsigned long)array.count);
            for (User *user in array) {
                NSLog(@"user.id = %@",user.wbCurrentUserID);
            }
            weakself.currentUser = [array lastObject];
        }
    }];
}

//用户授权成功
- (void)userAuthorizeSuccess:(NSNotification *)notify {
    /*处理思路：
     1.用户授权成功后，检查是否数据库中已存在该对象，或者数据库中用户对应的token已过期，通过userID判断
     2.对上述情景做相应的处理
     */
//    NSLog(@"用户授权成功！");
//    //先在这里保存一下用户授权数据
//    WBAuthorizeResponse *result = ( WBAuthorizeResponse *)notify.object;
//    User *user = [CoreDataManager modelWithClassName:@"User"];
//    user.wbCurrentUserID = result.userID;
//    user.wbRefreshToken = result.refreshToken;
//    user.wbtoken = result.accessToken;
//    user.expirationDate = result.expirationDate;
//    [kManagedObjectContext save:nil];
    
    [super userAuthorizeSuccess:notify];
    
    _currentUser = [User currentUser];
    
    [SVProgressHUD show];
    
    [self loadDataWithRequestType:HomeRequestTypeRefresh];
    
//    [CMNetwork GET:kURL_UserInfo parameters:@{@"access_token" : user.wbtoken, @"uid" : @(user.wbCurrentUserID.longLongValue)} success:^(NSString * _Nonnull jsonString) {
//
//        UserModel *usermodel = [UserModel initWithJSONString:jsonString];
//        NSLog(@"用户昵称： %@",usermodel.screen_name);
//        NSLog(@"用户大头像：%@",usermodel.avatar_large);
//    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
//        
//    }];
    
}

//用户授权失败
/**
 *  思路：用户授权失败后，先检查user数据库是否为空，如果为空，显示空页面，提示去登录授权，
 如果不为空，则请求已存user的微博数据
 */
- (void)userAuthorizeFailure:(NSNotification *)notify {
//    Weakself;
    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable arr) {
        if (arr == nil || arr.count == 0) {
            //数据库中没有存储user，数据库为空
            
        }
    }];
}

//用户收藏成功
- (void)userFavoriteSuccess:(NSNotification *)notify {
    
//    [self loadData];
}

- (void)lookupMyGroupList {
    MMDrawerController *drawController = App.mainViewController;
    Weakself;
    [drawController toggleDrawerSide:MMDrawerSideLeft animated:true completion:^(BOOL finished) {
        CMBrowserViewController *browser = [[CMBrowserViewController alloc] initWithUrl:kURL_EditMyGroup];
        [weakself.navigationController pushViewController:browser animated:true];
    }];
    
}

#pragma mark - Load Data
- (void)loadDataWithRequestType:(HomeRequestType)type {
    if (_currentUser != nil) {
        Weakself;
        //请求一条微博
        _requestCount += kRequestCount.integerValue;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [CMNetwork GET:kURL_UserTimeline parameters:@{@"access_token" : [User currentUser].wbtoken,@"count" : kRequestCount} success:^(NSString * _Nonnull jsonString) {
//                NSLog(@"%@",jsonString);
                
                if (type == HomeRequestTypeRefresh) {
                    weakself.list = [WeiboList initWithJSONString:jsonString];
                }else {
                    weakself.list = [weakself.list addDataFromJson:jsonString];
                }
                //请求到微博数据列表，刷新UI
                [weakself.showTableView reloadData];
                [weakself.showTableView.pullToRefreshView stopAnimating];
                [weakself.showTableView.infiniteScrollingView stopAnimating];
                NSLog(@"list中的微博数量：%lu",(unsigned long)weakself.list.statuses.count);
                NSLog(@"微博数量总计：%ld",(long)weakself.list.total_number);
            } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
                NSLog(@"请求失败了。。。");
                NSLog(@"%@",error);
                [weakself.showTableView.pullToRefreshView stopAnimating];
                [weakself.showTableView.infiniteScrollingView stopAnimating];
            }];
        });
    }
}

#pragma mark - Build UI

//- (SidePullView *)sidePullView {
//    if (_sidePullView == nil) {
////        _sidePullView = [SidePullViewWidth];
//    }
//    return _sidePullView;
//}

- (void)buildTableView {
    _showTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:UITableViewStylePlain];
    _showTableView.delegate = (id<UITableViewDelegate>) self;
    _showTableView.dataSource = (id<UITableViewDataSource>) self;
    _showTableView.tableFooterView = [UIView new];
    [self.view addSubview:_showTableView];
    
    Weakself;
    [_showTableView addPullToRefreshWithActionHandler:^{
        [weakself loadDataWithRequestType:HomeRequestTypeRefresh];
    }];
    [_showTableView addInfiniteScrollingWithActionHandler:^{
        [weakself loadDataWithRequestType:HomeRequestTypeMore];
    }];
}


- (void)buildNavigationItems {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Side"] style:UIBarButtonItemStylePlain target:self action:@selector(showOrCloseSideView)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EditWeibo"] style:UIBarButtonItemStylePlain target:self action:@selector(editWeibo)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UITableViewDataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.statuses.count > 0 ? _list.statuses.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboModel *model = [_list.statuses objectAtIndex:indexPath.row];
    return model.cellFrames.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboModel *model = [_list.statuses objectAtIndex:indexPath.row];
    WeiboCell *cell = [WeiboCell cellWithTableView:tableView Indexpath:indexPath WeiboModel:model];
    cell.delegate = self;
    Weakself;
    cell.eventHandleBlock = ^(WBClickEventType type){
        if (type == WBClickEventTypeRepost) {
            RepostViewController *repostVC = [[RepostViewController alloc] initWithLeftTitle:@"取消" RightTitle:@"发送"];
            repostVC.model = model;
            CMBaseNavigationController *nav = [[CMBaseNavigationController alloc] initWithRootViewController:repostVC];
            [weakself.navigationController presentViewController:nav animated:true completion:nil];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - WeiboCellDelegate 事件处理

/// 正文富文本点击事件处理
- (void)cm_weiboCellContentClickEventHandleWithContainerView:(UIView *)containerView Text:(NSString *)text Rect:(CGRect)rect EventType:(WBClickEventType)clickType {
    switch (clickType) {
        case WBClickEventTypeTopic: {
            //话题topic
            TopicViewController *topicVC = [[TopicViewController alloc] initWithTopic:text];
            [self.navigationController pushViewController:topicVC animated:true];
            break;
        }
        case WBClickEventTypeHttpURl:{
            //http类型
            CMBrowserViewController *browser = [[CMBrowserViewController alloc] initWithUrl:text];
            [self.navigationController pushViewController:browser animated:true];
            break;
        }
            
        case WBClickEventTypeAtSomeOne:
            
            break;
        default:
            break;
    }
}

#pragma mark - NavigationItem Event handle

- (void)showOrCloseSideView {
    //显示或隐藏左边栏
    MMDrawerController *drawController = App.mainViewController;
    [drawController toggleDrawerSide:MMDrawerSideLeft animated:true completion:^(BOOL finished) {
        
    }];
    
    
//    [CMNetwork GET:kURL_UserInfo parameters:@{@"access_token" : [User currentUser].wbtoken ,@"uid" : [User currentUser].wbCurrentUserID} success:^(NSString * _Nonnull jsonString) {
//        NSLog(@"-- : %@",jsonString);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
//    CMBrowserViewController *editMyGroupList = [[CMBrowserViewController alloc] initWithUrl:kURL_EditMyGroup];
//    [self.navigationController pushViewController:editMyGroupList animated:true];
}

- (void)editWeibo {

}

@end
