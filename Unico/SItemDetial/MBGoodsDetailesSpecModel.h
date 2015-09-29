//
//  MBGoodsDetailesSpecModel.h
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBGoodsDetailesSpecModel : NSObject

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *lM_PROD_CLS_ID;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *stockList;
@property (nonatomic, assign) BOOL isUnStock;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
