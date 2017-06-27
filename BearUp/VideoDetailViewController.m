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

@interface VideoDetailViewController ()<ZFPlayerDelegate, UITableViewDelegate, UITableViewDataSource,BottomCommentDelegate>
{
    NSInteger _index;
}
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BottomCommentView *bottomView;
@property (nonatomic, strong) BarrageRenderer *render;
@end

@implementation VideoDetailViewController

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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频详情";
    [self initBarrageRenderer];
    [self autoSendBarrage];
    [_render start];
}
- (void)initBarrageRenderer{
    _render = [[BarrageRenderer alloc]init];
    [self.view addSubview:_render.view];
    _render.canvasMargin = UIEdgeInsetsMake(300, 0, 44, 0);
    _render.view.userInteractionEnabled = YES;
    _render.masked = NO;
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
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
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
        self.playerView.hasPreviewView = YES;
        
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
        return 4;
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
        return cell;
    }else{
        tableView.estimatedRowHeight = 130.5f;
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.commentLabel.text = @"一个不会动脑筋的人，他的成就必然有限，不要说写字这种精细的活儿，就是举重、百米跑这种看似只需要有肌肉有力量的项目，你不动脑筋去想办法提高，你不用心去体会动作技巧，你也很难达到相应的高度。";
        return cell;
    }
}
#pragma mark - bottomComment delegate
- (void)danmuWithBtnClick:(UIButton *)btn{
    if (!btn.selected) {
        [_render start];
        [btn setImage:[UIImage imageNamed:@"弹幕红"] forState:UIControlStateNormal];
    }else{
        [_render stop];
        [btn setImage:[UIImage imageNamed:@"弹幕灰"] forState:UIControlStateNormal];
    }
}
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"过场文字弹幕:%ld",(long)_index++];
    descriptor.params[@"textColor"] = [UIColor blueColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}
- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_render spritesNumberWithName:nil];
    if (spriteNumber <= 100) { // 用来演示如何限制屏幕上的弹幕量
        [_render receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideLeft]];
    }
}
- (void)lookForCommentWithBtnClick:(UIButton *)btn{
    
}
- (void)collectWithBtnClick:(UIButton *)btn{
    
}
- (void)shareWithBtnClick:(UIButton *)btn{
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"%ld---%@",(long)platformType, userInfo);
        [self shareImageAndTextToPlatformType:platformType];
    }];
    //    [self shareWithUI];
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
