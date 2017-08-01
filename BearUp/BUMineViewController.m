//
//  BUMineViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUMineViewController.h"
#import <WebKit/WebKit.h>
#import "MyStateTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "MIneCollectionTableViewCell.h"
#import "FocusModel.h"
#import "MyCollectionModel.h"
#import "MyStateModel.h"
#import "SettingTableViewController.h"
#import "LoginViewController.h"
#import "InfoSettingTableViewController.h"
#import "MessageViewController.h"
#import "SubCategoryViewController.h"

#define HederHeight ceil(SCREEN_HEIGHT/3) + 70
@interface BUMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *centerTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *focusArray;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSMutableArray *subCollectionArray;
@property (nonatomic, strong) NSMutableArray *collectionHeaderTitleArray;
@property (nonatomic, strong) NSMutableDictionary *collectionDic;
@property (nonatomic, assign) int collectionIndex;
@property (nonatomic, assign) int stateIndex;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *readNumLabel;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, assign) int loadIndex;
@property (nonatomic, strong) UIImageView *notLoginImageView;
@property (nonatomic, strong) UIImageView *headerImageBK;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *messageBtn;
@end

@implementation BUMineViewController

- (NSMutableArray *)focusArray{
    if (!_focusArray) {
        _focusArray = [NSMutableArray array];
    }
    return _focusArray;
}
- (NSMutableArray *)stateArray{
    if (!_stateArray) {
        _stateArray = [NSMutableArray array];
    }
    return _stateArray;
}
- (NSMutableArray *)_collectionHeaderTitleArray{
    if (!_collectionHeaderTitleArray) {
        _collectionHeaderTitleArray = [NSMutableArray array];
    }
    return _collectionHeaderTitleArray;
}
- (NSMutableArray *)subCollectionArray{
    if (!_subCollectionArray) {
        _subCollectionArray = [NSMutableArray array];
    }
    return _subCollectionArray;
}
- (NSMutableDictionary *)collectionDic{
    if (!_collectionDic) {
        _collectionDic = [NSMutableDictionary dictionary];
    }
    return _collectionDic;
}
- (UIImageView *)headerView{
    if (!_headerView ) {
        _headerView = [UIImageView new];
        _headerView.userInteractionEnabled = YES;
        UIImageView *headerView = [[UIImageView alloc]init];
        headerView.userInteractionEnabled = YES;
        [self.view addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@(ceil(SCREEN_HEIGHT/3) + 70));
            make.top.equalTo(self.view);
        }];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageBtn setImage:[UIImage imageNamed:@"登陆后无消息状态"] forState:UIControlStateNormal];
        [headerView addSubview:messageBtn];
        [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30);
            make.height.equalTo(@30);
            make.left.equalTo(headerView.mas_left).offset(15);
            make.top.equalTo(headerView.mas_top).offset(25);
        }];
        [messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
        self.messageBtn = messageBtn;
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setImage:[UIImage imageNamed:@"登陆后设置"] forState:UIControlStateNormal];
        [headerView addSubview:settingBtn];
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView.mas_right).offset(-15);
            make.top.equalTo(messageBtn);
            make.height.equalTo(messageBtn);
            make.width.equalTo(messageBtn);
        }];
        [settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
        self.settingBtn = settingBtn;
        
        UIImageView *headerImageBK = [UIImageView new];
        headerImageBK.image = [UIImage imageNamed:@""];
        [headerView addSubview:headerImageBK];
        if (UI_IS_IPHONE5) {
            [headerImageBK mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView).offset(-50);
                make.centerX.equalTo(headerView);
                make.width.equalTo(@110);
                make.height.equalTo(@110);
            }];
        }else if (UI_IS_IPHONE4){
            [headerImageBK mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView).offset(-60);
                make.centerX.equalTo(headerView);
                make.width.equalTo(@110);
                make.height.equalTo(@110);
            }];
        }else{
            [headerImageBK mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView).offset(-30);
                make.centerX.equalTo(headerView);
                make.width.equalTo(@110);
                make.height.equalTo(@110);
            }];
        }
        self.headerImageBK = headerImageBK;
        
        UIImageView *headerImageView = [UIImageView new];
        [headerImageBK addSubview:headerImageView];
        headerImageView.userInteractionEnabled = YES;
        headerImageView.image = [UIImage imageNamed:@"用户默认头像"];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageBK).offset(10);
            make.centerX.equalTo(headerImageBK).offset(-1);
            make.width.equalTo(@82);
            make.height.equalTo(@82);
        }];
        [headerImageView.layer setCornerRadius:41];
        [headerImageView.layer setMasksToBounds:YES];
        self.headerImageView = headerImageView;
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerImageBK addSubview:headerBtn];
        [headerImageBK bringSubviewToFront:headerBtn];
        headerImageBK.userInteractionEnabled = YES;
        [headerBtn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
        [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_left);
            make.right.equalTo(headerImageView.mas_right);
            make.top.equalTo(headerImageView.mas_top);
            make.bottom.equalTo(headerImageView.mas_bottom);
        }];
        self.headerBtn = headerBtn;
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.font = [UIFont systemFontOfSize:20];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"";
        nameLabel.textColor = UIColorFromRGB(0xffffff);
        [headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerBtn.mas_bottom).offset(5);
            make.left.equalTo(headerView.mas_left);
            make.right.equalTo(headerView.mas_right);
            make.height.equalTo(@35);
        }];
        self.userNameLabel = nameLabel;
        
        UILabel *readerNumLabel = [UILabel new];
        readerNumLabel.textAlignment = NSTextAlignmentCenter;
        readerNumLabel.font = [UIFont systemFontOfSize:14];
        readerNumLabel.textColor = UIColorFromRGB(0xffffff);
        readerNumLabel.text = @"您最近阅读了X篇文章，加油啊！";
        [headerView addSubview:readerNumLabel];
        [readerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.right.equalTo(nameLabel);
            make.height.equalTo(@20);
            make.top.equalTo(nameLabel.mas_bottom).offset(5);
        }];
        self.readNumLabel = readerNumLabel;
        
        UIView *centerClickView = [UIView new];
        centerClickView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:centerClickView];
        [centerClickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView);
            make.right.equalTo(headerView);
            make.height.equalTo(@50);
            make.bottom.equalTo(headerView);
        }];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:@"关注" forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateSelected];
        leftBtn.selected = YES;
        _tempBtn = leftBtn;
        [centerClickView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerClickView);
            make.width.equalTo(@(SCREEN_WIDTH/3));
            make.top.equalTo(centerClickView);
            make.bottom.equalTo(centerClickView).offset(-1);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateSelected];
        [centerClickView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftBtn);
            make.bottom.equalTo(leftBtn);
            make.width.equalTo(leftBtn);
            make.right.equalTo(centerClickView);
        }];
        
        UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [centerBtn setTitle:@"我的动态" forState:UIControlStateNormal];
        [centerBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [centerBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateSelected];
        [centerClickView addSubview:centerBtn];
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBtn.mas_right);
            make.right.equalTo(rightBtn.mas_left);
            make.top.equalTo(leftBtn);
            make.bottom.equalTo(leftBtn);
        }];
        self.leftBtn = leftBtn;
        self.centerBtn = centerBtn;
        self.rightBtn = rightBtn;
        
        UILabel *line = [UILabel new];
        line.backgroundColor = UIColorFromRGB(0xff4466);
        [centerClickView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@1);
            make.centerX.equalTo(leftBtn.mas_centerX);
            make.bottom.equalTo(leftBtn);
        }];
        self.line = line;
        
        UILabel *line1 = [UILabel new];
        line1.backgroundColor = UIColorFromRGB(0xeeeeee);
        [centerClickView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerClickView);
            make.right.equalTo(centerClickView);
            make.height.equalTo(@1);
            make.top.equalTo(line.mas_bottom);
        }];
        
        
        [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = 1001;
        centerBtn.tag = 1002;
        rightBtn.tag = 1003;
        _headerView = headerView;
    }
    return _headerView;
}
- (void)settingClick{
    [self.navigationController pushViewController:[SettingTableViewController new] animated:YES];
}
- (void)messageClick{
//    SVProgressShowStuteText(@"暂无消息", NO);
//    return;
    if (USER_ID) {
             [self.navigationController pushViewController:[MessageViewController new] animated:YES];
    }else{
        SVProgressShowStuteText(@"请先登录", NO);
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self userLogin];
}
- (void)notLogin{
    self.notLoginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"未登录提示图"]];
    [self.scrollView addSubview:self.notLoginImageView];
    [self.centerTableView removeFromSuperview];
    [self.leftTableView removeFromSuperview];
    [self.rightTableView removeFromSuperview];

    self.notLoginImageView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = NO;
    [self.notLoginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    self.notLoginImageView.contentMode = UIViewContentModeCenter;
    [self btnClick:self.leftBtn];
    self.leftBtn.userInteractionEnabled = NO;
    self.centerBtn.userInteractionEnabled = NO;
    self.rightBtn.userInteractionEnabled = NO;
    
    self.userNameLabel.text = @"去登录";
    self.readNumLabel.text = @"你最近阅读了0篇文章，加油哦";
    self.headerImageView.image = [UIImage imageNamed:@"用户默认头像"];
    [self.headerBtn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.image = [UIImage imageNamed:@"未登录背景"];
    self.headerImageBK.image = [UIImage imageNamed:@""];
    self.userNameLabel.textColor = UIColorFromRGB(0xffffff);
    self.readNumLabel.textColor = UIColorFromRGB(0xffffff);
    [self.settingBtn setImage:[UIImage imageNamed:@"未登录设置"] forState:UIControlStateNormal];
    [self.messageBtn setImage:[UIImage imageNamed:@"未登录消息状态"] forState:UIControlStateNormal];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self headerView];
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notLogin) name:@"userquit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:@"userlogin" object:nil];
}
- (void)userLogin{
    if (USER_ID) {
        NSLog(@"%@",USER_ID);
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"loadIndex"] isEqualToString:@"1"] || _loadIndex != 1) {
            [self headerLoadData];
            [self footerLoadData];
            _loadIndex = 1;
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"loadIndex"];
            [self.notLoginImageView removeFromSuperview];
        }else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_PHOTO] ]] placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
            self.userNameLabel.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_NICKNAME]];
            self.readNumLabel.text = [NSString stringWithFormat:@"你最近阅读了%@篇文章，加油哦",[userDefaults objectForKey:USER_READNUM]];
            if ([[userDefaults objectForKey:USER_SEX] isEqual:@1]) {
                self.headerView.backgroundColor = RGBCOLOR(228, 235, 243);
                self.headerImageBK.image = [UIImage imageNamed:@"男标示"];
                self.userNameLabel.textColor = UIColorFromRGB(0x000000);
                self.readNumLabel.textColor = UIColorFromRGB(0x6b6b6b);
                [self.settingBtn setImage:[UIImage imageNamed:@"登陆后设置"] forState:UIControlStateNormal];
                [self.messageBtn setImage:[UIImage imageNamed:@"登陆后无消息状态"] forState:UIControlStateNormal];
                self.headerView.image = [UIImage imageNamed:@""];
            }else if ([[userDefaults objectForKey:USER_SEX] isEqual:@2]){
                self.headerView.backgroundColor = RGBCOLOR(255, 240, 243);
                self.headerImageBK.image = [UIImage imageNamed:@"女生标示"];
                self.userNameLabel.textColor = UIColorFromRGB(0x000000);
                self.readNumLabel.textColor = UIColorFromRGB(0x6b6b6b);
                
                [self.settingBtn setImage:[UIImage imageNamed:@"登陆后设置"] forState:UIControlStateNormal];
                [self.messageBtn setImage:[UIImage imageNamed:@"登陆后无消息状态"] forState:UIControlStateNormal];
                self.headerView.image = [UIImage imageNamed:@""];
            }else{
                self.headerView.image = [UIImage imageNamed:@"未登录背景"];
                self.headerImageBK.image = [UIImage imageNamed:@""];
                self.userNameLabel.textColor = UIColorFromRGB(0xffffff);
                self.readNumLabel.textColor = UIColorFromRGB(0xffffff);
                [self.settingBtn setImage:[UIImage imageNamed:@"未登录设置"] forState:UIControlStateNormal];
                [self.messageBtn setImage:[UIImage imageNamed:@"未登录消息状态"] forState:UIControlStateNormal];
            }
        }
        self.leftBtn.userInteractionEnabled = YES;
        self.centerBtn.userInteractionEnabled = YES;
        self.rightBtn.userInteractionEnabled = YES;
        self.scrollView.scrollEnabled = YES;
        [self.notLoginImageView removeFromSuperview];
        [self.scrollView sendSubviewToBack:self.notLoginImageView];
    }else{
        [self notLogin];
    }
}
- (void)gotoLogin:(UIButton *)btn{
    if (USER_ID) {
        [self.navigationController pushViewController:[InfoSettingTableViewController new] animated:YES];
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
        LoginViewController *lvc = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:lvc];
        [self presentViewController:navi animated:YES completion:nil];
    }
}
- (void)headerLoadData{
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [LTHttpManager userSubscripWithUser_uuid:GETUUID User_id:USER_ID User_token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSDictionary *infoDic = data[@"responseData"][@"info"];
                if (![infoDic[@"photo"] isEqual:[NSNull null]]) {
                      [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",infoDic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
                    [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"photo"] forKey:USER_PHOTO];

                }
                if (infoDic[@"nickname"]) {
                    self.userNameLabel.text = [NSString stringWithFormat:@"%@",infoDic[@"nickname"]];
                     [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"nickname"] forKey:USER_NICKNAME];
                }else{
                    if (infoDic[@"mobile"]) {
                        self.userNameLabel.text = [NSString stringWithFormat:@"%@",infoDic[@"mobile"]];
                        [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"mobile"] forKey:USER_MOBILE];
                        [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"nickname"] forKey:USER_NICKNAME];
                    }
                }
