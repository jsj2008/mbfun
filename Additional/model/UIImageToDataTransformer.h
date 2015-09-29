//
//  UIImageToDataTransformer.h
//  newdesigner
//
//  Created by Miaoz on 14-9-19.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageToDataTransformer : NSValueTransformer

+ (BOOL)allowsReverseTransformation;
+ (Class)transformedValueClass;
- (id)transformedValue:(id)value;
- (id)reverseTransformedValue:(id)value;
@end
