//
//  SAgilitySpaceModel.h
//  Wefafa
//
//  Created by Mr_J on 15/8/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAgilitySpaceModel : NSObject

@property (nonatomic, strong) NSNumber *img_height;
@property (nonatomic, strong) NSNumber *img_width;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
