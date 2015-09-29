//
//  MBOtherUserInfoModel.m
//  Wefafa
//
//  Created by Jiang on 4/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBOtherUserInfoModel.h"

@implementation MBOtherUserInfoModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setCollocationInfo:(NSDictionary *)collocationInfo{
    _collocationInfo = [[MBOtherStoreUserInfoModel alloc]initWithDictionary:collocationInfo];
}

- (void)setStatisticsFilterList:(NSDictionary *)statisticsFilterList{
    _statisticsFilterList = [[MBUserStatisticsFilterList alloc]initWithDictionary:statisticsFilterList];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }else if ([key isEqualToString:@"head_img"]){
        self.headPortrait = value;
    }if ([key isEqualToString:@"nick_name"]){
        self.nickName = value;
    }if ([key isEqualToString:@"user_id"]){
        self.userId = value;
    }if ([key isEqualToString:@"is_like"]){
        self.isConcerned = value;
    }
    //userviptype yuhead_v_type
    if ([key isEqualToString:@"user_vip_type"]) {
        self.head_v_type = value;
    }
}

+ (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MBOtherUserInfoModel *model = [[MBOtherUserInfoModel alloc]initWithDictionary:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}
+ (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray WithType:(BOOL)isAttend{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MBOtherUserInfoModel *model = [[MBOtherUserInfoModel alloc]initWithDictionary:dict WithType:isAttend];
        [modelArray addObject:model];
    }
    return modelArray;
}
- (instancetype)initWithDictionary:(NSDictionary*)dict WithType:(BOOL)isAttend
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.isAttend= isAttend;
    }
    return self;
}
@end
