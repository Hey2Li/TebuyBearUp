//
//  CategoryTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/6/28.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.leftImageView.layer setMasksToBounds:YES];
    [self.leftImageView.layer setCornerRadius:10];
    
    self.categoryNameLabel.textColor = UIColorFromRGB(0x000000);
    self.categoryNameLabel.font = [UIFont systemFontOfSize:18];
    
    [self.focusBtn.layer setMasksToBounds:YES];
    [self.focusBtn.layer setCornerRadius:13];
    [self.focusBtn.layer setBorderWidth:1];
    [self.focusBtn.layer setBorderColor:UIColorFromRGB(0xff4466).CGColor];
    [self.focusBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [self.focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.focusBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
    [self.focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [self.focusBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateSelected];
    [self.focusBtn addTarget:self action:@selector(focusClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.introducelabel.textColor = UIColorFromRGB(0xaeaeae);
    self.introducelabel.font = [UIFont systemFontOfSize:14];
    
    self.subTitleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.subTitleLabel.font = [UIFont systemFontOfSize:14];

}
- (void)focusClick:(UIButton *)btn{
    if (self.focusCategoryClick) {
        self.focusCategoryClick(btn);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