//                self.readNumLabel.text = [NSString stringWithFormat:@"你最近阅读了%@篇文章，加油哦",infoDic[@"read_num"]];
                [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"read_num"] forKey:USER_READNUM];
                [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"mobile"] forKey:USER_MOBILE];
                [[NSUserDefaults standardUserDefaults]setObject:infoDic[@"sex"] forKey:USER_SEX];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_PHOTO] ]] placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
                self.userNameLabel.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_NICKNAME]];
                self.readNumLabel.text = [NSString stringWithFormat:@"你最近阅读了%@篇文章，加油哦",[userDefaults objectForKey:USER_READNUM]];
                if ([[userDefaults objectForKey:USER_SEX] isEqual:@1]) {
                    self.headerView.backgroundColor = RGBCOLOR(228, 235, 243);
                    self.headerImageBK.image = [UIImage imageNamed:@"男标示"];
                    self.userNameLabel.textColor = UIColorFromRGB(0x000000);
                    self.readNumLabel.textColor = UIColorFromRGB(0x6b6b6b);
                    [self.settingBtn setImage:[UIImage imageNamed:@"登陆后设置"] forState:UIControlStateNormal];
                    [self.messageBtn setImage:[UIImage imageNamed:@"登陆后无消息状态"] forState:UIControlStateNormal];
                    self.headerView.image = [UIImage imageNamed:@""];
                }else if ([[userDefaults objectForKey:USER_SEX] isEqual:@2]){
                    self.headerView.backgroundColor = RGBCOLOR(255, 240, 243);
                    self.headerImageBK.image = [UIImage imageNamed:@"女生标示"];
                    self.userNameLabel.textColor = UIColorFromRGB(0x000000);
                    self.readNumLabel.textColor = UIColorFromRGB(0x6b6b6b);
                    [self.settingBtn setImage:[UIImage imageNamed:@"登陆后设置"] forState:UIControlStateNormal];
                    [self.messageBtn setImage:[UIImage imageNamed:@"登陆后无消息状态"] forState:UIControlStateNormal];
                    self.headerView.image = [UIImage imageNamed:@""];
                }else{
                    self.headerView.image = [UIImage imageNamed:@"未登录背景"];
                    self.headerImageBK.image = [UIImage imageNamed:@""];
                    self.userNameLabel.textColor = UIColorFromRGB(0xffffff);
                    self.readNumLabel.textColor = UIColorFromRGB(0xffffff);
                    [self.settingBtn setImage:[UIImage imageNamed:@"未登录设置"] forState:UIControlStateNormal];
                    [self.messageBtn setImage:[UIImage imageNamed:@"未登录消息状态"] forState:UIControlStateNormal];
                }

            
                [self.focusArray removeAllObjects];
                NSArray *array = data[@"responseData"][@"rows"];
                for (NSDictionary *dic in array) {
                    FocusModel *model = [FocusModel mj_objectWithKeyValues:dic];
                    [self.focusArray addObject:model];
                }
                if (self.focusArray.count < 1) {
                    UIImageView *imageView  =[UIImageView new];
                    imageView.image = [UIImage imageNamed:@"没有关注"];
                    imageView.contentMode = UIViewContentModeCenter;
                    [self.leftTableView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.equalTo(self.leftTableView);
                        make.width.equalTo(self.leftTableView);
                        make.height.equalTo(self.leftTableView);
                    }];
                    imageView.tag = 11110;
                }else{
                    for (UIImageView *image in self.leftTableView.subviews) {
                        if (image.tag == 11110) {
                            [image removeFromSuperview];
                        }                        }
                    [self.leftTableView reloadData];
                }
                [self.leftTableView.mj_header endRefreshing];
            }else{
                [self.leftTableView.mj_header endRefreshing];
            }
        }];
    }];
    self.centerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _stateIndex = 1;
        [LTHttpManager myStateWithLimit:@10 Token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                [self.stateArray removeAllObjects];
                NSArray *array = data[@"responseData"][@"rows"][@"data"];
                for (NSDictionary *dic in array) {
                    MyStateModel *model = [MyStateModel mj_objectWithKeyValues:dic];
                    [self.stateArray addObject:model];
                }
                if (self.stateArray.count < 1) {
                    UIImageView *imageView  =[UIImageView new];
                    imageView.image = [UIImage imageNamed:@"没有动态"];
                    imageView.contentMode = UIViewContentModeCenter;
                    [self.centerTableView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.equalTo(self.centerTableView);
                        make.width.equalTo(self.centerTableView);
                        make.height.equalTo(self.centerTableView);
                    }];
                    imageView.tag = 11110;
                }else{
                    for (UIImageView *image in self.centerTableView.subviews) {
                        if (image.tag == 11110) {
                            [image removeFromSuperview];
                        }                        }
                    [self.centerTableView reloadData];
                }
                [self.centerTableView.mj_header endRefreshing];
            }else{
                [self.centerTableView.mj_header endRefreshing];
            }
        }];
    }];
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _collectionIndex = 1;
        [LTHttpManager myCollectionsWithLimit:@10 User_token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *collectionDics = data[@"responseData"][@"rows"];
                    NSArray *titleArrays = [collectionDics allKeys];

                    [titleArrays sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        if (obj1 == [NSNull null]) {
                            obj1 = @"0000-00-00";
                        }
                        if (obj2 == [NSNull null]) {
                            obj2 = @"0000-00-00";
                        }
                        NSDate *date1 = [formatter dateFromString:obj1];
                        NSDate *date2 = [formatter dateFromString:obj2];
                        NSComparisonResult result = [date1 compare:date2];
                        return result == NSOrderedDescending;
                    }];
                    
                    self.collectionHeaderTitleArray = [NSMutableArray arrayWithArray:titleArrays];
                    [self.collectionDic removeAllObjects];
                    NSMutableArray *muArr = [NSMutableArray array];
                    for (int i = 0; i < self.collectionHeaderTitleArray.count; i++) {
                        NSArray *arr = collectionDics[self.collectionHeaderTitleArray[i]];
                        [muArr removeAllObjects];
                        for (NSDictionary *dic in arr) {
                            MyCollectionModel *model = [MyCollectionModel mj_objectWithKeyValues:dic];
                            [muArr addObject:model];
                        }
                        [self.collectionDic setObject:muArr.mutableCopy forKey:self.collectionHeaderTitleArray[i]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (titleArrays.count <= 1 && [titleArrays[0] isEqualToString:@""]) {
                            UIImageView *imageView  =[UIImageView new];
                            imageView.image = [UIImage imageNamed:@"没有收藏"];
                            imageView.contentMode = UIViewContentModeCenter;
                            [self.rightTableView addSubview:imageView];
                            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.center.equalTo(self.rightTableView);
                                make.width.equalTo(self.rightTableView);
                                make.height.equalTo(self.rightTableView);
                            }];
                            imageView.tag = 11110;
                        }else{
                            for (UIImageView *image in self.rightTableView.subviews) {
                                if (image.tag == 11110) {
                                    [image removeFromSuperview];
                                }                        }
                            [self.rightTableView reloadData];
                        }
                        [self.rightTableView.mj_header endRefreshing];
                    });
                });
            }else{
                [self.rightTableView.mj_header endRefreshing];
            }
        }];
    }];
    [self.leftTableView.mj_header beginRefreshing];
    [self.centerTableView.mj_header beginRefreshing];
    [self.rightTableView.mj_header beginRefreshing];
}
- (void)footerLoadData{
    self.centerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _stateIndex++;
        [LTHttpManager myStateMoreWithLimit:@10 Page:@(_stateIndex) Token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *array = data[@"responseData"][@"data"];
                for (NSDictionary *dic in array) {
                    MyStateModel *model = [MyStateModel mj_objectWithKeyValues:dic];
                    [self.stateArray addObject:model];
                }
                [self.centerTableView reloadData];
                [self.centerTableView.mj_footer endRefreshing];
            }else{
                _selectIndex--;
                [self.centerTableView.mj_footer endRefreshing];
            }
        }];
    }];
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _collectionIndex++;
        [LTHttpManager myCollectionsMoreWithLimit:@10 Page:@(_collectionIndex) User_token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *collectionDics = data[@"responseData"];
                    
                    NSArray *titleArrays = [collectionDics allKeys];
                    [self.collectionHeaderTitleArray addObjectsFromArray:titleArrays];
                    [self.collectionHeaderTitleArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd"];
                        if (obj1 == [NSNull null]) {
                            obj1 = @"0000-00-00";
                        }
                        if (obj2 == [NSNull null]) {
                            obj2 = @"0000-00-00";
                        }
                        NSDate *date1 = [formatter dateFromString:obj1];
                        NSDate *date2 = [formatter dateFromString:obj2];
                        NSComparisonResult result = [date1 compare:date2];
                        return result == NSOrderedDescending;
                    }];
                    NSLog(@"%@",self.collectionHeaderTitleArray);
                    NSMutableArray *muArr = [NSMutableArray array];
                    [muArr removeAllObjects];
                    for (int i = 0; i < [collectionDics allKeys].count; i++) {
                        NSArray *arr = collectionDics[[collectionDics allKeys][i]];
                        for (NSDictionary *dic in arr) {
                            MyCollectionModel *model = [MyCollectionModel mj_objectWithKeyValues:dic];
                            [muArr addObject:model];
                        }
                        [self.collectionDic setObject:muArr.mutableCopy forKey:[collectionDics allKeys][i]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.rightTableView reloadData];
                        [self.rightTableView.mj_footer endRefreshing];
                    });
                });
            }else{
                _collectionIndex--;
                [self.rightTableView.mj_footer endRefreshing];
            }
        }];
    }];
}
- (void)initWithView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
   
    if (USER_ID) {
        
        UITableView *leftTableView = [UITableView new];
        leftTableView.delegate = self;
        leftTableView.dataSource = self;
        //    leftTableView.separatorStyle = NO;
        leftTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HederHeight - 188);
        [scrollView addSubview:leftTableView];
        self.leftTableView = leftTableView;
        
        UITableView *rightTableView = [UITableView new];
        rightTableView.delegate = self;
        rightTableView.dataSource = self;
        rightTableView.separatorStyle = NO;
        rightTableView.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HederHeight - 188);
        [scrollView addSubview:rightTableView];
        self.rightTableView = rightTableView;
        
        UITableView *centerTableView = [UITableView new];
        centerTableView.delegate = self;
        centerTableView.dataSource = self;
        //    centerTableView.separatorStyle = NO;
        centerTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HederHeight - 188);
        [scrollView addSubview:centerTableView];
        self.centerTableView = centerTableView;
        
        
        [self.centerTableView registerNib:[UINib nibWithNibName:@"MyStateTableViewCell" bundle:nil] forCellReuseIdentifier:@"myStateCell"];

        
        [self.leftTableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"focusCell"];
        self.leftTableView.estimatedRowHeight = 100.f;
        
        [self.rightTableView registerNib:[UINib nibWithNibName:@"MIneCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"mineCollectionCell"];
        self.leftTableView.tableFooterView = [UIView new];
        self.centerTableView.tableFooterView = [UIView new];
        self.rightTableView.tableFooterView = [UIView new];
    }
}

