//
//  FilterSizeCategoryModel.h
//  Wefafa
//
//  Created by Funwear on 15/9/8.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterSizeCategoryModel : NSObject

@property (nonatomic, assign) NSNumber *count;
@property (nonatomic, assign) NSNumber *sortIndex;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;
@end
