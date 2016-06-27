//
//  ManageAccountCell.m
//  CMWeibo
//
//  Created by 贾宸穆 on 16/6/25.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "ManageAccountCell.h"


@interface ManageAccountCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (copy, nonatomic) UserModel *model;

@end

static NSString *ManageCellID = @"ManageCellID";

@implementation ManageAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _iconView.layer.cornerRadius = 43/2;
    _iconView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 选中微博用户
- (IBAction)selectThisUser:(id)sender {
    if (_selectBtn.isSelected) {
        return;
    }
    __block User *tempUser = [CoreDataManager modelWithClassName:@"User"];
    Weakself;
    // 将选中的user放在数据库的最后面即可
    [[CoreDataManager shareInstance] arrayWithObjectClass:[User class] CompltetBlock:^(NSArray * _Nullable array) {
        
        [array enumerateObjectsUsingBlock:^(User *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([_model.idstr isEqualToString:obj.wbCurrentUserID]) {
                
                tempUser.wbtoken = obj.wbtoken;
                tempUser.wbCurrentUserID = obj.wbCurrentUserID;
                tempUser.wbRefreshToken = obj.wbRefreshToken;
                tempUser.expirationDate = obj.expirationDate;
                NSLog(@"选中的userID：%@",tempUser.wbCurrentUserID);
                [kManagedObjectContext deleteObject:obj];
                [kManagedObjectContext save:nil];
                weakself.selectBtn.selected = true;
                if (weakself.selectUserBlock) {
                    weakself.selectUserBlock();
                }
            }
        }];
        
    }];
    
}


- (void)setModel:(UserModel *)model {
    _model = model;
    [_iconView yy_setImageWithURL:[NSURL URLWithString:_model.avatar_large] placeholder:DefaultIcon];
    _userNameLabel.text = _model.screen_name;
    
    //是否为当前用户
    _selectBtn.selected = [_model.idstr isEqualToString:[User currentUser].wbCurrentUserID];
}

+ (instancetype)cellWithTableView:(UITableView *)tablewView Model:(UserModel *)model {
    
    ManageAccountCell *cell = [tablewView dequeueReusableCellWithIdentifier:ManageCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ManageAccountCell" owner:nil options:nil] lastObject];
    }
    cell.model = model;
    
    return cell;
}

@end
