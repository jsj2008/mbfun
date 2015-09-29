//
//  MBGoodsDetailsPictureModel.h
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBGoodsDetailsPictureModel : NSObject

@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *aID;
@property (nonatomic, strong) NSNumber *isMainImage;
@property (nonatomic, strong) NSNumber *srC_ID;
@property (nonatomic, strong) NSNumber *width;

@property (nonatomic, copy) NSString *filE_PATH;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *srC_TYPE;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)modelArrayForDataArray:(NSArray *)dataArray;

@end
