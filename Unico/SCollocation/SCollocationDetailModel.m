//
//  SCollocationDetailModel.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationDetailModel.h"

@implementation SCollocationDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
//打开加入话题标签        
//        for (SCollocationGoodsTagModel *model in _tag_list) {
//            if (model.attributes.type.intValue == 3) {
//                SCollocationDetailTagTypeModel *tagModel = [[SCollocationDetailTagTypeModel alloc]init];
//                tagModel.contentText = [NSString stringWithFormat:@"#%@", model.text];
//                tagModel.isTopic = YES;
//                tagModel.topicID = model.attributes.aID;
//                [_tab_str insertObject:tagModel atIndex:0];
//            }
//        }
    }
    return self;
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SCollocationDetailModel *model = [[SCollocationDetailModel alloc]initWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.aID = value;
    }
}

- (void)setTag_list:(NSString *)tag_list{
    NSData *data = [tag_list dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _tag_list = [SCollocationGoodsTagModel modelArrayForDataArray:dataArray];
    
    NSMutableArray *brandArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        //打开去重
        SCollocationGoodsTagModel *model = [[SCollocationGoodsTagModel alloc]initWithDictionary:dict];
        int count = 0;
        for (SCollocationGoodsTagModel *tagModel in brandArray) {
            if ([tagModel.brandCode isEqualToString:model.brandCode]) {
                count ++;
            }
        }
        if (count == 0) {
            [brandArray addObject:model];
        }
    }
    NSMutableArray *array = [NSMutableArray array];
    for (SCollocationGoodsTagModel *model in brandArray) {
        if (model.attributes.code && model.attributes.code.length > 0) {
            [array addObject:model];
        }
    }
    _useBrand = array;
}

- (void)setTab_str:(NSString *)tab_str{
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *array = [tab_str componentsSeparatedByString:@","];
    for (NSString *tabString in array) {
        if (![tabString isEqualToString:@""]) {
            SCollocationDetailTagTypeModel *model = [[SCollocationDetailTagTypeModel alloc]init];
            model.contentText = tabString;
            [mutableArray addObject:model];
        }
        
    }
    _tab_str = mutableArray;
}

- (void)setUser_json:(NSString *)user_json{
    NSData *data = [user_json dataUsingEncoding:NSUTF8StringEncoding];
    _user_json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)setItem_str:(NSString *)item_str{
    _item_str = item_str;
    NSArray *itemAry = [item_str componentsSeparatedByString:@"_"];
    NSMutableArray *goodsIDs = [NSMutableArray array];
    for (int i=0;i < itemAry.count;i++) {
        if (![itemAry[i] isEqualToString:@""]) {
            NSNumber *num = [NSNumber numberWithInt:[itemAry[i] intValue]];
            [goodsIDs addObject:num];
        }
    }
    self.itemIdArray = goodsIDs;
}

- (void)setProduct_list:(NSArray *)product_list{
    _product_list = [SCollocationSubProductModel modelArrayForDataArray:product_list];
}

- (void)setBrand_str:(NSString *)brand_str{
    _brand_str = [brand_str copy];
    NSArray *itemAry = [brand_str componentsSeparatedByString:@"_"];
    NSMutableArray *goodsIDs = [NSMutableArray array];
    for (int i=0;i < itemAry.count;i++) {
        if (![itemAry[i] isEqualToString:@""]) {
            NSString *string = [NSString stringWithFormat:@"%@", itemAry[i]];
            [goodsIDs addObject:string];
        }
    }
    self.brandArray = goodsIDs;
}

- (void)setProductArray:(NSArray *)productArray{
    _productArray = productArray;
    CGFloat salePrice = 0.0;
    CGFloat price = 0.0;
    for (MBGoodsDetailsModel *model in productArray) {
        salePrice += model.clsInfo.sale_price.doubleValue;
        price += model.clsInfo.price.doubleValue;
    }
    _sale_price = @(salePrice);
    _price = @(price);
}

- (void)setBanner:(NSDictionary *)banner{
    _banner = [SDiscoveryBannerModel modelArrayForDataArray:banner[@"1006"]];
}

- (void)setDesigner:(NSDictionary *)designer{
    _designer = [[SDiscoveryUserModel alloc]initWithDictionary:designer];
}

- (void)setLike_user_list:(NSArray *)like_user_list{
    _like_user_list = [SDiscoveryUserModel modelArrayForDataArray:like_user_list];
}

@end

@implementation SCollocationDetailTagTypeModel



@end
