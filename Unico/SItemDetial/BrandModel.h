//
//  BrandModel.h
//  Wefafa
//
//  Created by su on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BrandSubItem;

@interface BrandModel : NSObject
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSNumber *idValue;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *parent_id;
@property(nonatomic,strong)NSString *proD_CATEGORY_FLAG;
@property(nonatomic,strong)NSNumber *sorT_NO;
@property(nonatomic,strong)NSArray *subItems;

- (id)initWithBrandDict:(NSDictionary *)dict;
@end

@interface BrandSubItem : NSObject
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *idValue;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *parent_id;
@property(nonatomic,strong)NSString *proD_CATEGORY_FLAG;
@property(nonatomic,strong)NSNumber *sorT_NO;
@property(nonatomic,strong)NSString *tiP_FLAG;
@property(nonatomic,strong)NSString *url;

- (id)initWithDict:(NSDictionary *)dict;
@end
