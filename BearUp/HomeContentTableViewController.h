//
//  HomeContentTableViewController.h
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeContentTableViewController : UITableViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSNumber *categoryID;
@end
