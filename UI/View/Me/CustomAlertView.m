//
//  CustomAlertView.m
//  Wefafa
//
//  Created by fafatime on 15-1-29.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "CustomAlertView.h"
#import "Utils.h"

#define MAX_CATEGORY_NAME_LENGTH 9
#define kTagViewTextFieldJalBreakPassW (1001)

@implementation CustomAlertView
@synthesize customDelegate=_customDelegate;
@synthesize contentLabel;
@synthesize textField;
@synthesize buttonTag;
//含有title，提示内容以及两个button.
- (id)initWithTitle:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle  delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_Msg_TwoBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
//        [_bgView release];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.masksToBounds=YES;
        _alertView.layer.cornerRadius = 6;
        [_alertView setBackgroundColor:[UIColor whiteColor]];
        
        if (title.length==0)
        {
            titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10,_alertView.frame.size.width, 20)];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
            titleLabel.text =title;
            titleLabel.textAlignment=NSTextAlignmentCenter;
            [_alertView addSubview:titleLabel];
        }
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, _alertView.frame.size.width-20, 40)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        contentLabel.text =msg;
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [_alertView addSubview:contentLabel];

        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        rightBtn.frame=CGRectMake(alertRect.size.width/2+6, _alertView.frame.size.height -15-30, alertRect.size.width/2-5*2-6,30);
        rightBtn.layer.masksToBounds=YES;
        rightBtn.layer.cornerRadius = 3;
//        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.tag=1;
        [rightBtn addTarget:self action:@selector(btnPressedClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.backgroundColor=[Utils HexColor:0xE52027 Alpha:1];
         [_alertView addSubview:rightBtn];
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
//        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame=CGRectMake(10,_alertView.frame.size.height -15-30, rightBtn.frame.size.width, rightBtn.frame.size.height);
        leftBtn.layer.masksToBounds=YES;
        leftBtn.layer.cornerRadius = 3;
        leftBtn.tag=0;
        [leftBtn addTarget:self action:@selector(btnPressedClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];
        [self showBackground];
        [self showAlertAnmation];
        
    }
    return self;
}

- (id)initWithImage:(NSString *)imageName msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle  delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        _alertViewType=CustomAlertViewType_Msg_NOBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[Utils HexColor:0x3b3b3b Alpha:0.4]];
        [self addSubview:_bgView];

        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.masksToBounds=YES;
        _alertView.layer.cornerRadius = 6;
        [_alertView setBackgroundColor:[Utils HexColor:0x3b3b3b Alpha:0.7]];
    
        if (imageName.length!=0)
        {
            UIImageView *titleImgView=[[UIImageView alloc]initWithFrame:CGRectMake(_alertView.frame.size.width/2-10, 17, 20, 20)];
            [titleImgView setImage:[UIImage imageNamed:imageName]];
            [_alertView addSubview:titleImgView];
        }
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, _alertView.frame.size.width-20, 40)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        contentLabel.text =msg;
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [_alertView addSubview:contentLabel];
        
       /*
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        rightBtn.frame=CGRectMake(alertRect.size.width/2+6, _alertView.frame.size.height -15-30, alertRect.size.width/2-5*2-6,30);
        rightBtn.layer.masksToBounds=YES;
        rightBtn.layer.cornerRadius = 3;
        rightBtn.tag=1;
        [rightBtn addTarget:self action:@selector(btnPressedClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.backgroundColor=[Utils HexColor:0xE52027 Alpha:1];
        [_alertView addSubview:rightBtn];
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        leftBtn.frame=CGRectMake(10,_alertView.frame.size.height -15-30, rightBtn.frame.size.width, rightBtn.frame.size.height);
        leftBtn.layer.masksToBounds=YES;
        leftBtn.layer.cornerRadius = 3;
        leftBtn.tag=0;
        [leftBtn addTarget:self action:@selector(btnPressedClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [_alertView addSubview:leftBtn];
        
        if (_alertViewType==CustomAlertViewType_Msg_NOBtn) {
            rightBtn.hidden=YES;
            leftBtn.hidden=YES;
        }
        */
        
        [self addSubview:_alertView];
        [self showBackground];
        _bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAlertView)];
        [_bgView addGestureRecognizer:tapGest];
        [self showAlertAnmation];
//        [self performSelector:@selector(hideAlertView) withObject:nil afterDelay:1.0];
        
        
    }
    return self;
}

//可修改字体
- (id)initWithTitle:(NSString*)title
                msg:(NSString*)msg
      rightBtnTitle:(NSString*)rightTitle
       leftBtnTitle:(NSString*)leftTitle
           delegate:(id<CustomAlertViewDelegate>) _delegate
        msgFontSize:(CGFloat)fontSize
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_Msg_TwoBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
//        [_bgView release];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.image = [UIImage imageNamed:@"AlertView_background.png"];
        [_alertView addSubview:alertBg];
