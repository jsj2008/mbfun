//
//  AboutViewController.m
//  FaFa
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "LoadWebViewController.h"
#import "Utils.h"
#import "FileReaderViewController.h"
#import "MBShoppingGuideInterface.h"

NSString *const UPDATE_URL=@"http://itunes.apple.com/lookup?id=687237651";
static NSString *UPDATE_WEFAFA_PLIST_URL=@"";

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconPic;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImgView;

@end

@implementation AboutViewController
@synthesize lbVersion;
@synthesize severTelephone;
@synthesize rightInformation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect headrect=CGRectMake(0,0,UI_SCREEN_WIDTH,self.viewHead.frame.size.height);
    NavigationTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    titleView.lbTitle.text=@"关于";
//    [self.viewHead addSubview:titleView];
   
//    [self setupNavbar];
    [_iconPic setFrame:CGRectMake(UI_SCREEN_WIDTH/2-_iconPic.frame.size.width/2, _iconPic.frame.origin.y, _iconPic.frame.size.width, _iconPic.frame.size.height)];
    
//    [_bottomImgView setImage:[UIImage imageNamed:@"Unico/aboutwe"]];
    
    self.view.backgroundColor = [Utils HexColor:0xfcfcfc Alpha:1.0];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    // 主版本号,CFBundleShortVersionString关键字指定了束的版本号。一般包含该束的主、次版本号。这个字符串的格式通常是“n.n.n”（n表示某个数字）。第一个数字是束的主要版本号，另两个是次要版本号。该关键字的值会被显示在Cocoa应用程序的关于对话框中。
    NSString* versionNum=[infoDict objectForKey:@"CFBundleShortVersionString"];
    // 次版本号,CFBundleVersion关键字指定了一个字符串用来标识创建号。该关键字的值通常随每一次创建而改变，并且会被显示在Cocoa"关于"对话框中的扩号里
//    NSString* buildNum = [infoDict objectForKey:@"CFBundleVersion"];
    // 应用名称
//    NSString* appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    
    //lbVersion.text=[NSString stringWithFormat:@"Wefafa iPhone V%@ Build:%@", versionNum, buildNum];
    lbVersion.text=[NSString stringWithFormat:@"有范 iPhone V%@", versionNum];
    severTelephone.text= [NSString stringWithFormat:@"客服电话: %@",CUSTO_SERVICE_PHONE];
    rightInformation.text=COPYRIGHT;
    [rightInformation setFrame:CGRectMake(0, UI_SCREEN_HEIGHT-50,UI_SCREEN_WIDTH, 50)];
    
    rightInformation.textAlignment=NSTextAlignmentCenter;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
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
    self.title=@"关于我们";
    
//    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
//
//    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
//    [tempBtn setTitle:@"关于" forState:UIControlStateNormal];
//    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
//    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [tempView addSubview:tempBtn];
//    // default40@2x.9
//    
//    self.navigationItem.titleView = tempView;
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleTap:)];
//    [self.navigationItem.titleView setUserInteractionEnabled:YES];
//    [self.navigationItem.titleView addGestureRecognizer:recognizer];
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidUnload
{
    [self setLbVersion:nil];
    [self setBtnCheckVersion:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCheckVersionClick:(id)sender {
    [_btnCheckVersion setTitle:@"检查中..." forState:UIControlStateNormal];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#ifdef APPSTORE
        NSString *updateurl=[NSString stringWithContentsOfURL:[NSURL URLWithString:UPDATE_URL] encoding:NSUTF8StringEncoding error:nil];
        if (updateurl!=nil && [updateurl length]>0 && [updateurl rangeOfString:@"version"].length==7)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_btnCheckVersion setTitle:@"检查版本更新" forState:UIControlStateNormal];
                [AboutViewController checkAppUpdate:updateurl delegate:self];
            });
        }
#else
        NSMutableString *result=[[NSMutableString alloc] initWithCapacity:32];
        if ([SHOPPING_GUIDE_ITF requestMBSoaToken:result])
        {
            BOOL needUpdate=NO;
            
            NSMutableDictionary *rstDict=[[NSMutableDictionary alloc] initWithCapacity:10];
            NSMutableString *msg = [[NSMutableString alloc]init];
            
            NSDictionary *dict=@{@"softwareCode":SOFTWARECODE,@"evmCode":EVMCODE};
            //    if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"GetLastVersionSummary" param:dict responseAll:rstDict responseMsg:msg])
            if ([SHOPPING_GUIDE_ITF requestMBSoaServer:@"GetLastVersionSummary" param:dict method:@"GET" responseObject:rstDict returnMsg:msg])
            {
                for (NSDictionary *dictrst in rstDict[@"result"])
                {
                    //            {
                    //                ISFORECUPDATE = 1;
                    //                MAJORNO = "MB.Designer.App.IOS";
                    //                RELEASENOTE = "<null>";
                    //                SUDCODE = PR15015897;
                    //                VERSIONDESC = "1.1.1.9";
                    //                VERSIONNAME = "IOS\U5ba2\U6237\U7aef";
                    //                VERSIONNO = 1;
                    //            }
                    
                    if ([[dictrst[@"MAJORNO"] lowercaseString] rangeOfString:@"ios"].location != NSNotFound)
                    {
                        NSString *serverVersion=[Utils getSNSString:dictrst[@"VERSIONDESC"]];
                        
                        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
                        NSString* currVersion=[infoDict objectForKey:@"CFBundleShortVersionString"];
                        if ([currVersion isEqualToString:serverVersion]==NO)
                        {
                            if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"GetAppFilePath" param:@{@"ostype":@"ios"} responseAll:rstDict responseMsg:msg])
                            {
                                //                        {
                                //                            isSuccess = 1;
                                //                            message = "";
                                //                            result = "http://www.51mb.com/apps/designer/designer.plist";
                                //                        }
                                
                                UPDATE_WEFAFA_PLIST_URL=[[NSString alloc] initWithFormat:@"%@",rstDict[@"result"]];
                            }
                            
                            if (UPDATE_WEFAFA_PLIST_URL.length>0)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"新版本v%@已经发布(当前版本V%@)，\n请更新后再使用！",serverVersion,currVersion] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消",nil];
                                [alert show];
                                });
                                needUpdate=YES;
                            }
                            break;
                        }
                    }
                }
            }
        }

