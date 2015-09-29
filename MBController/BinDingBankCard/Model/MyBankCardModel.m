//
//  MyBankCardModel.m
//  Wefafa
//
//  Created by Jiang on 2/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MyBankCardModel.h"

@implementation MyBankCardModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.aID = value;
    }
}

@end
