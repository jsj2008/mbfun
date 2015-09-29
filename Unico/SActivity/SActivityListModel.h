//
//  SActivityListModel.h
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SActivityPromPlatModel.h"
#import "SActivityPromtionRangeModel.h"
#import "MBGoodsDetailListModel.h"
#import "MBGoodsDetailsModel.h"

@interface SActivityListModel : NSObject

@property (nonatomic, strong) NSNumber *coupoN_FLAG;
@property (nonatomic, strong) NSNumber *dis_Amount;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *isUse;
@property (nonatomic, strong) NSNumber *isVaild;
@property (nonatomic, strong) NSNumber *maX_NUM;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *uP_FLAG;

@property (nonatomic, copy) NSString *promotioN_RANGE;
@property (nonatomic, copy) NSString *beG_TIME;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *coupoN_CONDITION;
@property (nonatomic, copy) NSString *creatE_DATE;
@property (nonatomic, copy) NSString *creatE_USER;
@property (nonatomic, copy) NSString *enD_TIME;
@property (nonatomic, copy) NSString *lasT_MODIFY_DATE;
@property (nonatomic, copy) NSString *lasT_MODIFY_USER;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *piC_URL;
@property (nonatomic, copy) NSString *usE_TYPE;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *proD_SOURCE;

@property (nonatomic, strong) NSArray *promPlatComDtlFilterList;
@property (nonatomic, strong) NSArray *promtionRangeDtlFilterLst;
@property (nonatomic, strong) NSArray *collLst;
@property (nonatomic, strong) NSArray *prodClsLst;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;
+ (NSMutableArray *)modelArrayForDataUnlimitedArray:(NSArray *)dataArray;

@end
