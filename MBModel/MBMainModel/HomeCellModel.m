//
//  HomeCellModel.m
//  Wefafa
//
//  Created by su on 15/3/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "HomeCellModel.h"

@implementation HomeCellModel
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary *tagDict = [NSMutableDictionary dictionaryWithCapacity:0];
        NSArray *mapArr = dict[@"tagMapping"];
        if (mapArr) {
            [tagDict setObject:mapArr forKey:@"tagMapping"];
        }
        NSArray *customMap = dict[@"customTagColMapping"];
        if (customMap) {
            [tagDict setObject:customMap forKey:@"customTagColMapping"];
        }
        _tagDict = [[NSDictionary alloc] initWithDictionary:tagDict];
        
        _collocationInfo = [[SearchCollocationInfo alloc] initWithObject:dict[@"collocationInfo"]];
        _userEntity = [[FoundCellModel alloc] initWithFoundInfo:dict];
    }
    return self;
}
@end
