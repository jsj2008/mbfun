//
//  SProductDetailModel.h
//  Wefafa
//
//  Created by Jiang on 8/2/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "MBGoodsDetailsModel.h"

/** */
@interface SProductDetailModel : NSObject

@property (nonatomic, strong) MBGoodsDetailsModel *goodsDetailModel;
@property (nonatomic, strong) NSArray *activtiyArray;
@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, strong) NSArray *sizeList;
@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) BOOL isNoneData;
@property (nonatomic, assign) BOOL isShowActivity;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

/** */
@interface SProductDetailTagModel : NSObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end

/** */
@interface SProductDetailActivityModel : NSObject

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *tag_img;//web_url
@property (nonatomic, copy) NSString *web_url;
@property (nonatomic, copy) NSString *json;//加入购物袋 需要传入json
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
