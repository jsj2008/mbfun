//
//  SettingBalenceViewController.m
//  Wefafa
//
//  Created by fafatime on 15-1-26.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SettingBalenceViewController.h"
#import "Utils.h"
#import "Toast.h"
#import "NavigationTitleView.h"
#import "WaitExtrantTableViewCell.h"
#import "MBShoppingGuideInterface.h"
#import "QuestFeedBackViewController.h"

@interface SettingBalenceViewController ()
{
    NSMutableArray *detailMutableArray;
    NSMutableString *returnMessage;
    NSArray *balanceFlowList;
    
    
}
@end

@implementation SettingBalenceViewController
- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.title=@"结算详情";
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    
}
-(void)onBack:(id)sender
{
    [self popAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headView.backgroundColor=TITLE_BG;
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    balanceFlowList = [[NSArray alloc]init];
    
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"结算详情";
//    [self.headView addSubview:view];
    [self setupNavbar];
    
    NSString *st = @"WxSettleBalanceFlowDetailFilter";
    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
#ifdef DEBUG
//    userId=@"c066b1ad-c80a-4ef9-bbf9-aede01201847";
#endif
    NSString *seller_dtl_ID=[NSString stringWithFormat:@"%@",_balenceDic[@"settlE_DTL_ID"]];
    
    NSDictionary *dic = @{@"UserId":userId,@"SELLER_DTL_ID":seller_dtl_ID};
    detailMutableArray=[[NSMutableArray alloc]init];
    returnMessage=[[NSMutableString alloc]init];
    
    NSString *timeStr=[NSString stringWithFormat:@"%@",_balenceDic[@"balancE_TIME"]];
    NSString *stateStr=[NSString stringWithFormat:@"%@",_balenceDic[@"settlE_STATE_NAME"]];
    NSString *idStr = [NSString stringWithFormat:@"%@",_balenceDic[@"srC_DOC_CODE"]];
    timeStr = [Utils getdate:timeStr];
    
    _stateLabel.text=[Utils getSNSString:stateStr];
    _timeLabel.text=[Utils getSNSString:timeStr];
    _numberLable.text = [NSString stringWithFormat:@"提取编号:%@",[Utils getSNSString:idStr]];
    
    _setBanlenceTableV.tableHeaderView=_tableHeadView;
    _setBanlenceTableV.tableFooterView = [[UIView alloc]init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL succes =[SHOPPING_GUIDE_ITF requestGetUrlName:st param:dic responseList:detailMutableArray responseMsg:returnMessage];
        NSLog(@"detailMutableSRRAY----%@",detailMutableArray);
        if (succes)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
             
                NSDictionary *returnDic;
                if ([detailMutableArray count]>0)
                {
                    returnDic =[NSDictionary dictionaryWithDictionary:detailMutableArray[0]];
                    balanceFlowList = returnDic[@"balanceFlowList"];
                }
                
                NSLog(@"returnDic---%@",returnDic);
//                
//                NSString *timeStr=[NSString stringWithFormat:@"%@",returnDic[@"balancE_TIME"]];
//                NSString *stateStr=[NSString stringWithFormat:@"%@",returnDic[@"payStateName"]];
//                NSString *idStr = [NSString stringWithFormat:@"%@",returnDic[@"id"]];
//                _stateLabel.text=[Utils getSNSString:stateStr];
//                _timeLabel.text=[Utils getSNSString:timeStr];
//                _numberLable.text = [NSString stringWithFormat:@"提取编号:%@",[Utils getSNSString:idStr]];
//                
//                _setBanlenceTableV.tableHeaderView=_tableHeadView;
            
                [_setBanlenceTableV reloadData];
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utils alertMessage:returnMessage];
            });
        }
    });
    

}
- (void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 64;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 return [balanceFlowList count];
//    return [detailMutableArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//
    return 1 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WaitExtrantTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WaitExtrantTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
//    NSArray *detailList=[NSArray arrayWithArray:detailMutableArray[indexPath.section][@"detaiL_LIST"]];
    NSString *cardNumberLabeLStr = [NSString stringWithFormat:@"%@",balanceFlowList[indexPath.section][@"recordinfo"][@"proD_NAME"]];
    NSString *statesStr = [NSString stringWithFormat:@"%@",balanceFlowList[indexPath.section][@"srC_DOC_TYPE_NAME"]];
    NSString *depDateStr = [NSString stringWithFormat:@"%@",balanceFlowList[indexPath.section][@"balancE_TIME"]];
    NSString *amountStr = [NSString stringWithFormat:@"%@",balanceFlowList[indexPath.section][@"amount"]];
    NSString *nickName= [NSString stringWithFormat:@"%@",balanceFlowList[indexPath.section][@"recordinfo"][@"nickname"]];
    
    float amount = [amountStr floatValue];
    if ([statesStr isEqualToString:@"退款"])
    {
        cell.priceLabel.text=[NSString stringWithFormat:@"%@:-￥%.2f",statesStr,amount];
    }
    else
    {
        
        cell.priceLabel.text=[NSString stringWithFormat:@"%@:￥%.2f",statesStr,amount];
    }
    cell.cardNumberLabel.text=[Utils getSNSString:cardNumberLabeLStr];
    cell.statesLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:statesStr]];
    cell.timeLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:depDateStr]];
//    cell.buyLabel.text=@"买家";
    
    cell.buyNameLabel.text=[NSString stringWithFormat:@"买家:%@",[Utils getSNSString:nickName]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //提取编号 、、settlE_AMOUNT 金额 balancE_TIME
    return cell ;
}
-(IBAction)questReturn:(id)sender
{
      NSDictionary * returnDic =[NSDictionary dictionaryWithDictionary:detailMutableArray[0]];
    QuestFeedBackViewController *questFeedBack=[[QuestFeedBackViewController alloc]initWithNibName:@"QuestFeedBackViewController" bundle:nil];
//    questFeedBack.setBalenceId=_balenceDic[@"id"];
//    questFeedBack.seller_id =_balenceDic[@"selleR_ID"];
    questFeedBack.setBalenceId=returnDic[@"selleR_DTL_ID"];
    questFeedBack.seller_id =returnDic[@"supeR_SELLER_ID"];
    [self.navigationController pushViewController:questFeedBack animated:YES];
    
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
