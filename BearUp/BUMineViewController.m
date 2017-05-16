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
    self.myTableView = tableView;
    
    UIView *headerView = [UIView new];
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTableView.mas_left);
        make.top.equalTo(self.myTableView.mas_top).offset(50);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [headerBtn.layer setCornerRadius:25];
    [headerBtn.layer setMasksToBounds:YES];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"昵称";
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
