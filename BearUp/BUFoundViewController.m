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
#import "ScrollBannerTableViewCell.h"
#import "AdvertisingTableViewCell.h"

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
    [self loadData];
}
- (void)loadData{
    [LTHttpManager foundIndexComplete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            //
        }else{
            [self.view makeToast:message];
        }
    }];
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
    [tableView registerClass:[ScrollBannerTableViewCell class] forCellReuseIdentifier:@"scrollcell"];
    self.myTableView = tableView;
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 180;
            break;
        case 1:
            return 200;
            break;
        case 2:
            return 230;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else{
        return 25;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"热门排行";
        label.textColor = UIColorFromRGB(0x000000);
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = UIColorFromRGB(0xf5f5f5);
        return label;
    }else{
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"热门分类";
        label.textColor = UIColorFromRGB(0x000000);
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = UIColorFromRGB(0xf5f5f5);
        return label;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AdvertisingTableViewCell *cell = [[AdvertisingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adverCell"];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"adverCell"];
        }
        return  cell;
    }else if (indexPath.section == 1){
        ScrollBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scrollcell"];
        return cell;
           }else{
               HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HORCELL];
               cell.HorCollectionCellClick = ^(NSIndexPath *index){
                   NSLog(@"%ld",(long)index.row);
                   CategoryViewController *vc = [CategoryViewController new];
                   [self.navigationController pushViewController:vc animated:YES];
               };
               return cell;

    }
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
