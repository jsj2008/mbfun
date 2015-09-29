//
//  LNGood.m
//  WaterfallFlowDemo
//
//  Created by Lining on 15/5/3.
//  Copyright (c) 2015年 Lining. All rights reserved.
//

#import "LNGood.h"

@implementation like_user_listModel

- (instancetype)initWithDic:(NSDictionary*)dic; {
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

@implementation LNGood
/**
 *  字典转模型
 */
+ (instancetype)goodWithDict:(NSDictionary *)dict {
    id good = [[self alloc] init];
    [good setValuesForKeysWithDictionary:dict];
    return good;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"content_info"]) {
        CGFloat maxHeight = MAXFLOAT;
        CGFloat miniHeight = 0;
        NSString *infoStr = value;
        CGSize constrainSize = infoStr.length ? CGSizeMake(UI_SCREEN_WIDTH - 20, maxHeight) : CGSizeMake(UI_SCREEN_WIDTH - 20, miniHeight);
        CGSize size = [infoStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constrainSize lineBreakMode:NSLineBreakByCharWrapping];
        //value == nil 这里size。height = 13.8 !? 不知道什么原因所以强制赋值
        if (infoStr.length == 0) {
            size.height = 0;
        }
        self.infoHeight = infoStr.length ? MAX(size.height, 40) : 0;
        NSLog(@"_infoHeight ==== %f value ==== %@", _infoHeight, value);
        size = CGSizeZero;

//        CGFloat constrainHeight = infoStr.length ? maxHeight : miniHeight;
//        CGFloat constrainWidth = UI_SCREEN_WIDTH;
//        CGSize constrainSize2 = CGSizeMake(constrainWidth, constrainHeight);
//        
//        CGRect rect = [infoStr boundingRectWithSize:constrainSize2 options:NSLineBreakByCharWrapping attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.f]} context:nil];
//        self.infoHeight = infoStr.length ? MAX(rect.size.height, 40) : MAX(rect.size.height, 0);;
//        NSLog(@"_infoHeight ==== %f value ==== %@", _infoHeight, value);
    }else {
        
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"img_height"]) {
        self.h = [value integerValue];
    }else if ([key isEqualToString:@"img_width"]) {
        self.w = [value integerValue];
    }else if ([key isEqualToString:@"img_width"]) {
        self.product_ID = [NSString stringWithFormat:@"%@", value];
    }else if ([key isEqualToString:@"like_user_list"]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:((NSArray*)value).count];
        [((NSArray*)value) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            like_user_listModel *likeModel = [[like_user_listModel alloc]initWithDic:(NSDictionary*)obj];
            [array addObject:likeModel];
        }];
        self.array_like_user_list = array;
    }else if ([key isEqualToString:@"id"]) {
        self.product_ID = value;
    }
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        LNGood *model = [LNGood goodWithDict:dict];
        [array addObject:model];
    }
    return array;
}

/**
 *  根据索引返回商品数组
 */
+ (NSArray *)goodsWithIndex:(NSInteger)index {
    
    
    NSString *fielname = [NSString stringWithFormat:@"%d.plist", 1];
    NSString *paht = [[NSBundle mainBundle] pathForResource:fielname ofType:nil];
    NSArray *arrya = [NSArray arrayWithContentsOfFile:paht];
    [arrya enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"[obj class] is %@ \r %@", [obj class], obj);
    }];
    
    NSString *fileName = [NSString stringWithFormat:@"%d.plist", (int)index % 3 + 1];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSArray *goodsArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:goodsArray.count];
    
    [goodsArray enumerateObjectsUsingBlock: ^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        [tmpArray addObject:[self goodWithDict:dict]];
    }];
    return tmpArray.copy;
}
@end
