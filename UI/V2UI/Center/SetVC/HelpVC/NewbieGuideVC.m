//
//  NewbieGuideVC.m
//  Designer
//
//  Created by Juvid on 15/1/21.
//  Copyright (c) 2015年 banggo. All rights reserved.
//

#import "NewbieGuideVC.h"

@interface NewbieGuideVC ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic,weak)IBOutlet UIWebView *webView;
@end

@implementation NewbieGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新手指南";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
   
    [self.activityView setHidesWhenStopped:YES]; //当旋转结束时隐藏

    // Do any additional setup after loading the view from its nib.
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.activityView startAnimating]; // 开始旋转
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityView stopAnimating]; // 结束旋转
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityView stopAnimating]; // 结束旋转
    
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//
//
//        return res;
//}

-(void)dealloc
{
    [self.webView stopLoading];
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    //    缓存  清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.webView.delegate = nil;
    self.webView = nil;
    self.urlStr = nil;
    //    self.title_str = nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
