//
//  VideoDetailTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/6/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoDetails;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commendBtn;

@end
