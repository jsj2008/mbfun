//
//  ShoppingBagContentModel.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAddShoppingProductInfoModel.h"
#import "ShoppingBagCarInfoModel.h"

@interface ShoppingBagListModel : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) ShoppingBagCarInfoModel *cartInfo;
@property (nonatomic, strong) MBAddShoppingProductInfoModel *productInfo;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)modelArrayWithDataArray:(NSArray*)dataArray;

@end


@interface ShoppingBagContentModel : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *designerId;
@property (nonatomic, copy) NSString *designerName;
@property (nonatomic, strong) NSMutableArray *contentModelArray;

+ (NSMutableArray*)modelArrayWithDataArray:(NSArray*)dataArray;

@end