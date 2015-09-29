//
//  SSearchBrandTableView.h
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSearchBrandTableViewDelegate <NSObject>

- (void)listViewDidScroll:(UIScrollView *)scrollView;

@end

@interface SSearchBrandTableView : UITableView

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) id<SSearchBrandTableViewDelegate> brandDelegate;
@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@property (nonatomic, strong) NSNumber *isHotData;

@end

@interface SSearchBrandTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end