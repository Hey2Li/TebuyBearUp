//
//  ScrollBannerTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/5/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "ScrollBannerTableViewCell.h"


@interface ScrollBannerTableViewCell()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;
@end
@implementation ScrollBannerTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initWithCell];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}
- (void)initWithCell{
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"index_banner"]];
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    scrollView.currentPageDotColor = DRGBCOLOR;
    scrollView.pageDotColor = [UIColor whiteColor];
    scrollView.titlesGroup = @[@"马云乡村教师奖颁奖典礼进行中",@"马云乡村教师奖颁奖典礼进行中",@"马云乡村教师奖颁奖典礼进行中",@"马云乡村教师奖颁奖典礼进行中",@"马云乡村教师奖颁奖典礼进行中"];
    self.bannerScrollView = scrollView;
    self.bannerScrollView.localizationImageNamesGroup = @[@"index_banner",@"index_banner",@"index_banner",@"index_banner",@"index_banner"];
//    if (self.imageURLStringsGroup) {
//        self.bannerScrollView.imageURLStringsGroup = self.imageURLStringsGroup;
//    }
    [self.contentView addSubview:self.bannerScrollView];
}
//点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
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
