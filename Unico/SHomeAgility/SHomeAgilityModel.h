//
//  SHomeAgilityModel.h
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHomeAgilityJumpModel;

@interface SHomeAgilityModel : NSObject

@property (nonatomic, strong) NSMutableArray *config;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *width;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end

@interface SHomeAgilityConfigModel : NSObject

@property (nonatomic, strong) SHomeAgilityJumpModel *jump;

@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *jump_id;
@property (nonatomic, strong) NSNumber *temp_id;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *x;
@property (nonatomic, strong) NSNumber *y;

@property (nonatomic, copy) NSString *img;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end

@interface SHomeAgilityJumpModel : NSObject
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *is_h5;
@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
