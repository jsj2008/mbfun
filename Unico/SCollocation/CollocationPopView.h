//
//  CollocationPopView.h
//  Wefafa
//
//  Created by wave on 15/7/3.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol collocationPopViewDelegate <NSObject>
-(void)collocationPopViewSelected:(NSInteger)index;
@end

@interface CollocationPopView:UIView

@property(nonatomic,assign)id<collocationPopViewDelegate> delegate;

-(instancetype)initCollocationPopView:(CGRect)frame withIsMy:(BOOL)isMy;
-(void)showPop;
- (void)hidePop;
@end
