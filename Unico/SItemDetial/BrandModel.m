//
//  BrandModel.m
//  Wefafa
//
//  Created by su on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "BrandModel.h"

@implementation BrandModel
- (id)initWithBrandDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

//- (void)setSubItem:(id)subItem
//{
//    if ([subItem isKindOfClass:[NSDictionary class]]) {
//        _subItem = [[BrandSubItem alloc] initWithDict:subItem];
//    }
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idValue = value;
    }
    if ([key isEqualToString:@"subItem"]) {
         NSMutableArray *itemsArr = [NSMutableArray array];
        
        for(NSDictionary *dict in value){
            BrandSubItem *subItem = [[BrandSubItem alloc] initWithDict:dict];
            [itemsArr addObject:subItem];
        }
        _subItems = itemsArr;
    }
}
@end

@implementation BrandSubItem

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


