
//
//  SMyTopicModel.m
//  Wefafa
//
//  Created by wave on 15/7/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyTopicModel.h"

@implementation InfoModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation SMyTopicModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self = [super init]) {
        if (!_arrayInfoModel) {
            _arrayInfoModel = [NSMutableArray new];
        }
        InfoModel *model = [[InfoModel alloc]initWithDic:dic];
        [_arrayInfoModel addObject:model];
    }
    return self;
}

@end
