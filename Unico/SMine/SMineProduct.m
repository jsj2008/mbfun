//
//  SMineProduct.m
//  Wefafa
//
//  Created by Jiang on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMineProduct.h"

@implementation SMineProduct

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)productArrForDataArray:(NSArray *)dataArray
{
    NSMutableArray *tempArrM = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SMineProduct *product = [[SMineProduct alloc] initWithDict:dict];
        [tempArrM addObject:product];
    }
    return tempArrM;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.idStr=value;
    }
}
@end
