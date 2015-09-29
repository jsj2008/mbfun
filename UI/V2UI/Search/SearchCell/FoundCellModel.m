//
//  FoundCellModel.m
//  Wefafa
//
//  Created by su on 15/2/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "FoundCellModel.h"

@implementation FoundCellModel

- (id)initWithFoundInfo:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSDictionary *basicInfo = [dict objectForKey:@"storeBasicInfo"];
        
        if (basicInfo) {
            self.baseId = [[basicInfo objectForKey:@"id"] integerValue];
            self.backGround = [basicInfo objectForKey:@"backGround"];
            self.userId = [basicInfo objectForKey:@"userId"];
            
        }

        
        NSDictionary *userEntity = [dict objectForKey:@"userPublicEntity"];
        if (userEntity) {
            self.nickName = [userEntity objectForKey:@"nickName"];
            self.userName = [userEntity objectForKey:@"userName"];
            self.headPortrait = [userEntity objectForKey:@"headPortrait"];
            self.userLevel = [[userEntity objectForKey:@"userLevel"] integerValue];
            self.lastLoginDateUtc = [userEntity objectForKey:@"lastLoginDateUtc"];
            self.gender = [userEntity objectForKey:@"gender"];
            self.isActive = [[userEntity objectForKey:@"isActive"] integerValue];
            self.securityStamp = [userEntity objectForKey:@"securityStamp"];
            self.emailConfirmed = [[userEntity objectForKey:@"emailConfirmed"] integerValue];
            self.phoneNumber = [userEntity objectForKey:@"phoneNumber"];
            self.phoneNumberConfirmed = [[userEntity objectForKey:@"phoneNumberConfirmed"] integerValue];
            self.collocationList = [[NSArray alloc] initWithArray:[self configCollocationListWithArray:[dict objectForKey:@"collocationList"]]];
        }
//                NSLog(@"self.useid--%@------------%@........%@",self.userId,self.nickName,self.userName);
    }
    return self;
}

- (NSArray *)configCollocationListWithArray:(NSArray *)subArr
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for(NSDictionary *dict in subArr){
        SearchCollocationInfo *aInfo = [[SearchCollocationInfo alloc] initWithObject:dict];
        [array addObject:aInfo];
    }
    return array;
}
@end
