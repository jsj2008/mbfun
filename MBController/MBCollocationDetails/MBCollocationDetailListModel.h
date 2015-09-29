//
//  MBCollocationDetailListModel.h
//  Wefafa
//
//  Created by Jiang on 5/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBCollocationDetailListModel : NSObject

@property (nonatomic, strong) NSNumber *collocationId;
@property (nonatomic, strong) NSNumber *colorCode;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *productClsId;
@property (nonatomic, strong) NSNumber *productCode;
@property (nonatomic, strong) NSNumber *sourceType;
@property (nonatomic, strong) NSNumber *productPrice;

@property (nonatomic, copy) NSString *colorName;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPictureUrl;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end
