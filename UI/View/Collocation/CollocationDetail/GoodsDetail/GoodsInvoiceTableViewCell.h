//
//  GoodsInvoiceTableViewCell.h
//  Wefafa
//
//  Created by Miaoz on 14/12/12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextVIew.h"
@interface GoodsInvoiceTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *placeHolderTextView;


@end
