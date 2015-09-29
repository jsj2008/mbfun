//
//  MBStoreVisitorModel.h
//  Wefafa
//
//  Created by Jiang on 5/19/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBStoreVisitorModel : NSObject

@property (nonatomic, strong) NSNumber *clickCount;
@property (nonatomic, strong) NSNumber *channel;
@property (nonatomic, strong) NSNumber *sharedCount;
@property (nonatomic, strong) NSDate *create_date;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
