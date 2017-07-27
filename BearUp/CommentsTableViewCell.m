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
    [self.headerImageView setImage:[UIImage imageNamed:@"用户默认头像"]];
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
     if ([self.model.com_type isEqual:@1]) {
        [LTHttpManager agreeNewCommentWithId:self.model.ID User_uuid:GETUUID User_id:USER_ID User_token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                sender.selected = !sender.selected;
                [sender setTitle:[NSString stringWithFormat:@"%@",data[@"responseData"]] forState:UIControlStateSelected];
                [sender setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
                sender.userInteractionEnabled = NO;
                SVProgressShowStuteText(@"点赞成功", YES);
            }else{
                SVProgressShowStuteText(@"点赞失败", NO);
            }
        }];
    }else if([self.model.com_type isEqual:@2]){
        [LTHttpManager agreeVideoCommentWithId:self.model.ID User_uuid:GETUUID User_id:USER_ID User_token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                sender.selected = !sender.selected;
                [sender setTitle:[NSString stringWithFormat:@"%@",data[@"responseData"]] forState:UIControlStateSelected];
                [sender setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
                sender.userInteractionEnabled = NO;
                SVProgressShowStuteText(@"点赞成功", YES);
            }else{
                SVProgressShowStuteText(@"点赞失败", NO);
            }
        }];
    }
}
- (void)setModel:(CommentModel *)model{
    _model = model;
    self.commentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",model.time];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photo]] placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
    if ([model.is_agree isEqual:@1]) {
        self.praiseBtn.selected = YES;
        [self.praiseBtn setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
        self.praiseBtn.userInteractionEnabled = NO;
    }else{
        self.praiseBtn.selected = NO;
        [self.praiseBtn setImage:[UIImage imageNamed:@"点赞灰"] forState:UIControlStateNormal];
        self.praiseBtn.userInteractionEnabled = YES;
    }
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
