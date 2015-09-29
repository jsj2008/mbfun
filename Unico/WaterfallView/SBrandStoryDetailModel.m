//
//  SBrandStoryDetailModel.m
//  Wefafa
//
//  Created by unico_0 on 6/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SBrandStoryDetailModel.h"

@implementation SBrandStoryDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SBrandStoryDetailModel *model = [[SBrandStoryDetailModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setLike_user_list:(NSArray *)like_user_list{
    _like_user_list = [SBrandStoryUserModel modelArrayForDataArray:like_user_list];
}
-(void)setCollocation_list:(NSMutableArray *)collocation_list
{
    _collocation_list = [SBrandListContentModel modelArrayForDataArray:collocation_list];
    
}
- (void)setItemList:(NSArray *)itemList{
    _itemList = [SBrandListContentModel modelArrayForDataArray:itemList];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

@end

@implementation SBrandStoryUserModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SBrandStoryUserModel *model = [[SBrandStoryUserModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
//品牌
@implementation SBrandListContentModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        SBrandListContentModel *model = [[SBrandListContentModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
