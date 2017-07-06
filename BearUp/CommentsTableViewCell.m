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
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.headerImageView setImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self cutRoundView:self.headerImageView];
    [self.praiseBtn setImage:[UIImage imageNamed:@"点赞灰"] forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
    [self.praiseBtn setTitle:@"12221" forState:UIControlStateNormal];
    self.praiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.praiseBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    [self.praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.commentLabel setValue:@(30) forKey:@"lineSpacing"];
    self.commentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    self.dateLabel.textColor = UIColorFromRGB(0xaeaeae);
    self.userName.textColor = UIColorFromRGB(0x6b6b6b);
    
}
- (void)praiseClick:(UIButton *)sender{
    NSLog(@"parsieclick");
    sender.selected = !sender.selected;
    NSInteger num = [sender.titleLabel.text integerValue];
    num++;
    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateSelected];
}
- (void)setModel:(CommentModel *)model{
    _model = model;
    self.commentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",model.time];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photo]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%@",model.agree] forState:UIControlStateNormal];
    self.userName.text = [NSString stringWithFormat:@"%@",model.nickname];
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
