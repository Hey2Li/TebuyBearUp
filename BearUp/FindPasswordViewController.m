//
//  FindPasswordViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/8.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
@property (weak, nonatomic) IBOutlet UIButton *hidePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *hidePasswordagainBtn;
@property (weak, nonatomic) IBOutlet UIButton *postCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordAgainTF;


@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
//    self.navigationController.navigationBar.alpha = 0;
    [self.findBtn.layer setCornerRadius:25];
    [self.findBtn.layer setMasksToBounds:YES];
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
