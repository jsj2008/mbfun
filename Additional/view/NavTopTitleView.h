//
//  NavTopTitleView.h
//  newdesigner
//
//  Created by Miaoz on 14/11/3.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NavTopTitleViewBlock) (id sender);

@interface NavTopTitleView : UIView
@property(nonatomic,strong)NavTopTitleViewBlock myblock;
@property(nonatomic,strong)NSString *colortype;
@property(nonatomic,strong)NSString  *buttonWide;
@property(nonatomic,strong)NSMutableArray *buttonarray;
@property(nonatomic,strong)NSArray *titlearray;
@property(nonatomic,strong)NSArray *whiteImageArray;
@property(nonatomic,strong)NSArray *blackImageArray;
-(void)navTopTitleViewBlockWithbuttontag:(NavTopTitleViewBlock) block;
@end