- (void)btnClick:(UIButton *)btn{
    if (_tempBtn == nil) {
        btn.selected = YES;
        _tempBtn = btn;
    }else if (_tempBtn != nil && _tempBtn == btn){
        btn.selected = YES;
    }else if (_tempBtn != nil && _tempBtn != btn){
        btn.selected = YES;
        _tempBtn.selected = NO;
        _tempBtn = btn;
    }
    if (btn.selected) {
        [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.line.superview layoutIfNeeded];
        }];
        _selectIndex = btn.tag;
    }
    if (btn.tag == 1001) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.leftTableView reloadData];
    }else if (btn.tag == 1002){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        [self.centerTableView reloadData];
    }else if (btn.tag == 1003){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:NO];
        [self.rightTableView reloadData];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        UIButton *btn = [UIButton new];
        if (index == 0) {
            self.leftBtn.selected = YES;
            self.centerBtn.selected = NO;
            self.rightBtn.selected = NO;
            btn = self.leftBtn;
            [self.leftTableView reloadData];
        }else if (index == 1){
            self.centerBtn.selected = YES;
            self.leftBtn.selected = NO;
            self.rightBtn.selected = NO;
            btn = self.centerBtn;
            [self.centerTableView reloadData];
        }else if (index ==  2){
            self.rightBtn.selected = YES;
            self.centerBtn.selected = NO;
            self.leftBtn.selected = NO;
            btn = self.rightBtn;
            [self.rightTableView reloadData];
        }
        if (btn.selected) {
            [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@50);
                make.height.equalTo(@1);
                make.centerX.equalTo(btn.mas_centerX);
                make.bottom.equalTo(btn);
            }];
            [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@50);
                make.height.equalTo(@1);
                make.centerX.equalTo(btn.mas_centerX);
                make.bottom.equalTo(btn);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [self.line.superview layoutIfNeeded];
            }];
            _selectIndex = btn.tag;
        }

    }
}


