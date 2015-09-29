//
//  StopicListModel.h
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopicListModel : NSObject

@property (nonatomic, strong) NSNumber *collocation_count;
@property (nonatomic, strong) NSString *aID;
@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, strong) NSArray *collocation_list;

@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *obl;
@property (nonatomic, copy) NSString *tag;

//@property (nonatomic, copy) NSString *collocationCount;
//@property (nonatomic, copy) NSString *collocation_list;
//@property (nonatomic, copy) NSString *concernCount;
//@property (nonatomic, copy) NSString *head_img;
//
//@property (nonatomic, copy) NSString *head_v_type;
//@property (nonatomic, copy) NSString *nick_name;
//@property (nonatomic, copy) NSString *user_id;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end

@interface StopicListContentModel : NSObject

@property (nonatomic, strong) NSString *aID;
@property (nonatomic, strong) NSNumber *img_height;
@property (nonatomic, strong) NSNumber *img_width;

@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *stick_img_url;
@property (nonatomic, copy) NSString *video_url;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArray;

@end