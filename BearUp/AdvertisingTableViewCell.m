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
        advertisingImageView.image = [UIImage imageNamed:@"未加载好图片长"];
        [self.contentView addSubview:advertisingImageView];
        [advertisingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.height.equalTo(self.contentView.mas_height);
            make.top.equalTo(self.contentView.mas_top).offset(5);
        }];
        advertisingImageView.userInteractionEnabled = YES; 
        self.adImageView = advertisingImageView;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"广告关闭按钮"] forState:UIControlStateNormal];
        [advertisingImageView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(advertisingImageView.mas_right);
            make.top.equalTo(advertisingImageView.mas_top);
            make.height.equalTo(@35);
            make.width.equalTo(@35);
        }];
        [closeBtn addTarget:self action:@selector(adClose:) forControlEvents:UIControlEventTouchUpInside];
        self.closeBtn = closeBtn;
    }
    return self;
}
- (void)adClose:(UIButton *)btn{
    if (self.adCloseBlock) {
        self.adCloseBlock(btn);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
