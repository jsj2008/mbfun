//
//  StoreModel.h
//  Wefafa
//
//  Created by su on 15/1/26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 字段名	类型	字段说明
 ID	int
 UserId	nvarchar	用户UserId
 StoreCode	nvarchar	店铺编码
 StoreName	nvarchar	店铺名称
 StoreAccount	decimal	店铺资产
 IsActive	int	是否生效
 ActiveTime	datetime	生效日期
 BackGround	nvarchar	背景信息
 CREATE_DATE	datetime	创建日期
 LAST_MODIFIED_DATE	datetime	修改日期
 CREATE_USER	nvarchar	创建人
 LAST_MODIFIED_USER	nvarchar	修改人
 */

@interface StoreModel : NSObject
@property(nonatomic)NSInteger idNum;
@property(nonatomic,strong)NSString *userId;//用户UserId
@property(nonatomic,strong)NSString *storeCode;//店铺编码
@property(nonatomic,strong)NSString *storeName;//店铺名称
@property(nonatomic,strong)NSString *storeAccout;//店铺资产
@property(nonatomic)BOOL isActive;//是否生效
@property(nonatomic)double activeTime;//生效日期
@property(nonatomic,strong)NSString *backGround;//背景信息
@property(nonatomic)double createTime;//创建日期
@property(nonatomic)double lastModifityDate;//修改日期
@property(nonatomic,strong)NSString *createUser;//创建人
@property(nonatomic,strong)NSString *lastModofyUser;//修改人

- (id)initWithInfo:(NSDictionary *)dict;
@end

@interface CollocationDetail : NSObject
@property(nonatomic)NSInteger idNum;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *pictureUrl;
@property(nonatomic,strong)NSString *thrumbnailUrl;
@property(nonatomic,strong)NSString *backPictureUrl;
@property(nonatomic,strong)NSString *detail;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *statusName;
@property(nonatomic,strong)NSString *creatE_USER;
@property(nonatomic)double creatE_DATE;
@property(nonatomic)NSInteger favoriteCount;
@property(nonatomic)NSInteger amount;
@property(nonatomic)NSInteger commentCount;
@property(nonatomic)NSInteger sharedCount;
@property (nonatomic,strong)NSDictionary *originalDict;
- (id)initWithInfo:(NSDictionary *)dict;
@end

/*
 {"id":0,"code":"String","name":"String","pictureUrl":"String","thrumbnailUrl":"String","backPictureUrl":"String","description":"String","userId":"String","statusName":"String","creatE_USER":"String","creatE_DATE":"\/Date(-62135596800000-0000)\/","favoriteCount":0,"amount":0,"commentCount":0,"sharedCount":0},"statisticsFilterList":[{"sourceID":0,"commentCount":0,"browserCount":0,"sharedCount":0,"favoritCount":0}]}]}
 */