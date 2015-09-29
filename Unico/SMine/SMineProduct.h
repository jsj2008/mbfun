//
//  SMineProduct.h
//  Wefafa
//
//  Created by Jiang on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMineProduct : NSObject
/*
 "brand_code" = 4M;
 "brand_value" = 4M;
 "cate_id" = 3;
 "cate_value" = "\U7537\U88c5";
 "color_code" = 04;
 "color_value" = "\U6a59\U8272\U7cfb";
 "create_time" = "2015-09-01 22:17:49";
 id = 10;
 "is_delete" = 0;
 "product_code" = "";
 "product_img" = "http://metersbonwe.qiniucdn.com/FoinwfZnTjDn7TpMBCci5bK86rdW";
 "user_id" = "99c23812-4814-466e-b9ad-054b1c2262ef";

 */
@property (nonatomic, copy) NSString *brand_code;
@property (nonatomic, copy) NSString *brand_value;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *cate_value;
@property (nonatomic, copy) NSString *color_code;
@property (nonatomic, copy) NSString *color_value;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *product_code;
@property (nonatomic, copy) NSString *product_img;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) float price;


//+ (id)productWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)productArrForDataArray:(NSArray *)dataArray;

@end
