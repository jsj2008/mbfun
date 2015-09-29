//
//  MBGoodsDetailsPictureModel.m
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsDetailsPictureModel.h"

@implementation MBGoodsDetailsPictureModel

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

+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MBGoodsDetailsPictureModel *model = [[MBGoodsDetailsPictureModel alloc]initWithDictionary:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
