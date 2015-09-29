//
//  SBaseTableViewCell.h
//  Wefafa
//
//  Created by unico on 15/5/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBaseTableViewCell : UITableViewCell
//标准的cell高度
@property  (nonatomic) float cellHeight;
//有变化的cell高度，图片，文字等变化
@property (nonatomic) float cellAdditionalHeight;
//选择的index
@property (nonatomic) NSInteger cellIndex;
@end
