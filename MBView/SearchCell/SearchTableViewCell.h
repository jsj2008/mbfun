//
//  SearchTableViewCell.h
//  Wefafa
//
//  Created by su on 15/1/27.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "CollocationSearchModel.h"
#import "SearchCollocationInfo.h"
#import "SearchProduct.h"

@protocol kSearchCollocationTableCellDelegate <NSObject>

- (void)kSearchCollocationCellHeaderImageClick:(SearchCollocationInfo *)model;
- (void)kSearchCollocationCellCollocationImageClick:(SearchCollocationInfo *)model;

@end

@interface SearchTableViewCell : UITableViewCell
@property(nonatomic,weak)id<kSearchCollocationTableCellDelegate> delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCollocation:(BOOL)isCollocation;
- (void)updateCellContentWithLeftModel:(SearchCollocationInfo *)leftModel rightModel:(SearchCollocationInfo *)rightModel;

- (void)updateProducttWithLeftModel:(SearchProduct *)leftModel rightModel:(SearchProduct *)rightModel;
@end
