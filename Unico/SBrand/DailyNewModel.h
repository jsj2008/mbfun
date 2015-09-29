//
//  DailyNewModel.h
//  Wefafa
//
//  Created by metesbonweios on 15/8/4.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ItemImgModel;

@interface DailyNewModel : NSObject
@property (nonatomic, copy) NSString *english_name;
@property (nonatomic, copy) NSString *aId;
@property (nonatomic, assign) BOOL is_love;
@property (nonatomic, copy) NSString *logo_img;
@property (nonatomic, copy) NSString *look_num;
@property (nonatomic, copy) NSString *pic_img;
@property (nonatomic, copy) NSString *story;
@property (nonatomic, copy) NSString *temp_id;
@property (nonatomic, copy) NSString *brand_code;

@property (nonatomic, copy) ItemImgModel *item_img;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

@interface ItemImgModel : NSObject
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *width;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end