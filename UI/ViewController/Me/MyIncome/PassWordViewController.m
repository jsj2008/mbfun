//
//  PassWordViewController.m
//  Wefafa
//
//  Created by fafatime on 14-8-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "PassWordViewController.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "ExtractApplicationViewController.h"
#import "NavigationTitleView.h"
@interface PassWordViewController ()

@end

@implementation PassWordViewController
@synthesize transDic;
@synthesize cardDicArray;
@synthesize canUpMoney;
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
    // Do any additional setup after loading the view from its nib.
    _headView.backgroundColor=TITLE_BG;
    [_inputTextField resignFirstResponder];
    
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"密码验证";
    [self.headView addSubview:view];
     _inputTextField.delegate=self;
//     _inputTextField.secureTextEntry=YES;//输入密码为星号
    [_upDoneBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:187/255.0 blue:11/255.0 alpha:1]];
    
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//      [_inputTextField setBackgroundColor: [UIColor whiteColor]];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)updateBtnClick:(id)sender
{
    NSString *st = @"WxSellerCashPwsCheck";
    NSString *oldPass= [NSString stringWithFormat:@"%@",[[self.transDic objectForKeyedSubscript:@"responseMsg"] objectForKey:@"casH_PASSWORD"]];
    NSMutableString *returnMsg=[[NSMutableString alloc]init];
    NSMutableDictionary *requestDic=[[NSMutableDictionary alloc]init];
    
    if ([[_inputTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""])
    {
        [Utils alertMessage:@"密码不能为空"];
    }
    else
    {
        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary *paramdic=@{@"inputPws":_inputTextField.text,@"pws":oldPass};
////            NSDictionary *requestDic =[[NSDictionary alloc]initWithDictionary:[SHOPPING_GUIDE_ITF ASIPostJSonRequest:st PostParamDic:paramdic]];
//            BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:st param:paramdic responseList:requestArray responseMsg:returnMsg];
//            -(BOOL)requestGetUrlName:(NSString *)name param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnAll responseMsg:(NSMutableString *)returnMsg
            BOOL success = [SHOPPING_GUIDE_ITF  requestGetUrlName:st param:paramdic responseAll:requestDic responseMsg:returnMsg];
            NSString *flagStr;
            NSLog(@"requestDic--密码---%@",paramdic);
            if (success)
            {
                flagStr=[NSString stringWithFormat:@"%@",[requestDic objectForKey:@"flag"]];
            }
            //银行
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
                if ([flagStr isEqual:@"1"])
                {
                    ExtractApplicationViewController *extract=[[ExtractApplicationViewController alloc]init];
                    extract.transDic=self.transDic;
                    extract.cardDicArray=self.cardDicArray;
                    extract.canUpMoney=self.canUpMoney;
                    
                    [self.navigationController pushViewController:extract animated:YES];
                }
                else
                {
                    [Utils alertMessage:@"密码错误"];
                }
                
            });
        });
    
    }
}
-(void)backHome:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
