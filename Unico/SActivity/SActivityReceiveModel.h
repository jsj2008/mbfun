//
//  SActivityReceiveModel.h
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SActivityReceiveBatchModel.h"

@class SActivityReceivePromoInfoModel;

@interface SActivityReceiveModel : NSObject

@property (nonatomic, strong) NSNumber *bonuS_MAX_NUM;
@property (nonatomic, strong) NSNumber *coupoN_BATCH_ID;
@property (nonatomic, strong) NSNumber *isGet;
@property (nonatomic, strong) NSNumber *promotioN_ACT_ID;
@property (nonatomic, strong) NSNumber *pubeD_NUM;


//新model领取饭票 model
@property (nonatomic,strong)NSString *end_time;
@property (nonatomic,strong)NSString *img;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,strong)NSString *json;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *start_time;
@property (nonatomic,strong)NSString *tag_img;
@property (nonatomic,strong)NSString *type;
@property (nonatomic, copy) NSString *web_url;
@property (nonatomic, strong)NSArray *vouchersList;

//品牌商品进入model
@property (nonatomic,strong) NSArray *productList;



@property (nonatomic, strong) NSArray *batchInfoList;
@property (nonatomic, strong) SActivityReceivePromoInfoModel *promoInfo;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end

@interface SActivityReceivePromoInfoModel : NSObject

@property (nonatomic, strong) NSNumber *aID;

@property (nonatomic, copy) NSString *beG_TIME;
@property (nonatomic, copy) NSString *enD_TIME;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *piC_URL;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
/*
 {
 id = 1;
 info = "\U6d4b\U8bd5\U996d\U7968";
 isGet = 1;
 "left_num" = 986;
 name = "\U6307\U5b9a\U5546\U54c1\U996d\U7968";
 "part_num" = 0;
 "right_num" = 9014;
 "total_num" = 10000;
 "trigger_type" = 1;
 "use_end_time" = "2015-08-31 14:51:36";
 "use_start_time" = "2015-08-19 14:51:33";
 "user_num" = 3;
 vouchers = PT001;
 },
 */
@interface SActivityVouchersListModel : NSObject
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, strong) NSNumber *isGet;//是否已领取
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *left_num;//剩余票
@property (nonatomic, strong) NSNumber *right_num;//已领取
@property (nonatomic, strong) NSNumber *total_num;//总
@property (nonatomic, strong) NSString *trigger_type;//票的类型
@property (nonatomic, copy) NSString *use_end_time;
@property (nonatomic, copy) NSString *use_start_time;
@property (nonatomic,strong) NSNumber *user_num;//当前用户可领取多数量
@property (nonatomic, copy) NSString  *vouchers;//饭票批次
@property (nonatomic,strong) NSNumber *part_num;//当前用户已领取多少张
@property (nonatomic,strong) NSNumber *isEndActivity;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;
@end
/*
 productList =             (
 {
 "market_price" = "49.000000";
 "product_name" = "\U7537\U51c0\U8272V\U9886\U77ed\U8896\U6064";
 "product_sys_code" = 110205;
 "product_url" = "http://img6.ibanggo.com/sources/images/goods/MB/110205/110205_00.jpg";
 "spec_price_list" =                     (
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000",
 "49.000000"
 );
 },

 */

@interface SActivityProductListModel : NSObject
@property (nonatomic,copy)NSString *market_price;
@property (nonatomic,copy)NSString *product_name;
@property (nonatomic,copy)NSString *product_sys_code;
@property (nonatomic,copy)NSString *product_url;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *statusname;
@property (nonatomic, copy) NSString *price;


@property (nonatomic,copy)NSString *stock_num;

@property (nonatomic,strong)NSArray *spec_price_list;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;
@end
