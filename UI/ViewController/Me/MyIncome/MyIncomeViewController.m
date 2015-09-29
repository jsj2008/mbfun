//
//  MyIncomeViewController.m
//  Wefafa
//
//  Created by mac on 14-8-2.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//  废弃不用 我的收益
#import "MyIncomeViewController.h"
#import "Utils.h"
#import "Base.h"
#import <QuartzCore/QuartzCore.h>
#import "MBShoppingGuideInterface.h"
#import "WeFaFaGet.h"
#import "JSON.h"
#import "KxMenu.h"
#import "ExtractApplicationViewController.h"
#import "BingBankViewController.h"
#import "Toast.h"
#import "PassWordViewController.h"
#import "WaitExtractViewController.h"
#import "NavigationTitleView.h"
#import "NewBingBankViewController.h"
#import "CustomAlertView.h"

#import "BinDingBankCardHomeViewController.h"
#import "AlreadyBinDingBankCardViewController.h"


@interface MyIncomeViewController ()
{
    NSMutableDictionary *requestDic;
}
@end

@implementation MyIncomeViewController

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
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:@"我的收益" forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempView addSubview:tempBtn];
    // default40@2x.
    
    self.navigationItem.titleView = tempView;
    
}

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
    self.navigationController.navigationBarHidden=NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.headView.backgroundColor = TITLE_BG;
//    self.navigationController.navigationBarHidden=YES;
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];

    view.lbTitle.text=@"我的收益";
//    [self.headView addSubview:view];
    
    [self setupNavbar];
    
    _incomeBtn.layer.masksToBounds=YES;
    _incomeBtn.layer.cornerRadius=4;
    _setBalenceBtn.layer.masksToBounds=YES;
    _setBalenceBtn.layer.cornerRadius=4;
    [_setBalenceBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
    [_setBalenceBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
    requestDic = [[NSMutableDictionary alloc]init];
    
    NSMutableString *msg = [[NSMutableString alloc] initWithCapacity:10];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
//         userId=@"ed8e54f0-f69f-498d-99c7-85e8ede7de8e";
        BOOL success=[SHOPPING_GUIDE_ITF requestGetUrlName:@"WxSellerAccountByAccountFilter" param:@{@"userId":userId} responseAll:requestDic responseMsg:msg];
        
//       BOOL success = [SHOPPING_GUIDE_ITF requestGetUrlName:@"WxSellerAccountByAccountFilter" param:@{@"userId":userId} responseList:requestArray responseMsg:msg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if ([[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"lasT_DAY_IN_AMOUNT"]] floatValue]==0.0)
            {
                //
            }
            if (success)
            {
                NSString *lastSt=[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"lasT_DAY_IN_AMOUNT"]];
                NSString *extSt=[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"caN_CASH_AMOUNT"]];
                if ([[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"lasT_DAY_IN_AMOUNT"]] floatValue]==0.0)
                {
                    lastSt=@"无收益";
                }
                _showTitleLabel.text=lastSt;
                _showExtLabel.text=extSt;
                _ljsyShowLabel.text=[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"totaL_IN_AMOUNT"]];
                _ljtxShowLabel.text=[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"totaL_CASH_AMOUNT"]];
                _sysyShowLabel.text=[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"montH_IN_AMOUNT"]];
                _qtsyShowLabel.text=[Utils getSNSMoney:[[requestDic objectForKey:@"responseMsg"] objectForKey:@"weeK_IN_AMOUNT"]];
            }
            else
            {
              //  [Utils alertMessage:@"无数据"];
            }
        });
    });
//    _scrollView.frame = CGRectMake(0, 69, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 440);
}

-(IBAction)showList:(id)sender
{
     [self showRightMenu];
}
- (void) leftBtnPressedWithinalertView:(CustomAlertView*)alert;
{
}
- (void) rightBtnPressedWithinalertView:(CustomAlertView*)alert;
{
    
}
-(void)showRightMenu
{
    //CustomAlertView *alert=[[CustomAlertView alloc]initWithTitle:@"提示" msg:@"是否确定取消订单?" rightBtnTitle:@"确定" leftBtnTitle:@"取消" delegate:self];
    //[alert show];
  
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"添加银行卡"
                     image:[UIImage imageNamed:@"btn_card.png"]
                    target:self
                    action:@selector(menuBingBankCardClick:)]
      
//      [KxMenuItem menuItem:@"提现密码"
//                     image:[UIImage imageNamed:@"public_menu_icon_add.png"]
//                    target:self
//                    action:@selector(menuPassWordClick:)],
      ];
    
    [KxMenu setIconSize:CGSizeMake(25,25)];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(_btnMenu.frame.origin.x, _btnMenu.frame.origin.y-10 , _btnMenu.frame.size.width, _btnMenu.frame.size.height)
                 menuItems:menuItems];
}

