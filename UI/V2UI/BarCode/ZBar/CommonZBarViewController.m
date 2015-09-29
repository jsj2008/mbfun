//
//  CommonZBarViewController.m
//  BanggoPhone
//
//  Created by yintengxiang on 14/12/4.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "CommonZBarViewController.h"
#import "BGUtilUI.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "WeFaFaGet.h"
#import "MBShoppingGuideInterface.h"
#import "ASINetworkQueue.h"
#import "FittingRoomViewController.h"
#import "HttpRequest.h"
#import "ScanCodeInfo.h"
#import "JsonToModel.h"
#import "AppDelegate.h"
//#import "MBOtherStoreViewController.h"
#define  URLTAG 10000
#define  AlertViewTAG 10002

#define ImagePositionY 0
#define promptPositionY 50

@interface  CommonZBarViewController()
{
    ASIHTTPRequest * m_Request;
    BOOL hasBuildView;
    NSDictionary * responsDic ;
}
@property (nonatomic, strong) UIView *vi;
@property (nonatomic, strong) NSMutableDictionary *dicData;
@property (nonatomic, copy) NSString *codeUrl;
@property (nonatomic, strong) UIImageView *lineImageView;
@end

@implementation CommonZBarViewController

-(void)loadView
{
    [super loadView];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //获取环境url
    [self getCodeUrl:NO syData:@""];
}

#pragma mark - zbar
- (void)buidViewforZbar
{
    if (hasBuildView) {
        [self performSelector:@selector(animations) withObject:nil afterDelay:0.5];
        return;
    }
    self.readerDelegate = self;
 
    UIView *upBackGroundView = [[[UINib nibWithNibName:@"CommonZBarUpView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    upBackGroundView.alpha= 0.5 ;
//    upBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upBackGroundView] ;
    upBackGroundView.frame = CGRectMake(0, 0, 320, 70);
    
    

    
//    UIImageView *lineImageView = [BGUtilUI drawCustomImgViewInView:self.view Frame:CGRectMake(10, 140 , 300, 0) ImgName:@"bg-scanning-area2"];
////    lineImageView.height = 3;
    
    [BGUtilUI drawCustomImgViewInView:self.view Frame:CGRectMake((WINDOWW - 300)/2 , 140 , 300, 200) ImgName:@"bg-scanning-area2.png"];
    [BGUtilUI drawButtonInView:self.view Frame:CGRectMake(0, ImagePositionY, 60, 50) IconName:@"icon-arrow-return.png" Target:self Action:@selector(dismissZBar)];
    UIButton *d_button = [BGUtilUI drawButtonInView:self.view Frame:CGRectMake(320-65, ImagePositionY, 60, 50) IconName:@"icon-flash-on.png" SelectName:@"icon-flash-off.png" Target:self Action:@selector(clickFlashlightBut:)];
    
    [BGUtilUI drawButtonInView:self.view Frame:CGRectMake(320-60*2, ImagePositionY, 60, 50) IconName:@"imageSelect.png" Target:self Action:@selector(uploadImage:)];
    
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 140 + 200 +64  , 320, 400)];
    downView.backgroundColor = [UIColor blackColor];
    downView.alpha = 0.5 ;
    [self.view addSubview:downView];
    
    
    d_button.selected = YES;
    
    self.showsZBarControls = NO;
    for (id sender in [self.view subviews]){
        NSLog(@"%@",sender);
        if ([sender isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)sender;
            if (view.height == 63) {
                [view removeFromSuperview];
            }else {
                view.height = view.height + 63;
            }
        }
    }


    int butW = 80;
    int butH = 40;
    _vi = [BGUtilUI drawViewWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50-butH, [UIScreen mainScreen].bounds.size.width, butH) BackgroundColor:[UIColor clearColor]];
    // 去掉 门店，商品，造型师 的选项
//    [self.view addSubview:_vi];
    UIButton *storeBut = [BGUtilUI drawButtonInView:_vi Frame:CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2, 0, butW, butH) IconName:@"" Title:@"门店" TitleFont:16.0 Target:self Action:@selector(clickBut:)];
    UIButton *goodsBut = [BGUtilUI drawButtonInView:_vi Frame:CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2+butW, 0, butW, butH) IconName:@"" Title:@"商品" TitleFont:16.0 Target:self Action:@selector(clickBut:)];
    UIButton *designesBut = [BGUtilUI drawButtonInView:_vi Frame:CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2+butW*2, 0, butW, butH) IconName:@"" Title:@"造型师" TitleFont:16.0 Target:self Action:@selector(clickBut:)];
    storeBut.tag = 100;
    goodsBut.tag = 101;
    designesBut.tag = 102;
    storeBut.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    storeBut.layer.borderWidth = 1;
    storeBut.backgroundColor = [UIColor whiteColor];
    [storeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goodsBut.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    goodsBut.layer.borderWidth = 1;
    goodsBut.backgroundColor = [UIColor whiteColor];
    [goodsBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    designesBut.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    designesBut.layer.borderWidth = 1;
    designesBut.backgroundColor = [UIColor whiteColor];
    [designesBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    hasBuildView = YES;
    
    [self performSelector:@selector(animations) withObject:nil afterDelay:0.5];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.readerView.torchMode = 0;
//    [self performSelector:@selector(animations) withObject:nil afterDelay:0.5];
}
- (void)animations
{
    if (!self.lineImageView) {
        self.lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saoyisao_light"]];
        self.lineImageView.frame = CGRectMake(10, 140, 300, 3);
        [self.view addSubview:self.lineImageView];
    }

    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 140)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 400)];
    translation.duration = 3;//2
    translation.repeatCount = HUGE_VALF;
    translation.autoreverses = YES;
    [self.lineImageView.layer addAnimation:translation forKey:@"translation"];
}
- (void)showVi
{
    MBLog(@"showVi is not used");
    /* jo
    if (self.codeType == DirectionsCode) {
        self.vi.hidden = YES;
    }else {
        self.vi.hidden = NO;
    }*/
}
 

