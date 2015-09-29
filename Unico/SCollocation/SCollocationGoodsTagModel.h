//
//  SCollocationGoodsTagModel.h
//  Wefafa
//
//  Created by unico_0 on 6/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCollocationTagAttribute;

@interface SCollocationGoodsTagModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *brandCode;

@property (nonatomic, strong) NSNumber *x;
@property (nonatomic, strong) NSNumber *y;
@property (nonatomic, strong) NSNumber *flip;

@property (nonatomic, strong) SCollocationTagAttribute *attributes;

@property (nonatomic, strong) NSDictionary *dict;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end

@interface SCollocationTagAttribute : NSObject

@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *flip;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end