//
//  SysMsgTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/7/13.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "SysMsgTableViewCell.h"

@implementation SysMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.sysMsgBKView.layer setMasksToBounds:YES];
    [self.sysMsgBKView.layer setCornerRadius:5];
    self.selectionStyle = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
