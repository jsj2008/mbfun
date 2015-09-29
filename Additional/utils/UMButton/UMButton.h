//
//  UMButton.h
//  newdesigner
//
//  Created by Miaoz on 14/10/24.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMButton : UIButton
@property(nonatomic,strong)UIImageView *rightImageView;
@property(nonatomic,strong)UIImageView *centerImageView;
@property(nonatomic,assign)BOOL isClick;//判断点击

@end
