//
//  LTHttpManager.m
//  TwMall
//
//  Created by TaiHuiTao on 16/6/15.
//  Copyright © 2016年 TaiHuiTao. All rights reserved.
//

#import "LTHttpManager.h"
#import <MJExtension.h>

@implementation LTHttpManager

+ (void)testHttpPost:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    [manager POSTWithParameters:[NSString stringWithFormat:@"https://dopen.weimob.com/api/1_0/wangpu/CategoryAttribute/Get?accesstoken=ACCESS_TOKEN"] parameters:nil complete:complete];
}

+ (void)PostMemberLoginMobilePhone:(NSString *)mobilephone Password:(NSString *)password :(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *datas = @{@"mobile_phone":@"18862988023",
                            @"password":@"123456"};
    NSDictionary *parameters = @{@"datas":[datas mj_JSONString]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/member/login",BURL] parameters:parameters complete:complete];
}
/**
 *  爱萌货首页banner
 *
 *  @param complete 回调block
 */
+ (void)GetBanners:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    [manager GETWithParameters:[NSString stringWithFormat:@"http://api.maimenghuo.com/v2/banners"] parameters:nil complete:complete];
}
/**
 *  首页cell数据
 *
 *  @param complete 
 */
+ (void)GetHomePageCellDataPageCount:(NSString*)pagecount :(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    [manager GETWithParameters:[NSString stringWithFormat:@"http://api.maimenghuo.com/v2/posts?limit=10&offset=%@",pagecount] parameters:nil complete:complete];
}
/**
 *  http://api.maimenghuo.com/v2/secondary_banners
 */

+ (void)GetSecondBanners:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    [manager GETWithParameters:[NSString stringWithFormat:@"http://api.maimenghuo.com/v2/secondary_banners"] parameters:nil complete:complete];

}
+ (void)testApi:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    [manager POSTWithParameters:[NSString stringWithFormat:@"http://bearup.51tht.cn/api"] parameters:[Tool MD5Dictionary] complete:complete];
}

@end
