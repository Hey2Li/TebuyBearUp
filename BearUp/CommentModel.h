//
//  CommentModel.h
//  BearUp
//
//  Created by Tebuy on 2017/7/4.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
//agree = 2;
//content = "\U8fd9\U662f\U8bc4\U8bba";
//id = 1;
//nickname = "\U9e45\U9e45\U9e45\U9e45eeeeeeeee22";
//photo = "<null>";
//"show_type" = 1;
//time = 1494952668;
//uid = 1;
//vid = 2;
@property (nonatomic, copy) NSNumber *agree;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *ID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSNumber *show_type;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *uid;
@property (nonatomic, copy) NSNumber *vid;
@property (nonatomic, copy) NSNumber *com_type;
@end
