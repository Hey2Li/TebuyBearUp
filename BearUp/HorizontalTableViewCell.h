//
//  HorizontalTableViewCell.h
//  
//
//  Created by Tebuy on 2017/6/5.
//
//

#import <UIKit/UIKit.h>

@interface HorizontalTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^HorCollectionCellClick)(NSIndexPath *indexPath);
@end