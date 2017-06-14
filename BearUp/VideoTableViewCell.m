//
//  VideoTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/5/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "VideoTableViewCell.h"


@interface VideoTableViewCell()<ZFPlayerDelegate, ZFPlayerControlViewDelagate>
@property (nonatomic, strong) ZFPlayerView *playerView;
@end
@implementation VideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initWithCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.userInteractionEnabled = YES;
    }
    return self;
}
- (void)initWithCell{
    UIImageView *picView = [UIImageView new];
    picView.image = [UIImage imageNamed:@"index_shipin"];
    [self.contentView addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    self.picView = picView;
    // 设置imageView的tag，在PlayerView中取（建议设置100以上）
    self.picView.tag = 101;
    self.picView.userInteractionEnabled = YES;
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.picView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picView);
        make.right.equalTo(self.picView);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UILabel *playAmountLabel = [UILabel new];
    playAmountLabel.textAlignment = NSTextAlignmentLeft;
    playAmountLabel.font = [UIFont systemFontOfSize:12];
    playAmountLabel.backgroundColor = [UIColor clearColor];
    playAmountLabel.textColor = [UIColor whiteColor];
    playAmountLabel.text = @"4123播放";
    [bottomView addSubview:playAmountLabel];
    [playAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@15);
    }];
    
    UILabel *playTimeLabel = [UILabel new];
    playTimeLabel.textAlignment = NSTextAlignmentRight;
    playTimeLabel.font = [UIFont systemFontOfSize:12];
    playTimeLabel.backgroundColor = [UIColor clearColor];
    playTimeLabel.textColor = [UIColor whiteColor];
    playTimeLabel.text = @"3:20";
    [bottomView addSubview:playTimeLabel];
    [playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-10);
        make.height.equalTo(@15);
        make.width.equalTo(@50);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.picView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picView);
        make.width.height.mas_equalTo(50);
    }];
 
}
- (void)setModel:(ZFVideoModel *)model {
//    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
}
- (void)play:(UIButton *)sender{
    if (self.playBlock) {
        self.playBlock(sender);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