#pragma mark - zbar 按钮的点击事件
- (void)dismissZBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
  
}
- (void)clickFlashlightBut:(id)sender  //闪光灯
{
    UIButton *but = (UIButton *)sender;
    if (!but.selected) {
        self.readerView.torchMode = 0;
    }else {
        self.readerView.torchMode = 1;
    }
    but.selected = !but.selected;
    
}
- (void)clickBut:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
//            self.codeType = StoreCode;
            UIButton *but1 = (UIButton *) [self.view viewWithTag:100];
            but1.backgroundColor = [UIColor lightGrayColor];
            UIButton *but2 = (UIButton *) [self.view viewWithTag:101];
            but2.backgroundColor = [UIColor whiteColor];
            UIButton *but3 = (UIButton *) [self.view viewWithTag:102];
            but3.backgroundColor = [UIColor whiteColor];
        }
            break;
        case 101:
        {
//            self.codeType = GoodsCode;
            UIButton *but1 = (UIButton *) [self.view viewWithTag:100];
            but1.backgroundColor = [UIColor whiteColor];
            UIButton *but2 = (UIButton *) [self.view viewWithTag:101];
            but2.backgroundColor = [UIColor lightGrayColor];
            UIButton *but3 = (UIButton *) [self.view viewWithTag:102];
            but3.backgroundColor = [UIColor whiteColor];
        }
            break;
        case 102:
        {
//            self.codeType = DesignerCode;
            UIButton *but1 = (UIButton *) [self.view viewWithTag:100];
            but1.backgroundColor = [UIColor whiteColor];
            UIButton *but2 = (UIButton *) [self.view viewWithTag:101];
            but2.backgroundColor = [UIColor whiteColor];
            UIButton *but3 = (UIButton *) [self.view viewWithTag:102];
            but3.backgroundColor = [UIColor lightGrayColor];
        }
            break;
        default:
            break;
    }
    
}
- (void)shoudongshuru:(id)sender  //手动输入商品码
{
//    InputBarCodeController *inputBarCodeController = [[InputBarCodeController alloc] initWithNibName:@"InputBarCodeController" bundle:nil];
//    inputBarCodeController.readerVC = self;
//    [self.navigationController pushViewController:inputBarCodeController animated:YES];
}
- (void)uploadImage:(id)sender   //从相册选择图片扫描二维码
{
    self.isZbar = NO;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - ------
//进详情页
- (void)goToDetailViewController:(NSString *)symbolData{
    NSError * error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b(product/|goods_sn=|goodsSn=|Goods/)(\\d{6})" options:0 error:&error];
    
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:symbolData options:0 range:NSMakeRange(0, [symbolData length])];
    if (firstMatch != nil) {
        NSRange resultRange = [firstMatch rangeAtIndex:2];
        NSString *strGoodSn = [symbolData substringWithRange:resultRange];
        [self dismissViewControllerAnimated:YES completion:^{
            
            if ([self.delegate respondsToSelector:@selector(goToViewControllerWithGoodsSN:)]) {
                [self.delegate goToViewControllerWithGoodsSN:strGoodSn];
            }
            
        }];
    }
}
- (NSMutableDictionary *)getDicFromData:(NSString *)symbolData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
//    if ([symbolData rangeOfString:@"spid"].location != NSNotFound) { // 没有门店也可以 商品详情
        NSString *spid = @"";
        NSString *sid = @"";
        NSString *pid = @"";
        NSString *valu = [[symbolData componentsSeparatedByString:@"?"] objectAt:1];
    
    if (symbolData.length == 13) {
        [dic setObject:symbolData forKey:@"pid"];
    }
    
    NSError * error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b(product/|goods_sn=|goodsSn=|Goods/)(\\d{11})" options:0 error:&error];
    
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:symbolData options:0 range:NSMakeRange(0, [symbolData length])];
    if (firstMatch != nil) {
        NSRange resultRange = [firstMatch rangeAtIndex:2];
        NSString *strGoodSn = [symbolData substringWithRange:resultRange];
        [dic setObject:strGoodSn forKey:@"pid"];
    }
    
        for (int i = 0; i < [[valu componentsSeparatedByString:@"&"] count]; i ++) {
            NSString *key = [[[[valu componentsSeparatedByString:@"&"] objectAt:i] componentsSeparatedByString:@"="] objectAt:0];
            
            if ([key isEqualToString:@"spid"] && key) {
                spid =  [[[[valu componentsSeparatedByString:@"&"] objectAt:i] componentsSeparatedByString:@"="] objectAt:1];
                [dic setObject:spid forKey:@"spid"];
            }
            if ([key isEqualToString:@"sid"] && key) {
                sid =  [[[[valu componentsSeparatedByString:@"&"] objectAt:i] componentsSeparatedByString:@"="] objectAt:1];
                [dic setObject:sid forKey:@"sid"];
            }
            if ([key isEqualToString:@"pid"] && key) {
                pid =  [[[[valu componentsSeparatedByString:@"&"] objectAt:i] componentsSeparatedByString:@"="] objectAt:1];
                [dic setObject:pid forKey:@"pid"];
            }
            
        }
