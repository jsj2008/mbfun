//
//  MBMyStoreInfoModel.h
//  Wefafa
//
//  Created by Jiang on 4/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBMyStoreInfoModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, copy) NSString *backGround;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSNumber *protocol;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
