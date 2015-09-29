//
//  JSWebViewController.m
//  Wefafa
//
//  Created by su on 15/2/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "JSWebViewController.h"
#import "Utils.h"
#import "BaseViewController.h"
#import "ShareRelated.h"
#import "AppDelegate.h"
#import "SDataCache.h"
// 这里追加新的API
// 1 显示用户页面
// 2 显示搭配页面
// 3 显示品牌页面
// 4 显示话题页面
// 5 显示单品页面
// 6 显示专题
// 7 显示相机


#import "MBBrandViewController.h"
// TODO:Topic
// TODO:Special
#import "SUtilityTool.h"
#import "ScanViewController.h"
#import "Toast.h"
#import "MyOrderViewController.h"
#import "SMineViewController.h"
#import "MBAddShoppingViewController.h"
#import "MBGoodsDetailsModel.h"
#import "TalkingData.h"

#import "SCollocationDetailViewController.h"

#import "JSAPIWebView.h"
#import "SCRecorderViewController.h"
#import "UzysAssetsPickerController.h"
#import "GoodCollectionController.h"
#import "MBCollocationDetailsController.h"

@interface JSWebViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate, SCRecorderViewControllerDelegate, UzysAssetsPickerControllerDelegate>{
    NSString *_urlString;
    NSString *_shareUrl;
    JSAPIWebView *_webView;
    NSMutableData *_receivedData;
    NSString *showNoTokenUrl;
    
    BOOL isInviteCode;
    BOOL enterNavStatus;
    BOOL isFinishLoad;
    UIButton *shareBtn;
    UIImage *shareImage;
    UIButton *backBtn;
    NSDictionary *shareDic;
    BOOL isShareBack;
    
    //相机API 新增成员变量
    int _countMax;
    float _sizeMax;
    NSString *_successJSFun;
}
@property(nonatomic,strong)UIView *headView;

@end

@implementation JSWebViewController

- (id)initWithUrl:(NSString *)urlString
{
    self = [super init];
    if (self) {
        // 临时解决我的邀请码问题
        isInviteCode = [urlString isEqualToString:kInviteCodeUrl];
        
        if (isInviteCode) {
            NSRange rangecodeurl = [kShareInviteCodeUrl rangeOfString:@"userID"];
            if (rangecodeurl.location==NSNotFound) {
                  _shareUrl = [kShareInviteCodeUrl stringByAppendingFormat:@"&userID=%@",sns.ldap_uid];
            }
            else
            {
                _shareUrl = kShareInviteCodeUrl;
            }
        }
        
        // 统一处理所有userID
        // 修正问题，增加一个问号，避免url分享后不行。
        _urlString=urlString;
      
        NSRange range = [_urlString rangeOfString:@"userID"];
        
        if (range.location == NSNotFound)
        {
            NSArray *array = [urlString componentsSeparatedByString:@"?"];
            if (array.count >= 2) {
                _urlString = [urlString stringByAppendingFormat:@"&userID=%@",sns.ldap_uid];
            } else {
                _urlString = [urlString stringByAppendingFormat:@"?userID=%@",sns.ldap_uid];
            }
        }
        
        showNoTokenUrl = _urlString;
        
    }
    return self;
}
-(void)shareBack
{
    if ([[shareDic allKeys]containsObject:@"callback"]) {

        NSString * callBackStr=[NSString stringWithFormat:@"%@()",shareDic[@"callback"]];
//        ／／callBackStr
        isShareBack =YES;
        [_webView stringByEvaluatingJavaScriptFromString:callBackStr];
        [_webView reload];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareBack) name:@"shareback" object:nil];
    
    //  isshare（0）请求接口判断是否显示分享按钮

    shareDic = [[NSDictionary alloc]init];
    
    if (!_webView) {
        _webView = [[JSAPIWebView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
        
        
        //这里设置新接口
        [_webView setTarget:self action:@selector(chooseImageWithCountMax: sizeMax: sourceType: successJSFun:) forJSFunName:@"ocAPI_chooseSystemImage"];
        [_webView setTarget:self action:@selector(getImageWihtURL: sizeType: successCallback:) forJSFunName:@"ocAPI_getImage"];
        [_webView setTarget:self action:@selector(uploadImageWihtURL: callback:) forJSFunName:@"ocAPI_uploadImage"];
        
        
        _webView.backgroundColor = [UIColor blackColor];
        _webView.scrollView.bounces = NO;
        [_webView setDelegate:self];
    }
    isFinishLoad = NO;
    // 这个地方是为何这样判断？
    if (_urlString) {
        _urlString = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
        NSRange range = [_urlString rangeOfString:@"unico_token"];
        if (range.location == NSNotFound)
        {
             NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
//            _urlString =[NSString stringWithFormat:@"%@?unico_token=%@",_urlString,userToken];
//            NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
            NSArray *array = [_urlString componentsSeparatedByString:@"?"];
            if (array.count >= 2) {
                _urlString =[NSString stringWithFormat:@"%@&unico_token=%@",_urlString,userToken];
            } else {
                _urlString =[NSString stringWithFormat:@"%@?unico_token=%@",_urlString,userToken];
            }
        }
        
        NSURL *url = [NSURL URLWithString:_urlString];
    
        [self showUrlOnlyToday];
        
        
        NSDictionary *params = [self getParamsFromUrl:url];
        if ([params objectForKey:@"html"]) {
            NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            NSURLConnection *theConncetion=[[NSURLConnection alloc]
                                            initWithRequest:theRequest delegate:self];
            
            _receivedData=[NSMutableData data];
            
            [theConncetion start];
            
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [Toast makeToastActivity];
           
            
        } else {
            NSLog(@"————urlstring---%@",_urlString);
          [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]]];
        }
    }
    [self.view addSubview:_webView];
    
    // 主要是根据这个参数分成？？。。。
