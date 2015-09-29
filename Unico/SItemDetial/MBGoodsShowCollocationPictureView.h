//
//  MBGoodsShowCollocationPictureView.h
//  Wefafa
//
//  Created by Jiang on 5/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBGoodsShowCollocationPictureViewDelegate <NSObject>

- (void)showCollocationViewSelectedIndex:(int)index;

@end

@interface MBGoodsShowCollocationPictureView : UIView

@property (nonatomic, assign) id<MBGoodsShowCollocationPictureViewDelegate> delegate;
//-----搭配图片
@property (strong, nonatomic) NSArray *contentModelArray;


@end