//        [alertBg release];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
//        [titleLabel release];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 40)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.text =msg;
        contentLabel.textAlignment =NSTextAlignmentCenter;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping
;
        contentLabel.numberOfLines = 0;
        [_alertView addSubview:contentLabel];
//        [contentLabel release];
        
        UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=[UIImage imageNamed:@"button_selected.png"];
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(155, 85, selectedImg.size.width, selectedImg.size.height);
        [_alertView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame=CGRectMake(20, 85, unselectedImg.size.width, unselectedImg.size.height);
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];
        [_alertView release];
        [self showBackground];
        [self showAlertAnmation];
    }
    return self;
}


- (id)initWithTitle:(NSString*)title  msg:(NSString*)msg centerBtnTitle:(NSString*)centerTitle
{
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        _alertViewType=CustomAlertViewType_Msg_OneBtn;
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        [_bgView release];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.image = [UIImage imageNamed:@"AlertView_background.png"];
        [_alertView addSubview:alertBg];
        [alertBg release];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        [titleLabel release];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 260, 20)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.text =msg;
        contentLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:contentLabel];
        [contentLabel release];
        
        UIImage* selectedImg=[UIImage imageNamed:@"bigbuttonbkimg.png"];
        centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [centerBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [centerBtn setTitle:centerTitle forState:UIControlStateNormal];
        centerBtn.frame=CGRectMake(27, 85, 249, 43);
        [_alertView addSubview:centerBtn];
        [centerBtn addTarget:self action:@selector(centerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_alertView];
        [_alertView release];
        [self showBackground];
        [self showAlertAnmation];
    }
    return self;
}


//含有title，UIActivityIndicatorView控件,提示内容以及一个button.
- (id)initProgressAlertViewWithTitle:(NSString*)title  msg:(NSString*)msg centerBtnTitle:(NSString*)centerTitle  delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_ActivityIndiAndMsg_OneBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        [_bgView release];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.image = [UIImage imageNamed:@"AlertView_background.png"];
        [_alertView addSubview:alertBg];
        [alertBg release];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        [titleLabel release];
        
        indicatorView= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(80.0, 45.0, 30.0, 30.0)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.hidesWhenStopped=NO;
        [_alertView addSubview:indicatorView];
        [indicatorView release];
        [indicatorView startAnimating];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 50.0, 150.0, 20.0)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:15.0];
        contentLabel.text =msg;
        contentLabel.textAlignment=NSTextAlignmentLeft;
        [_alertView addSubview:contentLabel];
        [contentLabel release];
        
        UIImage* selectedImg=[UIImage imageNamed:@"button_selected.png"];
        centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [centerBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [centerBtn setTitle:centerTitle forState:UIControlStateNormal];
        centerBtn.frame=CGRectMake(27, 85, 249, 43);
        [_alertView addSubview:centerBtn];
        [centerBtn addTarget:self action:@selector(centerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_alertView];
        [_alertView release];
        [self showBackground];
        [self showAlertAnmation];
    }
    return self;
}


//含有title，textfield，提示内容以及两个button.
- (id)initTextFieldWithTitle:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_Msg_TextField_TwoBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        [_bgView release];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.image = [UIImage imageNamed:@"AlertView_background.png"];
        [_alertView addSubview:alertBg];
        [alertBg release];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 300, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        [titleLabel release];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 33.0, 300.0, 12.0)];
        contentLabel.textColor = [UIColor clearColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:8.0];
        contentLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:contentLabel];
        [contentLabel release];
        
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(21, 45, 260, 30)] autorelease];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.placeholder = msg;
        [textField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
        [_alertView addSubview:textField];
        [textField release];
        
        UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=[UIImage imageNamed:@"button_selected.png"];
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(155, 85, selectedImg.size.width, selectedImg.size.height);
        [_alertView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame=CGRectMake(20, 85, unselectedImg.size.width, unselectedImg.size.height);
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];
        [_alertView release];
        [self showBackground];
        [self showAlertAnmation];
    }
    return self;
}



