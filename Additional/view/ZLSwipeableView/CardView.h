//
//  CardView.h
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollocationInfo;
@interface CardView : UIView
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *skipImageView;
@property(nonatomic,strong)UIImageView *saveImageView;
@property(nonatomic,strong)CollocationInfo *collocationInfo;
//@property(nonatomic,strong)UILabel *leftLab;
//@property(nonatomic,strong)UILabel *rightLab;
@end
