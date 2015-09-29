//
//  MBGoodsDetailsModel.h
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBGoodsDetailsInfoModel : NSObject

@property (nonatomic, strong) NSNumber *colL_COUNT;
@property (nonatomic, strong) NSNumber *collocationCount;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *proD_FLAG;
@property (nonatomic, strong) NSNumber *sale_price;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *stockCount;
@property (nonatomic, strong) NSNumber *uP_COUNT;
@property (nonatomic, strong) NSNumber *branD_ID;

@property (nonatomic, copy) NSString *branD_Code;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *brandUrl;
@property (nonatomic, copy) NSString *aDescription;
@property (nonatomic, copy) NSString *marketTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *offLineTime;
@property (nonatomic, copy) NSString *plaN_LIST_TIME;
@property (nonatomic, copy) NSString *plaN_UNLIST_TIME;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *salE_ATTRIBUTE;
@property (nonatomic, copy) NSString *statusname;
@property (nonatomic, copy) NSString *mainImage;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
