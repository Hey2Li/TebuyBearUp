//
//  CategoryViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/6.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "CategoryViewController.h"
#import "SubCategoryViewController.h"
#import "CategoryTableViewCell.h"

@interface CategoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotCategoryArray;
@end

static NSString *CATECELL = @"categoryCell";
@implementation CategoryViewController
- (NSMutableArray *)hotCategoryArray{
    if (!_hotCategoryArray) {
        _hotCategoryArray = [NSMutableArray array];
    }
    return _hotCategoryArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
    self.title = @"热门分类";
    [self loadData];
}
- (void)loadData{
    [LTHttpManager hotCategoryWithLimit:@10 Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.hotCategoryArray = [NSMutableArray arrayWithArray:data[@"responseData"]];
            [self.tableView reloadData];
        }else{
            [self.view makeToast:message];
        }
    }];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    tableView.separatorStyle = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:CATECELL];
    self.tableView = tableView;
}
#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hotCategoryArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CATECELL forIndexPath:indexPath];
    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.hotCategoryArray[indexPath.section][@"photo"]]]];
    cell.categoryNameLabel.text = [NSString stringWithFormat:@"%@",self.hotCategoryArray[indexPath.section][@"name"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubCategoryViewController *vc = [SubCategoryViewController new];
    vc.cid = [NSNumber numberWithInteger:[self.hotCategoryArray[indexPath.section][@"id"] integerValue]];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
