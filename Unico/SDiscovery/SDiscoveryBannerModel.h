//
//  SDiscoveryBannerModel.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDiscoveryBannerModel : NSObject
//"id": "185",
//"type": "1001",
//"index": "0",
//"img": "http://7xjir4.com2.z0.glb.qiniucdn.com/Fi2LYR6B70ehNQS0zds3uwA0yM42",

//"img_width": "750",
//"img_height": "344",
//"jump_id": "66",
//"end_time": "2035-12-31 11:11:11",

//"jump_type": "6",
//"name": "测试抽奖1",
//"is_h5": "1",
//"url": "http://10.100.28.2/wx/?p=257",

//"tid": "0",
//"share": "1"

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *img_height;
@property (nonatomic, strong) NSNumber *img_width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, strong) NSNumber *is_h5;
@property (nonatomic, strong) NSNumber *jump_id;
@property (nonatomic, strong) NSNumber *jump_type;
@property (nonatomic, strong) NSNumber *tid;

@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *share;

@property (nonatomic, strong) NSDictionary *dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
