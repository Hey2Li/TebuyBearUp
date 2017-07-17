//
//  MineMsgTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/7/13.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "MineMsgTableViewCell.h"

@implementation MineMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.mineMsgBKView.layer setMasksToBounds:YES];
    [self.mineMsgBKView.layer setCornerRadius:5];
    self.selectionStyle = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
