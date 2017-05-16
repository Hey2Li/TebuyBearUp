//
//  Tool.m
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "Tool.h"

@implementation Tool
void SVProgressShow(){
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
}
void SVProgressShowText(NSString* text){
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:text];
}
void SVProgressShowStuteText(NSString* text,BOOL isSucceed){
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setFadeOutAnimationDuration:.2];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    if (isSucceed) {
        [SVProgressHUD showSuccessWithStatus:text];
    }else{
        [SVProgressHUD showErrorWithStatus:text];
    }
}
void SVProgressHiden(){
    [SVProgressHUD dismiss];
}
NSAttributedString *returnNumAttr(NSString *str,NSInteger fontSize){
    NSString *pattern = @"[0-9]{0,}";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    [regex enumerateMatchesInString:str options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        NSRange bindlingRange = NSMakeRange(range.location, range.length);
        [attrStr addAttribute:NSForegroundColorAttributeName value:SUBJECT_COLOR range:bindlingRange];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:bindlingRange];
        
    }];
    return attrStr;
}
 
@end
