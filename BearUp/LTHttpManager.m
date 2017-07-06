//
//  LTHttpManager.m
//  TwMall
//
//  Created by TaiHuiTao on 16/6/15.
//  Copyright © 2016年 TaiHuiTao. All rights reserved.
//

#import "LTHttpManager.h"
#import <MJExtension.h>
#import "LoginViewController.h"

@implementation LTHttpManager

/**
 注册帐号
 请求地址:api/register/index
 请求方式:POST
 
 @param mobile 手机号码
 @param password 密码
 @param complete block回调
 */

+ (void)registerWithMobile:(NSString *)mobile andPassword:(NSString *)password andUUID:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",password,@"password",user_uuid,@"user_uuid", nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/register/index",BaseURL] parameters:paramters complete:complete];
}

/**
 发送验证码
 请求地址:api/register/sendmsg
 
 @param mobile 手机号码
 @param complete block
 */
+ (void)registerSendCodeWithMobile:(NSString *)mobile Type:(NSNumber *)type Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                      type,@"type",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/register/sendmsg",BaseURL] parameters:paramters complete:complete];

}

/**
 帐号登录
 请求地址:api/login/index
 请求方式:POST
 
 @param mobile 手机号码
 @param password  密码
 @param complete  block回调
 */
+ (void)loginWithMobile:(NSString *)mobile andPassword:(NSString *) password andUUID:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",password,@"password",user_uuid,@"user_uuid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/login/index",BaseURL] parameters:paramters complete:complete];
}

/**
 提交新密码
 请求地址:api/register/checkcode
 
 @param mobile 手机号码
 @param code 验证码
 @param password 密码
 */
+ (void)submitNewPasswordWithMobile:(NSString *)mobile Code:(NSString *)code Password:(NSString *)password Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                     code,@"code",
                                     password,@"password",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/register/checkcode",BaseURL] parameters:paramters complete:complete];
}


/**
 请求地址:api/index
 请求方式:POST
 功能描述：首页头部栏目
 
 @param limit 查询数量 要返回几个栏目
 @param value 查询字段 格式如：id,name 
 @param page 数据分页
 @param nlimit 推荐内容查询数量 初始显示数量
 @param complete block
 */
+ (void)homeTitleWithLimit:(NSNumber *)limit Value:(NSString *)value  Page:(NSString *)page Nlimit:(NSString *)nlimit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",
                                      value,@"value",
                                      page,@"page",
                                      nlimit,@"nlimit",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/index",BaseURL] parameters:paramters complete:complete];
}


/**
 请求地址:api/news/index
 请求方式:POST
 功能描述：获得文章列表
 
 
 @param limit 要返回几个栏目
 @param value 格式如：id,name
 @param complete block
 */
+ (void)newsListWithLimit:(NSNumber *)limit Value:(NSString *)value Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",
                                      value,@"value",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/index",BaseURL] parameters:paramters complete:complete];
}

/**
 下滑获取下一页数据
 请求地址:api/index/nextpage
 请求方式:POST
 
 
 @param page 数据分页
 @param limit 查询文章数量
 @param complete block
 */
+ (void)newListNextPageWithPage:(NSNumber *)page Limit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",
                                      limit,@"limit",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/index/nextpage",BaseURL] parameters:paramters complete:complete];

}

/**
 首页推荐滑动获取更多：api/index/getmore
 
 @param page 数据分页
 @param limit 查询文章数量
 @param complete block
 */
+ (void)recommendGetMoreWithPage:(NSNumber *)page Limit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",
                                      limit,@"limit",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/index/getmore",BaseURL] parameters:paramters complete:complete];

}

/**
 请求地址:api/news/show
 请求方式:POST
 功能描述：获得文章内容、评论
 
 
 @param ID 文章id
 @param value 查询字段
 @param complete block
 */
+ (void)newsDetailWithId:(NSNumber *)ID Value:(NSString *)value Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      value,@"value",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/show",BaseURL] parameters:paramters complete:complete];
}


/**
 请求地址:api/news/savecomment
 请求方式:POST
 
 @param ID 文章id
 @param content 评论内容
 @param complete block
 */
+ (void)commentNewsWithId:(NSNumber *)ID Content:(NSString *)content Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                          content,@"content",
                                          USER_ID,@"user_id",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/savecomment",BaseURL] parameters:paramters complete:complete];
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
        LoginViewController *lvc = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:lvc];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
    }
}


/**
 请求地址:api/video/index
 请求方式:POST
 功能描述：获得视频列表
 
 
 @param limit 查询数量
 @param value 查询字段
 @param complete complete
 */
+ (void)videoListWithLimit:(NSNumber *)limit Value:(NSString *)value Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",
                                      value,@"value",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/index",BaseURL] parameters:paramters complete:complete];
}


/**
 请求地址:api/video/show
 请求方式:POST
 功能描述：获得视频内容、评论
 
 
 @param ID 文章id
 @param complete block
 */
+ (void)videoDetailWithId:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                    nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/show",BaseURL] parameters:paramters complete:complete];

}


/**
 请求地址:api/news/savecomment
 请求方式:POST
 
 
 @param ID 文章id
 @param content 评论内容
 @param complete block
 */
/*
+ (void)commentViewWithId:(NSNumber *)ID Content:(NSString *)content Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      content,@"content",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/savecomment",BaseURL] parameters:paramters complete:complete];
}
*/

/**
 个人中心主页
 请求地址:api/user/index
 请求方式:POST
 
 
 @param complete block
 */
+ (void)userInfoComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionary];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/index",BaseURL] parameters:paramters complete:complete];
}


/**
 系统消息
 请求地址:api/user/syslist
 请求方式:POST
 功能描述：系统消息列表
 
 
 @param limit 查询数量
 @param complete block
 */
