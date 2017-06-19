//
//  DetailViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/15.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "DetailViewController.h"
#import "DataInfo.h"
#import "ImageInfo.h"



@interface DetailViewController ()<UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIWebView *webView;
@property (strong, nonatomic) NSString *detailID;
@end

@implementation DetailViewController

- (void)httpRequest {
    self.detailID = @"AQ4RPLHG00964LQ9";//多张图片
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://c.m.163.com/nc/article/nil/full.html"];
    [urlStr replaceOccurrencesOfString:@"nil" withString:_detailID options:NSCaseInsensitiveSearch range:[urlStr rangeOfString:@"nil"]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    __weak typeof(self)weakSelf = self;
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DataInfo *model = [DataInfo mj_objectWithKeyValues:[responseObject objectForKey:self.detailID]];
        NSLog(@"请求成功");
        [weakSelf handleData:model];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@",error);  //这里打印错误信息
    }];
}

- (void)handleData:(DataInfo *)data {
    if (!data) {
        NSLog(@"返回数据错误");
        return;
    }
    
    NSMutableString *allTitleStr = [self handleNewsTitle:data];
    NSMutableString *bodyStr = [self handleImageInNews:data];
    
    NSString * str5 = [allTitleStr stringByAppendingString:bodyStr];
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"NewsHtml" ofType:@"html"];
    NSMutableString* appHtml = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [appHtml replaceOccurrencesOfString:@"<p>mainnews</p>" withString:str5 options:NSCaseInsensitiveSearch range:[appHtml rangeOfString:@"<p>mainnews</p>"]];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadHTMLString:appHtml baseURL:baseURL];
}

//处理新闻body中的图片
- (NSMutableString *)handleImageInNews:(DataInfo *)data {
    NSMutableString *bodyStr = [data.content mutableCopy];
    
    [data.img enumerateObjectsUsingBlock:^(ImageInfo *info, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [bodyStr rangeOfString:info.ref];
        NSArray *wh = [info.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[wh objectAtIndex:0] floatValue];
        CGFloat height = [[wh objectAtIndex:1] floatValue];
        
        //占位图
        NSString *loadingImg = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"png"];
        NSString *imageStr = [NSString stringWithFormat:@"<p style = 'text-align:center'><img onclick = 'didTappedImage(%lu);' src = %@ id = '%@' width = '%.0f' height = '%.0f' hspace='0.0' vspace ='5' style ='width:80%%;height:80%%;' /></p>", (unsigned long)idx, loadingImg, info.src, width, height];
        [bodyStr replaceOccurrencesOfString:info.ref withString:imageStr options:NSCaseInsensitiveSearch range:range];
        
    }];
    return bodyStr;
}

//处理title的拼接显示
- (NSMutableString *)handleNewsTitle:(DataInfo *)data {
    NSString *htmlTitleStr = @"<style type='text/css'> p.thicker{font-weight: 900}p.light{font-weight: 0}p{font-size: 108%}h2 {font-size: 120%}h3 {font-size: 80%}</style> <h2 class = 'thicker'>{{title}}</h2><h3>{{source}} {{ptime}}</h3>";
    return 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    [self httpRequest];
}
- (void)initWithView{
    self.webView.delegate = self;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}
#pragma mark -- webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    SVProgressShow(@"正在加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = self.webView.scrollView.contentSize.height;
    [self.webView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    NSLog(@"%f",height);
    [self.myTableView reloadData];
    SVProgressHiden();
}
#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGFLOAT_MIN;
    }else if (indexPath.section == 1){
        return 44;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.webView;
    }else{
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"评论";
        return label;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.webView.bounds.size.height;
    }else if (section == 1){
        return 50;
    }
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"HHHHHHHHHHH";
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
