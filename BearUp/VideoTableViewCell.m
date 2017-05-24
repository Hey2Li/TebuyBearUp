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
    [self.contentView addSubview:picView];
    picView.image = [UIImage imageNamed:@"index_shipin.jpg"];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    self.picView = picView;
    self.picView.tag = 101;
    
    UIButton *playBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:playBtn];
    [self.contentView bringSubviewToFront:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picView);
        make.width.height.mas_equalTo(50);
    }];
    self.playBtn = playBtn;
//    
//    ZFPlayerView *playerView = [[ZFPlayerView alloc]init];
//    [self.contentView addSubview:playerView];
//    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left);
//        make.right.equalTo(self.contentView.mas_right);
//        make.top.equalTo(self.contentView.mas_top);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//    }];
//    
//    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc]init];
//    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
//    playerModel.fatherView = self.contentView;
//    playerModel.videoURL = [NSURL URLWithString:@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4"];
//    playerModel.placeholderImage = [UIImage imageNamed: @"index_shipin.jpg"];
//    playerModel.indexPath = self.indexPath;
//    playerModel.tableView = self.tabelView;
//
//    [playerView playerControlView:controlView playerModel:playerModel];
//    
//    playerView.delegate = self;
//    
//    self.playerView = playerView;
    
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
