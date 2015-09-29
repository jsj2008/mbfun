//
//  StoreModel.m
//  Wefafa
//
//  Created by su on 15/1/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel

- (id)initWithInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.idNum = [[dict objectForKey:@"id"] integerValue];
        self.userId = [dict objectForKey:@"userId"];
        self.storeCode = [dict objectForKey:@"StoreCode"];
        self.storeName = [dict objectForKey:@"storeName"];
        self.storeAccout = [NSString stringWithFormat:@"%0.2f",[[dict objectForKey:@"storeAccount"] floatValue]];
        self.isActive = [[dict objectForKey:@"isActive"] boolValue];
        self.activeTime = [[dict objectForKey:@"activeTime"] doubleValue];
        self.backGround = [dict objectForKey:@"backGround"];
        self.createTime = [[dict objectForKey:@"creatE_DATE"] doubleValue];
        self.lastModifityDate = [[dict objectForKey:@"lasT_MODIFIED_DATE"] doubleValue];
        self.createUser = [dict objectForKey:@"creatE_USER"];
        self.lastModofyUser = [dict objectForKey:@"lasT_MODIFIED_USER"];
    }
    return self;
}
@end

@implementation CollocationDetail

- (id)initWithInfo:(NSDictionary *)collocationDict
{
    self = [super init];
    if (self) {
        self.originalDict = collocationDict;
        NSDictionary *dict = [collocationDict objectForKey:@"collocationInfo"];
        
        self.idNum = [[dict objectForKey:@"id"] integerValue];
        self.userId = [dict objectForKey:@"userId"];
        self.code = [dict objectForKey:@"code"];
        self.name = [dict objectForKey:@"name"];
//        self.storeAccout = [NSString stringWithFormat:@"%@",[dict objectForKey:@"storeAccount"]];
        self.favoriteCount = [[dict objectForKey:@"favoriteCount"] integerValue];
        self.amount = [[dict objectForKey:@"amount"] integerValue];
        self.commentCount = [[dict objectForKey:@"commentCount"] integerValue];
        self.sharedCount = [[dict objectForKey:@"sharedCount"] integerValue];
//        self.activeTime = [[dict objectForKey:@"activeTime"] doubleValue];
//        self.backGround = [dict objectForKey:@"backGround"];
        self.creatE_DATE = [[dict objectForKey:@"creatE_DATE"] doubleValue];
//        self.lastModifityDate = [[dict objectForKey:@"lasT_MODIFIED_DATE"] doubleValue];
        self.creatE_USER = [dict objectForKey:@"creatE_USER"];
        self.statusName = [dict objectForKey:@"statusName"];
        self.detail = [dict objectForKey:@"description"];
        self.backPictureUrl = [dict objectForKey:@"backPictureUrl"];
        self.thrumbnailUrl = [dict objectForKey:@"thrumbnailUrl"];
        self.pictureUrl = [dict objectForKey:@"pictureUrl"];
    }
    return self;
}

@end
