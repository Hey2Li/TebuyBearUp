//
//  BUMineViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUMineViewController.h"
#import <WebKit/WebKit.h>
#import "MyStateTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "MIneCollectionTableViewCell.h"
#import "FocusModel.h"
#import "MyCollectionModel.h"
#import "MyStateModel.h"
#import "SettingTableViewController.h"
#import "LoginViewController.h"
#import "InfoSettingTableViewController.h"
#import "MessageViewController.h"

#define HederHeight ceil(SCREEN_HEIGHT/3) + 70
@interface BUMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *centerTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *focusArray;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSMutableArray *subCollectionArray;
@property (nonatomic, strong) NSMutableArray *collectionHeaderTitleArray;
@property (nonatomic, strong) NSMutableDictionary *collectionDic;
@property (nonatomic, assign) int collectionIndex;
@property (nonatomic, assign) int stateIndex;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *readNumLabel;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, assign) int loadIndex;
@end

@implementation BUMineViewController

- (NSMutableArray *)focusArray{
    if (!_focusArray) {
        _focusArray = [NSMutableArray array];
    }
    return _focusArray;
}
- (NSMutableArray *)stateArray{
    if (!_stateArray) {
        _stateArray = [NSMutableArray array];
    }
    return _stateArray;
}
- (NSMutableArray *)_collectionHeaderTitleArray{
    if (!_collectionHeaderTitleArray) {
        _collectionHeaderTitleArray = [NSMutableArray array];
    }
    return _collectionHeaderTitleArray;
}
- (NSMutableArray *)subCollectionArray{
    if (!_subCollectionArray) {
        _subCollectionArray = [NSMutableArray array];
    }
    return _subCollectionArray;
}
- (NSMutableDictionary *)collectionDic{
    if (!_collectionDic) {
        _collectionDic = [NSMutableDictionary dictionary];
    }
    return _collectionDic;
}
- (UIView *)headerView{
    if (!_headerView ) {
        _headerView = [UIView new];
        UIView *headerView = [[UIView alloc]init];
        [self.view addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@(ceil(SCREEN_HEIGHT/3) + 70));
            make.top.equalTo(self.view);
        }];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageBtn setImage:[UIImage imageNamed:@"登陆后无消息状态"] forState:UIControlStateNormal];
        [headerView addSubview:messageBtn];
        [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30);
            make.height.equalTo(@30);
            make.left.equalTo(headerView.mas_left).offset(15);
            make.top.equalTo(headerView.mas_top).offset(25);
        }];
        [messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setImage:[UIImage imageNamed:@"登陆后设置"] forState:UIControlStateNormal];
        [headerView addSubview:settingBtn];
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView.mas_right).offset(-15);
            make.top.equalTo(messageBtn);
            make.height.equalTo(messageBtn);
            make.width.equalTo(messageBtn);
        }];
        [settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *headerImageView = [UIImageView new];
        [headerView addSubview:headerImageView];
        headerImageView.userInteractionEnabled = YES;
        headerImageView.image = [UIImage imageNamed:@"用户默认头像"];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView).offset(-30);
            make.centerX.equalTo(headerView);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
        [headerImageView.layer setCornerRadius:40];
        [headerImageView.layer setMasksToBounds:YES];
        self.headerImageView = headerImageView;
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerImageView addSubview:headerBtn];
        [headerBtn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
        [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_left);
            make.right.equalTo(headerImageView.mas_right);
            make.top.equalTo(headerImageView.mas_top);
            make.bottom.equalTo(headerImageView.mas_bottom);
        }];
        self.headerBtn = headerBtn;
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.font = [UIFont systemFontOfSize:20];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"快乐的小猴子";
        [headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerBtn.mas_bottom).offset(5);
            make.left.equalTo(headerView.mas_left);
            make.right.equalTo(headerView.mas_right);
            make.height.equalTo(@35);
        }];
        self.userNameLabel = nameLabel;
        
        UILabel *readerNumLabel = [UILabel new];
        readerNumLabel.textAlignment = NSTextAlignmentCenter;
        readerNumLabel.font = [UIFont systemFontOfSize:14];
        readerNumLabel.textColor = UIColorFromRGB(0xaeaeae);
        readerNumLabel.text = @"您最近阅读了X篇文章，加油啊！";
        [headerView addSubview:readerNumLabel];
        [readerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.right.equalTo(nameLabel);
            make.height.equalTo(@20);
            make.top.equalTo(nameLabel.mas_bottom).offset(5);
        }];
        self.readNumLabel = readerNumLabel;
        
        UIView *centerClickView = [UIView new];
        centerClickView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:centerClickView];
        [centerClickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView);
            make.right.equalTo(headerView);
            make.height.equalTo(@50);
            make.bottom.equalTo(headerView);
        }];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:@"关注" forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateSelected];
        leftBtn.selected = YES;
        _tempBtn = leftBtn;
        [centerClickView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerClickView);
            make.width.equalTo(@(SCREEN_WIDTH/3));
            make.top.equalTo(centerClickView);
            make.bottom.equalTo(centerClickView);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateSelected];
        [centerClickView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftBtn);
            make.bottom.equalTo(leftBtn);
            make.width.equalTo(leftBtn);
            make.right.equalTo(centerClickView);
        }];
        
        UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [centerBtn setTitle:@"我的动态" forState:UIControlStateNormal];
        [centerBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [centerBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateSelected];
        [centerClickView addSubview:centerBtn];
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBtn.mas_right);
            make.right.equalTo(rightBtn.mas_left);
            make.top.equalTo(leftBtn);
            make.bottom.equalTo(leftBtn);
        }];
        self.leftBtn = leftBtn;
        self.centerBtn = centerBtn;
        self.rightBtn = rightBtn;
        
        UILabel *line = [UILabel new];
        line.backgroundColor = UIColorFromRGB(0xff4466);
        [centerClickView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@1);
            make.centerX.equalTo(leftBtn.mas_centerX);
            make.bottom.equalTo(leftBtn);
        }];
        self.line = line;
        [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = 1001;
        centerBtn.tag = 1002;
        rightBtn.tag = 1003;
        _headerView = headerView;
    }
    return _headerView;
}
- (void)settingClick{
    [self.navigationController pushViewController:[SettingTableViewController new] animated:YES];
}
- (void)messageClick{
    [self.navigationController pushViewController:[MessageViewController new] animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (USER_ID) {
        if (_loadIndex != 1) {
            [self headerLoadData];
            [self footerLoadData];
            _loadIndex = 1;
        }
        self.leftBtn.userInteractionEnabled = YES;
        self.centerBtn.userInteractionEnabled = YES;
        self.rightBtn.userInteractionEnabled = YES;
        self.scrollView.scrollEnabled = YES;
    }else{
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"未登录提示图"]];
        [self.scrollView addSubview:imageView];
        imageView.backgroundColor = [UIColor whiteColor];
        self.scrollView.scrollEnabled = NO;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        imageView.contentMode = UIViewContentModeCenter;
        self.leftBtn.userInteractionEnabled = NO;
        self.centerBtn.userInteractionEnabled = NO;
        self.rightBtn.userInteractionEnabled = NO;
        
        self.userNameLabel.text = @"去登录";
        self.readNumLabel.text = @"你最近阅读了0篇文章，加油哦";
        self.headerImageView.image = [UIImage imageNamed:@"用户默认头像"];
        [self.headerBtn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
        self.headerView.backgroundColor = RGBCOLOR(237, 238, 239);
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self headerView];
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)gotoLogin:(UIButton *)btn{
    if (USER_ID) {
        [self.navigationController pushViewController:[InfoSettingTableViewController new] animated:YES];
    }else{
        [self presentViewController:[LoginViewController new] animated:YES completion:nil];
    }
}
- (void)headerLoadData{
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [LTHttpManager userSubscripWithUser_uuid:GETUUID User_id:USER_ID User_token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSDictionary *infoDic = data[@"responseData"][@"info"];
                if (![infoDic[@"photo"] isEqual:[NSNull null]]) {
                      [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",infoDic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"未登录提示图"]];
                    [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"photo"] forKey:USER_PHOTO];

                }
                if (infoDic[@"nickname"]) {
                    self.userNameLabel.text = [NSString stringWithFormat:@"%@",infoDic[@"nickname"]];
                }else{
                    if (infoDic[@"mobile"]) {
                        self.userNameLabel.text = [NSString stringWithFormat:@"%@",infoDic[@"mobile"]];
                    }
                }
                self.readNumLabel.text = [NSString stringWithFormat:@"你最近阅读了%@篇文章，加油哦",infoDic[@"read_num"]];
                [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"mobile"] forKey:USER_MOBILE];
                [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"nickname"] forKey:USER_NICKNAME];
                [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"sex"] forKey:USER_SEX];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if ([infoDic[@"sex"] isEqual:@1]) {
                    self.headerView.backgroundColor = RGBCOLOR(228, 235, 243);
                }else if ([infoDic[@"sex"]isEqual:@2]){
                    self.headerView.backgroundColor = RGBCOLOR(255, 240, 243);
                }else{
                    self.headerView.backgroundColor = RGBCOLOR(255, 240, 243);
                }

                [self.focusArray removeAllObjects];
                NSArray *array = data[@"responseData"][@"rows"];
                for (NSDictionary *dic in array) {
                    FocusModel *model = [FocusModel mj_objectWithKeyValues:dic];
                    [self.focusArray addObject:model];
                }
                [self.leftTableView reloadData];
                [self.leftTableView.mj_header endRefreshing];
            }else{
                [self.leftTableView.mj_header endRefreshing];
            }
        }];
    }];
    self.centerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _stateIndex = 1;
        [LTHttpManager myStateWithLimit:@10 Token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                [self.stateArray removeAllObjects];
                NSArray *array = data[@"responseData"][@"rows"][@"data"];
                for (NSDictionary *dic in array) {
                    MyStateModel *model = [MyStateModel mj_objectWithKeyValues:dic];
                    [self.stateArray addObject:model];
                }
                [self.centerTableView reloadData];
                [self.centerTableView.mj_header endRefreshing];
            }else{
                [self.centerTableView.mj_header endRefreshing];
            }
        }];
    }];
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _collectionIndex = 1;
        [LTHttpManager myCollectionsWithLimit:@10 User_token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *collectionDics = data[@"responseData"][@"rows"];
                    self.collectionHeaderTitleArray = [NSMutableArray arrayWithArray:[collectionDics allKeys]];
                    [self.collectionDic removeAllObjects];
                    NSMutableArray *muArr = [NSMutableArray array];
                    [muArr removeAllObjects];
                    for (int i = 0; i < self.collectionHeaderTitleArray.count; i++) {
                        NSArray *arr = collectionDics[self.collectionHeaderTitleArray[i]];
                        for (NSDictionary *dic in arr) {
                            MyCollectionModel *model = [MyCollectionModel mj_objectWithKeyValues:dic];
                            [muArr addObject:model];
                        }
                        [self.collectionDic setObject:muArr.mutableCopy forKey:self.collectionHeaderTitleArray[i]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.rightTableView reloadData];
                        [self.rightTableView.mj_header endRefreshing];
                    });
                });
            }else{
                [self.rightTableView.mj_header endRefreshing];
            }
        }];
    }];
    [self.leftTableView.mj_header beginRefreshing];
    [self.centerTableView.mj_header beginRefreshing];
    [self.rightTableView.mj_header beginRefreshing];
}
- (void)footerLoadData{
    self.centerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _stateIndex++;
        [LTHttpManager myStateMoreWithLimit:@10 Page:@(_stateIndex) Token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *array = data[@"responseData"][@"data"];
                for (NSDictionary *dic in array) {
                    MyStateModel *model = [MyStateModel mj_objectWithKeyValues:dic];
                    [self.stateArray addObject:model];
                }
                [self.centerTableView reloadData];
                [self.centerTableView.mj_footer endRefreshing];
            }else{
                _selectIndex--;
                [self.centerTableView.mj_footer endRefreshing];
            }
        }];
    }];
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _collectionIndex++;
        [LTHttpManager myCollectionsMoreWithLimit:@10 Page:@(_collectionIndex) User_token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *collectionDics = data[@"responseData"];
                    self.collectionHeaderTitleArray = [NSMutableArray arrayWithArray:[collectionDics allKeys]];
                    NSMutableArray *muArr = [NSMutableArray array];
                    [muArr removeAllObjects];
                    for (int i = 0; i < [collectionDics allKeys].count; i++) {
                        NSArray *arr = collectionDics[[collectionDics allKeys][i]];
                        for (NSDictionary *dic in arr) {
                            MyCollectionModel *model = [MyCollectionModel mj_objectWithKeyValues:dic];
                            [muArr addObject:model];
                        }
                        [self.collectionDic setObject:muArr.mutableCopy forKey:[collectionDics allKeys][i]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.rightTableView reloadData];
                        [self.rightTableView.mj_footer endRefreshing];
                    });
                });
            }else{
                _collectionIndex--;
                [self.rightTableView.mj_footer endRefreshing];
            }
        }];
    }];
}
- (void)initWithView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
   
    if (USER_ID) {
        
        UITableView *leftTableView = [UITableView new];
        leftTableView.delegate = self;
        leftTableView.dataSource = self;
        //    leftTableView.separatorStyle = NO;
        leftTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HederHeight - 188);
        [scrollView addSubview:leftTableView];
        self.leftTableView = leftTableView;
        
        UITableView *rightTableView = [UITableView new];
        rightTableView.delegate = self;
        rightTableView.dataSource = self;
        //    rightTableView.separatorStyle = NO;
        rightTableView.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HederHeight - 188);
        [scrollView addSubview:rightTableView];
        self.rightTableView = rightTableView;
        
        UITableView *centerTableView = [UITableView new];
        centerTableView.delegate = self;
        centerTableView.dataSource = self;
        //    centerTableView.separatorStyle = NO;
        centerTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HederHeight - 188);
        [scrollView addSubview:centerTableView];
        self.centerTableView = centerTableView;
        
        
        [self.centerTableView registerNib:[UINib nibWithNibName:@"MyStateTableViewCell" bundle:nil] forCellReuseIdentifier:@"myStateCell"];
        self.centerTableView.estimatedRowHeight = 150.0f;
        
        [self.leftTableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"focusCell"];
        self.leftTableView.estimatedRowHeight = 100.f;
        
        [self.rightTableView registerNib:[UINib nibWithNibName:@"MIneCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"mineCollectionCell"];
        self.leftTableView.tableFooterView = [UIView new];
        self.centerTableView.tableFooterView = [UIView new];
        self.rightTableView.tableFooterView = [UIView new];
    }
}

