//
//  BottomCommentView.m
//  BearUp
//
//  Created by Tebuy on 2017/5/27.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BottomCommentView.h"

@interface BottomCommentView ()<UITextFieldDelegate>

@end

@implementation BottomCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initWithView];
        self.backgroundColor  =[UIColor whiteColor];
    }
    return self;
}
- (void)initWithView{
    UIView *bottomView = [UIView new];

    bottomView = self;
    CALayer *topLayer = [CALayer layer];
    topLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    topLayer.frame = CGRectMake(CGRectGetMinX(bottomView.frame)+1, 0, SCREEN_WIDTH, 1.0);
    [bottomView.layer addSublayer:topLayer];
    
    UIButton *bulletScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bulletScreenBtn setImage:[UIImage imageNamed:@"弹幕红"] forState:UIControlStateNormal];
    [bulletScreenBtn addTarget:self action:@selector(danmuWithBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:bulletScreenBtn];
    [bulletScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
    }];
    
    UITextField *commentTextField = [UITextField new];
    [bottomView addSubview:commentTextField];
    [commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bulletScreenBtn.mas_right).offset(15);
        make.height.equalTo(bulletScreenBtn.mas_height);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH/2));
    }];
    commentTextField.delegate = self;
    commentTextField.placeholder = @"我也来一弹!";
    commentTextField.borderStyle = UITextBorderStyleRoundedRect;
    commentTextField.keyboardAppearance = UIReturnKeyDone;
    commentTextField.keyboardType = UIKeyboardTypeDefault;
    
    UIButton *lookForCommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookForCommendBtn setImage:[UIImage imageNamed:@"看评论灰"] forState:UIControlStateNormal];
    [lookForCommendBtn addTarget:self action:@selector(lookForCommentWithBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:lookForCommendBtn];
    [lookForCommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentTextField.mas_right).offset(15);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectBtn setImage:[UIImage imageNamed:@"收藏灰"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectWithBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lookForCommendBtn.mas_right).offset(15);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.equalTo(@26);
        make.width.equalTo(@26);
    }];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"分享灰"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareWithBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-15);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    self.commendTextfield = commentTextField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [LTHttpManager commentNewsWithId:@(textField.tag) Content:textField.text Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            SVProgressShowStuteText(@"评论成功", YES);
        }else{
            SVProgressShowStuteText(@"评论失败", NO);
        }
    }];
    return YES;
}
- (void)shareWithBtnClick:(UIButton *)btn{
    [_delegate shareWithBtnClick:btn];
}
- (void)danmuWithBtnClick:(UIButton *)btn{
    btn.selected  = !btn.selected;
    
    [_delegate danmuWithBtnClick:btn];
}
- (void)lookForCommentWithBtnClick:(UIButton *)btn{
    [_delegate lookForCommentWithBtnClick:btn];
}
- (void)collectWithBtnClick:(UIButton *)btn{
    [_delegate collectWithBtnClick:btn];
}
@end
