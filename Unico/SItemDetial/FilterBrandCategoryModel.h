//
//  FilterBrandCategoryModel.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterBrandCategoryModel : NSObject

@property (nonatomic, strong) NSNumber *hotFlag;
@property (nonatomic, strong) NSNumber *aID;

@property (nonatomic, copy) NSString *brand_code;
@property (nonatomic, copy) NSString *branD_NAME;
@property (nonatomic, copy) NSString *aDescription;
@property (nonatomic, copy) NSString *logO_URL;
@property (nonatomic, copy) NSString *mainUrl;
@property (nonatomic, copy) NSArray *picUrls;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *first_letter;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSMutableArray*)dataArray;

@end
