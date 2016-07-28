//
//  SelectPlaceCell.m
//  CMWeibo
//
//  Created by jiachenmu on 16/7/27.
//  Copyright © 2016年 jiachenmu. All rights reserved.
//

#import "SelectPlaceCell.h"

@interface SelectPlaceCell ()

/// 地址名称简写
@property (weak, nonatomic) IBOutlet UILabel *poisNameLabel;
/// 方向
@property (weak, nonatomic) IBOutlet UILabel *directLabel;
/// 距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/// tag
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;

@end

@implementation SelectPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// indexPath.row == 0

- (void)setModel:(CMLocationModel *)model {
    _model = model;
    
    _poisNameLabel.text = _model.business;
    
    _directLabel.text = @"附近";
    
    _distanceLabel.text = @"0m";
    
    _tagLabel.text = _model.business;
    
    _detailAddressLabel.text = _model.formatted_address;
}

- (void)setPoisInfo:(PoistionNearByModel *)poisInfo {
    _poisInfo = poisInfo;
 
    _poisNameLabel.text = _poisInfo.name;
    
    _directLabel.text = _poisInfo.direction;
    
    _distanceLabel.text = [_poisInfo.distance stringByAppendingString:@"m"];
    
    _tagLabel.text = _poisInfo.tag;
    
    _detailAddressLabel.text = _poisInfo.addr;
}

@end
