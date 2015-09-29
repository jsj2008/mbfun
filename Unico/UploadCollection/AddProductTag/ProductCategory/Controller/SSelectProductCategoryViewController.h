//
//  SSelectProductCategoryViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

#import "SCategorySubItemModel.h"
#import "SCategoryInfo.h"

@interface SSelectProductCategoryViewController : SBaseViewController


@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinishCategory)(NSString *productCategoryId, NSString *productCategoryName, NSString *productSubCategoryId, NSString *subCategoryCode, NSString *productSubCategoryName);

//单品
@property (nonatomic, strong) NSArray *bcurrentCategoryAry;

@end
