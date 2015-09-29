//
//  SProductDetailCommentModel.h
//  Wefafa
//
//  Created by Jiang on 8/4/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SProductDetailCommentModel : NSObject

@property (nonatomic, strong) NSNumber *iS_DELETED;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *satisfactioN_INDEX;
@property (nonatomic, strong) NSNumber *sourcE_ID;
@property (nonatomic, strong) NSNumber *sourcE_TYPE;
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *creatE_DATE;
@property (nonatomic, copy) NSString *creatE_USER;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *headPortrait;
@property (nonatomic, copy) NSString *lasT_MODIFIED_DATE;
@property (nonatomic, copy) NSString *lasT_MODIFIED_USER;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray*)modelArrayForDataArray:(NSArray*)dataArry;

@end
