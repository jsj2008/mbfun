//
//  MBMyGoodsContentModel.h
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBMyGoodsContentModel : NSObject

//@property (nonatomic, copy) NSString *pictureUrl;
//@property (nonatomic, copy) NSString *creatE_DATE;
//@property (nonatomic, copy) NSString *creatE_USER;
@property (nonatomic, copy) NSString *aDescription;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *userId;
//
//@property (nonatomic, strong) NSNumber *amount;
//@property (nonatomic, strong) NSNumber *code;
//@property (nonatomic, strong) NSNumber *commentCount;
//@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSString *aID;
//@property (nonatomic, strong) NSNumber *sharedCount;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayWithDataArray:(NSArray*)dataArray;

@end
