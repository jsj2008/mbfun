//
//  TemplateElement.m
//  newdesigner
//
//  Created by Miaoz on 14/10/21.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "TemplateElement.h"

@implementation TemplateElement
-(id)init{
    self= [super init];
    
    _layoutMappingList = [NSMutableArray new];
    _detailMappingList = [NSMutableArray new];
    
    return self;
}
@end
