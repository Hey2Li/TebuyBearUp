//
//  MyStateTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/7/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "MyStateTableViewCell.h"

@interface MyStateTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelHeight;

@end

@implementation MyStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = NO;
    [self.headerImageVIew.layer setMasksToBounds:YES];
    [self.headerImageVIew.layer setCornerRadius:25];
     self.timeLabel.textColor = UIColorFromRGB(0xaeaeae);
    self.articleTitleLabel.textColor = UIColorFromRGB(0xaeaeae);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_myStateCellStyle == MyStateCellStyleShare) {
        self.typeLabel.text = @"我分享了这篇文章";
        self.commentLabel.hidden = YES;
        self.commentLabelHeight.constant = CGFLOAT_MIN;
    }else if (_myStateCellStyle == MyStateCellStylePraiseComment){
        self.typeLabel.text = @"我赞了Ta的评论";
        self.commentLabel.hidden = YES;
        self.commentLabelHeight.constant = CGFLOAT_MIN;
    }else if (_myStateCellStyle == MyStateCellStyleComment){
        self.typeLabel.text = @"我评论了这篇文章";
        self.commentLabel.hidden = NO;
        self.commentLabelHeight.constant = 21;
    }else if (_myStateCellStyle == MyStateCellStylePraiseArticle){
        self.typeLabel.text = @"我赞了这篇文章";
        self.commentLabel.hidden = YES;
        self.commentLabelHeight.constant = CGFLOAT_MIN;
    }else if (_myStateCellStyle == MyStateCellStyleCollectionArticle){
        self.typeLabel.text = @"我收藏了这篇文章";
        self.commentLabel.hidden = YES;
        self.commentLabelHeight.constant = CGFLOAT_MIN;
    }
}
- (void)setModel:(MyStateModel *)model{
    _model = model;
    _myStateCellStyle = [model.stype integerValue];
    [self.headerImageVIew sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"游客登录默认"]];
    self.timeLabel.text = model.time;
    self.articleTitleLabel.text = model.title;
    if (_myStateCellStyle == MyStateCellStyleComment) {
        self.commentLabel.text = model.content;
    }
    [self layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
