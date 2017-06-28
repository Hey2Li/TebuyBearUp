//
//  CategoryTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/6/28.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UILabel *introducelabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
