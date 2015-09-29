//
//  MBGoodsDetailListModel.h
//  Wefafa
//
//  Created by Jiang on 5/8/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBGoodsDetailInfomationModel.h"
#import "MBGoodsDetailsModel.h"

@interface MBGoodsDetailListModel : NSObject

@property (nonatomic, strong) MBGoodsDetailInfomationModel *detailInfo;
@property (nonatomic, strong) MBGoodsDetailsModel *proudctList;

- (instancetype)initWithDictionary:(NSDictionary*)dict;
+ (NSArray *)modelArrayForDataArray:(NSArray*)dataArray;

@end
