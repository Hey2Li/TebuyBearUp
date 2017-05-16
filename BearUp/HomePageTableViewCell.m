
//
//  HomePageTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/5/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initWithCell];
    }
    return self;
}
- (void)initWithCell{
    self.contentImageView = [[UIImageView alloc]init];
    self.contentImageView.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:self.contentImageView];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"这是标题";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 2;
    [self.contentImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentImageView.mas_left).offset(50);
        make.right.equalTo(self.contentImageView.mas_right).offset(-50);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.contentImageView.mas_centerY);
    }];
    
    self.hotNumLabel = [UILabel new];
    self.hotNumLabel.text = @"999";
    self.hotNumLabel.textColor = [UIColor redColor];
    self.hotNumLabel.font = [UIFont systemFontOfSize:14];
    [self.contentImageView addSubview:self.hotNumLabel];
    [self.hotNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentImageView.mas_right).offset(-10);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentImageView.mas_bottom);
    }];
    
    self.hotLabel = [UILabel new];
    self.hotLabel.text = @"热度";
    self.hotLabel.font = [UIFont systemFontOfSize:14];
    [self.contentImageView addSubview:self.hotLabel];
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hotNumLabel.mas_top).offset(-10);
        make.left.equalTo(self.hotNumLabel.mas_left);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
