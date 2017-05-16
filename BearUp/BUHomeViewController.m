//
//  BUHomeViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUHomeViewController.h"
#import "HomeContentTableViewController.h"
#import "BUTitleLabel.h"

@interface BUHomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) BUTitleLabel *oldTitleLable;
@property (nonatomic, strong) HomeContentTableViewController *needScrollToTopPage;
@end

@implementation BUHomeViewController

- (void)addLabel{
    UIView *indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 42, 50, 2)];
    indicatorView.backgroundColor = [UIColor orangeColor];
    for (int i = 0; i < 8; i ++ ) {
        CGFloat lblW = 70;
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        BUTitleLabel *lbl1 = [[BUTitleLabel alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text = vc.title;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont systemFontOfSize:19];
        [self.titleScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblClick:)]];
    }
    self.titleScrollView.contentSize = CGSizeMake(70 * 8, 0);
    BUTitleLabel *titleLabel = [self.titleScrollView.subviews firstObject];
    titleLabel.scale = 1.0;
}
//标题栏点击事件
- (void)lblClick:(UITapGestureRecognizer *)tap{
    BUTitleLabel *titleLabel = (BUTitleLabel *)tap.view;
    CGFloat offSetX = titleLabel.tag * self.contentScrollView.frame.size.width;
    CGFloat offSetY = self.contentScrollView.contentOffset.y;
    CGPoint offSet = CGPointMake(offSetX, offSetY);
    [self.contentScrollView setContentOffset:offSet animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArray = @[@"推荐",@"漫画",@"八卦",@"育儿",@"时尚",@"搞笑",@"涨知识",@"精品集"];
    [self setupViewControllers];
    [self setupContentView];
    [self setupTitleScrollView];
    [self addLabel];
}
- (void)setupTitleScrollView{
    self.titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 , SCREEN_WIDTH, 44)];
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleScrollView];
    
    self.titleScrollView.showsVerticalScrollIndicator = NO;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.scrollsToTop = NO;
    
}
- (void)setupViewControllers{
    for (int i = 0; i < _titleArray.count; i ++) {
        HomeContentTableViewController *vc = [[HomeContentTableViewController alloc]init];
        vc.title = _titleArray[i];
        [self addChildViewController:vc];
    }
}
- (void)setupContentView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104 - 44)];
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.childViewControllers.count, self.contentScrollView.frame.size.height);
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    [self.view insertSubview:self.contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}
#pragma mark scrollViewDelegate
//产生动画的时候
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //获得索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    BUTitleLabel *titleLabel = (BUTitleLabel *)self.titleScrollView.subviews[index];
    CGFloat offsetx = titleLabel.center.x - self.titleScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMaxX = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMaxX){
        offsetx = offsetMaxX;
    }
    CGPoint offset = CGPointMake(offsetx, self.titleScrollView.contentOffset.y);
    [self.titleScrollView setContentOffset:offset animated:YES];
    UIViewController *vc = self.childViewControllers[index];
    
    [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            BUTitleLabel *temlabel = self.titleScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    if (vc.view.superview) {
        return;
    }
    
    vc.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
}
//停止滚动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
//正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftindex = (int)value;
    NSUInteger rightIndex = leftindex + 1;
    CGFloat scaleRight = value - leftindex;
    CGFloat scaleLeft = 1 - scaleRight;
    BUTitleLabel *labelLeft = self.titleScrollView.subviews[leftindex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.titleScrollView.subviews.count) {
        BUTitleLabel *labelRight = self.titleScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
