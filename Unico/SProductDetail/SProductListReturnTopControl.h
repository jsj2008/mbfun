//
//  SProductListReturnTopControl.h
//  Wefafa
//
//  Created by PHM on 9/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SProductListReturnTopControlDelegate;
@interface SProductListReturnTopControl : UIControl
@property (nonatomic, strong) UIImageView *returnTopImageView;              //返回顶端 图标
@property (nonatomic, assign) id<SProductListReturnTopControlDelegate> delegate;

@end

@protocol SProductListReturnTopControlDelegate <NSObject>

@optional
/**
 *	@简要 单击图标 返回顶端
 */
-(void)returnTopControlClick;

@end