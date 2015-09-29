//
//  CommunityKeyBoardAccessoryView.m
//  Wefafa
//
//  Created by wave on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "CommunityKeyBoardAccessoryView.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SMainViewController.h"

static CommunityKeyBoardAccessoryView *g_CommunityKeyBoardAccessoryView = nil;

@interface CommunityKeyBoardAccessoryView () <UITextFieldDelegate>
@property (nonatomic, strong) NSString *placeHoldStr;

@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation CommunityKeyBoardAccessoryView

+ (CommunityKeyBoardAccessoryView*)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_CommunityKeyBoardAccessoryView = [[self alloc] initWithFrame:CGRectZero];
    });
    return g_CommunityKeyBoardAccessoryView;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        [_modelView resignKeyWindow];
    }else {
        [_modelView makeKeyAndVisible];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, UI_SCREEN_HEIGHT-40, UI_SCREEN_WIDTH, 40);
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [Utils HexColor:0xd9d9d9 Alpha:1].CGColor;
        self.layer.borderWidth = 0.5f;
        _placeHoldStr = @"说点什么吧";
        _textView = [[UITextField alloc] initWithFrame:CGRectMake(10 * SCALE_UI_SCREEN, (frame.size.height - 30) / 2, UI_SCREEN_WIDTH - 45 * SCALE_UI_SCREEN - 10 * SCALE_UI_SCREEN , 30)];
        [_textView setPlaceholder:_placeHoldStr];
        _textView.layer.cornerRadius = 4;
        _textView.clipsToBounds = YES;
        _textView.borderStyle = UITextBorderStyleRoundedRect;
        _textView.delegate = self;
        [_textView setFont:FONT_t6];
        [_textView setTintColor:[Utils HexColor:0xfedc32 Alpha:1]];
        [self addSubview:_textView];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize sendSize =[@"发送" sizeWithAttributes:@{NSFontAttributeName:FONT_t5}];
        
        _sendBtn.frame = CGRectMake(_textView.right+(UI_SCREEN_WIDTH-_textView.right-sendSize.width)/2-2, 0, sendSize.width, frame.size.height * SCALE_UI_SCREEN);
        [_sendBtn sizeToFit];
        [_sendBtn setCenterY:frame.size.height / 2];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateHighlighted];
        [_sendBtn setTitle:@"发送" forState:UIControlStateSelected];
        [_sendBtn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        [_sendBtn setTitleColor:COLOR_C6 forState:UIControlStateSelected];
        [_sendBtn setTitleColor:COLOR_C6 forState:UIControlStateHighlighted];
        [_sendBtn.titleLabel setFont:FONT_t5];
        [_sendBtn addTarget:self action:@selector(sendClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
    
        _modelView = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _modelView.windowLevel = UIWindowLevelAlert;
        _modelView.backgroundColor = [UIColor clearColor];
        _modelView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideModelView)];        
        [_modelView addGestureRecognizer:tap];
        
        //键盘监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)hideKeyBoard {
    _modelView.hidden = YES;
    [_textView resignFirstResponder];
    [SMainViewController instance].IFView.hidden = YES;
}

- (void)hideModelView {
    [self hideKeyBoard];
}

- (void)sendClicked {
    [self hideKeyBoard];
    //调用API
    self.block(_model);
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = _modelView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - 40;
    _modelView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

#pragma mark - <UITextFieldDelegate>

@end
