//
//  MyBankCardModel.h
//  Wefafa
//
//  Created by Jiang on 2/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBankCardModel : NSObject

//aID = 72339;
//"banK_NAME" = "\U4ea4\U901a\U94f6\U884c";
//"carD_NAME" = "\U54e6\U95ee\U95ee\U4e86";
//"carD_NO" = 6222620100156245010;
//"carD_TYPE" = "\U501f\U8bb0\U5361";
//"iS_DEFAULT" = 1;
//"shorT_CODE" = BCM;
//state = 1;
//userId = "165ea06d-b3fe-4a32-9e20-27a6af05c9cf";
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, copy) NSString *banK_NAME;
@property (nonatomic, copy) NSString *carD_NAME;
@property (nonatomic, copy) NSString *carD_NO;
@property (nonatomic, copy) NSString *carD_TYPE;
@property (nonatomic, copy) NSNumber *iS_DEFAULT;
@property (nonatomic, copy) NSString *shorT_CODE;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *userId;


- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
