//
//  CollocationDetailGridView.h
//  Wefafa
//
//  Created by mac on 14-9-18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"

@interface CollocationDetailGridView : UIView<UIUrlImageViewDelegate>
{
}

@property (retain, nonatomic) UIView *backgroundView;
@property (retain, nonatomic) UIUrlImageView *imageView;
@property (retain, nonatomic) UILabel *lbTitle;
@property (retain, nonatomic) UILabel *lbPrice;
@property (retain, nonatomic) UILabel *lbStatus;
@property (retain, nonatomic) UILabel *lbNoneStock;

@property (strong, nonatomic) id data;
@property (assign, nonatomic) int index;

@end