//    _urlString = [_urlString stringByAppendingFormat:@"&shareuser=%@",sns.ldap_uid];
    
    if (_shareImgStr) {
        UIImageFromURL([NSURL URLWithString:_shareImgStr], ^(UIImage *image) {
            shareImage = [Utils reSizeImage:image toSize:CGSizeMake(57,57)];
        }, ^{
            shareImage = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
        });
        
    }
    if(_isPayResult)
    {
        [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
    }
   
}
-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}
-(void)showUrlOnlyToday
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locatime = [formatter stringFromDate:date];
    NSLog(@"locatime---%@",locatime);
    if([locatime isEqualToString:@"2015-08-07"])
    {
        if (_isPayResult) {
//            [Utils alertMessage:_urlString];
        }
        
    }
}
-(void)onBack:(id)selector{
    NSLog(@"返回");
    if(_isPayResult)//订单支付成功页面
    {
        UIViewController *target = nil;
        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
            if([controller isKindOfClass:[MyOrderViewController class]]){
                target = controller;
                break;
            }
        }
        
        if (target) {
            [self.navigationController popToViewController:target animated:YES]; //跳转
        }else{
            for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                if ([controller isKindOfClass:[SMineViewController class]]) { //这里判断是否为你想要跳转的页面
                    target = controller;
                    break;
                }
            }
            
            if (target) {
                [self.navigationController popToViewController:target animated:YES]; //跳转
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
        
    }
    else
    {
          [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)setupNavbar {
    [super setupNavbar];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    if(!backBtn)
    {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(0, 20, 44, 44)];
        backBtn.hidden=NO;
        [backBtn setImage:[UIImage imageNamed:@"Unico/icon_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
    }
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[left1] ;
    
    negativeSpacer.width = -15;
    
    if (!shareBtn) {
        shareBtn =[UIButton buttonWithType:UIButtonTypeCustom] ;
         [shareBtn setFrame:CGRectMake(0, 0, 44, 44)];
        shareBtn.hidden=YES;
        [shareBtn setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [shareBtn setOrigin:CGPointMake(0, 0)];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.tabBarController.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClick)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    
    self.title=self.naviTitle;
    
    
   }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:[NSString stringWithFormat:@"HTML5:%@", self.naviTitle]];

    [self setupNavbar];
//    if (isActive) {
//        [_webView stringByEvaluaxtingJavaScriptFromString:@"Funjia.playMusic()"];
//    }
//    isActive = YES;
    enterNavStatus = self.navigationController.navigationBar.hidden;

   
    
}
-(void)hiddenNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    [_webView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    backBtn.hidden=NO;
    [shareBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-44, 20, 44, 44)];
    [self.view addSubview:shareBtn];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:[NSString stringWithFormat:@"HTML5:%@", self.naviTitle]];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [Toast hideToastActivity];
//    [self.navigationController.navigationBar setHidden:enterNavStatus];
//    [self.navigationController setNavigationBarHidden:enterNavStatus];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)backHome:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClick
{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    ShareData *aData = [[ShareData alloc] init];
    NSString *urlStr = showNoTokenUrl;
    
    if ([[shareDic allKeys]count]==0) {
        if (isInviteCode) {
            urlStr = _shareUrl;
            aData.descriptionStr = @"明天穿什么？整套推荐不范愁!";
            aData.image = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
        } else {
            NSString *info = [NSString stringWithFormat:@"%@ - 全球时尚，有范搭配",self.naviTitle];
            aData.descriptionStr = info;
            aData.title= info;
        }
        
        aData.shareUrl = urlStr;
        
        aData.image = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
        
        if (shareImage) {
            aData.image = shareImage;
        }
    }
    else
    {
        if (isInviteCode) {
            urlStr = _shareUrl;

        }
        NSString *info = [NSString stringWithFormat:@"%@",shareDic[@"descriptionStr"]];
        NSString *shareTitle=[NSString stringWithFormat:@"%@",shareDic[@"shareTitle"]];
        if(info.length==0)
        {
             info = [NSString stringWithFormat:@"%@ - 全球时尚，有范搭配",self.naviTitle];
        }
        aData.descriptionStr = info;
        if (shareTitle.length==0) {
            shareTitle=self.naviTitle;
        }
        aData.title=[NSString stringWithFormat:@"%@",shareTitle];
        aData.shareUrl = urlStr;
        NSString *linkUrl=[NSString stringWithFormat:@"%@",shareDic[@"link"]];
        if (linkUrl.length!=0) {
             aData.shareUrl= shareDic[@"link"];
        }

        aData.image = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
        
        if (shareImage) {
            aData.image = shareImage;
        }
    }
    

    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:aData];
}
-(void)shareBtnClickWithConfiguration:(NSDictionary *)configDic
{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    ShareData *aData = [[ShareData alloc] init];
    NSString *urlStr = showNoTokenUrl;
    
    if ([[configDic allKeys] count]==0) {
        if (isInviteCode) {
            urlStr = _shareUrl;
            aData.descriptionStr = @"明天穿什么？整套推荐不范愁!";
            aData.image = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
        } else {
            NSString *info = [NSString stringWithFormat:@"%@ - 全球时尚，有范搭配",self.naviTitle];
            aData.descriptionStr = info;
            aData.title= info;
        }
        
        aData.shareUrl = urlStr;
        
        aData.image = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
        
        if (shareImage) {
            aData.image = shareImage;
        }
    }
    else
    {
        NSString *info = [NSString stringWithFormat:@"%@",configDic[@"descriptionStr"]];
        NSString *shareTitle=[NSString stringWithFormat:@"%@",configDic[@"shareTitle"]];
        if(info.length==0)
        {
           info = [NSString stringWithFormat:@"%@ - 全球时尚，有范搭配",self.naviTitle];
        }
        aData.descriptionStr = info;
        if (shareTitle.length==0) {
            shareTitle = self.naviTitle;
        }
        aData.title=[NSString stringWithFormat:@"%@",shareTitle];
        aData.shareUrl = urlStr;
        NSString *linkUrl=[NSString stringWithFormat:@"%@",configDic[@"link"]];
        if (linkUrl.length!=0) {
            aData.shareUrl= configDic[@"link"];
        }
        
        aData.image = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
        
        if (shareImage) {
            aData.image = shareImage;
        }
    }

    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:aData];
 
}
- (NSDictionary *)getParamsFromUrl:(NSURL *)url
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@",url];
    
    NSArray *urlArray = [requestURLString componentsSeparatedByString:@"?"];
    
    if (urlArray.count < 2) {
        return paramsDict;
    }
    
    NSArray *paramArray = [[urlArray lastObject] componentsSeparatedByString:@"&"];
    
    for (int i = 0; i < paramArray.count; i++) {
        NSString *paramOne = [paramArray objectAtIndex:i];
        NSArray *keyValue = [paramOne componentsSeparatedByString:@"="];
        
        if (keyValue.count == 2) {
            NSString * _dataString = [[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [paramsDict setObject:_dataString forKey:[keyValue objectAtIndex:0]];
        }
    }
    
    return paramsDict;
}

- (NSString *)getDocumentPath:(NSString *)lastFolderName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:lastFolderName];
    
    return documentsDirectory;
}

