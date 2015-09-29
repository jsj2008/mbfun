//
//  BrandListCellModel.m
//  Wefafa
//
//  Created by CesarBlade on 15-4-1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "BrandListCellModel.h"

@implementation BrandListCellModel
-(id)initWithBrandListCellDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.logoImg = [dic objectForKey:@"logO_URL"];
        self.brand = [dic objectForKey:@"branD_NAME"];
        self.brandID = [[dic objectForKey:@"id"] integerValue];
        self.brandCode =[[dic objectForKey:@"branD_CODE"] integerValue];
    }
    return self;
}

@end
