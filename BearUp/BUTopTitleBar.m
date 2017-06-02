//
//  BUTopTitleBar.m
//  BearUp
//
//  Created by Tebuy on 2017/5/17.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BUTopTitleBar.h"
#import "NSString+Extension.h"

@interface BUTopTitleBar()<UIScrollViewDelegate>
{
    UIScrollView *_nagationNavBar;
    UIView *_line;
    NSArray *_itemWidtn;
}
@end

@implementation BUTopTitleBar

- (id)initWithFrame:(CGRect)frame AndItems:(NSArray *)items{
    self = [super initWithFrame:frame];
    if (self) {
        _itemTitles = items;
        _nagationNavBar = [[UIScrollView alloc]initWithFrame:self.bounds];
        _nagationNavBar.showsHorizontalScrollIndicator = NO;
        _nagationNavBar.delegate = self;
        _currentItemIndex = 1;
        [self addSubview:_nagationNavBar];
        if (items) {
            _itemWidtn = [self getButtonsWidthWithTitles:_itemTitles];
            if (_itemWidtn.count) {
                CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemWidtn];
                _nagationNavBar.contentSize = CGSizeMake(contentWidth, 0);
            }
        }
    }
    return self;
}
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    _items = [@[] mutableCopy];
    for (NSInteger index = 0; index < widths.count; index++){
        CGFloat lblW = 70;
        CGFloat lblH = 40;
        CGFloat lblY = 20;
        CGFloat lblX = index * lblW;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
//        CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
//        CGSize textRealSize = [_itemTitles[index] sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize].size;
//        
//        textRealSize = CGSizeMake(textRealSize.width + 15*2, 44);
        button.frame = CGRectMake(lblX, lblY,lblW, lblH);
        
        //字体颜色
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_nagationNavBar addSubview:button];
        [_items addObject:button];
        buttonX += button.frame.size.width;
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}

#pragma mark  下划线
- (void)showLineWithButtonWidth:(CGFloat)width
{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(21, 64 - 5.0f, 28, 3.0f)];
    _line.backgroundColor = [UIColor whiteColor];
    [_nagationNavBar addSubview:_line];
    
    UIButton *btn = _items[0];
    [self itemPressed:btn type:0];
}
//计算数组内字体的宽度
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize textMaxSize = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
        CGSize textRealSize = [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize].size;
        
        NSNumber *width = [NSNumber numberWithFloat:textRealSize.width];
        [widths addObject:width];
    }
    
    return widths;
}


- (void)itemPressed:(UIButton *)button type:(int)type{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];
}
#pragma mark 偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    
    CGFloat offsetx = button.center.x - _nagationNavBar.frame.size.width * 0.5;
    
    CGFloat offsetMaxX = _nagationNavBar.contentSize.width - _nagationNavBar.frame.size.width;
    //offsetx topscrollview的偏移量
    //offsetMax topscrollview的最大偏移量
    //offsetx < 0 滚动距离的小于半屏时不动 大于半屏且小于最大偏移量时topscrollview滚动 大于最大偏移量时不动
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMaxX){
        offsetx = offsetMaxX;
    }
    CGPoint offset = CGPointMake(offsetx, _nagationNavBar.contentOffset.y);
    [_nagationNavBar setContentOffset:offset animated:YES];
    //下划线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 21, _line.frame.origin.y, 28, _line.frame.size.height);
    }];
}

- (void)updateData{
    
}
@end
