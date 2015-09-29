//
//  AttendCustomButton.h
//  Wefafa
//
//  Created by fafatime on 14-8-5.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ATTEND_CUSTOM_BUTTON_TYPE_UNDERLINE,
    ATTEND_CUSTOM_BUTTON_TYPE_BACKGROUND
}ATTEND_CUSTOM_BUTTON_TYPE;

typedef enum
{
    ATTEND_CLICK_SHOW_VIEW_PUSH, //新视图
    ATTEND_CLICK_SHOW_VIEW_MODAL //模态视图
}ATTEND_CLICK_SHOW_VIEW_TYPE;

@interface AttendCustomButton : UIButton
{
    UIImageView *itemImage;
    UILabel *titleLabel;
    UIImageView *clickImgView;
    UIImageView *rightLineImgView;
}
@property (nonatomic, retain)UIImageView *itemImage;
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UIImageView *clickImgView;
@property (nonatomic, assign)UIView *actionView;
@property (nonatomic, retain)UIImageView *rightLineImgView;

@property (assign,nonatomic) ATTEND_CLICK_SHOW_VIEW_TYPE showViewType;

@end
