//
//  ListViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/6.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "ListViewController.h"
#import "HomePageTableViewCell.h"

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISegmentedControl *changeControl;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSString *titleStr;
@end

@implementation ListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    [self initWithView];
    self.titleStr = @"文创总榜";
}
- (void)initWithView{
    UIView *topView = [UIView new];
    topView.backgroundColor = DRGBCOLOR;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@50);
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    UISegmentedControl *control = [[UISegmentedControl alloc]initWithItems:@[@"文创周榜",@"视频总榜",@"总榜"]];
    [control addTarget:self action:@selector(controlChange:) forControlEvents:UIControlEventValueChanged];
    control.tintColor = [UIColor whiteColor];
    [topView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.left.equalTo(topView.mas_left).offset(20);
        make.right.equalTo(topView.mas_right).offset(-20);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    control.selectedSegmentIndex = 0;
    self.changeControl = control;
    
    UITableView *tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(topView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    self.myTableView = tableView;
}
#pragma mark TableViewDelage
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
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.titleLabel.text = self.titleStr;
    return cell;
}
- (void)controlChange:(UISegmentedControl *)control{
    if (control.selectedSegmentIndex == 0) {
        self.titleStr = @"文创周榜";
    }else if (control.selectedSegmentIndex == 1){
        self.titleStr = @"视频总榜";
    }else if (control.selectedSegmentIndex == 2){
        self.titleStr = @"总榜";
    }
    [self.myTableView reloadData];
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
