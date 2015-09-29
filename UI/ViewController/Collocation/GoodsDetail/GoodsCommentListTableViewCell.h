//
//  GoodsCommentListTableViewCell.h
//  Wefafa
//
//  Created by Jiang on 3/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCommentListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *subLabelMutableArray;

@property (nonatomic, strong) NSArray *contentArray;
- (instancetype)initWithSubViewsCount:(NSInteger)count sizeArray:(NSArray*)sizeArray cellSize:(CGSize)cellSize;
- (void)setContentArray:(NSArray*)array index:(NSInteger)index;

@end
