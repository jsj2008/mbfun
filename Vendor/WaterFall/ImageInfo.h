//
//  ImageInfo.h
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject

@property float width;
@property float height;
@property (nonatomic,strong) NSString *thumbURL;//图片
@property (nonatomic,strong) NSArray *clsPicUrl;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong) NSArray *prodList;
@property (nonatomic,strong) NSDictionary *imageData;
@property (nonatomic,strong) NSDictionary *clsInfo;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *stockCount;
@property (nonatomic,retain) NSString *favriteCount;
@property (nonatomic,retain) NSString *sharedCount;
@property (nonatomic,retain) NSString *commentCount;
@property (nonatomic,retain) NSString *browserCount;
@property (nonatomic,strong) NSArray *collocationList;
@property (nonatomic,strong) NSDictionary *collocationInfo;
@property (nonatomic,retain) NSString *goodIds;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic,strong) NSString *goodCode;
@property (nonatomic,strong) NSString *descriptionStr;
//@property (nonatomic,strong) NSString *showRegistPrice;


-(instancetype)initWithDictionary:(NSDictionary*)dictionary WithGood:(BOOL)goods WithBrand:(BOOL)Isbrand;


//新接口
@property (nonatomic,strong) NSString *market_price;
@property (nonatomic,strong) NSString *product_name;
@property (nonatomic,strong) NSString *product_sys_code;
@property (nonatomic,strong) NSString *product_url;
@property (nonatomic,strong) NSString *brandUrl;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSArray *spec_price_list;


@end
