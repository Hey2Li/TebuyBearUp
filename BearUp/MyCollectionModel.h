//
//  MyCollectionModel.h
//  BearUp
//
//  Created by Tebuy on 2017/7/11.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollectionModel : NSObject
//agree = 0;
//collection = 1;
//id = 23;
//nid = 10;
//photo = "http://bearup.51tht.cn/uploads/news/20170620/0dc2c16f525a3575ff7666f24e029e3d.png";
//time = 1499737070;
//title = "\U5168\U56fd338\U4e2a\U57ce\U5e02\U6c34\U73af\U5883\U8d28\U91cf\U5c06\U6709\U6392\U884c\U699c \U6bcf\U5e74\U516c\U5e034\U6b21";
//type = 1;
//uid = 1;
@property (nonatomic, strong) NSNumber *agree;
@property (nonatomic, strong) NSNumber *collection;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *nid;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *uid;
@end
