//
//  LTHttpManager.h
//  TwMall
//
//  Created by TaiHuiTao on 16/6/15.
//  Copyright © 2016年 TaiHuiTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTHTTPSessionManager.h"

#define BURL @"http:192.168.1.29:5566"
@interface LTHttpManager : NSObject

+ (void)testHttpPost:(completeBlock)complete;

//+ (void)GetTestRequest:(completeBlock)complete;

/**
 *  登录
 *
 *  @param mobilephone 手机号码
 *  @param password    密码
 *  @param complete    回调block
 */
+ (void)PostMemberLoginMobilePhone:(NSString*)mobilephone
                      Password:(NSString *)password
                              :(completeBlock)complete;

/**
 *  首页banner图/爱萌货API
 *  http://api.maimenghuo.com/v2/banners
 */
+ (void)GetBanners:(completeBlock)complete;

/**
 *  首页cell数据/卖萌货API
 *
 */
+ (void)GetHomePageCellDataPageCount:(NSString *)pagecount
                                    :(completeBlock)complete;

/**
 *  首页分类
 */
+ (void)GetSecondBanners:(completeBlock)complete;

//http://bearup.51tht.cn/api

+ (void)testApi:(completeBlock)complete;


/**
 用户注册//http://bearup.51tht.cn/api/register

 @param mobile 手机号码
 @param password 密码
 @param complete block回调
 */
+ (void)registerWithMobile:(NSString *)mobile andPassword:(NSString *)password Complete:(completeBlock)complete;


/**
 用户登录//http://bearup.51tht.cn/api/login

 @param mobile 手机号码
 @param password  密码
 @param complete  block回调
 */
+ (void)loginWithMobile:(NSString *)mobile andPassword:(NSString *) password Complete:(completeBlock)complete;
@end