- (void) showPraiseBox{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}

#pragma mark - UIWebViewDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [Toast hideToastActivity];
    NSString *html = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    [_webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[self getDocumentPath:@"webCatche"]]];
}


// 这里根据URL来判断是否调用原生环境。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (!isFinishLoad) {
        return YES;
    }
    // 这里暂时兼容老API
    NSDictionary *dict = [self getParamsFromUrl:request.URL];
    if (![self isRequest:dict]){
    
        if([[dict allKeys]containsObject:@"shareTitle"]&&[[dict allKeys]containsObject:@"image"]&&[[dict allKeys]containsObject:@"descriptionStr"])
        {
            shareDic = dict;
            UIImageFromURL([NSURL URLWithString:shareDic[@"image"]], ^(UIImage *image) {

                shareImage = [Utils reSizeImage:image toSize:CGSizeMake(57,57)];
            }, ^{
                shareImage = [Utils reSizeImage:[UIImage imageNamed:@"Icon-60@2x.png"] toSize:CGSizeMake(57,57)];
            });
        }
        if ([[dict allKeys] containsObject:@"isShowTitle"]) {
            
            NSString *isShare = [NSString stringWithFormat:@"%@",dict[@"isShowTitle"]];
            if ([isShare isEqualToString:@"1"]) {
             
            }
            else
            {
                [self hiddenNavigationBar];
            }
        }
        //分享按钮
        if([[dict allKeys]containsObject:@"isShare"])
        {
            NSString *isShare = [NSString stringWithFormat:@"%@",dict[@"isShare"]];
            if ([isShare isEqualToString:@"1"]) {
                shareBtn.hidden=NO;
            }
            else
            {
                shareBtn.hidden=YES;
            }
        }
        //返回按钮
        if([[dict allKeys]containsObject:@"isBack"])
        {
            NSString *isBack = [NSString stringWithFormat:@"%@",dict[@"isBack"]];
            if ([isBack isEqualToString:@"1"]) {
                backBtn.hidden=NO;
                [self backHome:nil];
            }
            else
            {
                backBtn.hidden=YES;
            }
        }
        if([[dict allKeys]containsObject:@"isShareWithUserID"])
        {
//            NSString *isShareWithUserID = [NSString stringWithFormat:@"%@",dict[@"isShareWithUserID"]];
        }
        
        if ([dict objectForKey:@"cid"]) {
            if ([BaseViewController pushLoginViewController]){
                // 这里判断C
        
                MBCollocationDetailsController *collodetailvc=[[MBCollocationDetailsController alloc]init];
                collodetailvc.collocationID =[NSString stringWithFormat:@"%@",[dict objectForKey:@"cid"]];
                
                [[AppDelegate rootViewController] pushViewController:collodetailvc animated:YES];
            }
            [webView stringByEvaluatingJavaScriptFromString:@"Funjia.pauseMusic()"];
        }
        if (dict[@"jump_type"]){
            NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
            mutableDictionary[@"titleName"] = [NSString stringWithFormat:@"HTML页面：%@", self.naviTitle];
            [[SUtilityTool shared]jumpControllerWithContent:mutableDictionary target:self];
        }
        
        //邀请码 分享
        if ([[dict objectForKey:@"Method"] isEqualToString:@"showShare"]) {
            isInviteCode = YES;
            [self shareButtonClick];
        }
        //js 分享
        if ([[dict objectForKey:@"Method"] isEqualToString:@"showWebShare"]) {
            
            [self shareBtnClickWithConfiguration:shareDic];
        }
        //邀请码 分享
        if ([[dict objectForKey:@"Method"] isEqualToString:@"isBack"]) {
            [self backHome:nil];
        }
        //活动进选择商品
        if([[dict objectForKey:@"Method"] isEqualToString:@"activityGoShopping"])
        {
            if (![BaseViewController pushLoginViewController]) {
                return NO;
            }
            NSString *iscollocation=[NSString stringWithFormat:@"%@",dict[@"isCollocation"]];
            NSMutableArray *idArrays=[[NSMutableArray alloc]init];
            NSString *idStr=[NSString stringWithFormat:@"%@",dict[@"id"]];
            
            MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
            controller.fromControllerName = [NSString stringWithFormat:@"HTML页面：%@", self.naviTitle];
            controller.promotion_ID = dict[@"actvityId"]; //活动批次id
            controller.showType = typeBuyNow;
            if ([iscollocation isEqualToString:@"1"]) {
                controller.mbCollocationID = dict[@"id"];//搭配id
            }
            else
            {
                [idArrays addObject:@([idStr intValue])];
                controller.itemAry = idArrays;// 单品应该是 idarrays

            }
            [self.navigationController pushViewController:controller animated:YES];
        }
        return NO;
    }
    
    if([[dict objectForKey:@"Method"] isEqualToString:@"addressInputDone"])
    {
        //用户手动确认收货之后
        [self performSelector:@selector(showPraiseBox) withObject:nil afterDelay:3];
    }
    
    
    
    // 这里追加新的API
    
    // 显示用户页面
    // 显示搭配页面
    // 显示品牌页面
    // 显示话题页面
    // 显示单品页面
    // 显示相机
    if ([self parseNativeWithUrl:[request.URL absoluteString]]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isRequest:(NSDictionary *)dict{
    BOOL isRequest = YES;
    if([[dict allKeys]containsObject:@"shareTitle"]&&[[dict allKeys]containsObject:@"image"]&&[[dict allKeys]containsObject:@"descriptionStr"]){
        isRequest = NO;
    }
    if([[dict allKeys]containsObject:@"shareTitle"]&&[[dict allKeys]containsObject:@"image"]&&[[dict allKeys]containsObject:@"descriptionStr"])
    {
        isRequest = NO;
    }
    if ([[dict allKeys] containsObject:@"isShowTitle"]) {
        isRequest = NO;
    }
    //分享按钮
    if([[dict allKeys]containsObject:@"isShare"])
    {
        isRequest = NO;
    }
    //返回按钮
    if([[dict allKeys]containsObject:@"isBack"])
    {
        isRequest = NO;
    }
    if([[dict allKeys]containsObject:@"isShareWithUserID"])
    {
        isRequest = NO;
    }
    
    if ([dict objectForKey:@"cid"]) {
        isRequest = NO;
    }
    if (dict[@"jump_type"]){
        isRequest = NO;
    }
    //邀请码 分享
    if ([[dict objectForKey:@"Method"] isEqualToString:@"showShare"]) {
        isRequest = NO;
    }
    //js 分享
    if ([[dict objectForKey:@"Method"] isEqualToString:@"showWebShare"]) {
        isRequest = NO;
    }
    //邀请码 分享
    if ([[dict objectForKey:@"Method"] isEqualToString:@"isBack"]) {
        isRequest = NO;
    }
    //活动进选择商品
    if([[dict objectForKey:@"Method"] isEqualToString:@"activityGoShopping"])
    {
        isRequest = NO;
    }
    return isRequest;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [webView stringByEvaluatingJavaScriptFromString:@"isIOSApp = true;version='2.0.2';"];
    
    [Toast makeToastActivity];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    isFinishLoad = YES;
    [Toast hideToastActivity];
    // TODO:读plist
    [webView stringByEvaluatingJavaScriptFromString:@"isIOSApp = true;version='2.0.2';"];
    if (isShareBack) {
        
        if ([[shareDic allKeys]containsObject:@"callback"])
        {
            NSString * callBackStr=[NSString stringWithFormat:@"%@()",shareDic[@"callback"]];
            [_webView stringByEvaluatingJavaScriptFromString:callBackStr];
        }
            
    }

//    NSString * isshare =  [webView stringByEvaluatingJavaScriptFromString:@"isShare()"];
//    NSLog(@"isshare----%@",isshare);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [Toast hideToastActivity];
    // TODO : 这里创建一个重试按钮？
}


// 这里追加新的API
// 1 显示用户页面
// 2 显示搭配页面
// 3 显示品牌页面
// 4 显示话题页面
// 5 显示单品页面
// 6 显示专题
// 7 显示相机

// 暂时使用:分割 ，所以注意，参数里不能有: JS中有需要再封装
// location.href = "func:showUser:123";
// TODO: 对异常数据的容错性。
- (BOOL)parseNativeWithUrl:(NSString*)url{
    NSArray *componse = [url componentsSeparatedByString:@ "?"];
    if (componse.count != 2) {
        return NO;
    }
    NSString *strValue = [componse lastObject];
    NSArray *params = [strValue componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for(NSString *str in params){
        NSArray *subArr = [str componentsSeparatedByString:@"="];
        if (subArr.count == 2) {
            [dict setObject:[subArr lastObject] forKey:[subArr firstObject]];
        }
    }
    if(dict[@"name"]){
        NSString *tempStr =dict[@"name"];
        tempStr = [tempStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dict[@"name"] = tempStr;
    }
    // 参数数量不对的容错。
    if ([dict count]<3) {
        return NO;
    }
    [[SUtilityTool shared] jumpControllerWithContent:dict target:self];
    return YES;
    NSArray* urlComps = [url componentsSeparatedByString:@":"];
    if (urlComps.count < 3){
        // 参数数量不对的容错。
        return NO;
    }
    //func:jumpApp:1:222 
    if ([[urlComps objectAtIndex:0] isEqualToString:@"func"]) {
        NSString* funcStr = [urlComps objectAtIndex:1];
        if ([funcStr isEqualToString:@"showUser"]) {
            [SUTIL showUser:[urlComps objectAtIndex:2]];
        }
        else if ([funcStr isEqualToString:@"showCollection"]) {
            [SUTIL showCollection:[urlComps objectAtIndex:2]];
        }
        else if ([funcStr isEqualToString:@"showBrand"]) {
            [SUTIL showBrand:[urlComps objectAtIndex:2]];
        }
        else if ([funcStr isEqualToString:@"showTopic"]) {
            [SUTIL showTopic:[urlComps objectAtIndex:2]];
        }
        else if ([funcStr isEqualToString:@"showItem"]) {
            [SUTIL showItem:[urlComps objectAtIndex:2]];
        }
        else if ([funcStr isEqualToString:@"showSpecial"]) {
            [SUTIL showSpecial:[urlComps objectAtIndex:2]];
        }
        else if ([funcStr isEqualToString:@"showCamera"]) {
            [SUTIL showCamera:[urlComps objectAtIndex:2]];
        }
        else if ([funcStr isEqualToString:@"showShareBtn"]) {
            // 是否显示右上角share
            // TODO: 是否显示右上角share
        }
        else if ([funcStr isEqualToString:@"setNavTitle"]) {
            //
            // TODO: 设置标题
        }
        else if ([funcStr isEqualToString:@"showItemSelect"]) {
            //
            // TODO: 添加商品，显示商品参数选择
        }
        
        return YES;
    }
    return NO; //
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for(UIViewController *controller in array){
        if ([controller isKindOfClass:[ScanViewController class]]) {
            [array removeObject:controller];
            break;
        }
    }
    [self.navigationController setViewControllers:array];
}








#pragma mark - 新版JS与本地API交互的 Native API

- (void)chooseImageWithCountMax:(JSValue *)countMax sizeMax:(JSValue *)sizeMax sourceType:(JSValue *)sourceType successJSFun:(JSValue *)successJSFun
{
    NSLog(@"countMax = %d sizeMax = %f sourceType = %@ successJSFun = %@", [countMax toInt32], [sizeMax toDouble], [sourceType toString], [successJSFun toString]);
    
    _countMax = [countMax toInt32];
    _sizeMax = [sizeMax toDouble];
    _successJSFun = [successJSFun toString];
    
    
    if ([[sourceType toString] isEqualToString:@"camera"])
    {
        [self showCameraViewWithAnimated:YES completionSection1:nil completionSection2:nil];
    }
    else
    {
        [self showAssetsPickerWithAnimated:YES completion:^{
            
        }];
    }
}


- (void)getImageWihtURL:(JSValue *)url sizeType:(JSValue *)sizeType successCallback:(JSValue *)successCallback
{
    NSLog(@"getImageWihtURL = %@ sizeType = %@ successCallback = %@", [url toString], [sizeType toString], [successCallback toString]);
    
    if ([[url toString] hasPrefix:@"file:///"])
    {
        NSLog(@"[NSThread mainThread] = %@, [NSThread currentThread] = %@", [NSThread mainThread], [NSThread currentThread]);
        
        UIImage *imageResult = [[UIImage alloc] initWithContentsOfFile:[NSURL URLWithString:[url toString]].path];
        
        
        NSString *imageBase64Data = [self image2Base64DataString:imageResult];
        
        int i=0;
        for (; i<[imageBase64Data length]/1024; i++)
        {
            @autoreleasepool {
                
                NSString *subStr = [imageBase64Data substringWithRange:NSMakeRange(i * 1024, 1024)];
                [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"0\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                
            }
        }
        NSString *subStr = [imageBase64Data substringWithRange:NSMakeRange(i * 1024, [imageBase64Data length]-(i * 1024))];
        if (subStr == nil)
        {
            subStr = @"";
        }

        if ([NSThread currentThread] != [NSThread mainThread])
        {
            //dispatch_sync(dispatch_get_main_queue(), ^{
                
                [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"1\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                
                NSLog(@"i = %d", i);

                
            //});
        }
        else
        {
            [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"1\", \"%@\")", [successCallback toString], subStr, [url toString]]];
            
            NSLog(@"i = %d", i);
            
        }
    }
    else
    {
        __block UIImage *imageResult = nil;
        
        void (^assetRseult)(ALAsset *) = ^(ALAsset *result)
        {
            
            NSLog(@"assetRseult result = %@", result);
            
            if (result == nil)
            {
                return;
            }
            
            if ([[sizeType toString] isEqualToString:@"original"])
            {
                
                
                @autoreleasepool {
                    
                    ALAssetRepresentation *defaultRepresentation = result.defaultRepresentation;
                    UIImage *pickingImage = nil;
                    
                    if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
                    {
                        pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
                    }
                    else if (defaultRepresentation.fullResolutionImage != NULL)
                    {
                        pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                                           scale:defaultRepresentation.scale
                                                     orientation:(UIImageOrientation)defaultRepresentation.orientation];
                    }
                    else if ([result aspectRatioThumbnail] != NULL)
                    {
                        pickingImage = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
                    }

                    
                    NSLog(@"[NSThread mainThread] = %@, [NSThread currentThread] = %@", [NSThread mainThread], [NSThread currentThread]);
                    
                    imageResult = pickingImage;
                    
                    NSString *imageBase64Data = [self image2Base64DataString:imageResult];
                    
                    int i=0;
                    for (; i<[imageBase64Data length]/1024; i++)
                    {
                        @autoreleasepool {
                            
                            NSString *subStr = [imageBase64Data substringWithRange:NSMakeRange(i * 1024, 1024)];
                            [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"0\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                            
                        }
                    }
                    NSString *subStr = [imageBase64Data substringWithRange:NSMakeRange(i * 1024, [imageBase64Data length]-(i * 1024))];
                    if (subStr == nil)
                    {
                        subStr = @"";
                    }
                    
                    if ([NSThread currentThread] != [NSThread mainThread])
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"1\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                            
                            NSLog(@"i = %d", i);
                            
                        });
                    }
                    else
                    {
                        [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"1\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                        
                        NSLog(@"i = %d", i);

                    }
                }
            }
            else
            {
                @autoreleasepool {
                    
                    ALAssetRepresentation *defaultRepresentation = result.defaultRepresentation;
                    UIImage *pickingImage = nil;
                    
                    if ([result aspectRatioThumbnail] != NULL)
                    {
                        pickingImage = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
                    }
                    else if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
                    {
                        pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
                    }
                    else if (defaultRepresentation.fullResolutionImage != NULL)
                    {
                        pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                                           scale:defaultRepresentation.scale
                                                     orientation:(UIImageOrientation)defaultRepresentation.orientation];
                    }
                    
                    imageResult = pickingImage;
                    
                    NSString *imageBase64Data = [self image2Base64DataString:imageResult];
                    
                    int i=0;
                    for (; i<[imageBase64Data length]/1024; i++)
                    {
                        @autoreleasepool {
                            
                            NSString *subStr = [imageBase64Data substringWithRange:NSMakeRange(i * 1024, 1024)];
                            [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"0\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                            
                        }
                    }
                    NSString *subStr = [imageBase64Data substringWithRange:NSMakeRange(i * 1024, [imageBase64Data length]-(i * 1024))];
                    if (subStr == nil)
                    {
                        subStr = @"";
                    }

                    
                    if ([NSThread currentThread] != [NSThread mainThread])
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"1\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                            
                            NSLog(@"i = %d", i);
                            
                        });
                    }
                    else
                    {
                        [_webView evaluateJSFun:[NSString stringWithFormat:@"%@(\"%@\", \"1\", \"%@\")", [successCallback toString], subStr, [url toString]]];
                        
                        NSLog(@"i = %d", i);
                        
                    }
                    
                }
            }
        };
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        
        
        [library assetForURL:[NSURL URLWithString:[url toString]] resultBlock:assetRseult failureBlock:^(NSError *error) {
            
            
        }];

    }
    

}

