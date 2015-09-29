//
//  FilterPirceRangeModel.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterPirceRangeModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSNumber *max_Price;
@property (nonatomic, strong) NSNumber *min_Price;

@property (nonatomic, copy) NSString *name;


- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end

