//
//  MBCollocationInfoModel.h
//  Wefafa
//
//  Created by Jiang on 5/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBCollocationInfoModel : NSObject

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *sharedCount;
@property (nonatomic, strong) NSNumber *templateId;

@property (nonatomic, copy) NSString *creatE_DATE;
@property (nonatomic, copy) NSString *creatE_USER;
@property (nonatomic, copy) NSString *aDescription;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSString *thrumbnailUrl;
@property (nonatomic, copy) NSString *userId;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end
