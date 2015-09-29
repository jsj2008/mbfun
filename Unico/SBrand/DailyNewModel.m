//
//  DailyNewModel.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/4.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "DailyNewModel.h"

@implementation DailyNewModel
- (instancetype)initWithDictionary:(NSDictionary*)dict;
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setItem_img:(NSDictionary *)item_img{
   _item_img = [[ItemImgModel alloc] initWithDictionary:item_img];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aId = value;
    }
}
@end
@implementation ItemImgModel
- (instancetype)initWithDictionary:(NSDictionary*)dict;
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

@end