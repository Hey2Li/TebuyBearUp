//
//  BUFoundViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUFoundViewController.h"
#import "HorizontalTableViewCell.h"
#import "HomePageTableViewCell.h"
#import "ListViewController.h"
#import "CategoryViewController.h"

static NSString *HORCELL = @"HorizontalCell";
@interface BUFoundViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;

@end
static NSString *FOUNDCELL = @"foundCell";
@implementation BUFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
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
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[HomePageTableViewCell class] forCellReuseIdentifier:FOUNDCELL];
    [tableView registerClass:[HorizontalTableViewCell class] forCellReuseIdentifier:HORCELL];
    self.myTableView = tableView;
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"全部排行";
    label.textColor = UIColorFromRGB(0x000000);
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = UIColorFromRGB(0xf5f5f5);
    return label;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FOUNDCELL];
    if (indexPath.section == 4) {
        HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HORCELL];
        cell.HorCollectionCellClick = ^(NSIndexPath *index){
            NSLog(@"%ld",(long)index.row);
            CategoryViewController *vc = [CategoryViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
    
    }
    ListViewController *vc = [ListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
