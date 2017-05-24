//
//  VideoTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/5/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UIButton *playBtn;
/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *);
@end
