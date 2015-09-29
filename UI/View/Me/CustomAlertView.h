//
//  CustomAlertView.h
//  Wefafa
//
//  Created by fafatime on 15-1-29.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CustomAlertViewType_Msg_TwoBtn=1,//含有title，提示内容以及两个button.
    CustomAlertViewType_Msg_OneBtn,//含有title，提示内容以及一个button.
    CustomAlertViewType_Msg_NOBtn,//没btn
    CustomAlertViewType_ActivityIndiAndMsg_OneBtn, //含有title，UIActivityIndicatorView控件,提示内容以及一个button.
    CustomAlertViewType_Msg_TextField_TwoBtn,
    CustomAlertViewType_JalBreakBuy_Login,
    CustomAlertViewType_RemindTime,
    
}CustomAlertViewType;

@protocol CustomAlertViewDelegate;
@interface CustomAlertView : UIView<UITextFieldDelegate>

{
    CustomAlertViewType _alertViewType;
    id <CustomAlertViewDelegate> _customDelegate;
    
    UILabel* titleLabel;
    UILabel* contentLabel;
    
    UIButton* leftBtn;
    UIButton* rightBtn;
    UIButton* centerBtn;
    
    UIActivityIndicatorView *indicatorView;
    
    UITextField* textField;
    
    UIView* _alertView;
    UIView* _bgView;
    
}
@property (nonatomic,assign) id<CustomAlertViewDelegate> customDelegate;
@property (nonatomic,retain) UILabel* contentLabel;
@property (nonatomic,assign) UITextField* textField;
@property (nonatomic,assign) int buttonTag;

//含有title，提示内容以及两个button.
- (id)initWithTitle:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle delegate:(id<CustomAlertViewDelegate>) _delegate;
//图片
- (id)initWithImage:(NSString *)imageName msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle  delegate:(id<CustomAlertViewDelegate>) _delegate;


- (id)initWithTitle:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle delegate:(id<CustomAlertViewDelegate>) _delegate msgFontSize:(CGFloat)fontSize;

//含有title，提示内容以及一个button.
- (id)initWithTitle:(NSString*)title  msg:(NSString*)msg centerBtnTitle:(NSString*)centerTitle;

//含有title，UIActivityIndicatorView控件,提示内容以及一个button.
- (id)initProgressAlertViewWithTitle:(NSString*)title  msg:(NSString*)msg centerBtnTitle:(NSString*)centerTitle delegate:(id<CustomAlertViewDelegate>) _delegate;

//含有title，textfield，提示内容以及两个button.
- (id)initTextFieldWithTitle:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle delegate:(id<CustomAlertViewDelegate>) _delegate;

//含title,两个button，密码输入textfield，用户名等提示信息
-(id)initLoginWithDelegate:(id<CustomAlertViewDelegate>)delegate userId:(NSString*)userid title:(NSString*)strTitle rightBtnTitle:(NSString*)strRbt;

- (id)initRemindAlert;

-(void) show;
- (void) hideAlertView;

-(void) setTitle:(NSString*) title;
@end

@protocol CustomAlertViewDelegate <NSObject>

@optional

- (void) leftBtnPressedWithinalertView:(CustomAlertView*)alert;
- (void) rightBtnPressedWithinalertView:(CustomAlertView*)alert;
- (void) centerBtnPressedWithinalertView:(CustomAlertView*)alert;

- (void) customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


@end

