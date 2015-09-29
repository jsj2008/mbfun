//
//  SitemRelevantCollocationModel.h
//  Wefafa
//
//  Created by lizhaoxiang on 15/6/10.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SitemRelevantCollocationModel : NSObject
@property (nonatomic, copy) NSString *content_info;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *img_height;
@property (nonatomic, copy) NSString *img_width;
@property (nonatomic, copy) NSString *is_love;
@property (nonatomic, strong) NSNumber *like_count;
@property (nonatomic, copy) NSString *mbfun_code;
@property (nonatomic, copy) NSString *mbfun_id;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *stick_img_url;
@property (nonatomic, copy) NSString *tag_list;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *video_url;









//@property (nonatomic, strong) NSNumber *amount;
//@property (nonatomic, strong) NSNumber *code;
//@property (nonatomic, strong) NSNumber *commentCount;
//@property (nonatomic, strong) NSNumber *favoriteCount;
//@property (nonatomic, strong) NSNumber *sharedCount;
//@property (nonatomic, strong) NSNumber *templateId;
//
//@property (nonatomic, copy) NSString *creatE_USER;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *statusName;
//@property (nonatomic, copy) NSString *thrumbnailUrl;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
