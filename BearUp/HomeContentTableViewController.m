//
//  HomeContentTableViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "HomeContentTableViewController.h"
#import "HomePageTableViewCell.h"
#import "DetailViewController.h"
#import "CDetailViewController.h"
#import "ScrollBannerTableViewCell.h"
#import "VideoTableViewCell.h"
#import "ZFVideoModel.h"
#import "ZFVideoResolution.h"

static NSString *homepageCell = @"HOMEPAGECELL";
static NSString *scrollBannerCell = @"SCROLLBANNERCELL";
static NSString *videoCell = @"playerCell";
@interface HomeContentTableViewController ()<ZFPlayerDelegate, ZFPlayerControlViewDelagate>
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray      *dataSource;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HomeContentTableViewController
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
    //防止pop返回页面下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    self.tableView.separatorStyle = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self footerLoadData];
    [self headerLoadData];
    [self requestData];
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:videoCell];
}
- (void)requestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        ZFVideoModel *model = [[ZFVideoModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:model];
    }
    [LTHttpManager  newsListWithLimit:@1 Value:self.name Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            //
            NSArray *array = data[@"responseData"][@"news"][@"data"];
            self.dataArray = [NSArray arrayWithArray:array];
        }else{
            [self.view makeToast:message];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}
//下拉刷新
- (void)headerLoadData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        WeakSelf
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [weakSelf.tableView.mj_header endRefreshing];
            [timer invalidate];
            timer = nil;
        }];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)footerLoadData{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        WeakSelf
        NSTimer *timer  =[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [timer invalidate];
            timer = nil;
        }];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return @"工作这么辛苦";
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && self.index == 0) {
        ScrollBannerTableViewCell *cell = [[ScrollBannerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }else if (indexPath.section == 4){
        //取到对应cell的model
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell];
        __block ZFVideoModel *model = self.dataSource[indexPath.row];
        //赋值model
        cell.model = model;
        __block NSIndexPath *weakIndexPath = indexPath;
        __block VideoTableViewCell *weakCell = cell;
        __weak typeof(self)  weakSelf = self;
        //点击播放的回调
        cell.playBlock = ^(UIButton *btn){
            //分辨率字典（key:分辨率名称，value：分辨率url)
            NSMutableDictionary *dic = @{}.mutableCopy;
            for (ZFVideoResolution * resolution in model.playInfo) {
                [dic setValue:resolution.url forKey:resolution.name];
            }
            //取出字典中的第一视频URL
            NSURL *videoURL = [NSURL URLWithString:dic.allValues.firstObject];
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
            playerModel.fatherViewTag = weakCell.picView.tag;
            playerModel.videoURL = videoURL;
            playerModel.scrollView = weakSelf.tableView;
            playerModel.indexPath = weakIndexPath;
            [weakSelf.playerView playerControlView:self.controlView playerModel:playerModel];
            [weakSelf.playerView autoPlayTheVideo];
        };
        return cell;
    }else{
        HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homepageCell];
        if (!cell) {
            cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homepageCell];
        }
        cell.titleLabel.text = [NSString stringWithFormat:@"这是第%ld个页面",(long)self.index];
        cell.titleLabel.text = @"一组婚纱照火遍了网络，照片的重庆小伙";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDetailViewController *vc = [CDetailViewController new];
    NSLog(@"点击了--%ld",(long)indexPath.section);
    indexPath.section == 4 ? : [self.navigationController pushViewController:vc animated:YES];
//    vc.cid = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"id"]];
     vc.cid = @"1";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
