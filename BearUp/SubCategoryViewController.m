//
//  SubCategoryViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/6.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "HomePageTableViewCell.h"
#import "VideoTableViewCell.h"
#import "ZFVideoModel.h"
#import "ZFVideoResolution.h"


@interface SubCategoryViewController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,ZFPlayerDelegate, ZFPlayerControlViewDelagate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, assign) NSUInteger selectIndex;
@property (nonatomic, strong) UIView *navigtionBar;
@property (nonatomic, strong) UILabel *naviTitle;
@property (nonatomic, strong) UIButton *categoryHederBtn;
@property (nonatomic, strong) UIImageView *categoryBackgroundImageView;
@property (nonatomic, strong) UILabel *categoryDetailLabel;
@property (nonatomic, strong) UILabel *focusPeopleLabel;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *updateDataArray;
@property (nonatomic, strong) NSMutableArray *welcomeDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation SubCategoryViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
- (NSMutableArray *)updateDataArray{
    if (!_updateDataArray) {
        _updateDataArray = [NSMutableArray array];
    }
    return _updateDataArray;
}
- (NSMutableArray *)welcomeDataArray{
    if (!_welcomeDataArray) {
        _welcomeDataArray = [NSMutableArray array];
    }
    return _welcomeDataArray;
}
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        //        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"孕妈圈";
    _selectIndex = 1001;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self loadData];
}
- (void)loadData{
    [LTHttpManager categoryDetailWithLimit:@1 ID:self.cid Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:data[@"responseData"][@"info"]];
            self.naviTitle.text = [NSString stringWithFormat:@"%@",self.dataDic[@"name"]];
            [self.categoryBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"photo"]]]];
            [self.categoryHederBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"photo"]]] forState:UIControlStateNormal];
            self.focusPeopleLabel.text = [NSString stringWithFormat:@"已关注人数：%@",self.dataDic[@"hot"]];
            self.categoryDetailLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"introduct"]];
            self.welcomeDataArray = [NSMutableArray arrayWithArray:data[@"responseData"][@"comment"]];
            self.dataArray = [NSMutableArray arrayWithArray:data[@"responseData"][@"new"]];
            [self.welcomeDataArray removeAllObjects];
            for (NSDictionary *dataDic in data[@"responseData"][@"new"]) {
                ZFVideoModel *model = [[ZFVideoModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [self.updateDataArray addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            [self.view makeToast:message];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self initWithNavi];
}
- (void)initWithNavi{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigationBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:navigationBar];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
    [navigationBar addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationBar.mas_left).offset(15);
        make.height.equalTo(@50);
        make.width.equalTo(@30);
        make.centerY.equalTo(navigationBar);
    }];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"孕妈圈";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navigationBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(navigationBar);
        make.height.equalTo(@25);
        make.width.equalTo(@200);
    }];
    self.naviTitle = titleLabel;
    self.navigtionBar = navigationBar;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > SCREEN_HEIGHT/2 - 64) {
        self.navigtionBar.hidden = YES;
    }else{
        self.navigtionBar.hidden = NO;
    }
}
- (void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)initWithView{
    UITableView *tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top).offset(-20);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = [self tableViewHeaderView];
    [tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:@"welcomeCell"];
    self.myTableView = tableView;
}
- (UIView *)tableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2 - 50)];
    backgroundImageView.image = [UIImage imageNamed:@"图像背景"];
    [tableViewHeaderView addSubview:backgroundImageView];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurView.frame = backgroundImageView.frame;
    [tableViewHeaderView addSubview:blurView];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtn setImage:[UIImage imageNamed:@"图像背景"] forState:UIControlStateNormal];
    [headerBtn.layer setCornerRadius:45];
    [headerBtn.layer setMasksToBounds:YES];
    [blurView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blurView);
        make.centerY.equalTo(blurView).offset(-40);
        make.height.equalTo(@90);
        make.width.equalTo(headerBtn.mas_height);
    }];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.text = @"SEELE UPC拥有丰富的产品线，包括战骑士、暗黑者、适格者、装甲兵以及使徒等，这一次我们看到的使徒503是一台入门级游戏台式UPC，采";
    detailLabel.font = [UIFont systemFontOfSize:16];
    detailLabel.numberOfLines = 2;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [blurView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBtn.mas_bottom).offset(10);
        make.centerX.equalTo(blurView.mas_centerX);
        make.height.equalTo(@40);
        make.right.equalTo(blurView.mas_right).offset(-20);
        make.left.equalTo(blurView.mas_left).offset(20);
    }];
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusBtn.layer setMasksToBounds:YES];
    [focusBtn.layer setCornerRadius:15];
    [focusBtn setTitle:@" + 关注" forState:UIControlStateNormal];
    [focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [focusBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
    [focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [focusBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateSelected];
    [blurView addSubview:focusBtn];
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blurView.mas_centerX);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
        make.top.equalTo(detailLabel.mas_bottom).offset(10);
    }];
    
    UILabel *focusNum = [UILabel new];
    focusNum.textColor = [UIColor whiteColor];
    focusNum.font = [UIFont systemFontOfSize:14];
    focusNum.textAlignment = NSTextAlignmentCenter;
    focusNum.text = @"已关注人数：2345";
    [blurView addSubview:focusNum];
    [focusNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blurView.mas_centerX);
        make.bottom.equalTo(blurView.mas_bottom).offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@150);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"最近更新" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateSelected];
    leftBtn.selected = YES;
    _tempBtn = leftBtn;
    [tableViewHeaderView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableViewHeaderView);
        make.right.equalTo(tableViewHeaderView.mas_centerX);
        make.top.equalTo(blurView.mas_bottom);
        make.bottom.equalTo(tableViewHeaderView);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"最受欢迎" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateSelected];
    [tableViewHeaderView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableViewHeaderView.mas_centerX);
        make.right.equalTo(tableViewHeaderView.mas_right);
        make.top.equalTo(blurView.mas_bottom);
        make.bottom.equalTo(tableViewHeaderView);
    }];
    
    UILabel *lineLable = [UILabel new];
    lineLable.backgroundColor = UIColorFromRGB(0xff4466);
    [tableViewHeaderView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@1);
        make.centerX.equalTo(leftBtn.mas_centerX);
        make.bottom.equalTo(leftBtn);
    }];
    self.lineLabel = lineLable;
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 1001;
    rightBtn.tag = 1002;
    self.categoryHederBtn = headerBtn;
    self.categoryDetailLabel = detailLabel;
    self.categoryBackgroundImageView = backgroundImageView;
    self.focusPeopleLabel = focusNum;
    return tableViewHeaderView;
}
- (void)leftBtnClick:(UIButton *)btn{
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
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [self.lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.lineLabel.superview layoutIfNeeded];
        }];
        _selectIndex = btn.tag;
        [self.myTableView reloadData];
    }
}

