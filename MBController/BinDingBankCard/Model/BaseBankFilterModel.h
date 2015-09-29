//
//  BaseBankFilterModel.h
//  Wefafa
//
//  Created by Jiang on 2/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseBankFilterModel : NSObject

@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *carD_NAME;
//@property (nonatomic, strong) NSNumber *acC_LENGTH;
//@property (nonatomic, copy) NSString *acC_EXAMPLE;
//@property (nonatomic, strong) NSNumber *marK_LENGTH;
//@property (nonatomic, copy) NSString *marK_STRING;
@property (nonatomic, copy) NSString *carD_TYPE;
@property (nonatomic, copy) NSString *shorT_CODE;
//@property (nonatomic, copy) NSString *creatE_DATE;
//@property (nonatomic, copy) NSString *creatE_USER;
//@property (nonatomic, copy) NSString *lasT_MODIFIED_DATE;
//@property (nonatomic, copy) NSString *lasT_MODIFIED_USER;
//@property (nonatomic, copy) NSString *remark;


- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
