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
    self.bannerScrollView = scrollView;
    [self.contentView addSubview:self.bannerScrollView];
}
- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup{
    NSMutableArray *titleArray = [NSMutableArray array];
    [titleArray removeAllObjects];
    NSMutableArray *imageViewUrlArray = [NSMutableArray array];
    [imageViewUrlArray removeAllObjects];
    for (NSDictionary *dic in imageURLStringsGroup) {
        [titleArray addObject:dic[@"title"]];
        [imageViewUrlArray addObject:dic[@"photo"]];
    }
    self.bannerScrollView.titlesGroup = titleArray ? titleArray : @[@"ssss"];
    self.bannerScrollView.localizationImageNamesGroup = imageViewUrlArray;
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
