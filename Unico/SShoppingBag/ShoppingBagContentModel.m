//
//  ShoppingBagContentModel.m
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "ShoppingBagContentModel.h"

@implementation ShoppingBagListModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.cartInfo = [[ShoppingBagCarInfoModel alloc]initWithDictionary:dict[@"cartInfo"]];
        self.productInfo = [[MBAddShoppingProductInfoModel alloc]initWithDictionary:dict[@"proudctList"][@"productInfo"]];
    }
    return self;
}

+ (NSMutableArray*)modelArrayWithDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        ShoppingBagListModel *model = [[ShoppingBagListModel alloc] initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation ShoppingBagContentModel

+ (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        int count = 0;
        ShoppingBagListModel *model = [[ShoppingBagListModel alloc] initWithDictionary:dict];
        for (ShoppingBagContentModel *contentModel in array) {
            if ([contentModel.designerId isEqualToString:model.cartInfo.designerId]) {
                [contentModel.contentModelArray addObject:model];
                count ++;
                break;
            }
        }
        if (count > 0) {
            continue;
        }
        ShoppingBagContentModel *contentModel = [[ShoppingBagContentModel alloc]init];
        contentModel.designerId = model.cartInfo.designerId;
        if ([model.cartInfo.designerId isEqualToString:@""]) {
            contentModel.designerName = @"单品";
        }else{
            contentModel.designerName = model.cartInfo.designerName;
        }
        [contentModel.contentModelArray addObject:model];
        [array addObject:contentModel];
    }
    return array;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    for (ShoppingBagListModel *model in self.contentModelArray) {
        model.isSelected = isSelected;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentModelArray = [NSMutableArray array];
    }
    return self;
}

@end
 