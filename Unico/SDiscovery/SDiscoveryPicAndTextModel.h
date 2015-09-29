//
//  SDiscoveryPicAndTextModel.h
//  Wefafa
//
//  Created by metesbonweios on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDiscoveryPicTConfigerModel : NSObject
@property (nonatomic, strong) NSMutableArray *config;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *info;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;
@end

@interface SDiscoveryPicAndTextModel : NSObject
@property (nonatomic, strong) NSMutableArray *config;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, copy) NSString *name;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;
@end


@interface SDiscoveryPicAndTextConfigModel : NSObject

@property (nonatomic, strong) NSString *big_img;
@property (nonatomic, strong) NSString *fixed_id;
@property (nonatomic, strong) NSString *aID;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *small_img;
@property (nonatomic, strong) NSString *temp_id;
@property (nonatomic,strong) NSString *brand_code;


- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;
@end