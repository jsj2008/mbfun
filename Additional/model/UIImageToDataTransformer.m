//
//  UIImageToDataTransformer.m
//  newdesigner
//
//  Created by Miaoz on 14-9-19.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "UIImageToDataTransformer.h"

@implementation UIImageToDataTransformer

+ (BOOL)allowsReverseTransformation{
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
    return [[UIImage alloc] initWithData:value];
}
@end