- (BOOL) imageHasAlpha:(UIImage *)image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *)image2Base64DataString: (UIImage *)image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image])
    {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    }
    else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

- (void)uploadImageWihtURL:(JSValue *)url callback:(JSValue *)callback
{
    NSLog(@"uploadImageWihtURL url = %@  callback = %@", [url toString], [callback toString]);
    
    if ([[url toString] hasPrefix:@"file:///"])
    {
        UIImage *imageResult = [[UIImage alloc] initWithContentsOfFile:[NSURL URLWithString:[url toString]].path] ;
        
        [[SDataCache sharedInstance] uploadImageToQiNiuWithImage:imageResult complete:^(NSString *url) {
            
            NSString *jsFunAndArg = [NSString stringWithFormat:@"%@(\"%@\")", [callback toString], url];
            
            [_webView evaluateJSFun:jsFunAndArg];
        }];
    }
    else
    {
        __block UIImage *imageResult = nil;
        
        void (^assetRseult)(ALAsset *) = ^(ALAsset *result)
        {
            if (result == nil)
            {
                return;
            }
            
            ALAssetRepresentation *defaultRepresentation = result.defaultRepresentation;
            UIImage *pickingImage = nil;
            
            if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
            }
            else if (defaultRepresentation.fullResolutionImage != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                                   scale:defaultRepresentation.scale
                                             orientation:(UIImageOrientation)defaultRepresentation.orientation];
            }
            else if ([result aspectRatioThumbnail] != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
            }
            
            imageResult = pickingImage;

            
            [[SDataCache sharedInstance] uploadImageToQiNiuWithImage:imageResult complete:^(NSString *url) {
                
                NSString *jsFunAndArg = [NSString stringWithFormat:@"%@(\"%@\")", [callback toString], url];
                
                NSLog(@"jsFunAndArg = %@", jsFunAndArg);
                
                [_webView evaluateJSFun:jsFunAndArg];
            }];
        };
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library assetForURL:[NSURL URLWithString:[url toString]] resultBlock:assetRseult failureBlock:nil];
    }
}


