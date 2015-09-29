//
//  SCollocationDetailModel.h
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryBannerModel.h"
#import "SDiscoveryUserModel.h"
#import "SCollocationGoodsTagModel.h"
#import "MBGoodsDetailsModel.h"
#import "SCollocationSubProductModel.h"

@interface SCollocationDetailModel : NSObject

@property (nonatomic, strong) NSNumber *comment_count;
@property (nonatomic, strong) NSNumber *comment_score;
@property (nonatomic, strong) NSString *aID;
@property (nonatomic, strong) NSNumber *img_height;
@property (nonatomic, strong) NSNumber *img_width;
@property (nonatomic, strong) NSNumber *isFind;
@property (nonatomic, strong) NSNumber *is_love;
@property (nonatomic, strong) NSNumber *like_count;
@property (nonatomic, copy) NSString *mbfun_code;
@property (nonatomic, copy) NSString *mbfun_id;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *sale_price;

@property (nonatomic, copy) NSString *content_info;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *item_str;
@property (nonatomic, copy) NSString *stick_img_url;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *fromControllerName;
@property (nonatomic, copy) NSString *brand_str;

@property (nonatomic, strong) NSArray *itemIdArray;
@property (nonatomic, strong) NSArray *useBrand;
@property (nonatomic, strong) NSMutableArray *brandArray;
@property (nonatomic, strong) NSMutableArray *tab_str;
@property (nonatomic, strong) NSMutableArray *tag_list;
@property (nonatomic, strong) NSArray *banner;
@property (nonatomic, strong) SDiscoveryUserModel *designer;
@property (nonatomic, strong) NSMutableArray *like_user_list;
@property (nonatomic, strong) NSArray *productArray;
@property (nonatomic, strong) NSArray *product_list;
@property (nonatomic, strong) NSDictionary *user_json;

@property (nonatomic, strong) NSString *mb_collocationId;
@property (nonatomic, strong) NSArray *promPlatModelArray;
@property (nonatomic, strong) NSString * promotion_ID;
@property (nonatomic, assign) BOOL isNoneShopping;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end

@interface SCollocationDetailTagTypeModel : NSObject

@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, copy) NSString *topicID;
@property (nonatomic, assign) BOOL isTopic;

@end
