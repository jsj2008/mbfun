//
//  SActivutyOptimalTool.h
//  Wefafa
//
//  Created by unico_0 on 6/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SActivityPromPlatModel;

@interface SActivutyOptimalTool : NSObject

+ (NSDictionary *)activityOptimalForPromPlatModelArray:(NSArray*)promPlatModelArray price:(CGFloat)price paramer:(CGFloat)paramer;
+ (SActivityPromPlatModel *)optimalForFullCountModelArray:(NSArray*)promPlatModelArray;
+ (SActivityPromPlatModel *)optimalForFullMoneyOrProductModelArray:(NSArray*)promPlatModelArray paramer:(CGFloat)paramer;

@end
