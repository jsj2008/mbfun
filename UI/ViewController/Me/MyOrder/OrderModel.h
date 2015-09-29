//
//  OrderModel.h
//  Wefafa
//
//  Created by fafatime on 15-1-28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 //优惠
 {
 "diS_AMOUNT" = "1.6666";
 "diS_TIME" = "/Date(1434279909817-0000)/";
 "ordeR_ID" = 88979;
 "promotioN_ID" = 1047;
 "promotioN_NAME" = "lll\U95ea\U8d2d\U6307\U5b9a\U642d\U914d\U6ee1\U4ef6";
 "useR_ID" = "843b93c1-5a30-4513-8a31-46f3767eaf35";
 }
 */
@interface OrderModelPromListInfo :NSObject

@property (nonatomic,strong)NSString *diS_AMOUNT;
@property (nonatomic,strong)NSString *diS_TIME;
@property (nonatomic,strong)NSString *ordeR_ID;
@property (nonatomic,strong)NSString *promotioN_ID;
@property (nonatomic,strong)NSString *promotioN_NAME;
@property (nonatomic,strong)NSString *useR_ID;

- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
/*
 {
 amount = "0.01";
 "diS_AMOUNT" = 0;
 price = "0.01";
 "proD_ID" = 42728;
 qty = 1;
 "returN_ID" = 10119;
 }
 */
@interface OrderModelProdListInfo :NSObject

@property (nonatomic,strong)NSString *diS_AMOUNT;
@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *proD_ID;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *refunD_ID;
@property (nonatomic,strong)NSString *qty;
@property (nonatomic,strong)NSString *prodName;

- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
/*
 {
 "apP_DATE" = "/Date(1434038400000+0800)/";
 code = UTH15061200010119;
 "creatE_DATE" = "/Date(1434108358157+0800)/";
 "creatE_USER" = MD00000497;
 id = 10119;
 "lasT_MODIFIED_DATE" = "/Date(1434108358157+0800)/";
 "lasT_MODIFIED_USER" = MD00000497;
 "ordeR_ID" = 88826;
 prodList =             (
 {
 amount = "0.01";
 "diS_AMOUNT" = 0;
 price = "0.01";
 "proD_ID" = 42728;
 qty = 1;
 "returN_ID" = 10119;
 }
 );
 reason = "\U989c\U8272\U4e0d\U6ee1\U610f";
 remark = "";
 "returN_AMOUNT" = "0.01";
 "returN_TYPE" = "OFF_LINE";
 state = "-1";
 stateName = "\U5df2\U53d6\U6d88";
 },

 */
@interface OrderModelReturnInfoListInfo: NSObject

@property (nonatomic,strong)NSString *apP_DATE;
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *creatE_DATE;
@property (nonatomic,strong)NSString *creatE_USER;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,strong)NSString *lasT_MODIFIED_DATE;
@property (nonatomic,strong)NSString *lasT_MODIFIED_USER;
@property (nonatomic,strong)NSString *ordeR_ID;
@property (nonatomic,strong)NSString *reason;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *returN_AMOUNT;
@property (nonatomic,strong)NSString *returN_TYPE;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *pricE_TOTAL;
@property (nonatomic,strong)NSString *oS_DATETIME;

@property (nonatomic,strong)NSString *stateName;
@property (nonatomic,strong)NSArray *prodList;//
@property (nonatomic,strong)NSString *statusName;



- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
/*
refundProdDtlList =             (
                                 {
                                     "diS_AMOUNT" = 0;
                                     fee = 0;
                                     "ordeR_ID" = 88826;
                                     price = "0.01";
                                     "proD_ID" = 42728;
                                     "refunD_AMOUNT" = "0.01";
                                     "refunD_ID" = 10215;
                                     "refunD_QTY" = 1;
                                 }
                                 );
*/
@interface OrderModelRefundProdDtlListInfo: NSObject

@property (nonatomic,strong)NSString *diS_AMOUNT;
@property (nonatomic,strong)NSString *fee;
@property (nonatomic,strong)NSString *ordeR_ID;
@property (nonatomic,strong)NSString *proD_ID;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *refunD_AMOUNT;
@property (nonatomic,strong)NSString *refunD_ID;
@property (nonatomic,strong)NSString *refunD_QTY;
@property (nonatomic,strong)NSString *prodName;

- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
/*
 {
 code = UTK15060900010215;
 "creatE_DATE" = "/Date(1433836196147+0800)/";
 "creatE_USER" = MD00000497;
 description = H;
 freight = 0;
 id = 10215;
 "lasT_MODIFIED_DATE" = "/Date(1433836196147+0800)/";
 "lasT_MODIFIED_USER" = MD00000497;
 "oS_DATETIME" = "/Date(-62135596800000-0000)/";
 "ordeR_ID" = 88826;
 "pricE_TOTAL" = 0;
 reason = "\U53d1\U8d27\U901f\U5ea6\U592a\U6162";
 "refunD_AMOUNT" = "0.01";
 refundProdDtlList =             (
 {
 "diS_AMOUNT" = 0;
 fee = 0;
 "ordeR_ID" = 88826;
 price = "0.01";
 "proD_ID" = 42728;
 "refunD_AMOUNT" = "0.01";
 "refunD_ID" = 10215;
 "refunD_QTY" = 1;
 }
 );
 status = "-1";
 statusName = "\U5df2\U53d6\U6d88";
 },
 */
