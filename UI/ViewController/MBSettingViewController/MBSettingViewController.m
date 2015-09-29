//
//  MBSettingViewController.m
//  Wefafa
//
//  Created by fafatime on 14-11-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBSettingViewController.h"
#import "AppSetting.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SQLiteOper.h"

#import "AboutViewController.h"
#import "ModifyPasswordViewController.h"
#import "SDImageCache.h"
#import "NavigationTitleView.h"
#import "SuggestionFeedbackViewController.h"
#import "LoadWebViewController.h"
#import "MBShoppingGuideInterface.h"
#import "AppSetting.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "Toast.h"

//#import "HMCustomSwitch.h"
static NSString *UPDATE_WEFAFA_PLIST_URL=@"";


@interface MBSettingViewController ()
{
//    HMCustomSwitch * _voiceSwitch;
//    HMCustomSwitch * _vibtateSwitch;
//

}
@property (weak, nonatomic) IBOutlet UIButton *exitLoginBtn;
@property (strong, nonatomic) IBOutlet UITableViewCell *exitLoginTableViewCell;

@end

@implementation MBSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupNavbar {
    [super setupNavbar];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"设置";
//    [self changeArea];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.userInteractionEnabled=YES;
    _tableView.userInteractionEnabled=YES;
    
    _switchTipVoice.onTintColor = [Utils HexColor:0xfedc32 Alpha:1];
    _switchTipVoice.tintColor = [Utils HexColor:0xfedc32 Alpha:1];
    _switchTipViber.onTintColor = [Utils HexColor:0xfedc32 Alpha:1];
    _switchTipViber.tintColor = [Utils HexColor:0xfedc32 Alpha:1];
    //第三方登陆没有修改密码选项.
    if(sns.isThirdLogin)
    {
        sections = @[@"_userinfo", @[_tipVoiceTableViewCell,_tipViberTableViewCell], //_tipViberTableViewCell，_helpCell,_clearChattingRecordsCell,
                     @"_help",@[_clearDataCell, _checkUpdataCel],
                     @"_about", @[_aboutWeCell, _suggestionCell,],// _mdtgCell
//                     @"_quit",@[_exitLoginTableViewCell]
                     ];
    }
    else
    {
        sections = @[@"_userinfo", @[_tipVoiceTableViewCell,_tipViberTableViewCell], //_tipViberTableViewCell，_helpCell,_clearChattingRecordsCell,
                     @"_help",@[_clearDataCell, _checkUpdataCel],//_modifyPassWord,
                     @"_about", @[ _aboutWeCell,_suggestionCell],//, _mdtgCell
//                     @"_quit",@[_exitLoginTableViewCell]
                     ];
    }

    //@"_quit",@[_quitView]
    _tableView.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
//    _quitView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-74, self.view.width, 74);
//    [self.view addSubview:_quitView];
    [_tableView setTableFooterView:[self configFootView]];
    [self.exitLoginBtn setTitleColor:[Utils HexColor:0xffffff Alpha:1] forState:UIControlStateNormal];
    [self.exitLoginBtn setTitleColor:[Utils HexColor:0xffffff Alpha:1] forState:UIControlStateHighlighted];
//    [self.exitLoginBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    [self.exitLoginBtn setBackgroundColor:[Utils HexColor:0xfedc32 Alpha:1]];
    [_tableView setSeparatorColor:[Utils HexColor:0xE2E2E2 Alpha:1.0]];
    
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum=[infoDict objectForKey:@"CFBundleShortVersionString"];
    _lbVersion.text=[[NSString alloc] initWithFormat:@"版本%@",versionNum];
    
    //sdimagecache大小
    NSInteger sdCacheSize=[[SDImageCache sharedImageCache] getSize];
    float cacheS=sdCacheSize/(1000.0*1000.0);
    NSLog(@"sd-cache---%.2f",cacheS);
    //整个cache文件夹大小
//    NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) ;
//    NSString *cachePath = [pathes lastObject];
//    float cacheFileSize =[self folderSizeAtPath:cachePath];

    float personalFileSize =[self folderSizeAtPath:[AppSetting getPersonalFilePath]];
    NSLog(@"personalFileSize－－%f---cacheFileSize---%f",personalFileSize,cacheS);
    float allFileSize = cacheS +personalFileSize;
    
    _cacheSizeLabel.text = [NSString stringWithFormat:@"%.2fM",allFileSize];
    self.exitLoginBtn.layer.cornerRadius = 3;
    
    //[self initSwitch];
    [self initSwitchStatus];
}

- (UIView *)configFootView
{
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 230)];
//    [footView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1.0]];
    
//    _quitView.frame = CGRectMake(0, 230 - 55, UI_SCREEN_WIDTH, 55);
//    [footView addSubview:_quitView];
    
