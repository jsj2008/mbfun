//
//  SActivutyOptimalTool.m
//  Wefafa
//
//  Created by unico_0 on 6/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivutyOptimalTool.h"
#import "SActivityPromPlatModel.h"
#import "SUtilityTool.h"

@implementation SActivutyOptimalTool

+ (NSDictionary *)activityOptimalForPromPlatModelArray:(NSArray*)promPlatModelArray price:(CGFloat)price paramer:(CGFloat)paramer{
#pragma mark 优惠价格最优选择
    SActivityPromPlatModel *promPlatModel = [promPlatModelArray firstObject];
    if ([promPlatModel.condition isEqualToString:@"FULLCOUNT"]) {//满件优惠
        promPlatModel = [SActivutyOptimalTool optimalForFullCountModelArray:promPlatModelArray];
    }else if ([promPlatModel.condition isEqualToString:@"FULLMONEY"]) {//满额优惠
        promPlatModel = [SActivutyOptimalTool optimalForFullMoneyOrProductModelArray:promPlatModelArray paramer:paramer];
    }else if ([promPlatModel.condition isEqualToString:@"FULLPRODCLS"]) {//满款优惠
        promPlatModel = [SActivutyOptimalTool optimalForFullMoneyOrProductModelArray:promPlatModelArray paramer:paramer];
    }
    NSString *priceString = @"";
    if ([promPlatModel.commissioN_TYPE isEqualToString:@"RATE"]) {
        CGFloat discount = promPlatModel.commissioN_VALUE.floatValue/ 100;
        priceString = OTHER_TO_STRING(@"¥%0.2f", price * discount);
    }else{
        priceString = OTHER_TO_STRING(@"¥%0.2f", price - promPlatModel.commissioN_VALUE.floatValue);
    }
    NSDictionary *dict = @{@"price": priceString,
                           @"activityName": promPlatModel.name? promPlatModel.name: @""};
    return dict;
}

+ (SActivityPromPlatModel *)optimalForFullCountModelArray:(NSArray*)promPlatModelArray{
    SActivityPromPlatModel *promPlatModel = nil;
    NSInteger maxCount = 0;
    int maxStandards = 0;
    for (SActivityPromPlatModel *model in promPlatModelArray) {
        if (model.colL_FLAG.boolValue) {
            promPlatModel = model;
            break;
        }else{
            if (model.standards.intValue > maxStandards) {
                maxStandards = model.standards.intValue;
                maxCount = [promPlatModelArray indexOfObject:model];
            }
        }
    }
    promPlatModel = promPlatModel? promPlatModel: promPlatModelArray[maxCount];
    return promPlatModel;
}

+ (SActivityPromPlatModel *)optimalForFullMoneyOrProductModelArray:(NSArray*)promPlatModelArray paramer:(CGFloat)paramer{
    SActivityPromPlatModel *promPlatModel = nil;
    int maxCount = 0;
    int maxStandards = 0;
    for (int i = 0; i < promPlatModelArray.count; i++) {
        SActivityPromPlatModel *model = promPlatModelArray[i];
        if (model.colL_FLAG.boolValue) {
            promPlatModel = model;
            break;
        }else{
            if (paramer >= model.standards.intValue) {
                if (model.standards.intValue > maxStandards) {
                    maxStandards = model.standards.intValue;
                    maxCount = i;
                }
            }
        }
    }
    promPlatModel = promPlatModel? promPlatModel: promPlatModelArray[maxCount];
    return promPlatModel;
}

@end