@interface OrderModelRefundAppInfoListInfo: NSObject

@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *creatE_DATE;
@property (nonatomic,strong)NSString *creatE_USER;
@property (nonatomic,strong)NSString *descriptionStr;
@property (nonatomic,strong)NSString *freight;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *statusName;
@property (nonatomic,strong)NSString *lasT_MODIFIED_DATE;
@property (nonatomic,strong)NSString *lasT_MODIFIED_USER;
@property (nonatomic,strong)NSString *oS_DATETIME;
@property (nonatomic,strong)NSString *ordeR_ID;
@property (nonatomic,strong)NSString *pricE_TOTAL;
@property (nonatomic,strong)NSString *reason;
@property (nonatomic,strong)NSString *refunD_AMOUNT;

@property (nonatomic,strong)NSString *returN_TYPE;

@property (nonatomic,strong)NSArray *refundProdDtlList;//
//退货退款不一样
@property (nonatomic,copy)NSString *stateName;
@property (nonatomic,copy)NSString *state;

- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end

/*
 {
 "makE_AMOUNT" = "0.17";
 "paY_STATE" = 0;
 "paY_STATE_NAME" = "\U672a\U4ed8\U6b3e";
 "paY_TIME" = "/Date(1434369861337-0000)/";
 "paY_TYPE" = ZFB;
 payment = "ON_LINE";
 status = 0;
 statusName = "\U672a\U6210\U529f";
 }
 
 "create_time" = "2015-09-06 11:49:00";
 id = 400295;
 "order_id" = 405480;
 "pay_price" = "239.000000";
 "pay_type" = ZFB;
 payment = "ON_LINE";
 status = 0;
 }
 
 */
@interface OrderModelPaymentListInfo: NSObject

//@property (nonatomic,strong)NSString *makE_AMOUNT;
//@property (nonatomic,strong)NSString *paY_STATE;
//@property (nonatomic,strong)NSString *paY_STATE_NAME;
//@property (nonatomic,strong)NSString *paY_TYPE;
//@property (nonatomic,strong)NSString *payment;
//@property (nonatomic,strong)NSString *status;
//@property (nonatomic,strong)NSString *statusName;
//@property (nonatomic,strong)NSString *paY_TIME;


@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,strong)NSString *order_id;
@property (nonatomic,strong)NSString *pay_price;
@property (nonatomic,strong)NSString *pay_type;
@property (nonatomic,strong)NSString *payment;
@property (nonatomic,strong)NSString *status;

- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
/*
 {
 "doC_TYPE" = "LM_ORDER";
 "opeR_TIME" = "/Date(1434369861430+0800)/";
 "opeR_USER" = MD00031149;
 opinion = "\U65b0\U589e\U8ba2\U5355";
 remark = "\U65b0\U589e\U8ba2\U5355";
 }
 */
@interface OrderModelOperationInfo : NSObject

@property (nonatomic,strong)NSString *doC_TYPE;
@property (nonatomic,strong)NSString *opeR_TIME;
@property (nonatomic,strong)NSString *opeR_USER;
@property (nonatomic,strong)NSString *opinion;
@property (nonatomic,strong)NSString *remark;

- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
/*
 "branD_ID" = 1;
 "coloR_CODE" = 70;
 "coloR_FILE_PATH" = "http://img2.mixme.cn/sources/designer/ProdColor/ace6d3c8-d021-40e4-9e7a-e2987de1f030.jpg";
 "coloR_ID" = 10650;
 "coloR_NAME" = "\U7d2b\U8272\U7ec4";
 id = 42736;
 "inneR_CODE" = 6901549046440;
 "iteM_TYPE" = Z;
 "lM_PROD_CLS_ID" = 4191;
 "lisT_QTY" = 73;
 price = 169;
 "proD_CLS_NUM" = 223348;
 "proD_NAME" = "\U7537\U97e9\U5f0f\U65f6\U5c1a\U683c\U4ed4\U886c\U886b";
 "proD_NUM" = 22334870154;
 "salE_PRICE" = "0.01";
 "salE_QTY" = 60;
 "speC_CODE" = 22354;
 "speC_ID" = 14556;
 "speC_NAME" = "185/104B";
 status = 2;
 */
