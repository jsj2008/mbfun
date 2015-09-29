//
//  SHeaderTitleModel.h
//  Wefafa
//
//  Created by unico_0 on 6/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHeaderTitleModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *is_seleted;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
