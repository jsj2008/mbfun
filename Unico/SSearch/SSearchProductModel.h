//
//  SSearchProductModel.h
//  Wefafa
//
//  Created by unico_0 on 6/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSearchProductModel : NSObject

//productCode = model.productColorCode;
//productCategoryName = model.name;
//productSubCategoryId = model.productColorCode;
//productColorName = model.productColorName;

//新添加
@property(copy, readwrite, nonatomic)NSString *productColorId;//单品颜色id
@property(copy, readwrite, nonatomic)NSString *productColorCode;//单品颜色code
@property(copy, readwrite, nonatomic)NSString *productColorName;//单品颜色名称
//

@property (nonatomic, strong) NSNumber *branD_ID;
@property (nonatomic, strong) NSNumber *colL_COUNT;
@property (nonatomic, strong) NSNumber *collocationCount;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *sale_price;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *stockCount;
@property (nonatomic, strong) NSNumber *uP_COUNT;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *brandUrl;
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *mainImage;
@property (nonatomic, copy) NSString *marketTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *offLineTime;
@property (nonatomic, copy) NSString *plaN_LIST_TIME;
@property (nonatomic, copy) NSString *plaN_UNLIST_TIME;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *salE_ATTRIBUTE;

@property (nonatomic, strong) NSMutableArray *prodClsTag;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray;
+ (NSMutableArray *)modelArrayForCategaryDataArray:(NSArray*)dataArray;

@end

@interface SSearchProductShowTagModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *tagType;

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *tagUrl;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end
