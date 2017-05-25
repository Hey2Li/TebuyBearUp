//
//  Tool.m
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>


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
+ (NSDictionary *)MD5Dictionary{
    NSDate *date =[NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    //设置获取时间的格式
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString =[dateformatter stringFromDate:date];
    NSDictionary *dic = @{
                          @"app_key":@"201706",
                          @"sign_method":@"MD5",
                          @"timestamp":dateString
                          };
    //排序
    NSArray *keyArray = [dic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[dic objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *dicStr = [signArray componentsJoinedByString:@""];
    NSString *signStr = [NSString stringWithFormat:@"qLOWUGCzyn9vx6y8DSxEfgnPoheEDdGZ%@qLOWUGCzyn9vx6y8DSxEfgnPoheEDdGZ",dicStr];
    NSString *md5Str = [self MD5:signStr].uppercaseString;
    NSDictionary *params = @{@"app_key":@"201706",
                             @"sign":md5Str,
                             @"timestamp":dateString,
                             @"sign_method":@"MD5"};
    NSLog(@"signStr=%@,\nMD5=%@\n",signStr,md5Str);
    return params;
}

@end
