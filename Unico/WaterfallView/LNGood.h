//
//  LNGood.h
//  WaterfallFlowDemo
//
//  Created by Lining on 15/5/3.
//  Copyright (c) 2015年 Lining. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface like_user_listModel : NSObject
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, strong) NSString *user_id;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end

@interface LNGood : NSObject
@property (nonatomic, assign) NSInteger h; // 商品图片高/img_height
@property (nonatomic, assign) NSInteger w; // 商品图片宽/img_width
@property (nonatomic, copy) NSString *img; // 商品图片地址
@property (nonatomic, copy) NSString *stick_img_url; // 贴纸图片
@property (nonatomic, copy) NSString *video_url; // 视频地址
@property (nonatomic, strong) NSString *product_ID; //id
@property (nonatomic, copy) NSString *price; // 商品价格

@property (nonatomic, strong) NSString *content_info;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, strong) NSString *is_love;
@property (nonatomic, strong) NSString *like_count;
@property (nonatomic, strong) NSString *comment_count;
@property (nonatomic, strong) NSArray *array_like_user_list; //SubModel
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *tag_list;
@property (nonatomic, strong) NSString *user_id;
//为了banner类型 添加的成员变量
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *is_h5;
@property (nonatomic, strong) NSNumber *jump_id;
@property (nonatomic, strong) NSNumber *jump_type;
@property (nonatomic, strong) NSNumber *show_type;
@property (nonatomic, strong) NSNumber *tid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *head_v_type;

@property (nonatomic, assign) BOOL ishidden;
@property (nonatomic, assign) CGFloat infoHeight;      //评论的高度 cell用

+ (instancetype)goodWithDict:(NSDictionary *)dict; // 字典转模型
+ (NSArray *)goodsWithIndex:(NSInteger)index; // 根据索引返回商品数组
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
