//
//  GroupChatModel.m
//  Wefafa
//
//  Created by su on 15/5/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "GroupChatModel.h"

@implementation GroupChatModel

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idValue = value;
    }
}
@end
