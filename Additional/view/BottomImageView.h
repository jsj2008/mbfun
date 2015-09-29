//
//  BottomImageView.h
//  newdesigner
//
//  Created by Miaoz on 14-9-24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DraftVO;
@protocol BottomImageViewDelegate <NSObject>

@optional
-(void)callBackBottomImageViewWithImageView:(id)sender;

@end

@interface BottomImageView : UIImageView<UIGestureRecognizerDelegate>
@property(nonatomic,strong)DraftVO *draftVO;
@property(nonatomic,weak)id <BottomImageViewDelegate> delegate;
@end
