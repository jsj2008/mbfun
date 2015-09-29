//
//  SActivityPromPlatModel.h
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SActivityPromPlatModel : NSObject

@property (nonatomic, strong) NSNumber *colL_FLAG;
@property (nonatomic, strong) NSNumber *commissioN_VALUE;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *isUse;
@property (nonatomic, copy) NSString *promotioN_FLAT_ID;
@property (nonatomic, strong) NSNumber *standards;

@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *promotioN_RANGE;
@property (nonatomic, copy) NSString *commissioN_TYPE;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *remark;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
