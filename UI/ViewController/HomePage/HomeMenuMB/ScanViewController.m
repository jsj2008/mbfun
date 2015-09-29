//
//  ScanViewController.m
//  Wefafa
//
//  Created by fafatime on 14/12/3.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "ScanViewController.h"
#import "Utils.h"
#import "RootViewController.h"
#import "AppDelegate.h"

#import "SMineViewController.h"
#import "JSWebViewController.h"
#import "SUtilityTool.h"
#define QRCODELINE [Utils HexColor:0xf46c56 Alpha:1.0]

@interface ScanViewController ()
@property (nonatomic, strong) UIView *view_camera_negative;
@end

@implementation ScanViewController
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title =@"扫描二维码";
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title=@"扫描二维码";。
    [self setupNavbar];
    _naviView.hidden=YES;
    self.view.backgroundColor = [UIColor blackColor];
    
//    //判断摄像头权限
//    if (![self shoudCameraBegingToWork]) {
//        [self layoutSubViewWhileCameraDenied];
//        return;
//    }
    
    //初始化扫描界面
    [self setScanView];
    
    _readerView= [[ZBarReaderView alloc]init];
    _readerView.frame =CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    _readerView.tracksSymbols=NO;
    _readerView.readerDelegate =self;
    [_readerView addSubview:_scanView];
    //关闭闪光灯
    _readerView.torchMode =0;
    
    [self.view addSubview:_readerView];
    
    //扫描区域
    //readerView.scanCrop =
    
    [_readerView start];
    [self createTimer];
    
    //判断摄像头权限
    if (![self shoudCameraBegingToWork]) {
        //没权限使用摄像头
        [self layoutSubViewWhileCameraDenied];
        [_readerView removeFromSuperview];
    }
}

- (void)layoutSubViewWhileCameraDenied {
    if (!_view_camera_negative) {
        NSString *str = @"点击“设置”，允许有范使用您的相机扫描";
        _view_camera_negative = [[UIView alloc] initWithFrame:CGRectZero];
        
        UILabel* titleLabel = [UILabel new];
        [titleLabel setText:@"使用有范拍照"];
        [titleLabel setFont:FONT_T2];
        [titleLabel setTextColor:COLOR_C3];
        [titleLabel sizeToFit];
        [_view_camera_negative addSubview:titleLabel];
        
        UILabel *detailLabel = [UILabel new];
        [detailLabel setText:str];
        [detailLabel setFont:FONT_t5];
        [detailLabel setTextColor:COLOR_C3];
        [detailLabel setTop:titleLabel.bottom + 8];
        [detailLabel sizeToFit];
        [_view_camera_negative addSubview:detailLabel];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setFrame:CGRectMake(0, 0, 140, 30)];
        [settingBtn setTop:detailLabel.bottom + 30];
        settingBtn.layer.cornerRadius = 3;
        [settingBtn setBackgroundColor:COLOR_C1];
        [settingBtn setTitle:@"准许使用摄像头" forState:UIControlStateNormal];
        [settingBtn.titleLabel setFont:FONT_t4];
        [settingBtn setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(allowCameraClicked) forControlEvents:UIControlEventTouchUpInside];
        [_view_camera_negative addSubview:settingBtn];

        if ([self allowPrivateSetting]) {
            //可以跳转进入设置页面
        }else {
            str = @"您可以在隐私设置中设置相应权限";
            titleLabel.text = @"无法启用相机";
            detailLabel.text = str;
            [titleLabel sizeToFit];
            [detailLabel sizeToFit];
            settingBtn.hidden = YES;
        }
        CGRect rect = [str boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : FONT_t5} context:nil];
        _view_camera_negative.frame = CGRectMake(0, 0, rect.size.width, 0);
        rect.size.height = settingBtn.bottom;
        _view_camera_negative.frame = rect;
        
        [titleLabel setCenterX:_view_camera_negative.centerX];
        [detailLabel setCenterX:_view_camera_negative.centerX];
        [settingBtn setCenterX:_view_camera_negative.centerX];
        
        [_view_camera_negative setCenter:CGPointMake(UI_SCREEN_WIDTH / 2, (UI_SCREEN_HEIGHT - 64) / 2)];
        [self.view addSubview:_view_camera_negative];
    }
}

//二维码的扫描区域
- (void)setScanView
{
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT-49)];
    _scanView.backgroundColor=[UIColor clearColor];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,SCREEN_WIDTH-2*SCANVIEW_EdgeLeft)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:leftView];
    
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCREEN_WIDTH-2*SCANVIEW_EdgeLeft,SCREEN_WIDTH-2*SCANVIEW_EdgeLeft)];
    scanCropView.image=[UIImage imageNamed:@"scanBg.png"];
//    scanCropView.layer.borderColor=[UIColor whiteColor].CGColor;
//    scanCropView.layer.borderWidth=2.0;
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,SCREEN_WIDTH-2*SCANVIEW_EdgeLeft)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop,SCREEN_WIDTH, SCREEN_HEIGHT-(SCREEN_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop)-49)];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [_scanView addSubview:downView];
    
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0,5, SCREEN_WIDTH,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码对准方框，即可自动扫描";
    [downView addSubview:labIntroudction];
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, downView.frame.size.height-100.0,SCREEN_WIDTH, 100.0)];
    darkView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:DARKCOLOR_ALPHA];
    [downView addSubview:darkView];
    
