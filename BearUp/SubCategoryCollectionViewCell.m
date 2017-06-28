//
//  SubCategoryCollectionViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/6/27.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "SubCategoryCollectionViewCell.h"

@interface SubCategoryCollectionViewCell ()
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SubCategoryCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *topImageView = [UIImageView new];
        topImageView.image = [UIImage imageNamed:@"index_shipin"];
        [self.contentView addSubview:topImageView];
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(self.contentView.bounds.size.height - 20);
        }];
        
        self.subImageView = topImageView;
        
        UILabel *subTitleLabel = [UILabel new];
        subTitleLabel.text = @"娃逛迪士尼你你你你你你你";
        [self.contentView addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@20);
            make.top.equalTo(topImageView.mas_bottom);
        }];
        
        self.subTitleLabel = subTitleLabel;
    }
    return self;
}
@end
