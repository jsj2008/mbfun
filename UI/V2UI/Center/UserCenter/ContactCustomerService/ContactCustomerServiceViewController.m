//
//  ContactCustomerServiceViewController.m
//  Wefafa
//
//  Created by Jiang on 3/11/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "ContactCustomerServiceViewController.h"
#import "WeFaFaGet.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import <CommonCrypto/CommonDigest.h>
#import "ModelBase.h"


@interface ContactCustomerServiceViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;

@property (nonatomic, strong) NSURLSession *session;

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@property (assign, nonatomic, getter=isLoadingFinished) BOOL loadingFinished;
@end

@implementation ContactCustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self setupNavbar];
    
    [self initNavigationBar];
    [self initContentWebView];
    [self loadData];
}
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO
     ];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //    UIView *tempView;
    //    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];
    self.title=@"客服中心";

}

-(void)viewDidDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
    
}
- (void)initNavigationBar{
    
    CGRect headrect=CGRectMake(0,0,self.navigationBarView.frame.size.width,self.navigationBarView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:)  selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"客服中心";
//    [self.navigationBarView addSubview:view];
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)initContentWebView{
    self.contentWebView.delegate = self;
    [self.contentWebView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentWebView setScalesPageToFit:NO];
    self.contentWebView.scrollView.contentScaleFactor = 0.5;
}

- (void)loadData{
    NSString *signString = [NSString stringWithFormat:@"%@%@", sns.myStaffCard.nick_name, kIosKey];
    NSString *signStringMD5 = [self md5:signString];
    NSString *urlStringParame = [NSString stringWithFormat:@"loginName=%@&sign=%@&from=ios", sns.myStaffCard.nick_name, signStringMD5];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", kHttpUrlString, urlStringParame];
    //kHttpUrlString
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [self.contentWebView loadRequest:request];
}

- (NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

#pragma mark - web delelgate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [Toast hideToastActivity];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [Toast makeToastActivity:@"正在加载数据！" hasMusk:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

#pragma mark -
-(void)backHome:(id)sender
{
    [Toast hideToastActivity];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
