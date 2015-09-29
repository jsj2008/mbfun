//
//  SProductTagEditeInfo.m
//  Wefafa
//
//  Created by chencheng on 15/8/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SProductTagEditeInfo.h"

@implementation SProductTagEditeInfo
-(instancetype)initWithDictionary:(NSDictionary*)dic
{
    if (self==[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
