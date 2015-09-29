//
//  HomeTableViewCell.h
//  Wefafa
//
//  Created by su on 15/1/22.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStyleTableView.h"
#import "HomeCellModel.h"
#import "MBBrandModel.h"
#import "ShareRelated.h"

@protocol kHomeTableViewCellDelegate <NSObject>

- (void)kHomeTagDidSelect:(NSDictionary *)dict indexRow:(NSInteger)indexRow;
- (void)kShareWityType:(ShareReatedType)shareType withRow:(NSInteger)rowNum;

@end

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,weak) id<kHomeTableViewCellDelegate> delegate;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,weak) UIViewController *target;
@property (nonatomic,strong) UIView *cornerView;
@property (nonatomic,strong) UIView *cellSubView;

@property (nonatomic) NSInteger row;

- (void)updateHomeCell:(HomeSelectionModel*)model isFristRow:(BOOL)isFirstRow;
- (void)updateHomeCell:(HomeSelectionModel*)model;
@end
