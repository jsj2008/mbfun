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
        self.idNum = [[info objectForKey:@"id"] integerValue];
        self.code = [info objectForKey:@"code"];
        self.name = [info objectForKey:@"name"];
        self.brand = [info objectForKey:@"brand"];
        self.price = [[info objectForKey:@"price"] floatValue];
        self.saleAttribute = [info objectForKey:@"saleAttribute"];
        self.descriptionStr = [info objectForKey:@"description"];
        self.remark = [info objectForKey:@"remark"];
        self.marketTime = [info objectForKey:@"marketTime"];
        self.productYear = [[info objectForKey:@"productYear"] integerValue];
        self.mainImageUrl = [info objectForKey:@"mainImageUrl"];
        self.favortieCount = [[info objectForKey:@"favortieCount"] integerValue];
    }
    return self;
}
@end
