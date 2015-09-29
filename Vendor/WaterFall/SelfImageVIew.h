//
//  SelfImageVIew.h
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"
#import "UIImageView+WebCache.h"
//间距5  10
#define SPACE 5
#define UPSPACE 1
#define WIDTH [UIScreen mainScreen].applicationFrame.size.width/2

@protocol ImageDelegate<NSObject>
-(void)clickImage:(ImageInfo*)data;
-(void)favriteBtnClick:(ImageInfo *)data;
@end

@interface SelfImageVIew : UIView
@property (nonatomic,assign)id<ImageDelegate> delegate;
@property (nonatomic,strong)ImageInfo *data;

-(id)initWithImageInfo:(ImageInfo*)imageInfo y:(float)y withA:(int)a withShowHeight:(BOOL)show withMyLike:(BOOL)isMyLike; 

@end
