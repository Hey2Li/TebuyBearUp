//
//  MineMsgTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/7/13.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mineMsgBKView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImaegVIew;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