static UIWindow *g_cameraStartSlideWindow = nil;

/**
 *   显示相机
 */
- (void)showCameraViewWithAnimated:(BOOL)animated completionSection1:(void (^)(void))completionSection1 completionSection2:(void (^)(void))completionSection2
{
    SCRecorderViewController *cameraViewController = nil;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
    cameraViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCameraStoryBoardID"];
    cameraViewController.recorderStyle = RecorderViewOnlyPhotoStyle;
    cameraViewController.delegate = self;
    cameraViewController.animatedBack = YES;
    [cameraViewController setHidesBottomBarWhenPushed:YES];
    
    if (animated)
    {
        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = [AppDelegate rootViewController].view.frame;
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
            
            
            
        } completion:^(BOOL finished) {
            
            if (completionSection1 != nil)
            {
                completionSection1();
            }
            
            [[AppDelegate rootViewController] pushViewController:cameraViewController animated:NO];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
                
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                
                g_cameraStartSlideWindow = nil;
                
                if (completionSection2 != nil)
                {
                    completionSection2();
                }
            }];
        }];
    }
}


/**
 *   关闭相机视图
 */
- (void)closeCameraViewWithAnimated:(BOOL)animated
{
    if (animated)
    {
        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            
            [[AppDelegate rootViewController] popViewControllerAnimated:NO];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                g_cameraStartSlideWindow = nil;
            }];
        }];
    }
    else
    {
        [[AppDelegate rootViewController] popViewControllerAnimated:NO];
    }
}

- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureImage:(UIImage *)image
{
    NSString *tmpImageFilePatch = [NSString stringWithFormat:@"%@/tmp/tempImage.jpg", NSHomeDirectory()] ;
    
    
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    [[NSFileManager defaultManager] removeItemAtPath:tmpImageFilePatch error:nil];
    
    [imageData writeToFile:tmpImageFilePatch atomically:YES];
    
    
    NSURL *temVideoFileURL = [[NSURL alloc] initFileURLWithPath:tmpImageFilePatch];
    
    NSString *jsFunAndArg = [NSString stringWithFormat:@"%@(\"%@\")", _successJSFun, temVideoFileURL];
    
    NSLog(@"jsFunAndArg = %@", jsFunAndArg);
    
    
    [self closeCameraViewWithAnimated:YES];
    
    if ([NSThread currentThread] != [NSThread mainThread])
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [_webView evaluateJSFun:jsFunAndArg];
        });
    }
    else
    {
        [_webView evaluateJSFun:jsFunAndArg];

    }

    
    
    
}


- (void)recorderViewControllerDidPickingSystemPhoto:(SCRecorderViewController *)recorderViewController
{
    [self showAssetsPickerWithAnimated:YES completion:^{
        [self closeCameraViewWithAnimated:NO];
    }];
}

