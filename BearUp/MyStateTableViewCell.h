//
//  MyStateTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/7/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStateModel.h"

typedef NS_ENUM(NSInteger, MyStateCellStyle) {
//    1-点赞文章，2-分享文章，3-收藏，4-赞评论，5-评论文章
    MyStateCellStylePraiseArticle       = 1,
    MyStateCellStyleShare               = 2,
    MyStateCellStyleCollectionArticle   = 3,
    MyStateCellStylePraiseComment       = 4,
    MyStateCellStyleComment             = 5
};

@interface MyStateTableViewCell : UITableViewCell
@property (nonatomic, assign) MyStateCellStyle myStateCellStyle;
@property (nonatomic, strong) MyStateModel *model;
@end
