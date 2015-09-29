//
//  MBOtherStoreUserInfoModel.h
//  Wefafa
//
//  Created by Jiang on 4/2/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBOtherStoreUserInfoModel : NSObject

@property (nonatomic, copy) NSString *headPortrait;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userSignature;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureUrl;
//@property (nonatomic, copy) NSString *gender;


//php新借口字段
@property (nonatomic, copy) NSString *back_img;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSNumber *head_v_type;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *user_id;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