-(id)initLoginWithDelegate:(id<CustomAlertViewDelegate>)delegate userId:(NSString*)userid title:(NSString*)strTitle rightBtnTitle:(NSString*)strRbt
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        
        _alertViewType = CustomAlertViewType_JalBreakBuy_Login;
        self.customDelegate = delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        [_bgView release];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.image = [UIImage imageNamed:@"AlertView_background.png"];
        [_alertView addSubview:alertBg];
        [alertBg release];
        
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 280, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text = strTitle;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        [titleLabel release];
        
        CGFloat xLabel1 = 20;
        CGFloat xLabel2 = 120;
        CGFloat yLevel1 = 50;
        CGFloat yLevel2 = 100;
        
        
        
        UILabel* label = nil;
        label = [[UILabel alloc]initWithFrame:CGRectMake(xLabel1, yLevel1, 100, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"账号:";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:label];
        [label release];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(xLabel2, yLevel1,140, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = userid;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentLeft;
        [_alertView addSubview:label];
        [label release];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(xLabel1, yLevel2, 100, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"密码:";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:label];
        [label release];
        
        textField = [[[UITextField alloc]initWithFrame:CGRectMake(xLabel2, yLevel2, 140, 40)] autorelease];
        textField.delegate = self;
        textField.tag= kTagViewTextFieldJalBreakPassW;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:17];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeASCIICapable ;
        [_alertView addSubview:textField];
        [textField release];
        
        UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=[UIImage imageNamed:@"button_selected.png"];
        
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [rightBtn setTitle:strRbt forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(155, 155, selectedImg.size.width, selectedImg.size.height);
        [_alertView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame=CGRectMake(20, 155, unselectedImg.size.width, unselectedImg.size.height);
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];
        [_alertView release];
        [self showBackground];
        [self showAlertAnmation];
        
    }
    
    return self;
    
}



-(void) show
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    NSArray* windowViews = [window subviews];
    if(windowViews && [windowViews count]>0){
        UIView* subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView* aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
            
            
        }
        [subView addSubview:self];
    }
    
}


- (void)showBackground
{
    _bgView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _bgView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void) showAlertAnmation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_alertView.layer addAnimation:animation forKey:nil];
    
}

-(void) hideAlertAnmation
{
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _bgView.alpha = 0.0;
    [UIView commitAnimations];
}



-(CGRect)getAlertBounds
{
    CGRect retRect;
    
    if (_alertViewType == CustomAlertViewType_JalBreakBuy_Login)
    {
        
        retRect= CGRectMake((self.frame.size.width-300)/2, (self.frame.size.height-200)/2, 300, 220);
        
    }
    else if(_alertViewType ==CustomAlertViewType_Msg_NOBtn)
    {
        CGSize imageSize = CGSizeMake(230, 100);
        retRect= CGRectMake((self.frame.size.width-imageSize.width)/2,(self.frame.size.height-imageSize.height)/2, imageSize.width, imageSize.height);
    }
    else
    {
//       230 *140
        CGSize imageSize = CGSizeMake(230, 140);
        retRect= CGRectMake((self.frame.size.width-imageSize.width)/2,(self.frame.size.height-imageSize.height)/2, imageSize.width, imageSize.height);
        
    }
    
    return retRect;
}


- (void) hideAlertView
{
    _alertView.hidden = YES;
    [self hideAlertAnmation];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
}

-(void) removeFromSuperview
{
    [super removeFromSuperview];
}

-(void) btnPressedClick:(UIButton *)sender
{

    if (_customDelegate && [_customDelegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
    {
        [_customDelegate customAlertView:self clickedButtonAtIndex:sender.tag];
        [self hideAlertView];
    }
    else
    {
        [self hideAlertView];
    }
}
- (void) leftBtnPressed:(id)sender
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(leftBtnPressedWithinalertView:)])
    {
        [_customDelegate leftBtnPressedWithinalertView:self];
            [self hideAlertView];
    }
    else
    {
        [self hideAlertView];
    }
}

- (void) rightBtnPressed:(id)sender
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(rightBtnPressedWithinalertView:)])
    {
        [_customDelegate rightBtnPressedWithinalertView:self];
            [self hideAlertView];
    }
    else
    {
        [self hideAlertView];
    }
}

- (void) centerBtnPressed:(id)sender
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(centerBtnPressedWithinalertView:)])
    {
        [_customDelegate centerBtnPressedWithinalertView:self];
    }
    else
    {
        [self hideAlertView];
    }
}

-(void) setTitle:(NSString*) title
{
    titleLabel.text = title;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


-(void) textFieldChanged
{
    if ([textField.text length] > MAX_CATEGORY_NAME_LENGTH)
    {
        textField.text = [textField.text substringToIndex:MAX_CATEGORY_NAME_LENGTH];
    }
}

#pragma mark - DelegateTextField


- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    if (_textField.tag == kTagViewTextFieldJalBreakPassW)
    {
        [self rightBtnPressed:nil];
        return NO;
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField_ shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField_.tag == kTagViewTextFieldJalBreakPassW)
    {
        
        if (string && [string length] && [textField_.text length]>15)
        {
            return NO;
        }
        
    }
    
    return YES;
    
}
- (id)initRemindAlert
{
    return nil;
    
}

@end
