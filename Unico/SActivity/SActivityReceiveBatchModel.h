//
//  SActivityReceiveBatchModel.h
//  Wefafa
//
//  Created by unico_0 on 6/9/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SActivityReceiveBatchInfoModel.h"
@class SActivityReceiveRuleRuleFilterModel, SActivityReceiveRuleInfoModel;

@interface SActivityReceiveBatchModel : NSObject

@property(nonatomic, strong) NSNumber *isEndActivity;

@property (nonatomic, strong) SActivityReceiveBatchInfoModel *couponBatchBasicInfo;
@property (nonatomic, strong) SActivityReceiveRuleInfoModel *couponRuleInfo;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end

@interface SActivityReceiveRuleInfoModel : NSObject

@property (nonatomic, strong) NSArray *couponRuleDtlFilterList;
@property (nonatomic, strong) SActivityReceiveRuleRuleFilterModel *couponRuleFilterList;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end

@interface SActivityReceiveRuleRuleFilterModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *coupoN_RULE_RANGE;
@property (nonatomic, copy) NSString *aDescription;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end