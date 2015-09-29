//
//  SCollocationSubProductMode.h
//  Wefafa
//
//  Created by Mr_J on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCollocationSubProductInfoModel;

@interface SCollocationSubProductModel : NSObject

@property (nonatomic, strong) NSNumber *cate_id;
@property (nonatomic, strong) NSNumber *color_code;
@property (nonatomic, strong) NSNumber *is_delete;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *market_price;
@property (nonatomic, copy) NSString *brand_code;
@property (nonatomic, copy) NSString *brand_value;
@property (nonatomic, copy) NSString *cate_value;
@property (nonatomic, copy) NSString *color_value;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *product_code;
@property (nonatomic, copy) NSString *product_img;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isShowSelected;

@property (nonatomic, strong) SCollocationSubProductInfoModel *product;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end

@interface SCollocationSubProductInfoModel : NSObject

@property (nonatomic, copy) NSString *brandUrl;
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *market_price;
@property (nonatomic, copy) NSString *on_sale_date;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *product_sys_code;
@property (nonatomic, copy) NSString *product_url;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stock_num;
@property (nonatomic, strong) NSMutableArray *prodClsTag;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