+ (void)sysMessageListWithLimit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",
                                    nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/syslist",BaseURL] parameters:paramters complete:complete];
}


/**
 系统消息详情
 请求地址:api/user/sysinfo
 请求方式:POST
 
 
 @param ID 消息id
 @param complete block
 */
+ (void)sysMessageInfoWithId:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/sysinfo",BaseURL] parameters:paramters complete:complete];
}


/**
 保存用户意见
 请求地址:api/user/saveopinion
 请求方式:POST
 
 
 @param mobile 手机号
 @param content 建议内容
 @param complete block
 */
+ (void)saveUserOpinionWithMobile:(NSNumber *)mobile Content:(NSString *)content Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                      content,@"content",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/saveopinion",BaseURL] parameters:paramters complete:complete];
}


/**
 用户订阅管理
 请求地址:api/user/subscrip
 请求方式:POST
 
 
 @param complete block
 */
+ (void)userSubscripComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionary];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/subscrip",BaseURL] parameters:paramters complete:complete];
}



/**
 商品列表
 请求地址:api/user/commodity
 请求方式:POST
 
 
 @param complete block
 */
+ (void)userCommodityComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionary];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/commodity",BaseURL] parameters:paramters complete:complete];
}


/**
 商品详情
 请求地址:api/user/comminfo
 请求方式:POST
 
 
 @param ID 商品id
 @param complete block
 */
+ (void)usercommInfoWithId:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/comminfo",BaseURL] parameters:paramters complete:complete];
}


/**
 换商品
 请求地址:api/user/buycommodity
 请求方式:POST
 
 
 @param ID 商品id
 @param num 兑换数量
 @param recipient 收件人
 @param mobile 收件人电话
 @param city 省市
 @param address 详细地址
 @param complete block
 */
+ (void)buyCommodityWithId:(NSNumber *)ID Num:(NSNumber *)num Recipient:(NSString *)recipient Mobile:(NSNumber *)mobile City:(NSString *)city Address:(NSString *)address Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      num,@"num",
                                      recipient,@"recipient",
                                      mobile,@"mobile",
                                      city,@"city",
                                      address,@"address",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/buycommodity",BaseURL] parameters:paramters complete:complete];
}


/**
 获得评论
 请求地址:api/user/getcmment
 请求方式:POST
 
 
 @param type 类型
 @param page 页数
 @param complete block
 */
+ (void)getCommentWithType:(NSNumber *)type Page:(NSNumber *)page Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type",
                                     page,@"page",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/getcmment",BaseURL] parameters:paramters complete:complete];

}

/**
 发现首页api/explore/index
 
 @param complete block
 */
+ (void)foundIndexComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionary];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/index",BaseURL] parameters:paramters complete:complete];
}

/**
 排行榜
 请求地址:api/explore/toplist
 
 @param type 0-总榜；1-文章榜；2-视频榜
 @param limit 每次查询的排行数量
 @param complete block
 */
+ (void)topListWithType:(NSString *)type Limit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type", limit,@"limit",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/toplist",BaseURL] parameters:paramters complete:complete];
}

/**
 热门分类
 请求地址:api/explore/hotcolumn
 
 
 @param limit 每次查询的排行数量
 @param complete block
 */
+ (void)hotCategoryWithLimit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/hotcolumn",BaseURL] parameters:paramters complete:complete];
}


/**
 分类详情
 请求地址:api/explore/getcolumn
 
 @param limit 每次查询的排行数量
 @param ID 分类id
 @param complete block
 */
+ (void)categoryDetailWithLimit:(NSNumber *)limit ID:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",ID,@"id",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/getcolumn",BaseURL] parameters:paramters complete:complete];
}


/**
 关注类别
 请求地址:api/explore/attention
 
 @param cid 分类id
 @param complete block
 */
+ (void)focusCategoryWithCid:(NSNumber *)cid Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: cid,@"cid",USER_ID,@"user_id",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/attention",BaseURL] parameters:paramters complete:complete];
    }else{
         UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
        LoginViewController *lvc = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:lvc];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
    }
}

/**
 详情页评论分页
 请求地址:api/news/getMore
 功能描述：获得文章更多评论
 
 
 @param ID 文章id
 @param page 分页 初始值为2
 @param complete complete
 */
+ (void)getMoreNewsCommentWithID:(NSNumber *)ID Page:(NSNumber *)page Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: ID,@"id",page,@"page",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/getMore",BaseURL] parameters:paramters complete:complete];

}


/**
 获得更多文章
 请求地址:api/news/getnews
 功能描述：获得更多文章
 
 
 @param limit 查询数量
 @param page 分页
 @param cid 文章类别
 @param complete block
 */
+ (void)getMoreNewsWithLimit:(NSNumber *)limit Page:(NSNumber *)page Cid:(NSNumber *)cid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",page,@"page",cid,@"cid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/getnews",BaseURL] parameters:paramters complete:complete];

}


/**
 详情页评论分页
 请求地址:api/video/getMore
 功能描述：获得视频更多评论
 
 
 @param ID 视频id
 @param page 分页 初始值为2
 @param complete blcok
 */
+ (void)getMoreVideoCommentWithId:(NSNumber *) ID Page:(NSNumber *)page Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: ID,@"id",page,@"page",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/getMore",BaseURL] parameters:paramters complete:complete];
}


/**
 获得更多视频
 请求地址:api/video/getvideo
 功能描述：获得更多视频
 
 
 @param limit 查询数量
 @param page 分页
 @param cid 视频类别
 @param complete block
 */
+ (void)getMoreVideoWithLimit:(NSNumber *)limit Page:(NSNumber *)page Cid:(NSNumber *)cid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",page,@"page",cid,@"cid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/getvideo",BaseURL] parameters:paramters complete:complete];
}
@end
