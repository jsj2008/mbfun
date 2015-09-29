//
//  CollocationElement.m
//  newdesigner
//
//  Created by Miaoz on 14-10-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "CollocationElement.h"

@implementation CollocationElement
-(id)init{
    self= [super init];
    
    _layoutMappingList = [NSMutableArray new];
    _topicMappingList = [NSMutableArray new];
    _tagMappingList = [NSMutableArray new];
    _detailMappingList = [NSMutableArray new];
    return self;
}
@end
