//
//  FoundCellModel.h
//  Wefafa
//
//  Created by su on 15/2/2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchCollocationInfo.h"

@interface FoundCellModel : NSObject
//storeBasicInfo
@property(nonatomic)NSInteger baseId;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *backGround;
//userPublicEntity
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *headPortrait;
@property(nonatomic,strong)NSString *lastLoginDateUtc;
@property(nonatomic,strong)NSString *securityStamp;
@property(nonatomic)NSInteger userLevel;
@property(nonatomic,strong)NSString *gender;
@property(nonatomic)NSInteger isActive;
@property(nonatomic)NSInteger emailConfirmed;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic)NSInteger phoneNumberConfirmed;
@property(nonatomic,strong)NSArray *collocationList;//SearchCollocationInfo

- (id)initWithFoundInfo:(NSDictionary *)dict;
@end

/*
 storeBasicInfo
 
 
 --id	:	121
 userId	:	82170f39-cd2a-4cc5-b41c-67411a6e4f4b
 storeName	:	冰冰
 backGround	:	http://180.168.84.178/getfile/54aa670d6803fa085c8cf8fd

 userPublicEntity
 
 id	:	82170f39-cd2a-4cc5-b41c-67411a6e4f4b
 nickName	:	冰冰
 userName	:	MD00000232
 headPortrait	:	http://180.168.84.178/getfile/54aa670d6803fa085c8cf8fd
 lastLoginDateUtc	:	/Date(1422859556343+0800)/
 userLevel	:	0
 gender	:	女
 isActive	:	1
 securityStamp	:	RfDFfPfg0UiysaASfee/QadBVJb697Em
 emailConfirmed	:	0
 phoneNumber	:	15026959903
 phoneNumberConfirmed	:
 
 
 
 collocationList
 
 id	:	72324
 code	:	10072324
 name	:
 pictureUrl	:	http://img.51mb.com:5659/sources/designer/Collocation/20150130/1422614059.jpg
 thrumbnailUrl	:	http://img.51mb.com:5659/sources/designer/Collocation/20150130/1422614059.jpg
 description	:	aaa
 userId	:	82170f39-cd2a-4cc5-b41c-67411a6e4f4b
 creatE_USER	:	MD00000232
 creatE_DATE	:	/Date(1422614059077-0000)/
 favoriteCount	:	0
 amount	:	400
 commentCount	:	0
 sharedCount	:
 
 */