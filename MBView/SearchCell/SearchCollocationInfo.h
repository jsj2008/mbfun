//
//  SearchCollocationInfo.h
//  Wefafa
//
//  Created by su on 15/2/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCollocationInfo : NSObject
@property(nonatomic)NSInteger amount;
@property(nonatomic)NSInteger code;
@property(nonatomic)NSInteger commentCount;
@property(nonatomic,strong)NSString *creatE_DATE;
@property(nonatomic,strong)NSString *creatE_USER;
@property(nonatomic,strong)NSString *descriptionStr;
@property(nonatomic)NSInteger favoriteCount;
@property(nonatomic)NSInteger idNum;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *pictureUrl;
@property(nonatomic,strong)NSString *thrumbnailUrl;
@property(nonatomic)NSInteger sharedCount;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSDictionary *resultDict;
@property(nonatomic,strong)NSString *headPortrait;



- (id)initWithObject:(NSDictionary *)dict;
@end
/*
 amount = 158;
 code = 10001274;
 commentCount = 0;
 "creatE_DATE" = "/Date(1422507724125+0800)/";
 "creatE_USER" = "\U6635\U79f0\U540c\U6b65";
 description = "iPhone\U53d1\U5e03\U642d\U914d";
 favoriteCount = 0;
 id = 1274;
 name = sd;
 pictureUrl = "http://img.51mb.com:5659/sources/designer/Collocation/20150129/1422507724.png";
 sharedCount = 0;
 thrumbnailUrl = "http://img.51mb.com:5659/sources/designer/Collocation/20150129/1422507724.png";
 userId = "645c0feb-40f0-4a5b-a8c2-27b2cdf40219";

 */