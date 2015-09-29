//
//  SitemRelevantCollocationModel.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/6/10.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SitemRelevantCollocationModel.h"

@implementation SitemRelevantCollocationModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
    
}


@end
