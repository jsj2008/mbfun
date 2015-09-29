//
//  SActivityPromtionRangeModel.h
//  Wefafa
//
//  Created by unico_0 on 6/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SActivityPromtionRangeModel : NSObject

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *promotioN_ID;
@property (nonatomic, strong) NSNumber *sorT_NO;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, copy) NSString *remark;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
