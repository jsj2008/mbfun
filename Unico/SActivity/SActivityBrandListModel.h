//
//  SActivityBrandListModel.h
//  Wefafa
//
//  Created by unico_0 on 6/12/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SActivityBrandListModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *favoritE_COUNT;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *markeT_PRICE;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *branD_ID;
@property (nonatomic, copy) NSString *clsPicUrl;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
