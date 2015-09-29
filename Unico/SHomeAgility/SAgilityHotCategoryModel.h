//
//  SAgilityHotCategoryModel.h
//  Wefafa
//
//  Created by Mr_J on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAgilityHotCategoryModel : NSObject

@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, copy) NSString *temp_id;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
