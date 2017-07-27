//
//  BUHomeViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUHomeViewController.h"
#import "HomeContentTableViewController.h"
#import "BUTopTitleBar.h"
#import "TYTabButtonPagerController.h"

@interface BUHomeViewController ()<UIScrollViewDelegate, BUTopTitleBarDelegate, TYPagerControllerDelegate, TYPagerControllerDataSource>
{
    NSInteger _currentIndex;
}
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) HomeContentTableViewController *needScrollToTopPage;
@property (nonatomic, strong) BUTopTitleBar *topTitleBar;
@property (nonatomic, strong) TYTabButtonPagerController *pagerController;

@end

@implementation BUHomeViewController

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setupContentView];
//    [self initWithTopBar];
//    [self setupViewControllers];
    [self loadData];
    [self addPagerController];
}
- (void)addPagerController{
    TYTabButtonPagerController *pagerController = [[TYTabButtonPagerController alloc]init];
    pagerController.dataSource = self;
    pagerController.adjustStatusBarHeight = YES;
    pagerController.pagerBarColor = DRGBCOLOR;
    pagerController.selectedTextColor = [UIColor whiteColor];
    pagerController.normalTextColor = [UIColor whiteColor];
    //pagerController.cellWidth = 56;
    pagerController.cellSpacing = 8;
    pagerController.barStyle = TYPagerBarStyleProgressElasticView;
    pagerController.cellEdging = 10;
    pagerController.progressBottomEdging = 2;
    pagerController.pagerBarImageView.image = [UIImage imageNamed:@"navi"];
    
    pagerController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50);
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    /*
     self.view addsubView:pageController.view;
     */
}
- (void)loadData{
    WeakSelf
    [LTHttpManager homeTitleWithLimit:@100 Value:@"id,name" Page:@"1" Nlimit:@"1" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSArray *array = data[@"responseData"][@"column"];
            [weakSelf.titleArray removeAllObjects];
            [self.titleArray addObject:@{@"id":@"0",@"name":@"热门"}];
            for (NSDictionary *dic in array) {
                [weakSelf.titleArray addObject:dic];
            }
            [_pagerController reloadData];
        }else{
           // [self.view makeToast:message];
        }
    }];
}
#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return self.titleArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index{
    return self.titleArray[index][@"name"];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index{
    HomeContentTableViewController *vc  =[HomeContentTableViewController new];
    vc.name = self.titleArray[index][@"name"];
    vc.categoryID = self.titleArray[index][@"id"];
    vc.index = index;
    return vc;
}

//#pragma mark - 自定义TopTitle
//- (void)initWithTopBar{
//    self.topTitleBar = [[BUTopTitleBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64) AndItems:self.titleArray];
//    self.topTitleBar.itemTitles = self.titleArray;
//    self.topTitleBar.delegate = self;
//    self.topTitleBar.backgroundColor = RGBCOLOR(241, 73, 104);
//    [self.view addSubview:self.topTitleBar];
//}
//- (void)setupViewControllers{
//    for (int i = 0; i < _titleArray.count; i ++) {
//        HomeContentTableViewController *vc = [[HomeContentTableViewController alloc]init];
//        vc.title = _titleArray[i][@"name"];
//        vc.categoryID = _titleArray[i][@"id"];
//        [self addChildViewController:vc];
//    }
//}
//- (void)setupContentView{
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.contentScrollView.backgroundColor = [UIColor whiteColor];
//    self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64)];
//    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.childViewControllers.count, self.contentScrollView.frame.size.height);
//    self.contentScrollView.delegate = self;
//    self.contentScrollView.pagingEnabled = YES;
//    [self.view insertSubview:self.contentScrollView atIndex:0];
//    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
//}
//#pragma mark - BUTopTitleBarDelegate
//- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex{
//    NSLog(@"%ld,%ld",(long)index,(long)currentIndex);
//    
//    if (currentIndex-index>=2 || currentIndex-index<=-2) {
//        [self.contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
//        [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
//    }else{
//        [self.contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
//        [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
//    }
//}
//#pragma mark scrollViewDelegate
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    //获得索引
//    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
//    _currentIndex = index;
//    self.topTitleBar.currentItemIndex = _currentIndex;
//   
//    if (self.childViewControllers.count > 0) {
//         HomeContentTableViewController *vc = self.childViewControllers[index];
//        if (vc.view.superview) {
//            return;
//        }
//        vc.view.frame = scrollView.bounds;
//        vc.index = index;
//        [self.contentScrollView addSubview:vc.view];
//    }
//}
////停止滚动时
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self scrollViewDidEndScrollingAnimation:scrollView];
//}
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
