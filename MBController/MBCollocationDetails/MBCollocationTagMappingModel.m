//
//  MBCollocationTagMappingModel.m
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBCollocationTagMappingModel.h"

@implementation MBCollocationTagMappingModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        [array addObject:[[MBCollocationTagMappingModel alloc]initWithDictionary:dict]];
    }
    return array;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray IsCustom:(BOOL)isCustom{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MBCollocationTagMappingModel *mode = [[MBCollocationTagMappingModel alloc]initWithDictionary:dict];
        mode.isCustom = isCustom;
        [array addObject:mode];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
