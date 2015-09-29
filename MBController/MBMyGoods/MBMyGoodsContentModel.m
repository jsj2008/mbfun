//
//  MBMyGoodsContentModel.m
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyGoodsContentModel.h"

@implementation MBMyGoodsContentModel

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
    if ([key isEqualToString:@"description"]) {
        self.aDescription = value;
    }
    if ([key isEqualToString:@"productClsID"])
    {
        self.aID=value;
    }
    if ([key isEqualToString:@"sourcE_ID"]) {
        self.aID=value;
    }
    
}
+ (NSMutableArray*)modelArrayWithDataArray:(NSArray*)dataArray
{
    return nil;
}
@end
