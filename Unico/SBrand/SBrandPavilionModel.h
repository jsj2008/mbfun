//
//  SBrandPavilionModel.h
//  Wefafa
//
//  Created by metesbonweios on 15/8/19.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//
/*

 {
 height = 250;
 img = "http://metersbonwe.qiniucdn.com/banner_pp10114.jpg";
 name = "\U58a8\U5320.";
 "temp_id" = 91;
 width = 750;
 },
 {
 height = 250;
 img = "http://metersbonwe.qiniucdn.com/banner_pp10146.jpg";
 name = "\U8877\U60c5\U96e8L-rain.";
 "temp_id" = 130;
 width = 750;
 },

 */

#import <Foundation/Foundation.h>

@interface SBrandPavilionModel : NSObject
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *temp_id;
@property (nonatomic, copy) NSString *brand_code;

@property (nonatomic, copy) NSString *name;
// 新的品牌馆列表
@property (nonatomic, assign) BOOL isCanShow;//是否展开
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy)NSString *idStr;
@property (nonatomic, copy)NSString *brand_img;

@property (nonatomic,strong)NSArray *banner;
@property (nonatomic,strong)NSString *brand_banner_type;


@property (nonatomic, strong)NSArray *brand_list;
@property (nonatomic, strong)NSArray *fixed_list;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;
@end
//brand_list
@interface BrandListModel : NSObject

@property (nonatomic,copy)NSString *brand_code;
@property (nonatomic,copy)NSString *logo_img;
@property (nonatomic,strong)NSArray*cateIdList;
@property (nonatomic,copy)NSString *cname;
@property (nonatomic,copy)NSString *ename;
@property (nonatomic,copy)NSString *english_name;
@property (nonatomic,copy)NSString *pic_img;
@property (nonatomic,copy)NSString *temp_id;


//fixed——list
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *name;

//banner
@property (nonatomic,copy)NSString *end_time;
@property (nonatomic,copy)NSString *img_height;
@property (nonatomic,copy)NSString *index;
@property (nonatomic,copy)NSString *is_h5;
@property (nonatomic,copy)NSString *jump_id;
@property (nonatomic,copy)NSString *jump_type;
@property (nonatomic,copy)NSString *share;
@property (nonatomic,copy)NSString *tid;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *url;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;
@end
