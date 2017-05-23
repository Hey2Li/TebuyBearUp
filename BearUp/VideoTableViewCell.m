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
    }
    return self;
}
- (void)initWithCell{
    ZFPlayerView *playerView = [[ZFPlayerView alloc]init];
    [self.contentView addSubview:playerView];
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc]init];
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.fatherView = self.contentView;
    playerModel.videoURL = [NSURL URLWithString:@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4"];
    playerModel.placeholderImage = [UIImage imageNamed: @"index_shipin.jpg"];

    [playerView playerControlView:controlView playerModel:playerModel];
    
    playerView.delegate = self;
    
    self.playerView = playerView;
    
    self.playerView.

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
