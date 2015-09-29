//
//  MBBrandModel.m
//  Wefafa
//
//  Created by su on 15/4/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBBrandModel.h"

@implementation MBBrandModel

@end

@implementation HomeSelectionModel
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.detailStr = [dict objectForKey:@"description"];
        self.designID = [dict objectForKey:@"userId"];
    }
    return self;
}

-(void)setStoreInfo:(id)storeInfo{
    if ([storeInfo isKindOfClass:[NSDictionary class]]) {
        MBMyStoreInfoModel *model = [[MBMyStoreInfoModel alloc]initWithDictionary:storeInfo];
        _storeInfo = model;
    }
    if ([storeInfo isKindOfClass:[MBMyStoreInfoModel class]]) {
        _storeInfo = storeInfo;
    }
}

- (void)setDescriptionStr:(NSString *)descriptionStr
{
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idValue = value;
    }
}
@end

