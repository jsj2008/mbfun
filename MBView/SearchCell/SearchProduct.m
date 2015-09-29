//
//  SearchProduct.m
//  Wefafa
//
//  Created by su on 15/2/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SearchProduct.h"

@implementation SearchProduct

- (id)initWithProductInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
//        self.idNum = [[info objectForKey:@"id"] integerValue];
//        self.code = [info objectForKey:@"code"];
//        self.name = [info objectForKey:@"name"];
//        self.brand = [info objectForKey:@"brand"];
//        self.price = [[info objectForKey:@"price"] floatValue];
//        self.saleAttribute = [info objectForKey:@"saleAttribute"];
//        self.descriptionStr = [info objectForKey:@"description"];
//        self.remark = [info objectForKey:@"remark"];
//        self.marketTime = [info objectForKey:@"marketTime"];
//        self.productYear = [[info objectForKey:@"productYear"] integerValue];
//        self.mainImageUrl = [info objectForKey:@"mainImageUrl"];
//        self.favortieCount = [[info objectForKey:@"favortieCount"] integerValue];
        
        if ([info[@"id"] integerValue]) {
            self.idNum = [info[@"id"] integerValue];

        }
        if (info [@"code"]) {
            self.code = info [@"code"];

        }
        if (info [@"name"]) {
            self.name = info [@"name"];

        }
        if (info [@"brand"]) {
            self.brand = info [@"brand"];

        }
        if ([info[@"sale_price"] floatValue]) {
            self.price = [info[@"sale_price"] floatValue];

        }
        if (info [@"saleAttribute"]) {
            self.saleAttribute = info [@"saleAttribute"];

        }
        if (info [@"description"]) {
            self.descriptionStr = info [@"description"];

        }
        if (info [@"remark"]) {
            self.remark = info [@"remark"];

        }
        if (info [@"marketTime"]) {
            self.marketTime = info [@"marketTime"];

        }
        if ([info[@"productYear"] integerValue]) {
            self.productYear = [info[@"productYear"] integerValue];

        }
        if (info [@"mainImage"]) {
            self.mainImageUrl = info [@"mainImage"];

        }
        if ([info[@"favortieCount"] integerValue]) {
            self.favortieCount = [info[@"favoriteCount"] integerValue];

        }
        
    }
    return self;
}
@end
