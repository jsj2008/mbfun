//
//  CCButton.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCButton : UIButton


@property(strong, readonly, nonatomic)UIImageView *rightImageView;

@property(assign, readwrite, nonatomic)int customState;//自定义状态 供用户自行扩展

@end