@interface OrderModelProductInfo : NSObject
@property (nonatomic,strong)NSString *branD_ID;
@property (nonatomic,strong)NSString *coloR_CODE;
@property (nonatomic,strong)NSString *coloR_FILE_PATH;
@property (nonatomic,strong)NSString *coloR_ID;
@property (nonatomic,strong)NSString *coloR_NAME;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,strong)NSString *inneR_CODE;
@property (nonatomic,strong)NSString *iteM_TYPE;
@property (nonatomic,strong)NSString *lisT_QTY;
@property (nonatomic,strong)NSString *lM_PROD_CLS_ID;
@property (nonatomic,strong)NSString *proD_CLS_NUM;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *proD_NUM;
@property (nonatomic,strong)NSString *proD_NAME;
@property (nonatomic,strong)NSString *salE_PRICE;
@property (nonatomic,strong)NSString *salE_QTY;
@property (nonatomic,strong)NSString *speC_ID;
@property (nonatomic,strong)NSString *speC_CODE;
@property (nonatomic,strong)NSString *speC_NAME;
@property (nonatomic,strong)NSString *status;



- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
/*
 Printing description of [0].value:
 {
 "acT_PRICE" = "0.01";
 amount = "0.16";
 bonus = 0;
 "collocatioN_ID" = 5649;
 designerId = "48dbc545-fa97-462f-ac00-6db8cb3d509a";
 designerName = "\U5728\U4e5f\U4e0d\U5728";
 "diS_AMOUNT" = 0;
 id = 109518;
 "judgE_STATUS" = 1;
 "ordeR_ID" = 89003;
 "originaL_QTY" = 16;
 "proD_ID" = 42736;
 qty = 16;
 "reapP_ID" = 0;
 "settlE_AMOUNT" = "0.16";
 "sharE_SELLER_ID" = "";
 state = 1;
 statename = "\U6b63\U5e38";
 "uniT_PRICE" = 169;
 */
@interface OrderModelDetailInfo : NSObject
@property (nonatomic,strong)NSString *acT_PRICE;
@property (nonatomic,strong)NSNumber *amount;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *bonus;
@property (nonatomic,strong)NSString *collocatioN_ID;
@property (nonatomic,strong)NSString *designerId;
@property (nonatomic,strong)NSString *designerName;
@property (nonatomic,strong)NSNumber *diS_AMOUNT;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,strong)NSString *judgE_STATUS;
@property (nonatomic,strong)NSString *ordeR_ID;
@property (nonatomic,strong)NSString *originaL_QTY;
@property (nonatomic,strong)NSString *proD_ID;
@property (nonatomic,strong)NSString *qty;
@property (nonatomic,strong)NSString *reapP_ID;
@property (nonatomic,strong)NSNumber *settlE_AMOUNT;
@property (nonatomic,strong)NSString *sharE_SELLER_ID;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *statename;
@property (nonatomic,strong)NSString *uniT_PRICE;

- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;
@end

@interface OrderModelProductListInfo : NSObject
@property (nonatomic,strong)OrderModelProductInfo *productInfo;
- (id)initWithInfo:(NSDictionary *)dict;
@end

@interface OrderModelDetailListInfo : NSObject
@property (nonatomic,strong)OrderModelDetailInfo *detailInfo;
@property (nonatomic,strong)OrderModelProductListInfo *proudctList;
- (id)initWithInfo:(NSDictionary *)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;
@end

@interface OrderModel : NSObject

@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *country;
@property (nonatomic,strong)NSString *county;
@property (nonatomic,strong)NSString *creatE_DATE;
@property (nonatomic,strong)NSString *creatE_USER;
@property (nonatomic,strong)NSString *diS_AMOUNT;
@property (nonatomic,strong)NSString *fee;
@property (nonatomic,strong)NSString *idStr;
@property (nonatomic,strong)NSString *invoicE_TITLE;
//@property (nonatomic,strong)NSString *judgE_STATUS;
@property (nonatomic,strong) NSString *judgeStatus;
@property (nonatomic,strong)NSString *lasT_MODIFIED_DATE;
@property (nonatomic,strong)NSString *lasT_MODIFIED_USER;
@property (nonatomic,strong)NSString *memo;
@property (nonatomic,strong)NSString *oS_ORDER_NO;
@property (nonatomic,strong)NSString *orderno;
@property (nonatomic,strong)NSString *orderTotalPrice;
@property (nonatomic,strong)NSString *paY_FEE;
@property (nonatomic,strong)NSString *posT_CODE;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *qty;
@property (nonatomic,strong)NSString *receiver;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *senD_REQUIRE;
@property (nonatomic,strong)NSString *shoP_CODE;
@property (nonatomic,strong)NSString *source;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *street;
@property (nonatomic,strong)NSString *statusName;
@property (nonatomic,strong)NSString *teL_PHONE;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSArray *detailList;
@property (nonatomic,strong)NSArray *operationInfoList;
@property (nonatomic,strong)NSArray *paymentList;
@property (nonatomic,strong)NSArray *refundAppInfoList;
@property (nonatomic,strong)NSArray *returnInfoList;
@property (nonatomic,strong)NSArray *promList;
@property (nonatomic,strong)NSArray *usedCouponList;
//退货退款
@property (nonatomic,strong)NSArray *refundProdDtlList;
@property (nonatomic,strong)NSArray *prodList;
@property (nonatomic,strong)NSString *bonus;
@property (nonatomic,strong)NSString *reason;
@property (nonatomic,strong)NSString *descriptionStr;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end