//    return _quitView;
    return [[UIView alloc]init];
    
}
//-(void)initSwitch
//{
//    _voiceSwitch = [[HMCustomSwitch alloc] init];
////    _voiceSwitch.center = CGPointMake(160.0f, 260.0f);
//    _voiceSwitch.tintColor = [UIColor colorWithRed:125.f/255.f green:157.f/255.f blue:93.f/255.f alpha:1.0];
//    [_voiceSwitch addTarget:self action:@selector(voiceSwitchFlipped:) forControlEvents:UIControlEventValueChanged];
//    [_tipVoiceTableViewCell.contentView addSubview:_voiceSwitch];
//    
//    _vibtateSwitch = [[HMCustomSwitch alloc] init];
////    _vibtateSwitch.center = CGPointMake(160.0f, 260.0f);
//    _vibtateSwitch.tintColor = [UIColor colorWithRed:125.f/255.f green:157.f/255.f blue:93.f/255.f alpha:1.0];
//    [_vibtateSwitch addTarget:self action:@selector(viberateSwitchFlipped:) forControlEvents:UIControlEventValueChanged];
//    [_tipViberTableViewCell.contentView addSubview:_vibtateSwitch];
//
//}
-(void)initSwitchStatus
{
    [self.switchTipVoice setOn:[AppSetting getMsgTipVoice]];
    [self.switchTipViber setOn:[AppSetting getMsgTipViber]];

}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count] / 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headername = [sections objectAtIndex:section*2+0];
    if ([headername characterAtIndex:0] == '_') return nil;
    return headername;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tablesection = [sections objectAtIndex:section*2+1];
    return [tablesection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tablesection = [sections objectAtIndex:[indexPath section]*2+1];
    UITableViewCell *cellX = [tablesection objectAtIndex:[indexPath row]];
    
    NSString *AIdentifier =  [cellX reuseIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = cellX;
    }
    if (cell == _checkUpdataCel) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if (cell == _modifyPassWord && sns.isThirdLogin) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if (cell==_clearDataCell) {
         [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==0) {
        return 20;
    }else{
        return 15;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tablesection = [sections objectAtIndex:[indexPath section]*2+1];
    UITableViewCell *cellX = [tablesection objectAtIndex:[indexPath row]];
    
    if (cellX == _helpCell)
    {
        LoadWebViewController *loadWebVC=[[LoadWebViewController alloc] initWithNibName:@"LoadWebViewController" bundle:nil title:@"帮助中心"];
        [loadWebVC loadWebPageWithString:@"http://10.100.5.12:8066/?filter=#"];//http://www.banggo.com/Article/help.shtml
        [self.navigationController pushViewController:loadWebVC animated:YES];
    }
    else if (cellX==_checkUpdataCel)
    {
//        [self checkUpdate];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本更新" message:[NSString stringWithFormat:@"已经是最新版本!"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
    }
    else if (cellX == _clearDataCell)
    {
        [self clearUserData];
    }
    else if (cellX == _clearChattingRecordsCell)
    {
        [self clearChattingRecords];
    }
    else if (cellX == _suggestionCell)
    {
        SuggestionFeedbackViewController *suggestionViewController = [[SuggestionFeedbackViewController alloc] initWithNibName:@"SuggestionFeedbackViewController" bundle:nil];
//        suggestionViewController.navigationItem.hidesBackButton = YES;
        [self pushController:suggestionViewController animated:YES];
//        RootViewController *rootvc=[AppDelegate rootViewController];
//        [rootvc pushViewController:suggestionViewController animated:YES];
    }
    else if (cellX == _aboutWeCell)
    {
        AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
          [self pushController:aboutViewController animated:YES];
//        RootViewController *rootvc=[AppDelegate rootViewController];
//        [rootvc pushViewController:aboutViewController animated:YES];
    }
    else if (cellX == _mdtgCell)
    {
        [[SUtilityTool shared] showWebpage:MBH5URL titleName:@"我的推广码" shareImg:nil];
    }
    else if (cellX == _modifyPassWord){
        if (!sns.isThirdLogin) {
            ModifyPasswordViewController *modifyPwdVC=[[ModifyPasswordViewController alloc] initWithNibName:@"ModifyPasswordViewController" bundle:nil];
              [self pushController:modifyPwdVC animated:YES];
//            RootViewController *rootvc=[AppDelegate rootViewController];
//            [rootvc pushViewController:modifyPwdVC animated:YES];
        }
    }
    else if (cellX==_exitLoginTableViewCell)
    {
        [self quitBtnClick:nil];
        
    }

}
-(void)clearChattingRecords
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清除所有聊天记录吗？" delegate:self cancelButtonTitle:@"清除" otherButtonTitles:@"取消",nil];
    alert.tag = 1001;
    [alert show];
}
-(void)clearUserData
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清除数据缓存吗？" delegate:self cancelButtonTitle:@"清除" otherButtonTitles:@"取消",nil];
    alert.tag = 1000;
    [alert show];
}

