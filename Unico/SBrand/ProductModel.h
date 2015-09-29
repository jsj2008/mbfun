//
//  ProductModel.h
//  Wefafa
//
//  Created by wave on 15/8/5.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
//{
//    clsInfo =     {
//        "branD_ID" = 2;
//        brand = "ME&CITY";
//        brandUrl = "http://img.mixme.cn/sources/designer/BrandLogo/1768d56b-f16a-4586-9e7a-8f262b21be8a.png";
//        code = 549092;

//        "colL_COUNT" = 4;
//        collocationCount = 4;
//        favoriteCount = 35;
//        id = 84007;

//        mainImage = "http://img.mixme.cn/sources/designer/ProdCls/c655febe-6018-42b7-b552-54a23dab38ec.jpg";
//        marketTime = "/Date(1439395200000-0000)/";
//        name = "\U7537\U9e82\U76ae\U7ed2\U9488\U7ec7\U88e4";
//        offLineTime = "/Date(631123200000-0000)/";

//        "plaN_LIST_TIME" = "/Date(1439395200000-0000)/";
//        "plaN_UNLIST_TIME" = "/Date(631123200000-0000)/";
//        price = 399;
//        remark = "\U7537\U9e82\U76ae\U7ed2\U9488\U7ec7\U88e4\U2014CMS\U5bfc\U5165";

//        "salE_ATTRIBUTE" = "\U96f6\U552e";
//        "sale_price" = 399;
//        status = 2;
//        stockCount = 393;

//        "uP_COUNT" = 0;
//    };
//    colorList =     (
//                     {
//                         baseColorId = 10;
//                         colorCode = 90;
//                         colorId = 212517;
//                         colorName = "\U9ed1\U8272\U7ec4";
//                         height = 600;
//                         picUrls =             (
//                                                "http://img.mixme.cn/sources/designer/ProdColor/5e116db8-ef79-4ab1-a67b-a39bd211199d.png"
//                                                );
//                         "pnG_FLAG" = 1;
//                         width = 251;
//                     }
//                     );
//    isFavorite = 0;
//    prodClsTag =     (
//                      {
//                          id = 1;
//                          remark = "\U5907\U6ce8\U4e3a\U7a7a";
//                          tagName = "\U65b0\U54c1";
//                          tagType = 0;
//                          tagUrl = "http://metersbonwe.qiniucdn.com/xinpingtubiao.png";
//                      }
//                      );
//}
 */
//clsInfo
@interface clsInfo : NSObject
@property (nonatomic, strong) NSString *branD_ID;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *brandUrl;
@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *colL_COUNT;
@property (nonatomic, strong) NSString *collocationCount;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSString *aid;        //id

@property (nonatomic, strong) NSString *mainImage;
@property (nonatomic, strong) NSString *marketTime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *offLineTime;

@property (nonatomic, strong) NSString *plaN_LIST_TIME;
@property (nonatomic, strong) NSString *plaN_UNLIST_TIME;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *salE_ATTRIBUTE;
@property (nonatomic, strong) NSString *sale_price;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *stockCount;

@property (nonatomic, strong) NSString *uP_COUNT;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
//colorList
@interface colorList : NSObject

@property (nonatomic, strong) NSString *baseColorId;
@property (nonatomic, strong) NSString *colorCode;
@property (nonatomic, strong) NSString *colorId;
@property (nonatomic, strong) NSString *colorName;

@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSMutableArray *picUrls_Array;  //picUrls
@property (nonatomic, strong) NSString *pnG_FLAG;
@property (nonatomic, strong) NSString *width;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end

//prodClsTag
@interface prodClsTag : NSObject

@property (nonatomic, strong) NSString *aid;                //id
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *tagType;

@property (nonatomic, strong) NSString *tagUrl;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end

@interface ProductModel : NSObject
@property (nonatomic, strong) NSString *isFavorite;
@property (nonatomic, strong) clsInfo *cls_info;
@property (nonatomic, strong) NSMutableArray *colorList_array;
@property (nonatomic, strong) NSMutableArray *prodClsTag_array;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
