//
//  MessageViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/7/12.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "MessageViewController.h"
#import "SysMsgTableViewCell.h"
#import "MineMsgTableViewCell.h"

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *MineMsgTableView;
@property (nonatomic, strong) UITableView *SysMsgTableView;
@property (nonatomic, strong) NSMutableArray *mineMsgArray;
@property (nonatomic, strong) NSMutableArray *sysMsgArray;
@end

@implementation MessageViewController

- (NSMutableArray *)mineMsgArray{
    if (!_mineMsgArray) {
        _mineMsgArray = [NSMutableArray array];
    }
    return _mineMsgArray;
}

- (NSMutableArray *)sysMsgArray{
    if (!_sysMsgArray) {
        _sysMsgArray = [NSMutableArray array];
    }
    return _sysMsgArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    [self initWithView];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.MineMsgTableView.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.SysMsgTableView.backgroundColor = UIColorFromRGB(0xeeeeee);;
    self.MineMsgTableView.separatorStyle = NO;
    self.SysMsgTableView.separatorStyle = NO;
    [self loadData];
//    [self loadFooterData];
}
- (void)loadFooterData{

}
- (void)loadData{
   [LTHttpManager sysMessageListWithLimit:@10 User_uuid:GETUUID User_id:USER_ID User_token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
       if (LTHttpResultSuccess == result) {
           NSArray *dataArray = data[@"responseData"][@"data"];
           self.sysMsgArray = [NSMutableArray arrayWithArray:dataArray];
           [self.SysMsgTableView reloadData];
        }else{
           
       }
   }];
    [LTHttpManager myMessageWithLimit:@10 User_token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *dataArray = data[@"responseData"][@"data"];
            self.mineMsgArray = [NSMutableArray arrayWithArray:dataArray];
            [self.MineMsgTableView reloadData];
        }else{
            
        }
    }];
}
- (void)initWithView{
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@60);
    }];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"系统通知",@"我的消息"]];
    segment.tintColor = UIColorFromRGB(0xff4466);
    [topView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.height.equalTo(@30);
        make.width.equalTo(@210);
    }];

    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(messageChange:) forControlEvents:UIControlEventValueChanged];
    
    UITableView *leftTableView = [UITableView new];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    [self.view addSubview:leftTableView];
    [leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    UITableView *rightTableView = [UITableView new];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    [self.view addSubview:rightTableView];
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
        make.top.equalTo(topView.mas_bottom);
    }];
    self.SysMsgTableView = leftTableView;
    self.MineMsgTableView = rightTableView;
    self.MineMsgTableView.hidden = YES;
    [self.MineMsgTableView registerNib:[UINib nibWithNibName:@"MineMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"minemsgcell"];
    [self.SysMsgTableView registerNib:[UINib nibWithNibName:@"SysMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"sysmsgcell"];
}
- (void)messageChange:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        self.SysMsgTableView.hidden = NO;
        self.MineMsgTableView.hidden = YES;
        [self.SysMsgTableView reloadData];
    }else if (sender.selectedSegmentIndex == 1){
        self.SysMsgTableView.hidden = YES;
        self.MineMsgTableView.hidden = NO;
        [self.MineMsgTableView reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    UILabel *label = [UILabel new];
    label.textColor =[UIColor whiteColor];
    label.backgroundColor = RGBCOLOR(182, 183, 184);
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:8];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.equalTo(@100);
        make.height.equalTo(@16);
    }];
    if (tableView == self.MineMsgTableView) {
        label.text  = [NSString stringWithFormat:@"%@",self.mineMsgArray[section][@"time"]];
    }else{
        label.text  = [NSString stringWithFormat:@"%@",self.sysMsgArray[section][@"time"]];
    }
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.MineMsgTableView) {
        return self.mineMsgArray.count;

    }else if (tableView == self.SysMsgTableView){
        return self.sysMsgArray.count;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.MineMsgTableView) {
        self.MineMsgTableView.rowHeight = UITableViewAutomaticDimension;
        self.MineMsgTableView.estimatedRowHeight = 100;
        return self.MineMsgTableView.rowHeight;
    }else if (tableView == self.SysMsgTableView){
        self.SysMsgTableView.estimatedRowHeight = 200;
        self.SysMsgTableView.rowHeight = UITableViewAutomaticDimension;
        return self.SysMsgTableView.rowHeight;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.SysMsgTableView) {
        SysMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysmsgcell"];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
        cell.contentLabel.text = self.sysMsgArray[indexPath.section][@"title"];
//        cell.userName.text = self.sysMsgArray[indexPath.section][@"nickname"];
        cell.userName.text = @"熊起";
        return cell;
    }else{
        MineMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"minemsgcell"];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.headerImaegVIew sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
        cell.contentLabel.text = @"";
        cell.userName.text = self.mineMsgArray[indexPath.section][@"nickname"];
        return cell;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
