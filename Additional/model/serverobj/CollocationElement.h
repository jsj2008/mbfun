//
//  CollocationElement.h
//  newdesigner
//
//  Created by Miaoz on 14-10-11.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollocationInfo.h"
#import "TopicMapping.h"
#import "TagMapping.h"
#import "LayoutMapping.h"
#import "DetailMapping.h"
@interface CollocationElement : NSObject
@property(strong,nonatomic)CollocationInfo *collocationInfo;
@property(strong,nonatomic)NSMutableArray *layoutMappingList;
@property(strong,nonatomic)NSMutableArray *topicMappingList;
@property(strong,nonatomic)NSMutableArray *tagMappingList;
@property(strong,nonatomic)NSMutableArray *detailMappingList;
@end
