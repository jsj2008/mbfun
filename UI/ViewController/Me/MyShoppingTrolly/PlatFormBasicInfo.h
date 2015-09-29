//
//  PlatFormBasicInfo.h
//  Wefafa
//
//  Created by Miaoz on 15/6/5.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
"platFormBasicInfo" :
 {
 "proD_SOURCE" : "Z",
 "creatE_USER" : "超级管理员",
 "status" : "1",
 "promotioN_RANGE" : "ALL",
 "code" : "BPP0000000803",
 "isVaild" : false,
 "promtionRangeDtlFilterLst" : [
 
 ],
 "usE_TYPE" : "COMMON",
 "piC_URL" : "",
 "creatE_DATE" : "/Date(1433412039487-0000)/",
 "lasT_MODIFY_DATE" : "/Date(1433412039487-0000)/",
 "enD_TIME" : "/Date(1435658211000-0000)/",
 "name" : "自营全场满件优惠",
 "coupoN_CONDITION" : "ALL",
 "beG_TIME" : "/Date(1433325408000-0000)/",
 "isUse" : false,
 "id" : 803,
 "maX_NUM" : 0,
 "comM_FLAG" : "0",
 "coupoN_FLAG" : "0",
 "condition" : "FULLPRODCLS",
 "maX_FLAG" : "0",
 "dis_Amount" : 0,
 "uP_FLAG" : "0",
 "lasT_MODIFY_USER" : "超级管理员",
 "promPlatComDtlFilterList" : [
 {
 "remark" : "",
 "commissioN_VALUE" : 30,
 "id" : 404,
 "colL_FLAG" : "0",
 "commissioN_TYPE" : "FIX",
 "standards" : 4,
 "isUse" : false,
 "name" : "test",
 "promotioN_FLAT_ID" : 803
 },
 {
 "remark" : "",
 "commissioN_VALUE" : 16,
 "id" : 403,
 "colL_FLAG" : "0",
 "commissioN_TYPE" : "FIX",
 "standards" : 3,
 "isUse" : false,
 "name" : "test",
 "promotioN_FLAT_ID" : 803
 },
 {
 "remark" : "",
 "commissioN_VALUE" : 10,
 "id" : 402,
 "colL_FLAG" : "0",
 "commissioN_TYPE" : "FIX",
 "standards" : 2,
 "isUse" : false,
 "name" : "test",
 "promotioN_FLAT_ID" : 803
 }
 ]
 },
 "prodLst" : [
 {
 "prodId" : 1064,
 "sale_Price" : 100,
 "collocation_Id" : 0,
 "prodClsCode" : "223191",
 "brandCode" : "MB",
 "diS_Price" : 0,
 "prodClsId" : 52,
 "qty" : 10
 },
 {
 "prodId" : 1065,
 "sale_Price" : 100,
 "collocation_Id" : 0,
 "prodClsCode" : "223191",
 "brandCode" : "MB",
 "diS_Price" : 0,
 "prodClsId" : 52,
 "qty" : 10
 }
 ]
 }
 */
#import "ProdInfo.h"
#import "PromPlatComDtlInfo.h"

//活动优惠
@interface PlatFormBasicInfo : NSObject
/*
@property(nonatomic,strong)NSString * proD_SOURCE;
@property(nonatomic,strong)NSString * creatE_USER;
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSString * promotioN_RANGE;
@property(nonatomic,strong)NSString * code;
@property(nonatomic,strong)NSString * isVaild;
@property(nonatomic,strong)NSString * usE_TYPE;
@property(nonatomic,strong)NSString * piC_URL;
@property(nonatomic,strong)NSString * creatE_DATE;
@property(nonatomic,strong)NSString * lasT_MODIFY_DATE;
@property(nonatomic,strong)NSString * enD_TIME;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * coupoN_CONDITION;
@property(nonatomic,strong)NSString * beG_TIME;
@property(nonatomic,strong)NSString * isUse;
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * maX_NUM;
@property(nonatomic,strong)NSString * comM_FLAG;
@property(nonatomic,strong)NSString * coupoN_FLAG;
@property(nonatomic,strong)NSString * condition;
@property(nonatomic,strong)NSString * maX_FLAG;
@property(nonatomic,strong)NSString * dis_Amount;
@property(nonatomic,strong)NSString * uP_FLAG;
@property(nonatomic,strong)NSString * lasT_MODIFY_USER;
@property(nonatomic,strong)NSString * usE_COUPON_FLAG;//判断是否能范票
@property(nonatomic,strong)NSMutableArray *promPlatComDtlFilterList;
@property(nonatomic,strong)NSMutableArray *prodLst;
*/
@property(nonatomic,copy)NSString * code;
@property(nonatomic,copy)NSString * dec_price;
@property(nonatomic,copy)NSString * dec_trans_price;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * totalPrice;
@property(nonatomic,copy)NSString * trans_price;
@property (nonatomic,copy)NSString *web_url;
@property (nonatomic,copy)NSString *activityName;

//@property(nonatomic,strong)NSMutableArray *promPlatComDtlFilterList;
@property(nonatomic,strong)NSArray *productList;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(NSArray *)modelDataArrayWithArray:(NSArray *)dataArray;

@end

@interface ProductListModel : NSObject

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

-(id)initWithDictionary:(NSDictionary *)dic;

+(NSArray *)modelDataWithArray:(NSArray *)dataArray;

@end
/* 购物袋header进入
 {
 "can_use" = 0;
 "end_time" = "2016-08-31 22:48:22";
 id = 1;
 img = "http://img1.imgtn.bdimg.com/it/u=2717347867,1358796114&fm=21&gp=0.jpg";
 json = 1;
 name = "\U6ee1200\U625375\U6298";
 "start_time" = "2015-08-24 22:48:20";
 "tag_img" = "\U6ee1200\U625375\U6298";
 "trigger_type" = "<null>";
 type = 1;
 }
 */

@interface ActivityOrderModel : NSObject
@property(nonatomic,copy)NSString * can_use;
@property(nonatomic,copy)NSString * end_time;
@property(nonatomic,copy)NSString * idStr;
@property(nonatomic,copy)NSString * img;
@property(nonatomic,copy)NSString * json;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * start_time;
@property(nonatomic,copy)NSString * tag_img;
@property(nonatomic,copy)NSString * trigger_type;
@property(nonatomic,copy)NSString * type;

-(id)initWithDictionary:(NSDictionary *)dic;

+(NSArray *)modelDataWithArray:(NSArray *)dataArray;

@end