//    //用于开关灯操作的button
//    UIButton *openButton=[[UIButton alloc] initWithFrame:CGRectMake(10,20, 300.0, 40.0)];
//    [openButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
//    [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
//    openButton.backgroundColor=[UIColor redColor];
//    openButton.titleLabel.font=[UIFont systemFontOfSize:22.0];
//    [openButton addTarget:self action:@selector(openLight)forControlEvents:UIControlEventTouchUpInside];
//    [darkView addSubview:openButton];
    
    //画中间的基准线
    _QrCodeline = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCREEN_WIDTH-2*SCANVIEW_EdgeLeft,2)];
    _QrCodeline.backgroundColor = QRCODELINE;//f46c56
    [_scanView addSubview:_QrCodeline];
}

- (void)openLight
{
    if (_readerView.torchMode ==0) {
        _readerView.torchMode =1;
    }else
    {
        _readerView.torchMode =0;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_readerView.torchMode ==1) {
        _readerView.torchMode =0;
    }
    [self stopTimer];
    
    [_readerView stop];
    
}
//二维码的横线移动
- (void)moveUpAndDownLine
{
    CGFloat Y=_QrCodeline.frame.origin.y;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (SCREEN_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, SCREEN_WIDTH-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
    }else if(SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCREEN_WIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, SCREEN_WIDTH-2*SCANVIEW_EdgeLeft,1);
        [UIView commitAnimations];
    }
    
}

- (void)createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}

#pragma mark -- ZBarReaderViewDelegate
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    const zbar_symbol_t *symbol =zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    if([_scanTypeChat isEqualToString:@"1"]){
    
        [self dismissViewControllerAnimated:YES completion:^{
            NSDictionary *dict = @{@"scanInfo":symbolStr};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"symbolStr" object:self userInfo:dict];
        }];
    }
    
    else{
        if ([[[symbolStr substringToIndex:7] lowercaseString] isEqualToString:@"http://"] || [[[symbolStr substringToIndex:8] lowercaseString] isEqualToString:@"https://"])
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:symbolStr]]) {
                JSWebViewController *web = [[JSWebViewController alloc] initWithUrl:symbolStr];
                [web setNaviTitle:@"扫描信息"];
                [self.navigationController pushViewController:web animated:YES];
            }else{
                [Utils alertMessage:@"未知信息"];
            }
//            int urllength=58;
//            NSString *msg=[NSString stringWithFormat:@"是否打开网页: [%@]？",[symbolStr length]<urllength?symbolStr:[NSString stringWithFormat:@"%@...",[symbolStr substringToIndex:urllength]]];
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"打开" otherButtonTitles:@"取消", nil];
//            
//            UILabel *httplab=[[UILabel alloc] init];
//            httplab.tag=10;
//            httplab.text=symbolStr;
//            [alert addSubview: httplab];
//            alert.tag=1001;
//            [alert show];
//            symbolStr=@"";
        }
        
        else if ([[symbolStr substringToIndex:4] isEqualToString:@"fun_"])
        {//跳转到好友名片
            
            SMineViewController *mineViewControl = [[SMineViewController alloc] init];
            symbolStr = [symbolStr stringByReplacingOccurrencesOfString:@"fun_" withString:@""];
            mineViewControl.person_id = symbolStr;
            [[AppDelegate rootViewController] popViewControllerAnimated:NO];
            [[AppDelegate rootViewController] pushViewController:mineViewControl animated:YES];
            
//            [self dismissViewControllerAnimated:NO completion:nil];
            
//            MBOtherStoreViewController *otherStore=[[MBOtherStoreViewController alloc]initWithNibName:@"MBOtherStoreViewController" bundle:nil];
//            otherStore.staffType=STAFF_TYPE_LOGINACCOUNT;
//            otherStore.user_ID = symbolStr;
//            [[AppDelegate rootViewController] pushViewController:otherStore animated:YES];
//            
//            [self dismissViewControllerAnimated:NO completion:nil];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫描的内容无效" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    }
    
    
    //    //判断是否包含 头'http:'
    //    NSString *regex =@"http+:[^\\s]*";
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@""message:symbolStr delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:nil];
    //    [alertView show];
    //
    //    //判断是否包含 头'ssid:'
    //    NSString *ssid =@"ssid+:[^\\s]*";;
    //    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    //
    //    if ([predicate evaluateWithObject:symbolStr]) {
    //
    //    }
    //    else if([ssidPre evaluateWithObject:symbolStr]){
    //
    //        NSArray *arr = [symbolStr componentsSeparatedByString:@";"];
    //
    //        NSArray * arrInfoHead = [[arr  objectAtIndex:0]componentsSeparatedByString:@":"];
    //
    //        NSArray * arrInfoFoot = [[arr objectAtIndex:1]componentsSeparatedByString:@":"];
    //
    //
    //        symbolStr = [NSString stringWithFormat:@"ssid: %@ \n password:%@",
    //                     [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
    //
    //        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    //        //然后，可以使用如下代码来把一个字符串放置到剪贴板上：
    //        pasteboard.string = [arrInfoFoot objectAtIndex:1];
    //    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
        if (buttonIndex==0)
        {
            UILabel *httplab=(UILabel *)[alertView viewWithTag:10];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:httplab.text]];
        }
    }
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

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)allowCameraClicked {
    if ([self allowPrivateSetting])
    {
        //可以跳转进入设置页面
        NSURL *url=[NSURL URLWithString:@"prefs:root=Privacy"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (BOOL)allowPrivateSetting {
    NSURL *url=[NSURL URLWithString:@"prefs:root=Privacy"];
    BOOL ret = [[UIApplication sharedApplication] canOpenURL:url];
    return ret;
}


#pragma mark - 判断摄像头权限
- (BOOL)shoudCameraBegingToWork {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    AVAuthorizationStatusNotDetermined = 0,
//    AVAuthorizationStatusRestricted,
//    AVAuthorizationStatusDenied,
//    AVAuthorizationStatusAuthorized
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined){
        return false;
    }
    return YES;
}
@end
