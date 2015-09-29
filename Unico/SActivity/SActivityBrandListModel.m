//
//  SActivityBrandListModel.m
//  Wefafa
//
//  Created by unico_0 on 6/12/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityBrandListModel.h"

@implementation SActivityBrandListModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        NSDictionary *subDict = [dict objectForKey:@"clsInfo"];
        SActivityBrandListModel *model = [[SActivityBrandListModel alloc]initWithDictionary:subDict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }else if ([key isEqualToString:@"sale_price"]){
        self.markeT_PRICE = value;
    }else if ([key isEqualToString:@"mainImage"]){
        self.clsPicUrl = value;
    }else if ([key isEqualToString:@"favoriteCount"]){
        self.favoritE_COUNT = value;
    }
}

@end