//    }
        return dic;
}
//分析二维码
- (void)analyticalTheCode:(NSString *)symbolData{
    //新云门店的逻辑
//    if ([symbolData rangeOfString:@"mb.stylist.shop"].location != NSNotFound) {
        //------
    if (symbolData.length > 0) {
        self.dicData = [self getDicFromData:symbolData];
        [self startHttpWithASI:symbolData];
    }
//    }
}
- (void)goTofittingRoomList:(UIButton *)button
{
    UIView * alertView  = [self.view viewWithTag:88];
    [alertView removeFromSuperview] ;
    UIView * alertContentVeiw  = [self.view viewWithTag:87];
    [alertContentVeiw removeFromSuperview] ;
    FittingRoomViewController *controller = [[FittingRoomViewController alloc] initWithNibName:@"FittingRoomViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)showGuidList:(UIButton*)button{
    UIView * alertView  = [self.view viewWithTag:88];
    if (alertView) {
        [alertView removeFromSuperview] ;
    }
    
    UIView * alertContentVeiw  = [self.view viewWithTag:87];
    if (alertContentVeiw) {
         [alertContentVeiw removeFromSuperview] ;
    }
//   
//    GuideListViewController *controller = [[GuideListViewController alloc] initWithNibName:@"GuideListViewController" bundle:nil];
//    if (responsDic != nil) {
//        controller.storeId = responsDic[@"result"][@"ORG_CODE"];
//        controller.resultDic = responsDic[@"result"];
//    }
//    
//    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - http back

-(NSDictionary*)getNoNullDictionary:(NSDictionary*) dic {
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary] ;
    NSArray * keyArray = [dic allKeys];
    for (id  keyID in keyArray) {
        id valuelContent = dic[keyID];
       
        if(valuelContent != NULL && [valuelContent isEqualToString:@""]){
            [tempDic setObject:valuelContent forKey:keyID] ;
        }
    }
    return tempDic ;
}

-(void) dismissZbarGotoOrderConfirmViewController:(NSDictionary*)responseJSON{
    if ([self.delegate respondsToSelector:@selector(dissmissZbar:)]) {
        [self.delegate dissmissZbar:responseJSON];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)goBackToOrderConfirmViewController:(NSDictionary*)responseJSON{  //
    
    responsDic = responseJSON ;
    NSInteger searchType =[responseJSON[@"type"] integerValue] ;
    
    switch (searchType) {
        case 1:
        {  // 扫描门店
            [self dismissZbarGotoOrderConfirmViewController:responseJSON];
        
        }
            break;
        case 3:
            //进详情页
        {
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"请扫描导购或门店的二维码" message:nil delegate:nil cancelButtonTitle:nil
                                                otherButtonTitles:@"确定", nil];
            [ale show];
        }
            break;
        case 2:
            //关注造型师 进造型师的个人资料
        {
            [self dismissZbarGotoOrderConfirmViewController:responseJSON];
            
        }
            break;
            
        default:
            break;
    }


}

- (void)goToTheRightViewController:(NSDictionary *)responseJSON
{
    //------
    responsDic = responseJSON ;
    NSInteger searchType =[responseJSON[@"type"] integerValue] ;
    switch (searchType) {
        case 1://门店
        {
           
            
            //先注释，接口返回有问题，字典里面有null 不能做存储
            [[NSUserDefaults standardUserDefaults] setObject:responseJSON forKey:@"STOREINFO"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //进门店导购列表
            
//            NSInteger falg =  [responsDic[@"flag"] integerValue] ; // 0 第一次签到
//            if(falg == 0){  // 第一次签到 提示  为了解决透明度的问题 先这样做
                UIView * windowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                
                UIView * alertViewContent = [[[UINib nibWithNibName:@"BarcodeAlertView" bundle:nil] instantiateWithOwner:nil options:nil
                                  ] objectAtIndex:0] ;
            alertViewContent.layer.masksToBounds = YES;
            alertViewContent.layer.cornerRadius = 5.0;
                windowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                alertViewContent.center = windowView.center ;
                windowView.tag = 88 ;
                alertViewContent.tag = 87 ;
                UIButton * but =(UIButton*) [alertViewContent viewWithTag:89];// 显示导购列表的信息
                if (but) {
                    [but addTarget:self action:@selector(showGuidList:) forControlEvents:UIControlEventTouchUpInside] ;

                
                }
                UIButton * fittingRoom =(UIButton*) [alertViewContent viewWithTag:90];// 显示导购列表的信息
                if (fittingRoom) {
                    [fittingRoom addTarget:self action:@selector(goTofittingRoomList:) forControlEvents:UIControlEventTouchUpInside] ;
                    
                }
                [self.view addSubview:windowView];
                [self.view addSubview:alertViewContent] ;
      
//            }else{
//                GuideListViewController *controller = [[GuideListViewController alloc] initWithNibName:@"GuideListViewController" bundle:nil];
//                controller.storeId = responseJSON[@"result"][@"ORG_CODE"];
//                controller.resultDic = responseJSON[@"result"];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
          
            
            
        }
            break;
        case 3:
            //进详情页   扫单品时情况
            //         [self goToDetailViewController:symbolData];
             {
                 [self gotoRightViewController:(NSDictionary *)responseJSON];
                
            }
            break;
        case 2://导购
            //关注造型师 进造型师的个人资料
        {
            if (self.dicData[@"sid"]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseJSON forKey:@"STOREINFO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIView * windowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                
                UIView * alertViewContent = [[[UINib nibWithNibName:@"BarcodeAlertView" bundle:nil] instantiateWithOwner:nil options:nil
                                              ] objectAtIndex:0] ;
                alertViewContent.layer.masksToBounds = YES;
                alertViewContent.layer.cornerRadius = 5.0;
                windowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                alertViewContent.center = windowView.center ;
                windowView.tag = 88 ;
                alertViewContent.tag = 87 ;
                UIButton * but =(UIButton*) [alertViewContent viewWithTag:89];// 显示导购列表的信息
                if (but) {
                    [but setTitle:@"查看个人信息" forState:UIControlStateNormal];
                    [but addTarget:self action:@selector(showOtherPeopleVC:) forControlEvents:UIControlEventTouchUpInside] ;
                    
                    
                }
                UIButton * fittingRoom =(UIButton*) [alertViewContent viewWithTag:90];// 显示导购列表的信息
                if (fittingRoom) {
                    [fittingRoom addTarget:self action:@selector(goTofittingRoomList:) forControlEvents:UIControlEventTouchUpInside] ;
                    
                }
                [self.view addSubview:windowView];
                [self.view addSubview:alertViewContent] ;
                
                
                
            }else {
                UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"请扫描造型师二维码" message:nil delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:@"确定", nil];
                [ale show];
            }
            
        }
            break;
            
        default:
            break;
    }

    
}
- (void)showOtherPeopleVC:(UIButton *)button
{

}
-(void) gotoRightViewController:(NSDictionary *)responseJSON{ //获取门店签到情况
    
    //    SHOP_CODE
    __weak typeof(self) wself = self;
    //判断签到否
    [[HttpRequest shareRequst] httpRequestGetSCSIGNRECORDFilterWithDic:(NSMutableDictionary *)@{@"USER_ID":sns.ldap_uid} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                
                NSDictionary *dic =(NSDictionary *)data[0];
                ScanCodeInfo *_scanCodeInfo = [JsonToModel objectFromDictionary:dic className:@"ScanCodeInfo"];
                
                // 如果服务器有门店数据 表示已经签到
                if (_scanCodeInfo.shoP_CODE!=nil &&_scanCodeInfo.shoP_CODE.length != 0) { //
                    NSDictionary *stroeInfoDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"STOREINFO"];//本地的门店信息
                    if (stroeInfoDic) {//判断本地是否保存门店信息   保存并且服务器没失效
                        // 签到的单品详情
        
                    }else {//服务器未失效但是本地没保存门店信息
                        
                
                    }
                }else{//服务器门店信息失效
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"STOREINFO"];
       
                }
                
                
            }
        }
    } fail:^(NSString *errorMsg) {
        

        
    }];
    
    
    
}

