//
//  FilterColorCategoryModel.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterColorCategoryModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *coloR_CODE;

@property (nonatomic, copy) NSString *coloR_VALUE;
@property (nonatomic, copy) NSString *coloR_NAME;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end