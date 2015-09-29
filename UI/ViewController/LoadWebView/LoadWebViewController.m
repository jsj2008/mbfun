//
//  LoadWebViewController.m
//  Wefafa
//
//  Created by mac on 13-9-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "LoadWebViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Utils.h"
#import "NavigationTitleView.h"

@interface LoadWebViewController ()

@end

@implementation LoadWebViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleString=[[NSString alloc] initWithFormat:@"%@",title ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    _titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [_titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    _titleView.lbTitle.text=_titleString.length>0?_titleString:@"查看";
    [self.viewHead addSubview:_titleView];
    
    _actView.backgroundColor=[Utils HexColor:0x080808 Alpha:0.5];
    CALayer *sublayer = [_actView layer];
    sublayer.cornerRadius = 7;
    webView.scalesPageToFit =YES;
    webView.delegate =self;
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.view addSubview:webView];
    webView.userInteractionEnabled=YES;
    
    [webView loadRequest:request];
    [self startAct];
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setAct:nil];
    [self setActView:nil];
    [super viewDidUnload];
}

-(void)startAct
{
    _actView.hidden=NO;
    [_act startAnimating];
}
-(void)stopAct
{
    _actView.hidden=YES;
    [_act stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"JIAZAIWAN");
    [self stopAct];
}

@end
