//
//  FoundTableViewCell.h
//  Wefafa
//
//  Created by su on 15/1/29.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "FoundCellModel.h"

@interface FoundTableViewCell : UITableViewCell
- (void)updateCellInfo:(FoundCellModel *)model;
@end
