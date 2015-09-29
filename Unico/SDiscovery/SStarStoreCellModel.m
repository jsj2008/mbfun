//
//  SStarStoreCellModel.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/28.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SStarStoreCellModel.h"

@implementation SStarStoreCellModel

-(id)initStarStoreModelWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.userName = dic[@"nick_name"];
        self.collocationList = [dic[@"collocation_list"] mutableCopy];
        self.designId = dic[@"user_id"];
        self.headImg = dic[@"head_img"];
        self.head_v_type =dic[@"head_v_type"];
        self.is_like = dic[@"is_like"];
        self.collocationCount = dic[@"collocationCount"];
        self.concernCount = dic[@"concernCount"];
    }
    return self;
}

+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArry) {
        SStarStoreCellModel *model = [[SStarStoreCellModel alloc]initStarStoreModelWithDic:dict];
        [array addObject:model];
    }
    return array;
}

@end
