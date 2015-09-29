//
//  MBMyStoreModel.m
//  Wefafa
//
//  Created by Jiang on 4/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyStoreModel.h"

@implementation MBMyStoreModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setStoreInfo:(NSDictionary *)storeInfo{
    MBMyStoreInfoModel *model = [[MBMyStoreInfoModel alloc]initWithDictionary:storeInfo];
    _storeInfo = model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
