//
//  SFashionViewCell.h
//  Wefafa
//
//  Created by 凯 张 on 15/5/31.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBaseTableViewCell.h"


//typeof ns_option
typedef NS_OPTIONS(NSInteger, FashionCellType) {
    fashionCellTypeShowTransparentView = 1 << 1,
    fashionCellTypeHideTransparentView = 1 << 2
};

@interface SFashionViewCell : SBaseTableViewCell
@property (nonatomic, assign) FashionCellType type;
@property (nonatomic) NSDictionary *cellData;
-(void)updateCellUI;
@end
