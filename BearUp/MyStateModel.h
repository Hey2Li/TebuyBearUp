//
//  MyStateModel.h
//  BearUp
//
//  Created by Tebuy on 2017/7/11.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyStateModel : NSObject
//agree = 0;
//collection = 1;
//content = "\U4f60\U6536\U85cf\U4e86\U6587\U7ae0";
//id = 7;
//nid = 1;
//photo = "http://bearup.51tht.cn/uploads/news/20170619/06dd86a7dc9844100480218402e969e1.jpg";
//stype = 3;
//time = 1499736928;
//title = "\U6587\U7ae0\U6807\U9898";
//type = 1;
//uid = 1;
@property (nonatomic, strong) NSNumber *agree;
@property (nonatomic, strong) NSNumber *collection;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *nid;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, strong) NSNumber *stype;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, copy) NSString *nickname;
@end
