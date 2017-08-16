//
//  BUFoundViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUFoundViewController.h"
#import "HorizontalTableViewCell.h"
#import "HomePageTableViewCell.h"
#import "ListViewController.h"
#import "CategoryViewController.h"
#import "ScrollBannerTableViewCell.h"
#import "AdvertisingTableViewCell.h"
#import "SubCategoryViewController.h"
#import "WebContentViewController.h"

#import "SXWeatherView.h"
#import "UIView+Frame.h"
#import "SXWeatherViewModel.h"
#import "SXWeatherDetailPage.h"
#import <PYSearch.h>

#import "HomeContentTableViewController.h"
#import "VideoTableViewController.h"

static NSString *HORCELL = @"HorizontalCell";
@interface BUFoundViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *hotCategoryArray;
@property (nonatomic, strong) NSMutableArray *hotRankArray;
@property (nonatomic, strong) NSDictionary *adDic;
@property (nonatomic, strong) NSMutableDictionary  *allDataDic;

@property(nonatomic,strong)UIButton *rightItem;
@property(nonatomic,assign,getter=isWeatherShow)BOOL weatherShow;
@property(nonatomic,strong)SXWeatherView *weatherView;
@property(nonatomic,strong)UIImageView *tran;
@property(nonatomic,strong)SXWeatherViewModel *weatherViewModel;


@end
static NSString *FOUNDCELL = @"foundCell";
@implementation BUFoundViewController

- (NSMutableDictionary *)allDataDic{
    if (!_allDataDic) {
        _allDataDic = [NSMutableDictionary dictionary];
    }
    return _allDataDic;
}
- (NSMutableArray *)hotRankArray{
    if (!_hotRankArray) {
        _hotRankArray = [NSMutableArray array];
    }
    return _hotRankArray;
}
- (NSMutableArray *)hotCategoryArray{
    if (!_hotCategoryArray) {
        _hotCategoryArray = [NSMutableArray array];
    }
    return _hotCategoryArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"熊起";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
    [self loadData];
}
- (void)loadData{
//    [LTHttpManager foundIndexComplete:^(LTHttpResult result, NSString *message, id data) {
//        if (LTHttpResultSuccess == result) {
//            self.hotRankArray = [NSMutableArray arrayWithArray:data[@"responseData"][@"toparr"]];
//            self.hotCategoryArray = [NSMutableArray arrayWithArray:data[@"responseData"][@"columns"]];
//            [self.myTableView reloadData];
//        }else{
//           // [self.view makeToast:message];
//        }
//    }];
    [LTHttpManager foundIndexADWithAid:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.allDataDic = [NSMutableDictionary dictionaryWithDictionary:data[@"responseData"]];
            self.adDic = self.allDataDic[@"advert"];
            self.hotRankArray = [NSMutableArray arrayWithArray:data[@"responseData"][@"toparr"]];
            self.hotCategoryArray = [NSMutableArray arrayWithArray:data[@"responseData"][@"columns"]];
            [self.myTableView reloadData];
        }else{
            
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)initWithView{    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_navigation_square"] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    
    [self sendWeatherRequest];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[HomePageTableViewCell class] forCellReuseIdentifier:FOUNDCELL];
    [tableView registerClass:[HorizontalTableViewCell class] forCellReuseIdentifier:HORCELL];
    [tableView registerClass:[ScrollBannerTableViewCell class] forCellReuseIdentifier:@"scrollcell"];
    self.myTableView = tableView;
}
#pragma mark Weather
- (void)sendWeatherRequest
{
    @weakify(self)
    [[self.weatherViewModel.fetchWeatherInfoCommand execute:nil]subscribeNext:^(id x) {
        @strongify(self)
        [self addWeather];
    } error:^(NSError *error) {
        NSLog(@"failure %@",error.userInfo);
    }];}
