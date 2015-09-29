//
//  SMessageBannerModel.h
//  Wefafa
//
//  Created by wave on 15/7/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMessageBannerModel : NSObject
@property (nonatomic) NSString *end_time;
@property (nonatomic) NSString *aid;
@property (nonatomic) NSString *img;
@property (nonatomic) NSString *img_height;
@property (nonatomic) NSString *img_width;

@property (nonatomic) NSString *index;
@property (nonatomic) NSString *is_h5;
@property (nonatomic) NSString *jump_id;
@property (nonatomic) NSString *jump_type;
@property (nonatomic) NSString *name;

@property (nonatomic) NSString *share;
@property (nonatomic) NSString *tid;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *url;

- (instancetype) initWithDic:(NSDictionary*)dic;
@end
