//
//  SMIneAddProductViewController.h
//  Wefafa
//
//  Created by Jiang on 15/9/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"
#import "SAddProductTagViewControlCenter.h"
#import "SProductTagEditeInfo.h"

@interface SMIneAddProductViewController : SBaseViewController

@property(strong, readwrite, nonatomic)UIImage *productImage;//单品截图
@property(strong, readwrite, nonatomic)UIImage *originalImage;//如果是给图片创建标签的话就是原图

@property(strong, readwrite, nonatomic)NSURL *videoURL;//如果是给视频创建标签的话就是视频

@property(strong, readwrite, nonatomic) void(^back)(void);

//@property(strong, readwrite, nonatomic) void(^didFinish)(void);

@property(strong, readwrite, nonatomic) void(^didFinishEdit)(SProductTagEditeInfo *productTagEditeInfo);


@property(strong, readonly, nonatomic)SProductTagEditeInfo *productTagEditeInfo;

@property(copy, readwrite, nonatomic) NSString *productId;


- (void)setTagIndex:(int)tagIndex;

- (void)setTagViewCenter:(CGPoint)center;

- (void)setTagViewFlip:(BOOL)flip;


- (void)setProductCategoryWithCategoryId:(NSString *)categoryId categoryName:(NSString *)categoryName subCategoryId:(NSString *)subCategoryId subCategoryCode:(NSString *)subCategoryCode subCategoryName:(NSString *)subCategoryName;

- (void)setProductColorWithColorId:(NSString *)colorId colorCode:(NSString *)colorCode colorName:(NSString *)colorName;

- (void)setProductBrandWithBrandId:(NSString *)brandId brandCode:(NSString *)brandCode brandName:(NSString *)brandName;

@end
