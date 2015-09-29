//
//  SDiscoveryJumpModel.h
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDiscoveryJumpModel : NSObject

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *is_h5;
@property (nonatomic, strong) NSNumber *jump_id;
@property (nonatomic, strong) NSNumber *jump_type;
@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *url;

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
