//
//  SMyTopicHeadModel.h
//  Wefafa
//
//  Created by wave on 15/7/22.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, strong) NSString *head_v_type;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *back_img;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end


@interface SMyTopicHeadModel : NSObject

@property (nonatomic, strong) NSString *collCount;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSString *likeCount;
@property (nonatomic, strong) NSString *topicCount;

@property (nonatomic, strong) UserInfo *userinfo;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end
