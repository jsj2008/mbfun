//
//  BrandListTableCell.h
//  Wefafa
//
//  Created by CesarBlade on 15-4-1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandListCellModel.h"
#import "UIImageView+AFNetworking.h"

@interface BrandListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong,nonatomic) NSMutableDictionary * cellDataDic;
- (void)updateCellInfo:(BrandListCellModel *)model;

@end
