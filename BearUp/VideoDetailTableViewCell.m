//
//  VideoDetailTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/6/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "VideoDetailTableViewCell.h"

@implementation VideoDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoTitle.textColor = UIColorFromRGB(0x000000);
    self.videoDetails.textColor = UIColorFromRGB(0x6b6b6b);
//    [shareBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.hotBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.praiseBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.commendBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
