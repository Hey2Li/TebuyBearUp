//
//  FocusModel.h
//  BearUp
//
//  Created by Tebuy on 2017/7/11.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FocusModel : NSObject
//cid = 8;
//id = 4;
//name = "\U539f\U521b";
//photo = "http://bearup.51tht.cn/uploads/columnimg/20170620/98d7103f5947f93d1eeb8bb104cf475e.png";
//time = 1499737613;
//type = 1;
//uid = 1;
@property (nonatomic, strong) NSNumber *cid;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, strong) NSNumber *uid;
@end
