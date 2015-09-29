//
//  MBCollocationDetailModel.m
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBCollocationDetailModel.h"

@implementation MBCollocationDetailModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.tagModelArray = [NSMutableArray array];
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setCollocationInfo:(NSDictionary *)collocationInfo{
    _collocationInfo = [[MBCollocationInfoModel alloc]initWithDictionary:collocationInfo];
}

- (void)setDetailList:(NSArray *)detailList{
    _detailList = [MBCollocationDetailListModel modelArrayForDataArray:detailList];
}
//customTagColMapping
- (void)setTagMapping:(NSArray *)tagMapping{
    _tagMapping = [MBCollocationTagMappingModel modelArrayForDataArray:tagMapping IsCustom:NO];
    [self.tagModelArray addObjectsFromArray:_tagMapping];
}

- (void)setCustomTagColMapping:(NSArray *)customTagColMapping{
    _customTagColMapping = [MBCollocationTagMappingModel modelArrayForDataArray:customTagColMapping IsCustom:YES];
    [self.tagModelArray addObjectsFromArray:_customTagColMapping];
}

- (void)setUserPublicEntity:(NSDictionary *)userPublicEntity{
    _userPublicEntity = [[MBCollocationUserPublicModel alloc]initWithDictionary:userPublicEntity];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