#pragma mark TableViewDelage
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_selectIndex == 1001) {
        return self.updateDataArray.count;
    }else if (_selectIndex == 1002){
        return self.welcomeDataArray.count;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectIndex == 1001) {
        return 200;
    }else if (_selectIndex == 1002){
        return 270;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectIndex == 1001) {
//        if ([self.dataArray[indexPath.section][@"show_type"] isEqual:@1]) {
//            VideoTableViewCell *cell  =[[VideoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            __block ZFVideoModel *model = self.updateDataArray[indexPath.section];
//            //赋值model
//            cell.model = model;
//            __block NSIndexPath *weakIndexPath = indexPath;
//            __block VideoTableViewCell *weakCell = cell;
//            __weak typeof(self)  weakSelf = self;
//            //点击播放的回调
//            cell.playBlock = ^(UIButton *btn){
//                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
//                playerModel.fatherViewTag = weakCell.picView.tag;
//                playerModel.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.url]];
//                playerModel.scrollView = weakSelf.myTableView;
//                playerModel.indexPath = weakIndexPath;
//                [weakSelf.playerView playerControlView:self.controlView playerModel:playerModel];
//                [weakSelf.playerView autoPlayTheVideo];
//            };
//            return cell;
//        }else{
//            HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//            if (!cell) {
//                cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//            }
//            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"photo"]]]]];
//            cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"title"]];
//            cell.hotImageView.hidden = YES;
//            cell.hotNumLabel.hidden = YES;
//            return cell;
//        }
        HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"photo"]]]]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"title"]];
        cell.hotImageView.hidden = YES;
        cell.hotNumLabel.hidden = YES;
        return cell;

    }else{
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"welcomeCell"];
        cell.playBtn.hidden = YES;
        return cell;
        
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
