//
//  HorizontalCollectionViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/5/18.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "HorizontalCollectionViewCell.h"

@interface HorizontalCollectionViewCell()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HorizontalCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initWithCell];
        self.backgroundColor = [UIColor greenColor];
        self.contentView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    return self;
}

- (void)initWithCell{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.contentView addSubview:tableView];
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView = tableView;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor grayColor];
    cell.textLabel.text = @"今天的天气";
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    return cell;
}
@end
