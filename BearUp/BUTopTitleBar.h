//
//  BUTopTitleBar.h
//  BearUp
//
//  Created by Tebuy on 2017/5/17.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BUTopTitleBarDelegate <NSObject>

@optional
- (void)itemDidSelectedWithIndex:(NSInteger)index;
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;

@end

@interface BUTopTitleBar : UIView

@property (nonatomic, weak) id<BUTopTitleBarDelegate>delegate;
@property (nonatomic, assign) NSInteger currentItemIndex;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSMutableArray *items;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame AndItems:(NSArray *)items;
- (void)updateData;
@end
