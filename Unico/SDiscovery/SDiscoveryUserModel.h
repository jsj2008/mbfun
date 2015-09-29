//
//  SDuscoveryUserModel.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDiscoveryUserModel : NSObject

@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy)NSString *userSignature;
@property (nonatomic, strong)NSNumber *head_v_type;
@property (nonatomic, strong)NSNumber *concernedCount;
@property (nonatomic, strong)NSNumber *isConcerned;


- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
