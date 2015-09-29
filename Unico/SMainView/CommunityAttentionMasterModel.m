//
//  CommunityAttentionMasterModel.m
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityAttentionMasterModel.h"

@implementation CommunityAttentionMasterModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        self.isConcerned = NO;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
