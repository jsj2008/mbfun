//
//  MBGoodDetailsColorModel.m
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsDetailsColorModel.h"
#import "SUtilityTool.h"

@implementation MBGoodsDetailsColorModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        // 缩略图
        _selectedSizeId = -1;
        self.picurl = [SUTIL getThumbImageUrl:self.picurl];
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
        MBGoodsDetailsColorModel *model = [[MBGoodsDetailsColorModel alloc]initWithDictionary:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}

@end