#pragma mark - TableViewDelegate

-(void)viewDidLayoutSubviews {
    
    if ([self.rightTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.rightTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.rightTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.rightTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.centerTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.centerTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.centerTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.centerTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    if ([self.leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.leftTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.leftTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.leftTableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;
    }else if (tableView == self.centerTableView){
        return 1;
    }else if (tableView == self.rightTableView){
        return self.collectionHeaderTitleArray.count;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.focusArray.count;
    }else if (tableView == self.centerTableView){
        return self.stateArray.count;
    }else if (tableView == self.rightTableView){
        NSArray *array = self.collectionDic[self.collectionHeaderTitleArray[section]];
      return array.count;
    }else{
        return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) {
        [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor whiteColor]];
        return self.collectionHeaderTitleArray[section];
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        return 100;
    }else if (tableView == self.centerTableView){
        self.centerTableView.estimatedRowHeight = 150.0f;
        self.centerTableView.rowHeight = UITableViewAutomaticDimension;
        return self.centerTableView.rowHeight;
    }else{
        self.rightTableView.estimatedRowHeight = 60.0f;
        self.rightTableView.rowHeight = UITableViewAutomaticDimension;
        return self.rightTableView.rowHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _centerTableView) {
        MyStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myStateCell"];
        if (self.stateArray.count > 0) {
            cell.model = self.stateArray[indexPath.row];
        }
        return cell;
    }else if (tableView == _leftTableView){
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusCell"];
        if (self.focusArray.count > 0) {
            cell.model = self.focusArray[indexPath.row];
        }
        cell.focusBtn.selected = YES;
        cell.focusBtn.backgroundColor = [UIColor whiteColor];
        [cell.focusBtn.layer setBorderColor:UIColorFromRGB(0xaeaeae).CGColor];
        cell.focusCategoryClick = ^(UIButton *btn) {
            if (btn.selected) {
                [self initBottomView:self.focusArray[indexPath.row] And:indexPath.row];
            }
        };
        return cell;
    }else if (tableView == _rightTableView){
        MIneCollectionTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"mineCollectionCell"];
        cell.model = self.collectionDic[self.collectionHeaderTitleArray[indexPath.section]][indexPath.row];
        return cell;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        FocusModel *model = self.focusArray[indexPath.row];
        SubCategoryViewController *vc = [SubCategoryViewController new];
        vc.cid = model.cid;
        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else if (tableView == self.centerTableView){
        MyStateModel *model = self.stateArray[indexPath.row];
        if ([model.type  isEqual: @1]) {
            CDetailViewController *vc =[CDetailViewController new];
            vc.cid = [NSString stringWithFormat:@"%@",model.nid];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type  isEqual: @2]){
            VideoDetailViewController *vc = [VideoDetailViewController new];
            vc.vid = model.nid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (tableView == self.rightTableView){
        MyCollectionModel *model = self.collectionDic[self.collectionHeaderTitleArray[indexPath.section]][indexPath.row];
        if ([model.type  isEqual: @1]) {
            CDetailViewController *vc =[CDetailViewController new];
            vc.cid = [NSString stringWithFormat:@"%@",model.nid];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type  isEqual: @2]){
            VideoDetailViewController *vc = [VideoDetailViewController new];
            vc.vid = model.nid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initBottomView:(FocusModel *)model And:(NSInteger)row{
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(keyWindow);
        make.right.equalTo(keyWindow);
        make.top.equalTo(keyWindow);
        make.bottom.equalTo(keyWindow);
    }];
    
    UIView *showView = [UIView new];
    showView.backgroundColor  = [UIColor whiteColor];
    [maskView addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maskView);
        make.right.equalTo(maskView);
        make.bottom.equalTo(maskView);
        make.height.equalTo(@(SCREEN_WIDTH * 0.56));
    }];
    
    UIImageView *focusImageView = [UIImageView new];
    focusImageView.backgroundColor  =[UIColor redColor];
    [focusImageView.layer setMasksToBounds:YES];
    [focusImageView.layer setCornerRadius:8];
    [showView addSubview:focusImageView];
    [focusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(showView.mas_centerX);
        make.height.equalTo(@80);
        make.width.equalTo(focusImageView.mas_height);
        make.top.equalTo(showView.mas_top).offset(10);
    }];
    
    UIButton *noFocus = [UIButton buttonWithType:UIButtonTypeCustom];
    [noFocus setTitle:@"不在关注" forState:UIControlStateNormal];
    [noFocus setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateNormal];
    [noFocus setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    [showView addSubview:noFocus];
    [noFocus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView.mas_left).offset(20);
        make.right.equalTo(showView.mas_right).offset(-20);
        make.height.equalTo(@35);
        make.top.equalTo(focusImageView.mas_bottom).offset(20);
    }];
    noFocus.tag = row;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    [showView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView.mas_left).offset(20);
        make.right.equalTo(showView.mas_right).offset(-20);
        make.height.equalTo(@35);
        make.top.equalTo(noFocus.mas_bottom).offset(15);
    }];
    [noFocus.layer setMasksToBounds:YES];
    [noFocus.layer setCornerRadius:5];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn.layer setCornerRadius:5];
    [focusImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"未加载好图片正"]];
    [noFocus addTarget:self action:@selector(cancelFocus:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
     [focusImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"未加载好图片正"]];
}
- (void)cancelView:(UIButton *)btn{
    [btn.superview.superview removeFromSuperview];
}
- (void)cancelFocus:(UIButton *)btn{
    FocusModel *model = self.focusArray[btn.tag];
    [LTHttpManager focusCategoryWithCid:model.cid Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            SVProgressShowStuteText(@"取消成功", YES);
            [self.focusArray removeObjectAtIndex:btn.tag];
            [self.leftTableView reloadData];
            [btn.superview.superview removeFromSuperview];
        }else{
            SVProgressShowStuteText(@"取消失败", YES);
        }
    }];
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
