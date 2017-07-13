//
//  MIneCollectionTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/7/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "MIneCollectionTableViewCell.h"

@implementation MIneCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = NO;
    // Initialization code
}
- (void)setModel:(MyCollectionModel *)model{
    _model = model;
    [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"游客登录默认"]];
    self.articleDetail.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