-(void)checkUpdate
{
    _checkUpdataCel.detailTextLabel.text = @"检查中...";
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* currVersion=[infoDict objectForKey:@"CFBundleShortVersionString"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#ifdef APPSTORE
        NSString *updateurl=[NSString stringWithContentsOfURL:[NSURL URLWithString:UPDATE_URL] encoding:NSUTF8StringEncoding error:nil];
        if (updateurl!=nil && [updateurl length]>0 && [updateurl rangeOfString:@"version"].length==7)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _checkupdateLabel.text = @"检查更新";
                [AboutViewController checkAppUpdate:updateurl delegate:self];
            });
        }
        else
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _checkupdateLabel.text=@"检查更新";
                
                _checkUpdataCel.detailTextLabel.text =[NSString stringWithFormat:@"%@",currVersion];
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
                        else
                        {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [Utils alertMessage:@"已经是最新版本"];
                                 _checkUpdataCel.detailTextLabel.text =[NSString stringWithFormat:@"%@",currVersion];
                              });
                        }
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            _checkUpdataCel.detailTextLabel.text =[NSString stringWithFormat:@"%@",currVersion];
                        });
                    }
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _checkUpdataCel.detailTextLabel.text =[NSString stringWithFormat:@"%@",currVersion];
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{

                _checkUpdataCel.detailTextLabel.text =[NSString stringWithFormat:@"%@",currVersion];
            });
        }
//        //企业版
//        //check version
//        NSDictionary *dict=[Utils projectPlistToDictionary];
//        NSMutableString *version=[[NSMutableString alloc] init];
//        BOOL rst=[Utils isLastVersion:dict versionString:version];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (rst==NO)
//            {
//                _checkUpdataCel.detailTextLabel.text = @"检查中...";
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
    if (alertView.tag == 1000) //清除消息记录
    {
        if (buttonIndex==0) {
            [Utils clearUserData];
            //清除cookies
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies])
            {
                [storage deleteCookie:cookie];
            }
            
           
            [[SDImageCache sharedImageCache] clearDisk];
            //清除网页缓存
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
            NSURLCache * cache = [NSURLCache sharedURLCache];
            [cache removeAllCachedResponses];
            [cache setDiskCapacity:0];
            [cache setMemoryCapacity:0];
            
            _cacheSizeLabel.text=@"0 M";
            [self netConnectMessage:@"已清除缓存"];
//            NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) ;
//            NSString *cachePath = [pathes lastObject];
//            [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
//            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
//                    withIntermediateDirectories:YES
//                                     attributes:nil
//                                          error:NULL];
         
        }
    }
    else if (alertView.tag == 1001)
    {
        if (buttonIndex==0) {
            //clearDB Data
            [sqlite clearHisData];

            //删除首页等具体数据的缓存、图片的缓存等
            [[SDImageCache sharedImageCache] clearDisk];
            //刷新首页会话
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSessionNoti" object:nil];
        }
        
    }
    else if(alertView.tag == 1002)  //注销
    {
        if (buttonIndex==0) {
            [[AppDelegate App] logout];
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }

    else if ([alertView.title isEqualToString:@"版本更新"])
    {
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString* currVersion=[infoDict objectForKey:@"CFBundleShortVersionString"];
        
#ifdef APPSTORE
        if (buttonIndex==0) {
            UILabel *lb=(UILabel *)[alertView viewWithTag:9999];
            NSString *url= lb.text;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else
        {
               _checkUpdataCel.detailTextLabel.text =[NSString stringWithFormat:@"%@",currVersion];
        }
#else
        if (buttonIndex==0) {
            NSString *downloadurl = [[NSString alloc] initWithFormat:@"itms-services://?action=download-manifest&url=%@",UPDATE_WEFAFA_PLIST_URL.length>0?UPDATE_WEFAFA_PLIST_URL:WEFAFA_PLIST_URL];
            NSURL *url  = [NSURL URLWithString:downloadurl];
            [[UIApplication sharedApplication] openURL:url];
            exit(0);

//            NSString *downloadurl = [[NSString alloc] initWithFormat:@"itms-services://?action=download-manifest&url=%@",WEFAFA_PLIST_URL];
//            NSURL *url  = [NSURL URLWithString:downloadurl];
//            [[UIApplication sharedApplication] openURL:url];
//            exit(0);
        }
        else
        {
            
            _checkUpdataCel.detailTextLabel.text =[NSString stringWithFormat:@"%@",currVersion];
        }
#endif
    }
}
- (IBAction)quitBtnClick:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"退出登录" message:[NSString stringWithFormat:@"您确定退出当前帐号？"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"取消"];
    alert.tag = 1002;
    [alert show];
}
-(void)netConnectMessage:(NSString *)msg
{
    [self hideToast];
    if (msg==nil || [@"" isEqualToString:msg]) {
        msg=@"无法连接服务器，请稍后重试！";
    }
    [Toast makeToast:msg];
    [self timerHideToast];
}
- (void)timerHideToast {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}

- (void)hideToast {
    [Toast hideToastActivity];
}

//- (void)btnBackClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)btnHome:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    

    
}

-(void)voiceSwitchFlipped:(id)sender
{
    NSLog(@"voice clicked");
}
- (IBAction)switchTipVoice_OnValueChanged:(id)sender {
    [AppSetting setMsgTipVoice:[sender isOn]];
    [AppSetting save];
}

- (IBAction)switchTipViber_OnValueChanged:(id)sender {
    [AppSetting setMsgTipViber:[sender isOn]];
    [AppSetting save];
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1000.0*1000.0);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{

    OBJC_RELEASE(sections);
}



@end
