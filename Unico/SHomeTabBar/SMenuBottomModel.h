//
//  SMenuBottomModel.h
//  Wefafa
//
//  Created by Funwear on 15/8/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMenuLayoutButtonConfigModel;

@interface SMenuBottomModel : NSObject

@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *bottom_type;
@property (nonatomic, strong) NSNumber *is_web;
@property (nonatomic, strong) NSNumber *top_height;
@property (nonatomic, strong) NSNumber *top_width;
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, copy) NSString *aID;    //id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *bottom_config;
@property (nonatomic, copy) NSString *top_img;
@property (nonatomic, copy) NSString *normall_img;
@property (nonatomic, copy) NSString *selected_img;
@property (nonatomic, copy) NSString *web_url;

@property (nonatomic, strong) SMenuLayoutButtonConfigModel *button_config;

- (instancetype)initWithDictionary:(NSDictionary*)dic;

@end

@interface SMenuLayoutButtonConfigModel : NSObject

@property (nonatomic, strong)NSArray *left;
@property (nonatomic, strong)NSArray *right;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
