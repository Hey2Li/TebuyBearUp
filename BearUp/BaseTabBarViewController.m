//
//  BaseTabBarViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BUHomeViewController.h"
#import "BUVideoViewController.h"
#import "BUFoundViewController.h"
#import "BUMineViewController.h"
#import "BaseNaviViewController.h"

@interface BaseTabBarViewController ()
@property (nonatomic, strong) BaseNaviViewController *homeTab;
@property (nonatomic, strong) BaseNaviViewController *videoTab;
@property (nonatomic, strong) BaseNaviViewController *foundTab;
@property (nonatomic, strong) BaseNaviViewController *mineTab;
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建Tab
    [self createTabBar];
}
- (void)createTabBar{
    _homeTab = [[BaseNaviViewController alloc]initWithRootViewController:[BUHomeViewController new]];
    _videoTab = [[BaseNaviViewController alloc]initWithRootViewController:[BUVideoViewController new]];
    _foundTab = [[BaseNaviViewController alloc]initWithRootViewController:[BUFoundViewController new]];
    _mineTab = [[BaseNaviViewController alloc]initWithRootViewController:[BUMineViewController new]];
    self.viewControllers = @[_homeTab, _videoTab, _foundTab, _mineTab];
    self.selectedIndex = 0;
    
    NSArray *titleArray = @[@"首页", @"视频", @"发现", @"我的"];
    NSArray *normalImgArray = @[];
    NSArray *selectedImgArray = @[];
    
    //设置分栏元素项
    for (int i = 0; i < titleArray.count; i++) {
        UIViewController *vc =  self.viewControllers[i];
//        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArray[i] image:[UIImage imageNamed:normalImgArray[i]] selectedImage:[UIImage imageNamed:selectedImgArray[i]]];
        vc.tabBarItem.title = titleArray[i];
    }
    
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
}
#pragma mark tabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //
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
