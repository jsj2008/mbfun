//
//  SMDataModel.h
//  Wefafa
//
//  Created by su on 15/6/3.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDataModel : NSObject
@property(nonatomic,strong)NSString *idValue;
@property(nonatomic,strong)NSString *content_info;
@property(nonatomic,strong)NSString *stick_img_url;
@property(nonatomic,strong)NSString *head_img;
@property(nonatomic,strong)NSNumber *is_love;
@property(nonatomic,strong)NSString *mbfun_id;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *nick_name;
@property(nonatomic,strong)NSString *mbfun_code;
@property(nonatomic,strong)NSString *like_count;
@property(nonatomic,strong)NSString *img_width;
@property(nonatomic,strong)NSString *img_height;
@property(nonatomic,strong)NSString *video_url;
@property(nonatomic,strong)NSString *tag_list;
@property(nonatomic,strong)NSString *create_time;
@property(nonatomic,strong)NSNumber *head_v_type;
@property(nonatomic,strong)NSNumber *comment_count; //7.31

@property(nonatomic,assign)BOOL isHidden;//是否隐藏标签

@property(nonatomic,strong)NSMutableArray *likeUserArray;
//@property(nonatomic,strong)NSArray *commentArray;   //7.31评论列表
@property(nonatomic,strong, readwrite) NSMutableArray *commentArray;   //7.31评论列表

@property (nonatomic,assign) CGFloat cellHeight;    //cell高度
@property (nonatomic, assign) CGFloat commentHeight;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface SMLikeUser : NSObject
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *head_img;
@property(nonatomic,strong)NSNumber *head_v_type;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end


@interface SMBannerModle : NSObject
@property(nonatomic,strong)NSString *idValue;
@property(nonatomic,strong)NSString *index;
@property(nonatomic,strong)NSString *jump_id;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *jump_type;
@property(nonatomic,strong)NSString *is_h5;
@property(nonatomic,strong)NSString *img_width;
@property(nonatomic,strong)NSString *img_height;
@property(nonatomic,strong)NSString *end_time;
@property(nonatomic,strong)NSString *tid;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *show_type;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

/**
 *  评论信息模型
 */
@interface SMCommentInfo : NSObject

@property(nonatomic,strong)NSString *head_img;
@property(nonatomic,strong)NSString *head_v_type;
@property(nonatomic,strong)NSString *info;
@property(nonatomic,strong)NSString *nick_name;

@property(nonatomic,strong)NSString *to_user_nick_name;
@property(nonatomic,strong)NSString *to_user_user_id;

@property(nonatomic,strong)NSString *to_user_id;
@property(nonatomic,strong)NSString *user_id;

@property(nonatomic,assign) CGFloat info_Height;    //计算评论内容每行高度

@property (nonatomic, strong) NSMutableString *commentText;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end