//
//  ManangeAccountViewController.m
//  CMWeibo
//
//  Created by 贾宸穆 on 16/6/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "ManangeAccountViewController.h"
#import "ManageAccountCell.h"
#import "CMView.h"

@interface ManangeAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *showTableView;

@property (strong, nonatomic) NSMutableArray <UserModel *> *userArray;

@end

@implementation ManangeAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userArray = [NSMutableArray array];
    [self buildTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadUserInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildTableView {
    _showTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
    _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _showTableView.delegate = self;
    _showTableView.dataSource = self;
    _showTableView.tableFooterView = [CMView viewWithBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_showTableView];
}

- (void)loadUserInfo {
    Weakself;
    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable array) {
        [weakself getUerInfo:array];
    }];
}

- (void)getUerInfo:(NSArray <User *> *)array {
    Weakself;
    NSLog(@"token : %@ , uid : %@",[array lastObject].wbtoken,[array lastObject].wbCurrentUserID);
    [array enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [CMNetwork async_GET:kURL_UserInfo parameters:@{@"access_token" : obj.wbtoken, @"uid" : @(obj.wbCurrentUserID.longLongValue)} success:^(NSString * _Nonnull jsonString) {
            UserModel *model = [UserModel initWithJSONString:jsonString];
            [weakself.userArray addObject:model];
            
            [weakself.showTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"用户%@信息请求失败",obj.wbCurrentUserID]];
        }];
    }];
}

#pragma mark - UITableViewDelegate\DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.userArray && [self.userArray count] > 0) {
        return [self.userArray count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManageAccountCell *cell = [ManageAccountCell cellWithTableView:tableView Model:_userArray[indexPath.row]];
    Weakself;
    cell.selectUserBlock = ^(){
        [weakself.showTableView reloadData];
    };
    return cell;
}



@end