- (void)startCodeInfo:(NSString *)url symbolData:(NSString *)symbolData
{
    
    NSMutableDictionary * params = [self getDicFromData:symbolData];
    if (self.whereComeFrom == comeFromeCloudStroe) {//云门店
        [params setObject:@"1" forKey:@"tag"];
    }else if (self.whereComeFrom == ComeFromOrderConfirm) {//确认订单界面
        [params setObject:@"2" forKey:@"tag"];
    }
    if (sns.ldap_uid) {
        [params setObject:sns.ldap_uid forKey:@"userid"];
    }
    
//    NSString *url = @"http://www.mixme.cn/shop/download/index.aspx";  //生产环境
    //    NSString *url = @"http://weixin.bonwe.com/mb.stylist.shop/stylistshop.ashx"; //测试环境
    NSMutableArray* getParamsString = [NSMutableArray arrayWithCapacity:[params count]];
    for (NSString* k in [params allKeys]) {
        NSString* v = params[k];
        [getParamsString addObject:[NSString stringWithFormat:@"%@=%@", k, v]];
    }
    NSString* connectGetParamsString = [getParamsString componentsJoinedByString:@"&"];
    NSString* fixedUrl = nil;
    if (connectGetParamsString.length > 0) {
        fixedUrl = [NSString stringWithFormat:@"%@?%@", url, connectGetParamsString];
    }
    else{
        fixedUrl = [NSString stringWithFormat:@"%@", url];
    }
    
    
    m_Request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fixedUrl]];
    NSLog(@"fixed url = ＝＝ %@  ",fixedUrl);
    m_Request.delegate = self;
    [m_Request setRequestMethod:@"GET"];
    [m_Request startAsynchronous];

}
- (void)startHttpWithASI:(NSString *)symbolData
{
    
    if (self.codeUrl.length > 0) {
        [self startCodeInfo:self.codeUrl symbolData:symbolData];
        return;
    }
    [[ASINetworkQueue queue] cancelAllOperations];
    [self getCodeUrl:YES syData:symbolData];
}

