//
//  HomeCellModel.h
//  Wefafa
//
//  Created by su on 15/3/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchCollocationInfo.h"
#import "FoundCellModel.h"

@interface HomeCellModel : NSObject
@property(nonatomic,strong)SearchCollocationInfo *collocationInfo;
@property(nonatomic,strong)FoundCellModel *userEntity;
@property(nonatomic,strong)NSDictionary *tagDict;
@property(nonatomic,strong)NSDictionary *originalDict;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