- (void)recorderViewControllerDidCancel:(SCRecorderViewController *)recorderViewController
{
    [self closeCameraViewWithAnimated:YES];
}



/**
 *   显示选择单品照片时的系统相册
 */
- (void)showAssetsPickerWithAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    UzysAssetsPickerController *assetsPickerController = nil;
    
    assetsPickerController = [[UzysAssetsPickerController alloc] init];
    
    assetsPickerController.delegate = (id<UzysAssetsPickerControllerDelegate>)self;
    
    assetsPickerController.maximumNumberOfSelectionMedia = _countMax;
    assetsPickerController.showCameraCell = YES;
    
    assetsPickerController.assetsFilter = [ALAssetsFilter allPhotos];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarHidden = NO;
    });
    
    [[AppDelegate rootViewController] presentViewController:assetsPickerController animated:animated completion:^{
        
        if (completion != nil)
        {
            completion();
        }
    }];
}


- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssetsWithURLArray:(NSArray *)urlArray
{
    NSMutableString *jsFunArg = [[NSMutableString alloc] init];
    
    for (int i=0; i<[urlArray count]; i++)
    {
        NSURL *url = [urlArray objectAtIndex:i];
        
        NSLog(@"url = %@", url);
        
        [jsFunArg appendString:[url description]];
        
        if (i+1 != [urlArray count])
        {
            [jsFunArg appendString:@";"];
        }
    }
    
    NSString *jsFunAndArg = [NSString stringWithFormat:@"%@(\"%@\")", _successJSFun, jsFunArg];
    
    NSLog(@"jsFunAndArg = %@", jsFunAndArg);
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    if ([NSThread currentThread] != [NSThread mainThread])
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [_webView evaluateJSFun:jsFunAndArg];
        });
    }
    else
    {
        [_webView evaluateJSFun:jsFunAndArg];
    }
}

- (void)uzysAssetsPickerControllerDidPickingCamera:(UzysAssetsPickerController *)picker
{
    [self showCameraViewWithAnimated:YES completionSection1:^{
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
        }];
        
    } completionSection2:^{
        
    }];
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
