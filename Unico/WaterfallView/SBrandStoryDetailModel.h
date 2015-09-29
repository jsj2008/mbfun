//
//  SBrandStoryDetailModel.h
//  Wefafa
//
//  Created by unico_0 on 6/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBrandStoryDetailModel : NSObject

@property (nonatomic, strong) NSNumber *coll_count;
@property (nonatomic, strong) NSNumber *is_love;
@property (nonatomic, strong) NSNumber *like_count;
@property (nonatomic, strong) NSNumber *look_num;
@property (nonatomic, strong) NSNumber *item_count;
@property (nonatomic, copy) NSString *story;
@property (nonatomic, strong) NSMutableArray *like_user_list;

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *temp_id;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSString *brand_code;
@property (nonatomic, copy) NSString *english_name;
@property (nonatomic, copy) NSString *logo_img;
@property (nonatomic, copy) NSString *pic_img;

@property (nonatomic, strong) NSNumber *collocation_count;
@property (nonatomic, strong) NSMutableArray *collocation_list;
//新接口
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSNumber *ename;
@property (nonatomic, strong) NSMutableArray *itemList;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end

@interface SBrandStoryUserModel : NSObject

@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, strong) NSNumber *head_v_type;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *user_id;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
//品牌collocation
@interface SBrandListContentModel : NSObject

//@property (nonatomic, strong) NSNumber *aID;
//@property (nonatomic, strong) NSNumber *img_height;
//@property (nonatomic, strong) NSNumber *img_width;
//
//@property (nonatomic, copy) NSString *img;
//@property (nonatomic, copy) NSString *stick_img_url;
//@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, copy) NSString *brandUrl;
@property (nonatomic, copy) NSString *brand_id;
@property (nonatomic, copy) NSString *on_sale_date;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *product_sys_code;
@property (nonatomic, copy) NSString *product_url;

@property (nonatomic, strong) NSNumber *market_price;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *status;


- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end
