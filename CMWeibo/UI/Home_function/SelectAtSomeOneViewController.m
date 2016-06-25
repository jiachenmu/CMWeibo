//
//  SelectAtSomeOneViewController.m
//  CMWeibo
//
//  Created by jiachen on 16/6/7.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

/*
这里没有将cell 单独抽出来，写在了这个文件里面
 */

#import "SelectAtSomeOneViewController.h"
#import "UserModel.h"


#pragma mark - Cell

@interface AtSomeOneCell : UITableViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *selectBtn;
// 该用户是否已被选中
@property (assign, nonatomic) BOOL isSelected;

@property (copy, nonatomic) UserModel *userModel;

@end

const CGFloat IconLeftMargin       = 10;
const CGFloat NameLeftMargin       = 10;
const CGFloat CellHeight           = 60;
const CGFloat IconHeight           = 40;
const CGFloat SelectBtnRightMargin = 24;
const CGFloat SelectBtnWidth       = 20;

@implementation AtSomeOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildUI];
    }
    
    return self;
}

// Build UI
- (void)buildUI {
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(IconLeftMargin, CellHeight/2 - IconHeight/2, IconHeight, IconHeight)];
    _imgView.layer.cornerRadius = IconHeight/2;
    _imgView.layer.masksToBounds = true;
    [self.contentView addSubview:_imgView];
    
    CGFloat nameLabel_maxLength = SCREEN_WIDTH - CGRectGetMaxX(_imgView.frame) - NameLeftMargin - SelectBtnRightMargin - SelectBtnWidth;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame) + NameLeftMargin, CellHeight/2 - 15.0/2, nameLabel_maxLength, 15)];
    _nameLabel.textColor = Color_ContentText;
    _nameLabel.font = Font(15);
    [self.contentView addSubview:_nameLabel];
    
    _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SelectBtnRightMargin - SelectBtnWidth, CellHeight/2 - SelectBtnWidth/2, SelectBtnWidth, SelectBtnWidth)];
    [_selectBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectBtn];
}

//更新UI
- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    [_imgView yy_setImageWithURL:[NSURL URLWithString:_userModel.avatar_hd] options:YYWebImageOptionUseNSURLCache];
    _nameLabel.text = _userModel.screen_name;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _selectBtn.selected = _isSelected;
}

// 调用方法
#define AtSomeCellID @"AtSomeCellID"

+ (instancetype)cellWithTableView:(UITableView *)tableView Model:(UserModel *)model {
    AtSomeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:AtSomeCellID];
    if (!cell) {
        cell = [[AtSomeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AtSomeCellID];
    }
    cell.userModel = model;
    return cell;
}

@end




#pragma mark - ViewController



@interface SelectAtSomeOneViewController()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *showTableView;

@property (strong, nonatomic) NSArray <UserModel *> *userList;

/// 记录cell是否选中
@property (strong, nonatomic) NSMutableArray <NSNumber *> *selectList;



@end


@implementation SelectAtSomeOneViewController

- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle{
    if (self = [super initWithLeftTitle:leftTitle RightTitle:rightTitle]) {
        _userList = [[NSArray alloc] init];
        _selectList = [NSMutableArray array];
        [self buildUI];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)barOK {
    //将所有选中的用户名称前加@ 然后拼接起来
    NSMutableString *str = [NSMutableString string];
    [_selectList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.boolValue) {
            [str appendFormat:@"@%@ ",_userList[idx].screen_name];
        }
    }];
    if (_selectAtNameArrayBlock) {
        _selectAtNameArrayBlock(str);
    }
    
    [super barOK];
}

/// MARK: Build UI
- (void)buildUI {
    _showTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _showTableView.backgroundColor = [UIColor whiteColor];
    _showTableView.delegate = self;
    _showTableView.dataSource = self;
    _showTableView.tableFooterView = [UIView new];
    [self.view addSubview:_showTableView];
}


/// MARK: 请求用户关注的列表
- (void)loadData {
    Weakself;
    [CMNetwork GET:kURL_FriendsList parameters:@{@"access_token" : [User currentUser].wbtoken , @"uid" : [User currentUser].wbCurrentUserID} success:^(NSString * _Nonnull jsonString) {
        FriendsListModel *list = [FriendsListModel initWithJSONString:jsonString];
        weakself.userList = list.users;
        
        // 初始化记录列表
        for (int i = 0; i < list.users.count; i++) {
            [weakself.selectList addObject:@(false)];
        }
        
        NSLog(@"关注的总人数： %ld",list.users.count);
        [weakself.showTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// MARK: UITableViewDelegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_userList && _userList.count > 0) {
        return _userList.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AtSomeOneCell *cell = [AtSomeOneCell cellWithTableView:tableView Model:_userList[indexPath.row]];
    cell.isSelected = _selectList[indexPath.row].boolValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //选择要@的对象 依次添加到数组中
    AtSomeOneCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    _selectList[indexPath.row] = @(cell.isSelected);
    
}

@end
