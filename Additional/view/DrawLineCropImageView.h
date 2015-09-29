//
//  DrawLineCropImageView.h
//  newdesigner
//
//  Created by Miaoz on 14-9-16.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBCroppableLayer.h"
#import <QuartzCore/QuartzCore.h>
@interface DrawLineCropImageView : UIImageView
@property(nonatomic,strong)  NSMutableArray *pointsArray;
@property(nonatomic,strong)  JBCroppableLayer *pointsView;

- (void)removePoint;
-(void)crop;
-(void)reverseCrop;
-(void)resetPointWithpointarray:(NSMutableArray *)oldPoints;
-(UIImage *)getCroppedImageWithTransparentBorders:(BOOL)transparent;
-(UIImage *)getCroppedImage;
@end
