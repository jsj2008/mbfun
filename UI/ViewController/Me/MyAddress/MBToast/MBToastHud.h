//
//  MBToastHud.h
//  Wefafa
//
//  Created by Miaoz on 15/7/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//
#import <UIKit/UIKit.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
#define HUD_STATUS_COLOR		[UIColor whiteColor]

#define HUD_SPINNER_COLOR		[UIColor whiteColor]//[UIColor colorWithRed:185.0/255.0 green:220.0/255.0 blue:47.0/255.0 alpha:1.0]
#define HUD_BACKGROUND_COLOR	[UIColor blackColor]//[UIColor colorWithWhite:0.0 alpha:0.1]
#define HUD_WINDOW_COLOR		[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]

#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"Unico/progresshud_success"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"Unico/progresshud_error"]

#define HUDWIDTH  180
#define HUDHEIGHT 100
//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface MBToastHud : UIView
//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (MBToastHud *)shared;

+ (void)dismiss;
//暂时这一个方法 status是文字 image是图片 spin是菊花 hide:间隔时间消失 Interaction是否屏蔽事件
+ (void)show:(NSString *)status image:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide Interaction:(BOOL)Interaction;


@property (nonatomic, assign) BOOL interaction;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *background;
@property (nonatomic, retain) UIView *hud;
@property (nonatomic,strong) UIView *sandwichView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *label;

@end
