//
//  CollocationSearchModel.m
//  Wefafa
//
//  Created by su on 15/1/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "CollocationSearchModel.h"

@implementation CollocationSearchModel

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict objectForKey:@"id"]) {
            self.idNum = [[dict objectForKey:@"id"] integerValue];
        }
        if ([dict objectForKey:@"collocationId"]) {
            self.collocationId = [[dict objectForKey:@"collocationId"] integerValue];
        }
        if ([dict objectForKey:@"productName"]) {
            self.productName = [dict objectForKey:@"productName"];
        }
        if ([dict objectForKey:@"productCode"]) {
            self.productCode = [dict objectForKey:@"productCode"];
        }
        if ([dict objectForKey:@"colorCode"]) {
            self.colorCode = [dict objectForKey:@"colorCode"];
        }
        if ([dict objectForKey:@"colorName"]) {
            self.colorName = [dict objectForKey:@"colorName"];
        }
        if ([dict objectForKey:@"productPrice"]) {
            self.productPrice = [[dict objectForKey:@"productPrice"] floatValue];
        }
        if ([dict objectForKey:@"productPictureUrl"]) {
            self.productPictureUrl = [dict objectForKey:@"productPictureUrl"];
        }
        if ([dict objectForKey:@"sourceType"]) {
            self.sourceType = [[dict objectForKey:@"sourceType"] integerValue];
        }
    }
    return self;
}
@end
