//
//  MBOtherUserInfoModel.h
//  Wefafa
//
//  Created by Jiang on 4/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBUserStatisticsFilterList.h"
#import "MBOtherStoreUserInfoModel.h"

@interface MBOtherUserInfoModel : NSObject

@property (nonatomic, strong) NSNumber *concernCount;
@property (nonatomic, strong) NSNumber *concernedCount;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *userLevel;
@property (nonatomic, strong) NSNumber *isConcerned;
//@property (nonatomic, strong) NSNumber *user_vip_type;
@property (nonatomic, strong) NSNumber *head_v_type;
@property (nonatomic, copy) NSString *concernId;
@property (nonatomic, copy) NSString *concernType;
@property (nonatomic, copy) NSString *concernTime;
@property (nonatomic, copy) NSString *headPortrait;
@property (nonatomic, copy) NSString *lastLoginDateUtc;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSignature;

@property (nonatomic, strong) MBOtherStoreUserInfoModel *collocationInfo;
@property (nonatomic, strong) MBUserStatisticsFilterList *statisticsFilterList;

@property (nonatomic, assign)BOOL isAttend;//是否是关注

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray;
+ (NSMutableArray *)modelArrayWithDataArray:(NSArray *)dataArray WithType:(BOOL)isAttend;
- (instancetype)initWithDictionary:(NSDictionary*)dict WithType:(BOOL)isAttend;
@end
