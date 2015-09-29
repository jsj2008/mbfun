//
//  CustomScrollView.h
//  newdesigner
//
//  Created by Miaoz on 14/10/20.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CustomScrollViewBlock) (id sender);


@interface CustomScrollView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,strong)CustomScrollViewBlock myblock;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *button;


-(void)customScrollViewBlockWithscrollView:(CustomScrollViewBlock) block;
@end
