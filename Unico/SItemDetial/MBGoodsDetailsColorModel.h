//
//  MBGoodDetailsColorModel.h
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBGoodsDetailsColorModel : NSObject

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *lM_PROD_CLS_ID;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picurl;

@property (nonatomic, strong) NSArray *stockList;
@property (nonatomic, assign) BOOL isUnStock;
@property (nonatomic, assign) NSInteger selectedSizeId;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
