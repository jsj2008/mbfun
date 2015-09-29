//
//  StopicDetailModel.h
//  Wefafa
//
//  Created by unico_0 on 6/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SBrandStoryDetailModel.h"

@interface StopicDetailModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *look_num;
@property (nonatomic, strong) NSNumber *allNum;
@property (nonatomic, strong) NSNumber *selectNum;
@property (nonatomic, strong) NSNumber *partUserCount;

@property (nonatomic, copy) NSString *big_img;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int selectedIndex;

@property (nonatomic, strong) NSMutableArray *partUserList;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
