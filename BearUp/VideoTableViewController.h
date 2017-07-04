//
//  VideoTableViewController.h
//  BearUp
//
//  Created by Tebuy on 2017/6/13.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewController : UITableViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSNumber *categoryID;
@end
