//
//  MIneCollectionTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/7/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionModel.h"

@interface MIneCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleDetail;
@property (nonatomic, strong) MyCollectionModel *model;
@end