- (void)addWeather{
    SXWeatherView *weatherView = [SXWeatherView view];
    weatherView.weatherModel = self.weatherViewModel.weatherModel;
    self.weatherView = weatherView;
    weatherView.alpha = 0.9;
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    [win addSubview:weatherView];
    
    UIImageView *tran = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"224"]];
    self.tran = tran;
    tran.width = 7;
    tran.height = 7;
    tran.y = 57;
    tran.x = [UIScreen mainScreen].bounds.size.width - 33;
    [win addSubview:tran];
    
    weatherView.frame = [UIScreen mainScreen].bounds;
    weatherView.y = 64;
    weatherView.height -= 64;
    self.weatherView.hidden = YES;
    self.tran.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushWeatherDetail) name:@"pushWeatherDetail" object:nil];
}
- (void)pushWeatherDetail
{
    self.weatherShow = NO;
    SXWeatherDetailPage *wdvc = [[SXWeatherDetailPage alloc]init];
    wdvc.weatherModel = self.weatherViewModel.weatherModel;
    [self.navigationController pushViewController:wdvc animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.weatherView.alpha = 0;
    } completion:^(BOOL finished) {
        self.weatherView.alpha = 0.9;
        self.weatherView.hidden = YES;
        self.tran.hidden = YES;
    }];
}
- (SXWeatherViewModel *)weatherViewModel
{
    if (_weatherViewModel == nil) {
        _weatherViewModel = [[SXWeatherViewModel alloc]init];
    }
    return _weatherViewModel;
}
- (void)rightItemClick{
    
    if (self.isWeatherShow) {
        self.weatherView.hidden = YES;
        self.tran.hidden = YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, M_1_PI * 5);
            
        } completion:^(BOOL finished) {
            [self.rightItem setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
        }];
    }else{
        
        [self.rightItem setImage:[UIImage imageNamed:@"223"] forState:UIControlStateNormal];
        self.weatherView.hidden = NO;
        self.tran.hidden = NO;
        [self.weatherView addAnimate];
        [UIView animateWithDuration:0.2 animations:^{
            self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, -M_1_PI * 6);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, M_1_PI );
            }];
        }];
    }
    self.weatherShow = !self.isWeatherShow;
}
- (void)leftBarButtonClick{
    NSArray *hotSeaches = @[@"原创",@"漫画", @"搞笑", @"热点", @"视频", @"美食", @"动物圈", @"娱乐圈"];
    // 2. Create searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"  " didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        HomeContentTableViewController *vc = [[HomeContentTableViewController alloc]init];
        vc.index =  0;
        searchViewController.navigationController.navigationBar.backIndicatorImage =  [[UIImage imageNamed:@"返回白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];        searchViewController.navigationController.navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"返回白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //去掉左边的title
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //自定义一个NavigationBar
        [searchViewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //消除阴影
        searchViewController.navigationController.navigationBar.shadowImage = [UIImage new];
        //PingFangSC
        searchViewController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Light" size:18],NSFontAttributeName, nil];
        [searchViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];

    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.navigationController.navigationBar.backIndicatorImage =  [[UIImage imageNamed:@"返回白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    searchViewController.navigationController.navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"返回白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //去掉左边的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //自定义一个NavigationBar
    [searchViewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    searchViewController.navigationController.navigationBar.shadowImage = [UIImage new];
    //PingFangSC
    searchViewController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Light" size:18],NSFontAttributeName, nil];
    [searchViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav  animated:NO completion:nil];
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.allDataDic allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([self.adDic allKeys].count > 2) {
            return 1;
        }else{
            return 0;
        }
    }else if (section == 1){
        return 1;
    }else{
        return self.hotCategoryArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 180;
            break;
        case 1:
            return 200;
            break;
        case 2:
            return 250;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        sectionHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"热门排行";
        label.textColor = UIColorFromRGB(0x000000);
        label.font = [UIFont systemFontOfSize:18];
//        label.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [sectionHeaderView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(sectionHeaderView);
            make.height.equalTo(@30);
            make.width.equalTo(@100);
        }];
        
        UILabel *lineLabel = [UILabel new];
        lineLabel.backgroundColor = [UIColor grayColor];
        [sectionHeaderView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label);
            make.top.equalTo(label.mas_bottom);
            make.height.equalTo(@1);
            make.width.equalTo(@50);
        }];
        
        UIButton *getAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [getAllBtn setTitle:@"全部排行" forState:UIControlStateNormal];
        [getAllBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
        getAllBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [getAllBtn.layer setBorderWidth:1.0f];
        [getAllBtn.layer setBorderColor:UIColorFromRGB(0xaeaeae).CGColor];
        [getAllBtn.layer setCornerRadius:9.0f];
        [sectionHeaderView addSubview:getAllBtn];
        [getAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sectionHeaderView.mas_right).offset(-5);
            make.bottom.equalTo(sectionHeaderView.mas_bottom).offset(-5);
            make.height.equalTo(@25);
            make.width.equalTo(@60);
        }];
        [getAllBtn addTarget:self action:@selector(pushAllList:) forControlEvents:UIControlEventTouchUpInside];
        return sectionHeaderView;
    }else{
        UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        sectionHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"热门分类";
        label.textColor = UIColorFromRGB(0x000000);
        label.font = [UIFont systemFontOfSize:18];
//        label.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [sectionHeaderView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(sectionHeaderView);
            make.height.equalTo(@30);
            make.width.equalTo(@100);
        }];
        
        UILabel *lineLabel = [UILabel new];
        lineLabel.backgroundColor = [UIColor grayColor];
        [sectionHeaderView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label);
            make.top.equalTo(label.mas_bottom);
            make.height.equalTo(@1);
            make.width.equalTo(@50);
        }];
        
        UIButton *getAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [getAllBtn setTitle:@"全部分类" forState:UIControlStateNormal];
        [getAllBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
        getAllBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [getAllBtn.layer setBorderWidth:1.0f];
        [getAllBtn.layer setBorderColor:UIColorFromRGB(0xaeaeae).CGColor];
        [getAllBtn.layer setCornerRadius:9.0f];
        [sectionHeaderView addSubview:getAllBtn];
        [getAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sectionHeaderView.mas_right).offset(-5);
            make.bottom.equalTo(sectionHeaderView.mas_bottom).offset(-5);
            make.height.equalTo(@25);
            make.width.equalTo(@60);
        }];
        [getAllBtn addTarget:self action:@selector(pushAllCategory:) forControlEvents:UIControlEventTouchUpInside];
        return sectionHeaderView;
    }
}
- (void)pushAllCategory:(UIButton *)btn{
    CategoryViewController *vc = [CategoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushAllList:(UIButton *)btn{
    ListViewController *vc = [ListViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AdvertisingTableViewCell *cell = [[AdvertisingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adverCell"];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"adverCell"];
        }
        [cell.adImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.adDic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"未加载好图片长"]];
        cell.adCloseBlock = ^(UIButton *btn) {
//            [self.allDataDic removeObjectForKey:@"advert"];
            self.adDic = @{};
//            [self.myTableView beginUpdates];
//            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationNone];
//            [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [self.myTableView endUpdates];
//            // 刷新第0个section
//            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [_myTableView reloadData];
        };
        return  cell;
    }else if (indexPath.section == 1){
        ScrollBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scrollcell"];
        if (self.hotRankArray) {
            cell.imageURLStringsGroup = self.hotRankArray;
        }
        WeakSelf
        cell.BannerImageClick = ^(NSInteger index) {
            if ([weakSelf.hotRankArray[index][@"type"] isEqual:@1]) {
                CDetailViewController *vc = [CDetailViewController new];
                vc.cid = [NSString stringWithFormat:@"%@",weakSelf.hotRankArray[index][@"nid"]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([weakSelf.hotRankArray[index][@"type"] isEqual:@2]){
                VideoDetailViewController *vc = [VideoDetailViewController new];
                vc.vid = [NSNumber numberWithInteger:[weakSelf.hotRankArray[index][@"nid"] integerValue]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };

        return cell;
    }else{
        HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HORCELL];
        
        [cell.categoryNameBtn setTitle:[NSString stringWithFormat:@"%@",self.hotCategoryArray[indexPath.row][@"name"]] forState:UIControlStateNormal];
        [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.hotCategoryArray[indexPath.row][@"photo"]]] placeholderImage:[UIImage imageNamed:@"未加载好图片长"]];
        cell.subCategoryArray = [NSMutableArray arrayWithArray:self.hotCategoryArray[indexPath.row][@"arr"]];
        
        NSArray *subArray = self.hotCategoryArray[indexPath.row][@"arr"];
        WeakSelf
        cell.HorCollectionCellClick = ^(NSIndexPath *index){
            if ([subArray[index.row][@"type"] isEqual:@1]) {
                CDetailViewController *vc = [CDetailViewController new];
                vc.cid = subArray[index.row][@"id"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([subArray[index.row][@"type"] isEqual:@2]){
                VideoDetailViewController *vc = [VideoDetailViewController new];
                vc.vid = [NSNumber numberWithInteger:[subArray[index.row][@"id"] integerValue]];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //跳转到分类详情
        SubCategoryViewController *vc = [SubCategoryViewController new];
        vc.cid = [NSNumber numberWithInteger:[self.hotCategoryArray[indexPath.row][@"id"] integerValue]];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && [self.adDic allKeys].count > 0){
        WebContentViewController *vc = [[WebContentViewController alloc]init];
        vc.UrlString = self.adDic[@"url"];
        [self.navigationController pushViewController:vc animated:YES];
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
