//
//  ShareTopView.h
//  Wefafa
//
//  Created by Miaoz on 14/12/1.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BUTTONTAG 70

@protocol ShareTopViewDelegate <NSObject>

-(void)callBackShareTopViewWithShareButton:(id)sender;

@end

@interface ShareTopView : UIView
@property(nonatomic,strong)UIImageView *mainShowImage;
@property(nonatomic,strong) UIButton *selectButton;

@property(nonatomic,weak)id <ShareTopViewDelegate> delegate;

@property(nonatomic,strong)UIView *parentView;
@end
