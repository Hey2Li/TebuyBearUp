//
//  BottomCommentView.h
//  BearUp
//
//  Created by Tebuy on 2017/5/27.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomCommentDelegate <NSObject>

@optional
- (void)danmuWithBtnClick:(UIButton *)btn;
- (void)lookForCommentWithBtnClick:(UIButton *)btn;
- (void)collectWithBtnClick:(UIButton *)btn;
- (void)shareWithBtnClick:(UIButton *)btn;

@end

@interface BottomCommentView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, weak) id<BottomCommentDelegate> delegate;
@property (nonatomic, strong) UITextField *commendTextfield;
@property (nonatomic, strong) UIButton *collectionBtn;
@end
