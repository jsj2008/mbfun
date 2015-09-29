//
//  CustomGridCell.h
//  Wefafa
//
//  Created by mac on 14-8-28.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

//缺省grid
@protocol CustomGridDelegate <NSObject>

-(void)grid:(id)sender dataForIndex:(int)gridIndex;
@optional
-(void)click:(id)sender forIndex:(int)index;

@end

@interface CustomGridCell : UIView
{
}

@property (assign,nonatomic) id<CustomGridDelegate> delegate;
@property (assign,nonatomic) int gridIndex;
@property (retain,nonatomic) NSString * defaultImageName;
@property (retain,nonatomic) UIImageView *image;
@property (retain,nonatomic) UILabel *namelabel;

+(float)MinGridHeight;

@end

