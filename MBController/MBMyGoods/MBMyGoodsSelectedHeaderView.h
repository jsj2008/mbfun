//
//  MBMyGoodsSelectedHeaderView.h
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MBMyGoodsSelectedHeaderViewDelegate <NSObject>

- (void)goodsSelectedButtonIndex:(int)index;

@end

@interface MBMyGoodsSelectedHeaderView : UIView

@property (assign, nonatomic) id<MBMyGoodsSelectedHeaderViewDelegate> delegate;

- (void)selectedButtonForIndex:(int)index;

@end
