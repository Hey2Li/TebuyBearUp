//
//  VideoTableViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/13.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "VideoTableViewController.h"
#import "ZFVideoModel.h"
#import "VideoTableViewCell.h"
#import "ZFVideoModel.h"
#import "ZFVideoResolution.h"
#import "CDetailViewController.h"
#import "VideoDetailViewController.h"
#import <UShareUI/UShareUI.h>


@interface VideoTableViewController ()<ZFPlayerControlViewDelagate, ZFPlayerDelegate>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end
static NSString *videoCell = @"playerCell";
@implementation VideoTableViewController

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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self footerLoadData];
    [self headerLoadData];
    [self requestData];
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:videoCell];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
}
//下拉刷新
- (void)headerLoadData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        WeakSelf
      [LTHttpManager videoListWithLimit:@100 Value:@"id,name" Complete:^(LTHttpResult result, NSString *message, id data) {
          if (LTHttpResultSuccess == result) {
              self.dataSource = @[].mutableCopy;
              NSArray *videoList = [data[@"responseData"][@"videos"] objectForKey:@"data"];
              for (NSDictionary *dataDic in videoList) {
                  ZFVideoModel *model = [[ZFVideoModel alloc] init];
                  [model setValuesForKeysWithDictionary:dataDic];
                  [weakSelf.dataSource addObject:model];
              }
              [weakSelf.tableView reloadData];
              [weakSelf.tableView.mj_header endRefreshing];
          }else{
              [weakSelf.view makeToast:message];
              [weakSelf.tableView.mj_header endRefreshing];
          }
      }];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 270;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //取到对应cell的model
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell forIndexPath:indexPath];
    __block ZFVideoModel *model = self.dataSource[indexPath.section];
    //赋值model
    cell.model = model;
    __block NSIndexPath *weakIndexPath = indexPath;
    __block VideoTableViewCell *weakCell = cell;
    __weak typeof(self)  weakSelf = self;
    //点击播放的回调
    cell.playBlock = ^(UIButton *btn){
//        //分辨率字典（key:分辨率名称，value：分辨率url)
//        NSMutableDictionary *dic = @{}.mutableCopy;
//        for (ZFVideoResolution * resolution in model.playInfo) {
//            [dic setValue:resolution.url forKey:resolution.name];
//        }
        //取出字典中的第一视频URL
//        NSURL *videoURL = [NSURL URLWithString:dic.allValues.firstObject];
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
        playerModel.fatherViewTag = weakCell.picView.tag;
        playerModel.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.url]];
        playerModel.scrollView = weakSelf.tableView;
        playerModel.indexPath = weakIndexPath;
        [weakSelf.playerView playerControlView:self.controlView playerModel:playerModel];
        [weakSelf.playerView autoPlayTheVideo];
    };
    cell.shareBlock = ^(UIButton *btn){
        [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
        [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            NSLog(@"%ld---%@",(long)platformType, userInfo);
            [self shareImageAndTextToPlatformType:platformType];
        }];

    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZFVideoModel *playerModel = self.dataSource[indexPath.section];
    VideoDetailViewController *vc = [VideoDetailViewController new];
//    vc.videoURL                   = [NSURL URLWithString:playerModel.url];
    vc.vid = [NSNumber numberWithInteger:[playerModel.vid integerValue]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:@"https://www.umeng.com/img/index/demo/1104.4b2f7dfe614bea70eea4c6071c72d7f5.jpg"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
