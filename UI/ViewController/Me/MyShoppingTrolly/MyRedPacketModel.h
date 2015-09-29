//
//  MyRedPacketModel.h
//  Wefafa
//
//  Created by metesbonweios on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRedPacketModel : NSObject
//范票
//@property (nonatomic,strong) NSString *idValue;//用户优惠券id
//@property (nonatomic,strong) NSString *channeL_NAME; //发放渠道名称
//@property (nonatomic,strong) NSString *coupoN_AMOUNT;//优惠券面额
//@property (nonatomic,strong) NSString *coupoN_CODE;//优惠券编码
//@property (nonatomic,strong) NSString *coupoN_NAME;//优惠券名称
//@property (nonatomic,strong) NSString *coupoN_TYPE;//优惠券类型
//@property (nonatomic,strong) NSString *descriptionStr;// 描述
//@property (nonatomic,strong) NSString *picturE_URL;//图片地址
//@property (nonatomic,strong) NSString *salE_AMOUNT;//优惠券最低限额
//@property (nonatomic,strong) NSString *status;    //状态
//@property (nonatomic,strong) NSString *statusname; //状态名称
//@property (nonatomic,strong) NSString *valiD_END_TIME; //有效期结束时间
//@property (nonatomic,strong) NSString *valiD_BEG_TIME; //有效期开始时间
//@property (nonatomic,strong) NSString *usE_RULE_STATUS;
//@property (nonatomic,strong) NSString *usE_RULE; //状态


@property (nonatomic,strong) NSString *coupon_code;//优惠券编码
@property (nonatomic,strong) NSString *coupon_name;//优惠券名称
@property (nonatomic,strong) NSString *info;// 描述
@property (nonatomic,strong) NSString *status;    //状态
@property (nonatomic,strong) NSString *statusname; //状态名称
@property (nonatomic,strong) NSString *valid_end_time; //有效期结束时间
@property (nonatomic,strong) NSString *valid_beg_time; //有效期开始时间
@property (nonatomic,strong) NSString *usE_RULE_STATUS;
@property (nonatomic,strong) NSString *use_rule; //状态
@property (nonatomic,strong) NSString *param_json;
@property (nonatomic,strong) NSString *prefer_type;
@property (nonatomic,strong) NSString *rules_param;
@property (nonatomic,strong) NSString *type_info;




//订单请求
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *end_time;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *start_time;
@property (nonatomic,copy) NSString *trigger_type;
@property (nonatomic,copy) NSString *vouchers;


////订单请求
//@property (nonatomic,strong) NSString *accepT_TIME;
//@property (nonatomic,strong) NSString *coupoN_BATCH_ID;  //优惠券批次id
//@property (nonatomic,strong) NSString *channeL_TYPE;
//@property (nonatomic,strong) NSString *channeL_CODE;
//@property (nonatomic,strong) NSString *coupoN_CHANNEL_ID;  //优惠券渠道id
//@property (nonatomic,strong) NSString *coupoN_ID;
//@property (nonatomic,strong) NSString *creatE_DATE;
//@property (nonatomic,strong) NSString *creatE_USER;
//@property (nonatomic,strong) NSString *lasT_MODIFIED_DATE;
//@property (nonatomic,strong) NSString *lasT_MODIFIED_USER;
//@property (nonatomic,strong) NSString *casH_COUPON_FLAG;
////订单
//@property (nonatomic,strong) NSString *coupoN_RULE_RANGE;
//@property (nonatomic,strong) NSString *coupoN_AMOUNT_Real;

- (instancetype)initWitDictionary:(NSDictionary*)dic;

+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
