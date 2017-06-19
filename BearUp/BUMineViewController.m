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
//    tableView.backgroundColor = DRGBCOLOR;
    self.myTableView = tableView;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 272.5)];
    headerView.backgroundColor = DRGBCOLOR;
    self.headerView = headerView;
    self.myTableView.tableHeaderView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(272.5));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];

    UIImageView *headerImageView = [UIImageView new];
    [headerView addSubview:headerImageView];
    headerImageView.userInteractionEnabled = YES;
    headerImageView.image = [UIImage imageNamed:@"defaultUserIcon"];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.top.equalTo(headerView.mas_top).offset(50);
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
    nameLabel.text = @"昵称:快乐的小猴子";
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBtn.mas_right).offset(5);
        make.centerY.equalTo(headerBtn.mas_centerY).offset(-15);
        make.right.equalTo(headerView.mas_right).offset(-5);
        make.height.equalTo(@20);
    }];
    
    UILabel *rederNumLabel = [UILabel new];
    rederNumLabel.text = @"您最近阅读了X篇文章，加油啊！";
    [headerView addSubview:rederNumLabel];
    [rederNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.right.equalTo(nameLabel.mas_right);
        make.centerY.equalTo(headerBtn.mas_centerY).offset(15);
        make.height.equalTo(@20);
    }];
    NSArray *array = @[@"点赞\n222",@"评论\n222",@"分享\n222",@"收藏\n222"];
    for (int i = 0; i < array.count; i++) {
        UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(SCREEN_WIDTH/4*i);
            make.bottom.equalTo(headerView.mas_bottom);
            make.width.equalTo(@(SCREEN_WIDTH/4));
            make.height.equalTo(@80);
        }];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的主页";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"我的消息";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"缓存清理";
    }
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