//        //企业版
//        //check version
//        NSDictionary *dict=[Utils projectPlistToDictionary];
//        NSMutableString *version=[[NSMutableString alloc] init];
//        BOOL rst=[Utils isLastVersion:dict versionString:version];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (rst==NO)
//            {
//                [_btnCheckVersion setTitle:@"检查版本更新" forState:UIControlStateNormal];
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"新版本v%@已经发布，\n请更新后再使用！",version] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//            }
//            else
//            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"已经是最新版本:%@!",version] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//            }
//        });
#endif
    });
}

+ (void)checkAppUpdate:(NSString*)appInfo delegate:(id)del{
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appInfo1=[appInfo substringFromIndex:[appInfo rangeOfString:@"\"version\":"].location+10];
    NSString *appInfo2=[appInfo substringFromIndex:[appInfo rangeOfString:@"\"trackViewUrl\":"].location+15];
    appInfo1=[[appInfo1 substringToIndex:[appInfo1 rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    appInfo2=[[appInfo2 substringToIndex:[appInfo2 rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    if (![appInfo1 isEqualToString:version]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo1] delegate:del cancelButtonTitle:@"查看" otherButtonTitles:@"忽略",nil];
        
        UILabel *ulbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
        [ulbl setText:[NSString stringWithFormat:@"%@",appInfo2]];
        [ulbl setTag:9999];
        [alert addSubview:ulbl];
        
        [alert show];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"已经是最新版本:%@!",appInfo1] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#ifdef APPSTORE
    if ([alertView.title isEqualToString:@"版本更新"])
    {
        if (buttonIndex==0) {
            UILabel *lb=(UILabel *)[alertView viewWithTag:9999];
            NSString *url= lb.text;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
#else
    if ([alertView.title isEqualToString:@"版本更新"])//企业版
    {
        if (buttonIndex==0) {
            NSString *downloadurl = [[NSString alloc] initWithFormat:@"itms-services://?action=download-manifest&url=%@",UPDATE_WEFAFA_PLIST_URL.length>0?UPDATE_WEFAFA_PLIST_URL:WEFAFA_PLIST_URL];
            NSURL *url  = [NSURL URLWithString:downloadurl];
            [[UIApplication sharedApplication] openURL:url];
            exit(0);
        }
//
//        if (buttonIndex==0) {
//            NSString *downloadurl = [[NSString alloc] initWithFormat:@"itms-services://?action=download-manifest&url=%@",WEFAFA_PLIST_URL];
//            NSURL *url  = [NSURL URLWithString:downloadurl];
//            [[UIApplication sharedApplication] openURL:url];
//            exit(0);
//        }
    }
#endif
}

- (IBAction)btnService_OnTouchUpInside:(id)sender {
   
    LoadWebViewController *loadWebVC=[[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil title:@"服务条款"];
    [loadWebVC loadWebPageWithString:@"https://www.wefafa.com/userlic.htm"];
    [self.navigationController pushViewController:loadWebVC animated:YES];
  
}

- (IBAction)btnZHServiceClick:(id)sender {
    FileReaderViewController *readerVC=[[FileReaderViewController alloc] initWithNibName:@"FileReaderViewController" bundle:nil];
    readerVC.fileName=@"服务条款";
    [self.navigationController pushViewController:readerVC animated:YES];
}

- (IBAction)btnZHPrivateClick:(id)sender {
    FileReaderViewController *readerVC=[[FileReaderViewController alloc] initWithNibName:@"FileReaderViewController" bundle:nil];
    readerVC.fileName=@"隐私声明";
    [self.navigationController pushViewController:readerVC animated:YES];
}

- (IBAction)btnCallClick:(id)sender {
    [self CallPhone:@"4008102525"];
}

- (IBAction)btnURLClick:(id)sender {
    LoadWebViewController *loadWebVC=[[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil title:@"美邦"];
    [loadWebVC loadWebPageWithString:@"http://www.metersbonwe.com"];
    [self.navigationController pushViewController:loadWebVC animated:YES];
}

-(void)CallPhone:(NSString *)phoneNum
{
    if ([phoneNum length] < 8 || ([phoneNum rangeOfString:@"*"].location != NSNotFound))
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"拨号" message:[NSString stringWithFormat:@"对方设置了无效的电话号码：\n%@\n无法拨出",phoneNum] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self startCallPhone:phoneNum];
    }
}

-(void)startCallPhone:(NSString *)phoneNum
{
    UIWebView *callWebview=nil;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !callWebview ) {
        callWebview = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:callWebview];
}

@end
