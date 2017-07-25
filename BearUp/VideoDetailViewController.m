//
//  VideoDetailViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/14.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "ZFPlayer.h"
#import "ZFVideoModel.h"
#import "CommentsTableViewCell.h"
#import "VideoDetailTableViewCell.h"
#import "BottomCommentView.h"
#import <UShareUI/UShareUI.h>
#import "BarrageRenderer/BarrageRenderer.h"
#import "CommentModel.h"

@interface VideoDetailViewController ()<ZFPlayerDelegate, UITableViewDelegate, UITableViewDataSource,BottomCommentDelegate>
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BottomCommentView *bottomView;
@property (nonatomic, strong) BarrageRenderer *render;
@property (nonatomic, strong) NSMutableArray *commentDataArray;
@property (nonatomic, strong) NSMutableDictionary *videoDataDic;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, strong) NSNumber *isCollection;
@property (nonatomic, strong) NSMutableArray *danmuArray;
@property (nonatomic, strong) NSString *shareUrl;
@end

@implementation VideoDetailViewController

- (NSMutableArray *)danmuArray{
    if (!_danmuArray) {
        _danmuArray = [NSMutableArray array];
    }
    return _danmuArray;
}
- (NSMutableDictionary *)videoDataDic{
    if (!_videoDataDic) {
        _videoDataDic = [NSMutableDictionary dictionary];
    }
    return _videoDataDic;
}

- (NSMutableArray *)commentDataArray{
    if (!_commentDataArray) {
        _commentDataArray =[NSMutableArray array];
    }
    return _commentDataArray;
}
- (BottomCommentView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BottomCommentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        //        [self.playerView pause];
        self.playerView.playerPushedOrPresented = YES;
    }else{
        [self.playerView resetPlayer];
    }
    [_render stop];
    [self.tabBarController.tabBar setHidden:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频详情";
    [self loadData];
    _pageNum = 1;
    [self footerLoadData];
}
- (void)loadData{
    [LTHttpManager videoDetailWithId:self.vid Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.videoDataDic = [NSMutableDictionary dictionaryWithDictionary:data[@"responseData"][@"info"]];
            _isCollection = data[@"responseData"][@"info"][@"iscoll"];
            _shareUrl = data[@"responseData"][@"info"][@"share_url"];

            if ([_isCollection isEqual:@2]) {
                self.bottomView.collectionBtn.selected = YES;
            }
            NSArray *array = data[@"responseData"][@"comment"][@"data"];
            [self.commentDataArray removeAllObjects];
            [self.danmuArray removeAllObjects];
            for (NSDictionary *dic in array) {
                CommentModel *model = [CommentModel mj_objectWithKeyValues:dic];
                [self.commentDataArray addObject:model];
                [self.danmuArray addObject:model];
            }
            [self initBarrageRenderer];
            [self autoSendBarrage];
            [_render start];
            self.playerModel.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.videoDataDic[@"url"]]];
            [self.playerView resetToPlayNewVideo:self.playerModel];
            [self.tableView reloadData];
        }else{
           // [self.view makeToast:message];
            [self.playerView resetPlayer];
        }
    }];
}
- (void)footerLoadData{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [LTHttpManager getMoreVideoCommentWithId:self.vid Page:@(_pageNum) Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *array = data[@"responseData"][@"data"];
                for (NSDictionary *dic in array) {
                    CommentModel *model = [CommentModel mj_objectWithKeyValues:dic];
                    [self.commentDataArray addObject:model];
                    [self.danmuArray addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshing];
                _pageNum--;
            }
        }];
    }];
}

- (void)initWithView{
    self.playerFatherView = [[UIView alloc] init];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    [self.playerView autoPlayTheVideo];


    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.playerFatherView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerNib:[UINib nibWithNibName:@"VideoDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"videoDetailCell"];
    tableView.estimatedRowHeight = 250;
    self.tableView = tableView;
    
}
- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = YES;
//    [UIView animateWithDuration:0.25 animations:^{
//        self.backBtn.alpha = 0;
//    }];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = fullscreen;
//    [UIView animateWithDuration:0.25 animations:^{
//        self.backBtn.alpha = !fullscreen;
//    }];
}

#pragma mark - Getter


- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
//        _playerModel.title            = @"这里设置视频标题";
//        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
//        _playerView.hasDownload    = YES;
        
        // 打开预览图
        _playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.commentDataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 44;
    }else{
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"全部评论";
        label.textColor = UIColorFromRGB(0x000000);
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = UIColorFromRGB(0xf5f5f5);
        return label;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        tableView.estimatedRowHeight = 250.0f;
        VideoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoDetailCell"];
        if (self.videoDataDic.allKeys.count > 0) {
            cell.selectionStyle = NO;
            cell.praiseBtn.tag = [[NSString stringWithFormat:@"%@",self.videoDataDic[@"id"]] integerValue];
            cell.videoTitle.text = [NSString stringWithFormat:@"%@",self.videoDataDic[@"title"]];
            cell.videoDetails.text = [NSString stringWithFormat:@"%@",self.videoDataDic[@"introduct"]];
            [cell.hotBtn setTitle:[NSString stringWithFormat:@"%@",self.videoDataDic[@"hits"]] forState:UIControlStateNormal];
            [cell.praiseBtn setTitle:[NSString stringWithFormat:@"%@",self.videoDataDic[@"agree"]] forState:UIControlStateNormal];
            [cell.commendBtn setTitle:[NSString stringWithFormat:@"%@",self.videoDataDic[@"comment"]] forState:UIControlStateNormal];
        }
        return cell;
    }else{
        tableView.estimatedRowHeight = 130.5f;
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.model = self.commentDataArray[indexPath.row];
        return cell;
    }
}
#pragma mark - bottomComment delegate
- (void)commentTextFieldShouldReturn:(UITextField *)textfiled{
    [LTHttpManager commentNewsWithId:@(textfiled.tag) Content:textfiled.text Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            SVProgressShowStuteText(@"评论成功", YES);
            [textfiled resignFirstResponder];
            textfiled.text = nil;
            [LTHttpManager getMoreNewsCommentWithID:self.vid Page:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    NSArray *array = data[@"responseData"][@"data"];
                    [self.commentDataArray removeAllObjects];
                    for (NSDictionary *dic in array) {
                        CommentModel *model = [CommentModel mj_objectWithKeyValues:dic];
                        [self.commentDataArray addObject:model];
                    }
                    [self.tableView reloadData];
                    [self lookForCommentWithBtnClick:nil];
                }else{
                    
                }
            }];
        }else{
            SVProgressShowStuteText(@"评论失败", NO);
        }
    }];
}
- (void)danmuWithBtnClick:(UIButton *)btn{
    if (!btn.selected) {
        [_render start];
        [btn setImage:[UIImage imageNamed:@"弹幕红"] forState:UIControlStateNormal];
    }else{
        [_render stop];
        [btn setImage:[UIImage imageNamed:@"弹幕灰"] forState:UIControlStateNormal];
    }
}
- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_render spritesNumberWithName:nil];
    if (spriteNumber <= 10) { // 用来演示如何限制屏幕上的弹幕量
        for (int i = 0; i < self.danmuArray.count; i++) {
              [_render receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideLeft andi:i]];
        }
    }
}
- (void)initBarrageRenderer{
    _render = [[BarrageRenderer alloc]init];
    [self.view addSubview:_render.view];
    _render.canvasMargin = UIEdgeInsetsMake(300, 0, 44, 0);
    _render.view.userInteractionEnabled = YES;
    _render.masked = NO;
}
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side andi:(int)i
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    if (self.danmuArray.count > 0) {
        CommentModel *model = (CommentModel *)self.danmuArray[i];
        descriptor.params[@"text"] = model.content;
    }
    descriptor.params[@"textColor"] = [UIColor orangeColor];
//    descriptor.params[@"backgroundColor"] = [UIColor redColor];

    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
    descriptor.params[@"clickAction"] = ^{
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alertView show];
    };
    return descriptor;
}


- (void)lookForCommentWithBtnClick:(UIButton *)btn{
    //看评论
    if (self.commentDataArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        SVProgressShowStuteText(@"暂无评论", NO);
    }
}
- (void)collectWithBtnClick:(UIButton *)btn{
    if (!btn.selected) {
        [LTHttpManager collectionVideoWithNewID:self.vid UUID:GETUUID User_id:USER_ID Token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                SVProgressShowStuteText(@"收藏成功", YES);
                btn.selected = YES;
                [btn setImage:[UIImage imageNamed:@"收藏红"] forState:UIControlStateSelected];
            }else{
                
            }
        }];
    }else{
        [LTHttpManager collectionVideoWithNewID:self.vid UUID:GETUUID User_id:USER_ID Token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                SVProgressShowStuteText(@"取消收藏成功", YES);
                btn.selected = NO;
                [btn setImage:[UIImage imageNamed:@"收藏灰"] forState:UIControlStateSelected];
            }else{
                
            }
        }];
    }
}
- (void)shareWithBtnClick:(UIButton *)btn{
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"%ld---%@",(long)platformType, userInfo);
        [self shareVedioToPlatformType:platformType];
    }];
    //    [self shareWithUI];
}
//视频分享
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:self.videoDataDic[@"title"] descr:self.videoDataDic[@"introduct"] thumImage:self.videoDataDic[@"photo"]];
    //设置视频网页播放地址
    if (_shareUrl.length > 5) {
        shareObject.videoUrl =_shareUrl;
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    

        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
                SVProgressShowStuteText(@"分享失败", YES);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    SVProgressShowStuteText(@"分享成功", YES);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
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
