//
//  SDiscoveryHeaderMoudleTool.h
//  Wefafa
//
//  Created by Mr_J on 15/8/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDiscoveryFlexibleModel;

@interface SDiscoveryHeaderMoudleTool : NSObject

+ (CGFloat)getHeaderCellHeightWithModel:(SDiscoveryFlexibleModel*)model;
+ (UIView*)cellContentViewWithModel:(SDiscoveryFlexibleModel *)model;

@end
