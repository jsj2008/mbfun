//
//  SActivityReceiveBatchInfoModel.h
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SActivityReceiveBatchInfoModel : NSObject

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *batcH_PIC_URL;
@property (nonatomic, strong) NSNumber *casH_COUPON_FLAG;
@property (nonatomic, strong) NSNumber *expecT_FLAG;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *locK_NUM;
@property (nonatomic, strong) NSNumber *maX_USE_NUM;
@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, strong) NSNumber *pubeD_NUM;
@property (nonatomic, strong) NSNumber *rulE_ID;
@property (nonatomic, strong) NSNumber *salE_AMOUNT;
@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, copy) NSString *batcH_CODE;
@property (nonatomic, copy) NSString *batcH_NAME;
@property (nonatomic, copy) NSString *coupoN_TYPE;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *senD_BEG_TIME;
@property (nonatomic, copy) NSString *senD_END_TIME;
@property (nonatomic, copy) NSString *valiD_BEG_TIME;
@property (nonatomic, copy) NSString *valiD_END_TIME;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
