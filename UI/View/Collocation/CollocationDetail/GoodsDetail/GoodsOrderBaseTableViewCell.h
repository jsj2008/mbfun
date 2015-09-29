//
//  GoodsOrderBaseTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"
#import "CommonEventHandler.h"
@interface GoodsOrderBaseTableViewCell : UITableViewCell<UIUrlImageViewDelegate>

@property (strong, nonatomic) id data;
@property (assign, nonatomic) NSInteger rownum;
@property (strong, nonatomic) CommonEventHandler *onTextFieldScroll;
@property (strong, nonatomic) CommonEventHandler *onTextChanged;

+(int)getCellHeight:(id)data1;

@end
