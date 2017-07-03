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
#import "TYTabButtonPagerController.h"
#import "VideoTableViewController.h"

@interface BUVideoViewController ()<UIScrollViewDelegate, BUTopTitleBarDelegate, TYPagerControllerDataSource>
{
    NSInteger _currentIndex;
}
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) HomeContentTableViewController *needScrollToTopPage;
@property (nonatomic, strong) BUTopTitleBar *topTitleBar;
@property (nonatomic, strong) TYTabButtonPagerController *pagerController;
@end

@implementation BUVideoViewController

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.titleArray = @[@"精选",@"原创",@"宠物",@"搞笑",@"萌娃",@"娱乐",@"影视",@"其他",];
    _currentIndex = 1;
//    [self setupViewControllers];
//    [self setupContentView];
//    [self initWithTopBar];
    [self loadData];
    [self addPagerController];
}
- (void)loadData{
    WeakSelf
    [LTHttpManager videoListWithLimit:@100 Value:@"id,name" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSArray *array = data[@"responseData"][@"columns"];
            [weakSelf.titleArray removeAllObjects];
            for (NSDictionary *dic in array) {
                NSString *name = dic[@"name"];
                [weakSelf.titleArray addObject:name];
            }
            [_pagerController reloadData];
        }else{
           // [self.view makeToast:message];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return _titleArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index{
    return _titleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index{
    VideoTableViewController *vc  =[VideoTableViewController new];
    return vc;
}
- (void)initWithTopBar{
//    self.topTitleBar = [[BUTopTitleBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64) AndItems:self.titleArray];
//    self.topTitleBar.itemTitles = self.titleArray;
//    self.topTitleBar.backgroundColor = [UIColor redColor];
//    self.topTitleBar.delegate = self;
//    [self.view addSubview:self.topTitleBar];
    self.topTitleBar = [[BUTopTitleBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64) AndItems:self.titleArray];
    self.topTitleBar.itemTitles = self.titleArray;
    self.topTitleBar.delegate = self;
    self.topTitleBar.backgroundColor = RGBCOLOR(241, 73, 104);
    [self.navigationController.view addSubview:self.topTitleBar];
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
    self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64)];
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.childViewControllers.count, self.contentScrollView.frame.size.height);
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    [self.view insertSubview:self.contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex{
    NSLog(@"%ld,%ld",(long)index,(long)currentIndex);

    if (currentIndex-index>=2 || currentIndex-index<=-2) {
        [self.contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
        [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    }else{
        [self.contentScrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
        [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //获得索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    _currentIndex = index;
    self.topTitleBar.currentItemIndex = _currentIndex;
    HomeContentTableViewController *vc = self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = scrollView.bounds;
    vc.index = index;
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
