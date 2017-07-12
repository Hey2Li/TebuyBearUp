//
//  MessageViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/7/12.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    [self initWithView];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
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
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"系统通知",@"我的收藏"]];
    segment.tintColor = UIColorFromRGB(0xff4466);
    [topView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.height.equalTo(@30);
        make.width.equalTo(@210);
    }];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(messageChange:) forControlEvents:UIControlEventValueChanged];
}
- (void)messageChange:(UISegmentedControl *)sender{
    
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
