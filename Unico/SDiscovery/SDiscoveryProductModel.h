//
//  SDiscoveryProductModel.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDiscoveryProductModel : NSObject

@property (nonatomic, copy) NSString *aID;
@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, copy) NSString *item_img;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *search;
@property (nonatomic, copy) NSString *info;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
