//
//  MBOtherStoreModel.m
//  Wefafa
//
//  Created by Jiang on 3/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBOtherStoreModel.h"

@implementation MBOtherStoreModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setUserInfo:(NSDictionary *)dict{
    MBOtherStoreUserInfoModel *model = [[MBOtherStoreUserInfoModel alloc]initWithDictionary:dict];
    _userInfo = model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
