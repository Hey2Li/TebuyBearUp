//
//  AdvertisingTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/6/27.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "AdvertisingTableViewCell.h"

@implementation AdvertisingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *advertisingImageView = [UIImageView new];
        advertisingImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:advertisingImageView];
        [advertisingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.height.equalTo(self.contentView.mas_height);
            make.top.equalTo(self.contentView.mas_top).offset(5);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [advertisingImageView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(advertisingImageView.mas_right).offset(-10);
            make.top.equalTo(advertisingImageView.mas_top).offset(10);
            make.height.equalTo(@50);
            make.width.equalTo(@50);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