-(void)menuBingBankCardClick:(id)sender
{
    AlreadyBinDingBankCardViewController *bingBanc=[[AlreadyBinDingBankCardViewController alloc]initWithNibName:@"AlreadyBinDingBankCardViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:bingBanc];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
    return;
    
    NewBingBankViewController *newBink=[[NewBingBankViewController alloc]initWithNibName:@"NewBingBankViewController" bundle:nil];
    [self.navigationController pushViewController:newBink animated:YES];
    return;
    
//    BingBankViewController *bingBanc=[[BingBankViewController alloc]initWithNibName:@"BingBankViewController" bundle:nil];
//    bingBanc.titleName=@"绑定银行卡";
//    bingBanc.transDic = requestDic;
//    [self.navigationController pushViewController:bingBanc animated:YES];

    
}
-(void)menuPassWordClick:(id)sender
{
    BingBankViewController *bingBanc=[[BingBankViewController alloc]init];
    bingBanc.titleName=@"提现密码";
    bingBanc.transDic = requestDic;
    [self.navigationController pushViewController:bingBanc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backHome:(UIButton *)sender
{
       [self.navigationController popViewControllerAnimated:YES]; 
}
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)extractSQBtnCLick:(id)sender {
    NSString *st = @"WxSellerCardFilter";
    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
    NSDictionary *dic=@{@"useId":userId};
    
    NSMutableString *returnMessage = [[NSMutableString alloc]init];
    NSMutableArray *detailResultsArray=[[NSMutableArray alloc]init];
    BOOL  success =[SHOPPING_GUIDE_ITF requestGetUrlName:st param:dic responseList:detailResultsArray responseMsg:returnMessage];

    NSLog(@"requestDic-我的收益---%@",requestDic);
    
    //    NSString *message =[NSString stringWithFormat:@"%@",[cardDic objectForKey:@"isSuccess"]];
    //    NSString *messageShow =[NSString stringWithFormat:@"%@",[cardDic objectForKey:@"message"]];
    //    NSArray *resultsArray=[[NSArray alloc]init];
    
    if ([returnMessage isEqualToString:@"1"]||success)
    {
        NSString *myCardNo = [NSString stringWithFormat:@"%@",[[requestDic objectForKey:@"responseMsg"] objectForKey:@"sellerId"]];
        myCardNo=@"323";
        NSString *oldPass=[NSString stringWithFormat:@"%@",[[requestDic objectForKey:@"responseMsg"] objectForKey:@"casH_PASSWORD"]];
        NSString *resultID;
        int k=0;
        for (int m=0; m<[detailResultsArray count]; m++)
        {
            resultID = [NSString stringWithFormat:@"%@",[[[detailResultsArray objectAtIndex:m] objectForKey:@"wsCardInfo"] objectForKey:@"accounT_ID"]];
            
            if ([resultID isEqualToString:myCardNo])
            {
                if (oldPass==nil||[[oldPass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""])
                {
                    //                   [self menuBingBankCardClick:nil];
                    [self menuPassWordClick:nil];
                }
                else
                {
                    PassWordViewController *passWord=[[PassWordViewController alloc]init];
                    passWord.transDic=requestDic;
                    passWord.cardDicArray=detailResultsArray;
                    passWord.canUpMoney=_showExtLabel.text;
                    [self.navigationController pushViewController:passWord animated:YES];
                    break;
                }
            }
            else
            {
                k++;
                if (k==[detailResultsArray count])
                {
                    [self menuBingBankCardClick:nil];
                }
            }
        }
        
    }
    else
    {
        [Utils alertMessage:returnMessage];
        
    }

}

- (IBAction)waitSQBtnClick:(id)sender {
    WaitExtractViewController *waitEx=[[WaitExtractViewController alloc]init];
    waitEx.sellerId =  [[requestDic objectForKey:@"responseMsg"] objectForKey:@"sellerId"];
    waitEx.titleName=@"待批申请";
    [self.navigationController pushViewController:waitEx animated:YES];
}

- (IBAction)earningLSBtnClick:(id)sender {
    WaitExtractViewController *waitEx=[[WaitExtractViewController alloc]init];
//    waitEx.sellerId =  [[requestDic objectForKey:@"responseMsg"] objectForKey:@"sellerId"];
    waitEx.isIncome=YES;
    waitEx.titleName=@"收益流水";
    [self.navigationController pushViewController:waitEx animated:YES];
}
-(IBAction)getLSBtnClick:(id)sender
{
    WaitExtractViewController *waitEx=[[WaitExtractViewController alloc]init];
//    waitEx.sellerId =  [[requestDic objectForKey:@"responseMsg"] objectForKey:@"sellerId"];
    waitEx.isIncome=NO;
    waitEx.titleName=@"结算流水";
    [self.navigationController pushViewController:waitEx animated:YES];
}
@end
