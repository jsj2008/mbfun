//
//  MBCollocationTagMappingModel.h
//  Wefafa
//
//  Created by Jiang on 5/7/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBCollocationTagMappingModel : NSObject

@property (nonatomic, copy) NSString *showTagName;

@property (nonatomic, strong) NSNumber *showTagId;
@property (nonatomic, strong) NSNumber *sourceId;
@property (nonatomic, assign) BOOL isCustom;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray IsCustom:(BOOL)isCustom;

@end
