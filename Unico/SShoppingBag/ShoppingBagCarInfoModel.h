//
//  ShoppingBagCarInfoModel.h
//  Wefafa
//
//  Created by unico_0 on 15/5/25.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingBagCarInfoModel : NSObject

@property (nonatomic, strong) NSNumber *collocatioN_ID;
@property (nonatomic, strong) NSNumber *coloR_ID;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *proD_ID;
@property (nonatomic, strong) NSNumber *qty;
@property (nonatomic, strong) NSNumber *speC_ID;

@property (nonatomic, copy) NSString *collocationname;
@property (nonatomic, copy) NSString *designerId;
@property (nonatomic, copy) NSString *designerName;
@property (nonatomic, copy) NSString *sharE_SELLER_ID;
@property (nonatomic, copy) NSString *userId;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