- (void)startHttp:(NSString *)syData imagePickerController: (UIImagePickerController*) reader
{
    if (self.codeUrl.length > 0) {
        [self startCodeInfo:self.codeUrl symbolData:syData];
        return;
    }
    [[ASINetworkQueue queue] cancelAllOperations];
    [self getCodeUrl:YES syData:syData];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSDictionary *responseJSON = nil;
    responseJSON = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
    
    if ([request responseStatusCode] == 200) {
        if ([responseJSON[@"status"] isEqualToString:@"success"]) {
            switch (self.whereComeFrom) {
                case comeFromeCloudStroe: // 云门店进入
                      [self goToTheRightViewController:responseJSON];
                    break;
                case ComeFromOrderConfirm: // 订单确认页面进入
                    [self goBackToOrderConfirmViewController:responseJSON];
                    break;
                default:
                    break;
            }
        
            NSLog(@"-----responseJSON －－－ %@",responseJSON);
        }else {
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" message:@"没有找到相关信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [ale show];
        }
    }
    
    if (m_Request) {
        [m_Request clearDelegatesAndCancel];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    if (m_Request) {
        [m_Request clearDelegatesAndCancel];
    }
}
#pragma mark - doThing
- (void)doThingWithScan:(NSDictionary *)info imagePickerController: (UIImagePickerController*) reader
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    AudioServicesPlaySystemSound(1106);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    MBLog(@"%@",symbol.data);
    
    if (symbol.data.length > 0) {
        if ([symbol.data hasPrefix:@"http://"] || [symbol.data hasPrefix:@"https://"]) {
            [self analyticalTheCode:symbol.data];
        }else if ([symbol.data hasPrefix:@"fun"]){ // 扫的是 会员二维码 格式为 fun_8a1ae96f-52aa-4ee0-9b01-c121d32fb292
            NSString * userID = [symbol.data substringFromIndex:4];

            if ([userID isEqualToString:sns.ldap_uid]) {
               
                return;
            }
            
      
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        else {
            if ([[[symbol.data componentsSeparatedByString:@"pid="] objectAt:1] length] == 13) {
                [self startHttp:symbol.data imagePickerController:reader];
            }else if(symbol.data.length == 13){
                [self startHttp:symbol.data imagePickerController:reader];
            }else {
                [self showAlertView];
            }
        }
    }else {
        [self showAlertView];
    }
}
- (void)doThingWithPickImage:(NSDictionary *)info imagePickerController: (UIImagePickerController*) reader
{
    self.isZbar = YES;
    ZBarReaderController* read = [ZBarReaderController new];
    read.readerDelegate = self;
    ZBarSymbol* symbol = nil;
    for(symbol in [read scanImage:[[info objectForKey:UIImagePickerControllerEditedImage] CGImage]]){
        break;
    }
    MBLog(@"%@",symbol.data);
    if (symbol.data.length > 0) {
        [reader dismissViewControllerAnimated:YES completion:^{
            if ([symbol.data hasPrefix:@"http://"] || [symbol.data hasPrefix:@"https://"]) {
                [self analyticalTheCode:symbol.data];
            }else if ([symbol.data hasPrefix:@"fun"]){ // 扫的是 会员二维码 格式为 fun_8a1ae96f-52aa-4ee0-9b01-c121d32fb292
      
            }
            else {
                // 不明白为啥要dismss
//                [self dismissViewControllerAnimated:YES completion:^{
//                    [self startHttp:symbol.data imagePickerController:nil];
//                }];
                
                if (symbol.data.length == 13) {
                    [self startHttp:symbol.data imagePickerController:reader];
                }else{
                    [self showAlertView];
                }
            }
        }];
    }else {
        [reader dismissViewControllerAnimated:YES completion:^{
            [self showAlertView];
        }];
    }
    
}

#pragma mark - UIImagePickerController   zbar 和相册选择的之后的回调
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{

    if (self.isZbar) { //扫描
        [self doThingWithScan:info imagePickerController:reader];
    }else {  //选择图片扫描
        [self doThingWithPickImage:info imagePickerController:reader];
    }
}

- (void) readerControllerDidFailToRead:(ZBarReaderController*)reader withRetry:(BOOL)retry
{
    if(retry){
        return;
    }
}
#pragma mark - ----- 获取环境url  isAnalyticalTheCode Yes 扫码之后
- (void)getCodeUrl:(BOOL)isAnalyticalTheCode syData:(NSString *)syData
{
    
    if ( self.codeUrl != nil && self.codeUrl.length != 0) {
        if (isAnalyticalTheCode) {
            [self startCodeInfo: self.codeUrl symbolData:syData];
        }
    }else{
        [HttpRequest collocationPostRequestPath:nil methodName:@"BSParamFilter" params:@{@"Code":@"CLOUDSHOP_URL"} success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            if ([dict[@"isSuccess"] boolValue]) {
                self.codeUrl = [dict[@"results"] lastObject][@"paraM_VALUE"];
                if (isAnalyticalTheCode) {
                    [self startCodeInfo:[dict[@"results"] lastObject][@"paraM_VALUE"] symbolData:syData];
                }
            }
            
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    }
    
   //    [HttpRequest collocationGetRequestPath:nil methodName:@"BSParamFilter" params:@{@"code":@"CLOUDSHOP_URL"} success:^(NSDictionary *dict) {
//        NSLog(@"%@",dict);
//        if ([dict[@"isSuccess"] boolValue]) {
//            self.codeUrl = [dict[@"results"] lastObject][@"paraM_VALUE"];
//            if (isAnalyticalTheCode) {
//                [self startCodeInfo:[dict[@"results"] lastObject][@"paraM_VALUE"] symbolData:syData];
//            }
//        }
//    } failed:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];

}

#pragma mark - UIAlertView
- (void)showAlertView
{
    UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"您扫描的二维码或者条形码不正确" message:nil delegate:self cancelButtonTitle:nil
                                        otherButtonTitles:@"确定", nil];
    ale.tag = 88 ;
    [ale show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == URLTAG) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.message]];
        }
    }else if(alertView.tag == AlertViewTAG){
        if (buttonIndex == 1) {
        }
    }else if (alertView.tag == 88){
        [self dismissZBar];
    }
    
}
@end
