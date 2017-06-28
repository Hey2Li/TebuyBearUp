//
//  HorizontalTableViewCell.m
//  
//
//  Created by Tebuy on 2017/6/5.
//
//

#import "HorizontalTableViewCell.h"
#import "SubCategoryCollectionViewCell.h"

@interface HorizontalTableViewCell()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
static NSString *SUBCATEGORY = @"subcateoryCell";
@implementation HorizontalTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *topImageView = [UIImageView new];
        topImageView.image = [UIImage imageNamed:@"发现页—排行版_03.jpg"];
        topImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:topImageView];
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top);
            make.height.equalTo(@100);
        }];
        UIImageView *sanjiaoImageView = [UIImageView new];
        sanjiaoImageView.image = [UIImage imageNamed:@"热门分类三角"];
        [topImageView addSubview:sanjiaoImageView];
        [sanjiaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageView.mas_left).offset(10);
            make.bottom.equalTo(topImageView.mas_bottom).offset(2);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"分类标题背景"] forState:UIControlStateNormal];
        [titleBtn setTitle:@"搞笑" forState:UIControlStateNormal];
        [titleBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [titleBtn setBackgroundColor:[UIColor whiteColor]];
        [topImageView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(topImageView);
            make.height.equalTo(@50);
            make.width.equalTo(@100);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 120) collectionViewLayout:flowlayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[SubCategoryCollectionViewCell class] forCellWithReuseIdentifier:SUBCATEGORY];
        collectionView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100 , 110);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 10, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SubCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SUBCATEGORY forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.HorCollectionCellClick(indexPath);
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
