//
//  MBCollocationUserPublicModel.h
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBCollocationUserPublicModel : NSObject

@property (nonatomic, copy) NSString *headPortrait;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *lastLoginDateUtc;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *securityStamp;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong) NSNumber *emailConfirmed;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *phoneNumber;
@property (nonatomic, strong) NSNumber *phoneNumberConfirmed;
@property (nonatomic, strong) NSNumber *userLevel;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
