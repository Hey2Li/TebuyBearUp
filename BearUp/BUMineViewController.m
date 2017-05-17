//
//  BUMineViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUMineViewController.h"

@interface BUMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation BUMineViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    self.myTableView = tableView;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:headerBtn];
    headerBtn.backgroundColor = [UIColor blueColor];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.top.equalTo(headerView.mas_top).offset(50);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    [headerBtn.layer setCornerRadius:50];
    [headerBtn.layer setMasksToBounds:YES];
    
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
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    NSArray *array = @[@"点赞\n222",@"评论\n222",@"分享\n222",@"收藏\n222"];
    for (int i = 0; i < array.count; i++) {
        UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blackColor];
        [headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(SCREEN_WIDTH/4*i);
            make.bottom.equalTo(headerView.mas_bottom);
            make.width.equalTo(@(SCREEN_WIDTH/4));
            make.top.equalTo(headerBtn.mas_bottom).offset(10);
        }];
    }
    
    self.myTableView.tableHeaderView = headerView;
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
