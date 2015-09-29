//
//  SChatSystemListModel.h
//  Wefafa
//
//  Created by wave on 15/6/11.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SChatSystemListBannerInfo : NSObject
@property (nonatomic) NSString *aid;
@property (nonatomic) NSString *is_h5;
@property (nonatomic) NSString *tid;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *url;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface SChatSystemListCreateUserInfo : NSObject
@property (nonatomic) NSString *head_img;
@property (nonatomic) NSString *nick_name;
@property (nonatomic) NSString *user_id;
@property (nonatomic,strong)NSNumber *head_v_type;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

@interface SChatSystemListModel : NSObject

@property (nonatomic) NSString *create_time;
@property (nonatomic) NSString *create_user_id;
@property (nonatomic) NSString *aid;    //id
@property (nonatomic) NSString *img;
@property (nonatomic) NSString *is_read;
@property (nonatomic) NSString *jump_id;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *type;


@property (nonatomic) SChatSystemListBannerInfo *SChatSystemListBannerInfo;
@property (nonatomic) SChatSystemListCreateUserInfo *SChatSystemListCreateUserInfo;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
