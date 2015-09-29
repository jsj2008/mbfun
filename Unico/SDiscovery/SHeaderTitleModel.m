//
//  SHeaderTitleModel.m
//  Wefafa
//
//  Created by unico_0 on 6/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SHeaderTitleModel.h"

@implementation SHeaderTitleModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.aID = @"";
        self.name = @"";
        self.index = @0;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SHeaderTitleModel *model = [[SHeaderTitleModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

@end
