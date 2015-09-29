//
//  SMBNewActivityListModel.h
//  Wefafa
//
//  Created by metesbonweios on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//
/*
 {
 "end_time" = "2016-08-27 22:49:42";
 id = 2;
    "web_url" : "",
 img = "http://10.100.22.213/sources/designer/PromotionPlatform/39250207-f5c1-4f99-a818-f1334f2326e8.jpg";
 json = "[1,2,3]";
 name = 22;
 "start_time" = "2015-08-24 22:49:40";
 "tag_img" = "";
 type = 2;
 },
 */
#import <Foundation/Foundation.h>

@interface SMBNewActivityListModel : NSObject

@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *json;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tag_img;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *web_url;//购物袋里 跳转到web页面

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;
@end
