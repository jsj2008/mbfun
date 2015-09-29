//
//  StopicDetailModel.m
//  Wefafa
//
//  Created by unico_0 on 6/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "StopicDetailModel.h"

@implementation StopicDetailModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setPartUserList:(NSMutableArray *)partUserList{
    _partUserList = [SBrandStoryUserModel modelArrayForDataArray:partUserList];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

@end
