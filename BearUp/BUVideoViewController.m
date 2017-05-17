//
//  BUVideoViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUVideoViewController.h"
#import "HomeContentTableViewController.h"
#import "BUTopTitleBar.h"

@interface BUVideoViewController ()<UIScrollViewDelegate, BUTopTitleBarDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) HomeContentTableViewController *needScrollToTopPage;
@property (nonatomic, strong) BUTopTitleBar *topTitleBar;
@end

@implementation BUVideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArray = @[@"推荐",@"漫画",@"八卦",@"育儿",@"时尚",@"搞笑",@"涨知识",@"精品集"];
    [self setupViewControllers];
    [self setupContentView];
    [self initWithTopBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)initWithTopBar{
    self.topTitleBar = [[BUTopTitleBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64) AndItems:self.titleArray];
    self.topTitleBar.itemTitles = self.titleArray;
    self.topTitleBar.backgroundColor = [UIColor redColor];
    self.topTitleBar.delegate = self;
    [self.view addSubview:self.topTitleBar];
    
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
    self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.childViewControllers.count, self.contentScrollView.frame.size.height);
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    [self.view insertSubview:self.contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex{
    NSLog(@"%ld,%ld",(long)index,(long)currentIndex);

      [self.contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //获得索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.topTitleBar.currentItemIndex = index;
    UIViewController *vc = self.childViewControllers[index];
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
