//
//  SearchCollocationInfo.m
//  Wefafa
//
//  Created by su on 15/2/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SearchCollocationInfo.h"

@implementation SearchCollocationInfo

- (id)initWithObject:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.amount = [[dict objectForKey:@"amount"] integerValue];
        self.code = [[dict objectForKey:@"code"] integerValue];
        self.commentCount = [[dict objectForKey:@"commentCount"] integerValue];
        self.creatE_DATE = [dict objectForKey:@"creatE_DATE"];
        self.creatE_USER = [dict objectForKey:@"creatE_USER"];
        self.descriptionStr = [dict objectForKey:@"description"];
        self.favoriteCount = [[dict objectForKey:@"favoriteCount"] integerValue];
        self.idNum = [[dict objectForKey:@"id"] integerValue];
        self.name = [dict objectForKey:@"name"];
        self.pictureUrl = [dict objectForKey:@"pictureUrl"];
        self.sharedCount = [[dict objectForKey:@"sharedCount"] integerValue];
        self.thrumbnailUrl = [dict objectForKey:@"thrumbnailUrl"];
        self.userId = [dict objectForKey:@"userId"];
    }
    return self;
}
@end
