//
//  CommentsTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/5/26.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "CommentsTableViewCell.h"

@implementation CommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self layoutIfNeeded];
    [self.headerImageView setImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self cutRoundView:self.headerImageView];
    [self.praiseBtn setImage:[UIImage imageNamed:@"点赞灰"] forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
    [self.praiseBtn setTitle:@"12221" forState:UIControlStateNormal];
    self.praiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.praiseBtn.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    [self.praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)praiseClick:(UIButton *)sender{
    NSLog(@"parsieclick");
    sender.selected = !sender.selected;
}
// 切圆角
- (void)cutRoundView:(UIImageView *)imageView {
    CGFloat corner = imageView.frame.size.width / 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
