//
//  AdvertisingTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/6/27.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertisingTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, copy) void (^adCloseBlock)(UIButton *btn);
@end
