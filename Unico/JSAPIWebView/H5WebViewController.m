//
//  H5WebViewController.m
//  Wefafa
//
//  Created by chencheng on 15/9/7.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "H5WebViewController.h"
#import "SUtilityTool.h"
#import "JSAPIWebView.h"

@interface H5WebViewController ()
{
    UILabel *_titleLabel;
    
    JSAPIWebView *_webView;
    NSString *_urlString;
}
@end

@implementation H5WebViewController

- (id)initWithUrl:(NSString *)urlString
{
    self = [super init];
    if (self != nil)
    {
        _urlString = [urlString copy];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _titleLabel.text = title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavbar];
    
    
    _webView = [[JSAPIWebView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    
    [_webView setTarget:self action:@selector(setTitle:) forJSFunName:@"ocAPI.setTitle"];//通过JS函数 设置导航栏上的标题
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    
    
    [self.view addSubview:_webView];
}

/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,backButtonItem] ;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    _titleLabel.font = FONT_SIZE(18);
    _titleLabel.textColor = COLOR_WHITE;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.title;
    
    self.navigationItem.titleView = _titleLabel;
}


@end
