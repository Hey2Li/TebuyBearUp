//
//  SXWeatherEntity.m
//  SXNews
//
//  Created by dongshangxian on 15/8/1.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "SXWeatherEntity.h"

@implementation SXWeatherEntity
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"detailArray":[SXWeatherDetailEntity class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"detailArray" : @"北京|北京"
             };
}

@end
