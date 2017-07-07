//
//  BUMineViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUMineViewController.h"
#import <WebKit/WebKit.h>

@interface BUMineViewController ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *centerTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@end

@implementation BUMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fMB",tmpSize/(1024*1024)] : [NSString stringWithFormat:@"%.1fKB",tmpSize * 1024];
    NSLog(@"%@",clearCacheName);
    
    /***********************************************/
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    NSLog(@"%fkb,%fkb",[self folderSizeAtPath:webKitFolderInCaches], [self folderSizeAtPath:webkitFolderInLib]);

    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
//    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
//    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
//    
//    /* iOS7.0 WebView Cache的存放路径 */
//    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    /**************************************/

}
- (void)cleanCache{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *type = [NSSet setWithArray:@[
                                            WKWebsiteDataTypeDiskCache,
                                            WKWebsiteDataTypeMemoryCache
                                            ]];
        NSDate *dateFrom = [NSDate date];
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:type modifiedSince:dateFrom completionHandler:^{
            NSLog(@"清理WKWebView缓存");
            
        }];
    }else{
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager]removeItemAtPath:cookiesFolderPath error:nil];
        NSLog(@"%fkb",[self folderSizeAtPath:cookiesFolderPath]);
    }
}
-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}
-(long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    [self initWithView];
}

- (void)initWithView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [UITableView new];
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
    self.myTableView = tableView;
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = DRGBCOLOR;
    self.headerView = headerView;
    self.myTableView.tableHeaderView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(ceil(SCREEN_HEIGHT/3) + 70));
        make.top.equalTo(self.myTableView);
    }];
    
    UIImageView *headerImageView = [UIImageView new];
    [headerView addSubview:headerImageView];
    headerImageView.userInteractionEnabled = YES;
    headerImageView.image = [UIImage imageNamed:@"defaultUserIcon"];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).offset(-30);
        make.centerX.equalTo(headerView);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    [headerImageView.layer setCornerRadius:40];
    [headerImageView.layer setMasksToBounds:YES];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerImageView addSubview:headerBtn];
    [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_left);
        make.right.equalTo(headerImageView.mas_right);
        make.top.equalTo(headerImageView.mas_top);
        make.bottom.equalTo(headerImageView.mas_bottom);
    }];
    
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
    
    UITableView *leftTableView = [UITableView new];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.separatorStyle = NO;
    [self.myTableView addSubview:leftTableView];
    [leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTableView);
        make.right.equalTo(self.myTableView);
        make.top.equalTo(self.myTableView.tableHeaderView.mas_bottom);
        make.bottom.equalTo(self.myTableView.mas_bottom);
    }];
    self.leftTableView = leftTableView;
    
    UITableView *rightTableView = [UITableView new];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.separatorStyle = NO;
    [self.myTableView addSubview:rightTableView];
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTableView);
        make.right.equalTo(self.myTableView);
        make.top.equalTo(self.myTableView.tableHeaderView.mas_bottom);
        make.bottom.equalTo(self.myTableView.mas_bottom);
    }];
    self.rightTableView = rightTableView;
    self.rightTableView.hidden = YES;
    
    UITableView *centerTableView = [UITableView new];
    centerTableView.delegate = self;
    centerTableView.dataSource = self;
    centerTableView.separatorStyle = NO;
    [self.myTableView addSubview:centerTableView];
    [centerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTableView);
        make.right.equalTo(self.myTableView);
        make.top.equalTo(self.myTableView.tableHeaderView.mas_bottom);
        make.bottom.equalTo(self.myTableView.mas_bottom);
    }];
    self.centerTableView = centerTableView;
    self.centerTableView.hidden = YES;
    
    self.leftTableView.backgroundColor = [UIColor redColor];
    self.centerTableView.backgroundColor = [UIColor greenColor];
    self.rightTableView.backgroundColor = [UIColor blueColor];
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
        [self.myTableView reloadData];
    }
    if (btn.tag == 1001) {
        self.leftTableView.hidden = NO;
        self.centerTableView.hidden = YES;
        self.rightTableView.hidden = YES;
    }else if (btn.tag == 1002){
        self.leftTableView.hidden = YES;
        self.centerTableView.hidden = NO;
        self.rightTableView.hidden = YES;
    }else if (btn.tag == 1003){
        self.leftTableView.hidden = YES;
        self.centerTableView.hidden = YES;
        self.rightTableView.hidden = NO;
    }
}

- (void)headerBtnClick:(UIButton *)btn{
    NSLog(@"headerBtnClick");
}
- (void)buttonClick:(UIButton *)btn{
    NSLog(@"%ld,%@",btn.tag,btn.titleLabel.text);
}
#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 1;
    }else if (tableView == self.centerTableView){
        return 2;
    }else if (tableView == self.rightTableView){
        return 3;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"我的主页";
//    }else if (indexPath.row == 1){
//        cell.textLabel.text = @"我的消息";
//    }else if (indexPath.row == 2){
//        cell.textLabel.text = @"缓存清理";
//    }
    return cell;
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
