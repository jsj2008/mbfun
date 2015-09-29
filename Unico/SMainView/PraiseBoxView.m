//
//  PraiseBoxView.m
//  Wefafa
//
//  Created by wave on 15/8/27.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "PraiseBoxView.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "SuggestionFeedbackViewController.h"
#import "AppDelegate.h"
#import "STabbarNavigationBarController.h"    

static PraiseBoxView *g_PraiseBoxView = nil;
//extern NSString *VERSION_NAME;

@interface PraiseBoxView ()
@property (nonatomic, strong) UIWindow      *window;
@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) UIViewController *currentViewController;
@end

@implementation PraiseBoxView

- (instancetype)init
{
    if (!g_PraiseBoxView) {
        self = [super init];
        if (self) {
            g_PraiseBoxView = self;
        }
    }
    return g_PraiseBoxView;
}

+ (instancetype)loginToShow {
    if (!g_PraiseBoxView) {
        [self new];
    }
    NSString *shortVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",IS_PRAISEBOX_HASSHOW,shortVersionString,shortVersionString];
    NSNumber *loginCount = [[NSUserDefaults standardUserDefaults] objectForKey:str];
    int loginCountInt = [loginCount intValue];
    //版本内第二次登陆用户收到一条弹出框，无论评分与否在此版本内都不会再收到评分弹框
    NSLog(@"loginCountInt ==== %d", loginCountInt);
    NSString *str2 = [NSString stringWithFormat:@"%@%@",IS_PRAISEBOX_HASSHOW,shortVersionString];
    NSNumber *isShown = [[NSUserDefaults standardUserDefaults] objectForKey:str2];
    if (loginCountInt == 1 && [isShown boolValue] == 0) {
        [g_PraiseBoxView show];
    }
    loginCount = @(++loginCountInt);
    [[NSUserDefaults standardUserDefaults] setValue:loginCount forKey:str];
    return g_PraiseBoxView;
}

+ (instancetype)show {
    if (!g_PraiseBoxView) {
        [self new];
    }
    //APP store弹出框弹出规则：\
    每个版本更新之后，每个用户只能收到一条弹出框，无论评分与否在此版本内都不会再收到评分弹框
    NSString *shortVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *str = [NSString stringWithFormat:@"%@%@",IS_PRAISEBOX_HASSHOW,shortVersionString];
    NSNumber *isShown = [[NSUserDefaults standardUserDefaults] objectForKey:str];
    if ([isShown boolValue] == 0) {
        [g_PraiseBoxView show];
    }
    return g_PraiseBoxView;
}

- (void)show {
    BOOL isShown = YES;
    NSString *shortVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *str = [NSString stringWithFormat:@"%@%@",IS_PRAISEBOX_HASSHOW,shortVersionString];
    [[NSUserDefaults standardUserDefaults] setObject:@(isShown) forKey:str];
    
    _btnArray = [NSMutableArray new];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    _currentViewController = [((STabbarNavigationBarController*)delegate.window.rootViewController).viewControllers objectAtIndex:0];
    
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    _window.windowLevel = UIWindowLevelAlert;
    [_window makeKeyAndVisible];
    _window.hidden = NO;
    
    //729*670
    //背景图
    _imgView = [UIImageView new];
    [_imgView setImage:[UIImage imageNamed:@"Unico/praisebos.png"]];
    [_imgView sizeToFit];
    if (_imgView.width > UI_SCREEN_WIDTH) {
        [_imgView setWidth:UI_SCREEN_WIDTH];
        [_imgView setHeight:_imgView.height * UI_SCREEN_WIDTH / _imgView.width];
    }
    [_imgView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2)];
    [_imgView setUserInteractionEnabled:YES];
    [_window addSubview:_imgView];
    
    //关闭按钮
    UIImageView *imgView = [UIImageView new];
    [imgView setImage:[UIImage imageNamed:@"Unico/praiseclose.png"]];
    [imgView sizeToFit];
    [imgView setRight:_imgView.width - 56];
    [imgView setTop:98];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [imgView setUserInteractionEnabled:YES];
    [imgView addGestureRecognizer:tap];
    [_imgView addSubview:imgView];
    
    CGFloat btnWidth = 180;
    CGFloat btnHeight = 36;
    
//    NSArray *array = @[@"忍不住去赞", @"逼我吐槽", @"我想静一静"];
    NSArray *array = @[@"逼我吐槽", @"我想静一静", @"忍不住去赞"];
    for (NSString *str in array) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setSize:CGSizeMake(btnWidth, btnHeight)];
        [btn setCenterX:_imgView.width / 2];
        [btn setTop:[array indexOfObject:str] * (btnHeight + 10) + imgView.bottom + 10];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitle:str forState:UIControlStateSelected];
        [btn setTitle:str forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:FONT_T2];
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArray addObject:btn];
        [_imgView addSubview:btn];
        if ([array indexOfObject:str] == 2) {
            btn.backgroundColor = [Utils HexColor:0xfedc32 Alpha:1];
            [btn setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateSelected];
            [btn setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateHighlighted];
            [btn setTitleColor:[Utils HexColor:0x3b3b3b Alpha:1] forState:UIControlStateNormal];
        }else {
            btn.backgroundColor = [Utils HexColor:0xffffff Alpha:1];
            [btn setTitleColor:[Utils HexColor:0xbbbbbb Alpha:1] forState:UIControlStateSelected];
            [btn setTitleColor:[Utils HexColor:0xbbbbbb Alpha:1] forState:UIControlStateHighlighted];
            [btn setTitleColor:[Utils HexColor:0xbbbbbb Alpha:1] forState:UIControlStateNormal];
        }
    }
}

//关闭按钮
- (void)close {
    _window.hidden = YES;
    [_window resignKeyWindow];
}

//按钮
-(void)click:(UIButton*)sender {
    UIViewController *viewctrl = nil;
    if ([sender.titleLabel.text isEqualToString:@"忍不住去赞"]) {
        NSString * const App_URL = @"https://itunes.apple.com/cn/app/you-fan/id977919857?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:App_URL]];
    }else if ([sender.titleLabel.text isEqualToString:@"逼我吐槽"]) {
        SuggestionFeedbackViewController *vc = [[SuggestionFeedbackViewController alloc]initWithNibName:@"SuggestionFeedbackViewController" bundle:nil];
        viewctrl = vc;
    }else if ([sender.titleLabel.text isEqualToString:@"我想静一静"]) {
        
    }else {
        
    }
    [self close];
    [_currentViewController.navigationController pushViewController:viewctrl animated:YES];
}

@end
