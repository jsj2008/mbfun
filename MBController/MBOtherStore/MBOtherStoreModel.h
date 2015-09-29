//
//  MBOtherStoreModel.h
//  Wefafa
//
//  Created by Jiang on 3/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBOtherStoreUserInfoModel.h"

@interface MBOtherStoreModel : NSObject

@property (nonatomic, strong) NSNumber *colCount;
@property (nonatomic, strong) NSNumber *concernCount;
@property (nonatomic, strong) NSNumber *concernedCount;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *isConcerned;
//@property (nonatomic, strong) NSNumber *un_read_num;
@property (nonatomic, strong) NSString *back_img;
@property (nonatomic, strong) NSNumber *head_v_type;




//php接口字段
@property (nonatomic, strong) NSNumber *bpLikeCount;
@property (nonatomic, strong) NSNumber *followCount;
@property (nonatomic, strong) NSNumber *followerCount;
@property (nonatomic, strong) NSNumber *productCount;

@property (nonatomic, strong) NSNumber *collocationCount;
@property (nonatomic, strong) NSNumber *collocationLikeCount;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *un_read_num;

@property (nonatomic, strong) MBOtherStoreUserInfoModel *userInfo;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
