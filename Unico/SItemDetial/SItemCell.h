//
//  SItemCell.h
//  Wefafa
//
//  Created by unico on 15/5/18.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandModel.h"
@interface SItemCell : UICollectionViewCell

-(void)updateSItemModel:(BrandSubItem*)model;
@end