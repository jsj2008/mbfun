//
//  CommentListModel.h
//  Wefafa
//
//  Created by unico_0 on 5/30/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentListModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *score;

@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *to_user_id;
@property (nonatomic, copy) NSNumber *head_v_type;

@property (nonatomic, strong) NSDictionary *to_user;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
