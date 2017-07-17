//
//  SysMsgTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/7/13.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SysMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *sysMsgBKView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
