//
//  ClothingCategoryFilterViewModel.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FilterGroup : NSObject

@property(copy, readwrite, nonatomic)NSString *groupName;
@property(strong, readwrite, nonatomic)NSArray *titles;
@property(strong, readwrite, nonatomic)NSArray *imageURLs;

@end


@interface ClothingCategoryFilterViewModel : NSObject

@property(strong, readwrite, nonatomic)NSArray *filterGroups;

@end
