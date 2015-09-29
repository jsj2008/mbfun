//
//  CommunityAttentionMasterModel.h
//  Wefafa
//
//  Created by wave on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityAttentionMasterModel : NSObject
@property (nonatomic, strong) NSString *head_img;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *concernCount;
@property (nonatomic, assign) BOOL isConcerned;     //默认为关注
- (instancetype)initWithDic:(NSDictionary*)dic;

@end
