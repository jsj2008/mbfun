//
//  OrderActivityProductListModel.h
//  Wefafa
//
//  Created by metesbonweios on 15/9/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderActivityProductListModel : NSObject
@property(nonatomic,copy)NSString * activity_dec_price;
@property(nonatomic,copy)NSString * activity_info;
@property(nonatomic,copy)NSString * activity_name;
@property(nonatomic,copy)NSString * aid;
@property(nonatomic,copy)NSString * barcode_sys_code;
@property(nonatomic,copy)NSString * caps_num;
@property(nonatomic,copy)NSString * cid;
@property(nonatomic,copy)NSString * dec_price;
@property(nonatomic,copy)NSString * is_vouchers;
@property(nonatomic,copy)NSString * market_price;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * part_num;
@property(nonatomic,copy)NSString * product_sys_code;
@property(nonatomic,copy)NSString * spec_price;
@property(nonatomic,copy)NSString * total_price;
@property(nonatomic,copy)NSString * use_activity;
@property(nonatomic,copy)NSString * user_num;
@property (nonatomic,copy)NSString *web_url;

-(id)initWithDictionary:(NSDictionary *)dic;

+(NSArray *)modelDataWithArray:(NSArray *)dataArray;
@end
