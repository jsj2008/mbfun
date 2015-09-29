//
//  MBChangeDescriptionViewController.m
//  Wefafa
//
//  Created by fafatime on 15-2-7.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBChangeDescriptionViewController.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "Toast.h"
#import "AppDelegate.h"
#import "WeFaFaGet.h"

#import "SQLiteOper.h"
#import "NetUtils.h"
#import "AppSetting.h"
#import "UIViewController+BG.h"
#import "HttpRequest.h"

@interface MBChangeDescriptionViewController ()
{
}
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSaveClick:(id)sender;

@end

@implementation MBChangeDescriptionViewController

- (void)setupNavbar {
    [super setupNavbar];
    self.view.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
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
    self.title =@"修改个性签名";
    
    
//    UIView *tempView;
//    CGRect navRect = self.navigationController.navigationBar.frame;
//    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, navRect.size.height)];
//    
//    
//    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 150, navRect.size.height)];
//    [tempBtn setTitle:@"修改个性签名" forState:UIControlStateNormal];
//    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
//    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [tempView addSubview:tempBtn];
//    self.navigationItem.titleView = tempView;
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGRect headrect=CGRectMake(0,0,_headView.frame.size.width,_headView.frame.size.height);
//    NavigationTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:@selector(btnSaveClick:) selectorMenu:nil];
//    titleView.lbTitle.text=@"修改个性签名";
//    [titleView.btnOk setTitle:@"保存" forState:UIControlStateNormal];
//    [_headView addSubview:titleView];
    [self setupNavbar];
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack)];
    [self.view addGestureRecognizer:tapGes];

    [_editTextView becomeFirstResponder];
    
    CGRect frame = _editTextView.frame;
    frame.origin.x = 15;
    frame.size.width = SCREEN_WIDTH - 30;
    _editTextView.frame = frame;
    
    [_editTextView.layer setBorderWidth:0.5];
    [_editTextView.layer setBorderColor:[UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.0].CGColor];
    [_editTextView.layer setCornerRadius:5.0];
 
    self.btnSend.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _editTextView.text=sns.myStaffCard.self_desc;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        return NO;
    }
    
    else
    {
        if ([text isEqualToString:@""]) {
            return YES;
        }
        if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
            [Toast makeToast:@"不能输入表情符号"];
            return NO;
        }
        
        return YES;
    }
}
-(void)tapBack
{
    [self.view endEditing:YES];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    
}


-(void)netConnectError:(NSString *)msg
{
    UIAlertView *alert=nil;
    if (msg!=NULL && msg.length>0) {
        [Toast hideToastActivity];
        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    }
    else alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接服务器，请稍后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert setTag:10000];
    [alert show];
}

- (void)btnSaveClick:(id)sender {
    
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:_editTextView.text
                                                               options:0
                                                                 range:NSMakeRange(0, [_editTextView.text length])
                                                          withTemplate:@""];
    NSLog(@"%lu----%lu",(unsigned long)modifiedString.length,(unsigned long)[[_editTextView.text stringByReplacingOccurrencesOfString:@"…" withString:@""] length]);
    if (modifiedString.length < [[_editTextView.text stringByReplacingOccurrencesOfString:@"…" withString:@""] length]) {
        [Toast makeToast:@"不能输入表情符号"];
        return ;
    }
//    NSString *regex1 = @"[a-zA-Z0-9\u4e00-\u9fa5]+";//[a-zA-Z\u4e00-\u9fa5]
//    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
//    
//    if(![pred1 evaluateWithObject:_editTextView.text])
//    {
//        [Toast makeToast:@"不能输入表情符号"];
//        return ;
//    }
    
    if (_editTextView.text.length==0) {
        UIAlertView  *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写个性签名!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        if (self.editTextView.text.length > 20) {
//            [Toast makeToast:@"签名不能多于20个字符！" duration:2.0 position:@"cenrer"];
            NSString *messageString = [NSString stringWithFormat:@"你当前输入了%lu个字符!", (unsigned long)self.editTextView.text.length];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"签名不能多于20个字符" message:messageString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected])) {
            [Toast hideToastActivity];

            [Toast makeToastActivity:@"保存中，请稍等..." hasMusk:YES];
//            
//            
//            NSMutableDictionary *areaReturnDic = [[NSMutableDictionary alloc]init];
//            NSMutableString *areaRequestStr = [[NSMutableString alloc]init];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
                NSArray *userClaims=@[@{@"claimType":@"MB.MasterOfDesigner.UserSignature",@"claimValue":_editTextView.text}];
                
                NSDictionary *valueDic=@{@"UserId":sns.ldap_uid,@"issuer":@"MB.MasterOfDesigner",@"userClaims":userClaims};
                
                
                [HttpRequest postRequestPath:kMBServerNameTypeAccout methodName:@"UserUpdateProfile" params:valueDic success:^(NSDictionary *dict) {
                    if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Toast hideToastActivity];
                            sns.myStaffCard.self_desc = _editTextView.text;
                       
//                            if(self.preViewController!=nil && [self.preViewController class]==[MBSelfInfoViewController class]) {
//                                [_preViewController performSelector:@selector(creatUserInfo)];
//                            }
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImgView" object:nil];
                            
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *message = [NSString stringWithFormat:@"%@",dict[@"message"]];
                            message = [Utils getSNSString:message];
                            if (message.length==0) {
                                message=@"保存失败，请稍后重试!";
                                
                            }
                            [self netConnectError:message];
                            [Toast hideToastActivity];
                        });
                    }
                } failed:^(NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self netConnectError:@"保存失败，请稍后重试！"];
                        [Toast hideToastActivity];
                    });
                    
                }];
                /*
               [SHOPPING_GUIDE_ITF requestPostUrlName:@"UserUpdateProfile" param:valueDic responseAll:areaReturnDic responseMsg:areaRequestStr];
 
                NSString *isSuccess=[NSString stringWithFormat:@"%@",areaReturnDic[@"isSuccess"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([isSuccess isEqualToString:@"1"])
                    {
                        [Toast hideToastActivity];
                        sns.myStaffCard.self_desc = _editTextView.text;
                        myUser.staffFull.self_desc= _editTextView.text;
                        [sqlite updateStaff:myUser.staffFull];
                        if(self.preViewController!=nil && [self.preViewController class]==[MBSelfInfoViewController class]) {
                            [_preViewController performSelector:@selector(creatUserInfo)];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDesc" object:@{@"newNick" : _editTextView.text}];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImgView" object:nil];
                        
                    }
                    else
                    {
                        [Toast hideToastActivity];
                        
                       [self netConnectError:@"保存失败，请稍后重试！"];
                    }
                });
                */
                
//            });

        }else [self netConnectError:nil];
    }
}

- (void)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