- (void)btnClick:(UIButton *)btn{
    if (_tempBtn == nil) {
        btn.selected = YES;
        _tempBtn = btn;
    }else if (_tempBtn != nil && _tempBtn == btn){
        btn.selected = YES;
    }else if (_tempBtn != nil && _tempBtn != btn){
        btn.selected = YES;
        _tempBtn.selected = NO;
        _tempBtn = btn;
    }
    if (btn.selected) {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.line.superview layoutIfNeeded];
        }];
        _selectIndex = btn.tag;
    }
    if (btn.tag == 1001) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.leftTableView reloadData];
    }else if (btn.tag == 1002){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        [self.centerTableView reloadData];
    }else if (btn.tag == 1003){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:NO];
        [self.rightTableView reloadData];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        UIButton *btn = [UIButton new];
        if (index == 0) {
            self.leftBtn.selected = YES;
            self.centerBtn.selected = NO;
            self.rightBtn.selected = NO;
            btn = self.leftBtn;
            [self.leftTableView reloadData];
        }else if (index == 1){
            self.centerBtn.selected = YES;
            self.leftBtn.selected = NO;
            self.rightBtn.selected = NO;
            btn = self.centerBtn;
            [self.centerTableView reloadData];
        }else if (index ==  2){
            self.rightBtn.selected = YES;
            self.centerBtn.selected = NO;
            self.leftBtn.selected = NO;
            btn = self.rightBtn;
            [self.rightTableView reloadData];
        }
        if (btn.selected) {
            [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@50);
                make.height.equalTo(@1);
                make.centerX.equalTo(btn.mas_centerX);
                make.bottom.equalTo(btn);
            }];
            [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@50);
                make.height.equalTo(@1);
                make.centerX.equalTo(btn.mas_centerX);
                make.bottom.equalTo(btn);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [self.line.superview layoutIfNeeded];
            }];
            _selectIndex = btn.tag;
        }

    }
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;
    }else if (tableView == self.centerTableView){
        return 1;
    }else if (tableView == self.rightTableView){
        return self.collectionHeaderTitleArray.count;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.focusArray.count;
    }else if (tableView == self.centerTableView){
        return self.stateArray.count;
    }else if (tableView == self.rightTableView){
        NSArray *array = self.collectionDic[self.collectionHeaderTitleArray[section]];
        return array.count;
    }else{
        return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) {
        return self.collectionHeaderTitleArray[section];
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        return 100;
    }else if (tableView == self.centerTableView){
        return 150;
    }else{
        return 60;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _centerTableView) {
        MyStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myStateCell"];
        if (self.stateArray.count > 0) {
            cell.model = self.stateArray[indexPath.row];
        }
        return cell;
    }else if (tableView == _leftTableView){
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusCell"];
        if (self.focusArray.count > 0) {
            cell.model = self.focusArray[indexPath.row];
        }
        cell.focusBtn.selected = YES;
        cell.focusBtn.userInteractionEnabled = NO;
        cell.focusBtn.backgroundColor = [UIColor whiteColor];
        [cell.focusBtn.layer setBorderColor:UIColorFromRGB(0xaeaeae).CGColor];
        return cell;
    }else if (tableView == _rightTableView){
        MIneCollectionTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"mineCollectionCell"];
        cell.model = self.collectionDic[self.collectionHeaderTitleArray[indexPath.section]][indexPath.row];
        return cell;
    }
    return 0;
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
