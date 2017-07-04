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
    _currentIndex = 1;
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
//                NSString *name = dic[@"name"];
                [weakSelf.titleArray addObject:dic];
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
    return _titleArray[index][@"name"];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index{
    VideoTableViewController *vc  =[VideoTableViewController new];
    vc.name = self.titleArray[index][@"name"];
    vc.categoryID = self.titleArray[index][@"id"];
    vc.index = index;
    return vc;
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
