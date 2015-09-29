//
//  SMyTopicModel.h
//  Wefafa
//
//  Created by wave on 15/7/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InfoModel : NSObject
@property (nonatomic, strong) NSString *content_info;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, strong) NSString *head_v_type;
@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *img_height;
@property (nonatomic, strong) NSString *img_width;
@property (nonatomic, strong) NSString *is_love;
@property (nonatomic, strong) NSString *item_str;

@property (nonatomic, strong) NSString *like_count;
@property (nonatomic, strong) NSString *mbfun_code;
@property (nonatomic, strong) NSString *mbfun_id;
@property (nonatomic, strong) NSString *nick_name;

@property (nonatomic, strong) NSString *stick_img_url;
@property (nonatomic, strong) NSString *tag_list;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *video_url;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end

@interface SMyTopicModel : NSObject //话题model

@property (nonatomic, strong) NSMutableArray *arrayInfoModel;
- (instancetype)initWithDic:(NSDictionary*)dic;

@end
