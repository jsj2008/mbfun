//
//  SLeftMainViewModel.h
//  Wefafa
//
//  Created by wave on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconJump : NSObject

@property (nonatomic, strong) NSString *aid;    //id
@property (nonatomic, strong) NSString *is_h5;
@property (nonatomic, strong) NSString *jump_type;
@property (nonatomic, strong) NSString *share;

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end


@interface Jump : NSObject

@property (nonatomic, strong) NSString *aid;    //id
@property (nonatomic, strong) NSString *is_h5;
@property (nonatomic, strong) NSString *jump_type;
@property (nonatomic, strong) NSString *share;

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end

@interface SLeftMainViewModel : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) IconJump *iconJump;
@property (nonatomic, strong) NSString *icon_jump_id;
@property (nonatomic, strong) NSString *index;

@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) Jump *jump;
@property (nonatomic, strong) NSString *jump_id;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *pic_img;

@property (nonatomic, strong) NSDictionary *JumpDic;        //cell Dictionary
@property (nonatomic, strong) NSDictionary *Icon_JumpDic;   //Icon cell Dictionary

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
