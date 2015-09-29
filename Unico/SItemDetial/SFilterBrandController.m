//
//  SFilterBrandController.m
//  Wefafa
//
//  Created by unico_0 on 7/16/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SFilterBrandController.h"
#import "FilterPirceRangeModel.h"
#import "FilterColorCategoryModel.h"
#import "FilterBrandCategoryModel.h"
#import "SFilterSelectedModel.h"

@interface SFilterBrandController ()

@end

@implementation SFilterBrandController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (IBAction)doneBtn:(id)sender {
    FilterPirceRangeModel *pirceRangeModel = nil;
//    FilterColorCategoryModel *colorModel = nil;
    
    NSIndexPath *indexPath = self.selectedIndexModel.firstCondition;
    if (indexPath) {
        pirceRangeModel = self.pirceRangeModelArray[indexPath.row];
        self.brandFilterDictionary[@"PriceId"] = pirceRangeModel.aID;
    }
    
//    indexPath = self.selectedIndexModel.secondCondition;
//    if (indexPath) {
//        colorModel = self.colorModelArray[indexPath.row];
//        self.brandFilterDictionary[@"ColorId"] = colorModel.aID;
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
