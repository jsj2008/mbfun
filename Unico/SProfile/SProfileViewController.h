//
//  SProfileViewController.h
//  Wefafa
//
//  Created by unico on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SProfileViewController : UIViewController
{
    UIView *contentView;
}
@property (nonatomic) UICollectionView *collectionView;
// 当前的数据索引
@property (nonatomic, assign) NSInteger headerViewHeight;
//添加标签和闪烁动画
-(void)addTag:(NSString*) str fontStyle:(UIFont*)fontStyle imageView:(UIImageView*)imageView point:(CGPoint)point;
-(UIImage*)getArrowLine;
-(UIImage*)getNormalLine;
@end