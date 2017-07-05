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
#import "VideoModel.h"

@interface VideoTableViewController ()<ZFPlayerControlViewDelagate, ZFPlayerDelegate>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, assign) int pageNum;
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
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:videoCell];
    self.tableView.separatorStyle = NO;
    _pageNum = 1;
}
//下拉刷新
- (void)headerLoadData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        WeakSelf
        if (self.index == 0) {
            [LTHttpManager videoListWithLimit:@10 Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    self.dataSource = @[].mutableCopy;
                    NSArray *videoList = [data[@"responseData"][@"videos"] objectForKey:@"data"];
                    for (NSDictionary *dataDic in videoList) {
                        VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                        //                  ZFVideoModel *model = [[ZFVideoModel alloc] init];
                        //                  [model setValuesForKeysWithDictionary:dataDic];
                        [weakSelf.dataSource addObject:model];
                    }
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_header endRefreshing];
                }else{
                    //              [weakSelf.view makeToast:message];
                    [weakSelf.tableView.mj_header endRefreshing];
                }
            }];
        }else{
            [LTHttpManager videoListWithLimit:@10 Value:[NSString stringWithFormat:@"%@",self.categoryID] Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    self.dataSource = @[].mutableCopy;
                    NSArray *videoList = [data[@"responseData"][@"videos"] objectForKey:@"data"];
                    for (NSDictionary *dataDic in videoList) {
                        VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                        //                  ZFVideoModel *model = [[ZFVideoModel alloc] init];
                        //                  [model setValuesForKeysWithDictionary:dataDic];
                        [weakSelf.dataSource addObject:model];
                    }
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_header endRefreshing];
                }else{
                    //              [weakSelf.view makeToast:message];
                    [weakSelf.tableView.mj_header endRefreshing];
                }
            }];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)footerLoadData{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        WeakSelf
        _pageNum++;
        if (self.index == 0) {
            [LTHttpManager getMoreVideoWithLimit:@10 Page:@(_pageNum) Cid:nil Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    NSArray *videoList = [data[@"responseData"][@"videos"] objectForKey:@"data"];
                    for (NSDictionary *dataDic in videoList) {
                        VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                        [weakSelf.dataSource addObject:model];
                    }
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                    _pageNum--;
                }
            }];
        }else{
            [LTHttpManager getMoreVideoWithLimit:@10 Page:@(_pageNum) Cid:self.categoryID Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    NSArray *videoList = [data[@"responseData"][@"videos"] objectForKey:@"data"];
                    for (NSDictionary *dataDic in videoList) {
                        VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                        [weakSelf.dataSource addObject:model];
                    }
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                    _pageNum--;
                }
            }];
        }
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
    __block VideoModel *model = self.dataSource[indexPath.section];
    //赋值model
    cell.model = model;
    __block NSIndexPath *weakIndexPath = indexPath;
    __block VideoTableViewCell *weakCell = cell;
    __weak typeof(self)  weakSelf = self;
    //点击播放的回调
    cell.playBlock = ^(UIButton *btn){
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
    VideoModel *playerModel = self.dataSource[indexPath.section];
    VideoDetailViewController *vc = [VideoDetailViewController new];
//    vc.videoURL                   = [NSURL URLWithString:playerModel.url];
    vc.vid = playerModel.ID;
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
