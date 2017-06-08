//
//  RegisterViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/7.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *readerUserBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordHideBtn;
@property (weak, nonatomic) IBOutlet UIButton *postCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //自定义一个NaVIgationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)initWithView{
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    self.codeTF.keyboardType = UIKeyboardTypePhonePad;
    self.setPasswordTF.secureTextEntry = YES;
    [self.registerBtn.layer setCornerRadius:self.registerBtn.bounds.size.height/2];
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)posetCodeBtn:(id)sender {
    [sender setBackgroundColor:UIColorFromRGB(0xff4466)];
}
- (IBAction)registerBtn:(id)sender {
}
- (IBAction)readerAgreement:(id)sender {
}
- (IBAction)hidePasswordBtn:(id)sender {
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
