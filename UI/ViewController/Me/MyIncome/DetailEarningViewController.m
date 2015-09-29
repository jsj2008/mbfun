//
//  DetailEarningViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "DetailEarningViewController.h"
#import "ModelBase.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "DetailEarnTableViewCell.h"
#import "NavigationTitleView.h"
#import "MyOrderViewTableViewCell.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "LogisticsViewController.h"
#import "LogisticsViewControlle2.h"

@interface DetailEarningViewController ()
{
    NSMutableArray *detailMutableArray;
    NSMutableString *returnMessage;
    NSArray *orderList ;
}

@end

@implementation DetailEarningViewController
@synthesize chooseTime;
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
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.title=@"收益详情";
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
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"收益详情";
//    [self.headView addSubview:view];
    [self setupNavbar];
    

    NSString *st = @"WxBalanceFlowDetailFilter";//收益详情
//    _productTableView.hidden=YES;
    detailMutableArray=[[NSMutableArray alloc]init];
    orderList = [[NSArray alloc]init];
    NSString *idStr=[NSString stringWithFormat:@"%@",self.paramDic[@"id"]];
    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
#ifdef DEBUG
//    userId=@"ed8e54f0-f69f-498d-99c7-85e8ede7de8e";//收益详情
#endif
    NSDictionary *dic=@{@"UserId":userId,@"ID":idStr};
    returnMessage=[[NSMutableString alloc]init];

//    detailProductTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 69, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-69-50) style:UITableViewStyleGrouped];
//    detailProductTableView.delegate=self;
//    detailProductTableView.dataSource=self;
//    detailProductTableView.backgroundColor = TITLE_BG;
//    [self.view addSubview:detailProductTableView];
    
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailOperation)];
    _transView.userInteractionEnabled=YES;
    [_transView addGestureRecognizer:tapGest];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

      BOOL succes =[SHOPPING_GUIDE_ITF requestGetUrlName:st param:dic responseList:detailMutableArray responseMsg:returnMessage];

        dispatch_async(dispatch_get_main_queue(), ^{

            NSLog(@"detailMutableArray=------%@",detailMutableArray);
            
            if (succes)
            {
                if ([detailMutableArray count]==0)
                {
                    
                }
                else
                {
                    ///[0]
                    orderList = detailMutableArray[0][@"ordeR_LIST"][@"detailList"];
                    NSDictionary *requestDic=[[NSDictionary alloc]initWithDictionary:detailMutableArray[0]];
                    NSString *amountSt=[NSString stringWithFormat:@"%@",requestDic[@"amount"]];
                    float amount = [amountSt floatValue];
                    _allAmountLabel.text=[NSString stringWithFormat:@"￥%0.2f",amount];
                    
                    NSDictionary *dic=[NSDictionary dictionaryWithDictionary: detailMutableArray[0][@"ordeR_LIST"]];//[0]
                    
                    NSString *buyer=[NSString stringWithFormat:@"%@",dic[@"creatE_USER"]];
                    NSString *dutyName=@"";
                    NSString *shareName=@"";
                   if ([dic[@"detailList"] count]>0)
                   {
                       dutyName=[NSString stringWithFormat:@"%@",dic[@"detailList"][0][@"detailInfo"][@"designerName"]];
                       shareName= [NSString stringWithFormat:@"%@",dic[@"detailList"][0][@"detailInfo"][@"sharE_SELLER_NAME"]];
                    }
                    NSString *dateStr= [CommMBBusiness getdate:dic[@"creatE_DATE"]];
                    NSString *orderNum = [NSString stringWithFormat:@"%@",dic[@"orderno"]];
                    NSString *payStyle = @"";
                    if ([dic[@"paymentList"][0] count] > 0) {
                        payStyle=[NSString stringWithFormat:@"%@",dic[@"paymentList"][0][@"paY_TYPE"]];
                    }
                    NSArray *operationInfoList=[[NSArray alloc]init];
                    NSString *operationInfoFirst=@"";
                    if ([dic[@"operationInfoList"] count]>0)
                    {
                        operationInfoList = dic[@"operationInfoList"];
                        operationInfoFirst = [NSString stringWithFormat:@"%@",operationInfoList[0][@"opinion"]];
                    }

                    
                    _buyerLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:buyer]];
                    _dutyNameLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:dutyName]];
                    _shareNameLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:shareName]];
                    _orderNumberLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:orderNum]];
                    _timeLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:dateStr]];
                    _transDetailLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:operationInfoFirst]];
                    
                    if ([payStyle isEqualToString:@"ZFB"])
                    {
                        _payStyleLabel.text=@"支付宝支付";
                    }
                    else if([payStyle isEqualToString:@"WX"])
                    {
                        _payStyleLabel.text=@"微信支付";
                    }else
                    {
                        _payStyleLabel.text=@"其他方式支付";
                    }
 
                }
//                _productTableView.hidden=NO;
                _productTableView.tableHeaderView=_showAllView;
                _productTableView.tableFooterView=_orderView;
                [_productTableView reloadData];
                
            }
            else
            {
               
                if (returnMessage.length==0)
                {
                    [Utils alertMessage:@"请求错误"];
                }
                else
                {
                    [Utils alertMessage:returnMessage];  
                }
     
            }
            
        });
    });

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 64+20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 83;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [orderList count];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
    [sectionView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    return sectionView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([detailMutableArray count]>0) {
        
        return _transView;
    }
    else
    {
       return nil;
    }
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyOrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MyOrderViewTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selected = NO;
    NSDictionary *dic =[NSDictionary dictionaryWithDictionary:orderList[indexPath.row]];
    NSDictionary *detailInfoDic=[NSDictionary dictionaryWithDictionary:dic[@"detailInfo"]];
    NSDictionary *proudctList = [dic objectForKey:@"proudctList"];
    //退款操作信息
    cell.goodNameLabel.text=[Utils getSNSString:proudctList[@"productInfo"][@"proD_NAME"]];
//    if ([cell.goodNameLabel.text length]>12){
//        cell.goodNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        cell.goodNameLabel.numberOfLines = 2;
//        [cell.goodNameLabel sizeToFit];
//    }
//    else{
//        cell.goodNameLabel.numberOfLines = 1;
//    }
    
    cell.orderNoLabel.text= [Utils getSNSString:proudctList[@"productInfo"][@"proD_CLS_NUM"]];
    cell.colcorLabel.text=[NSString stringWithFormat:@"%@ %@",[Utils getSNSString:proudctList[@"productInfo"][@"coloR_NAME"]],[Utils getSNSString:proudctList[@"productInfo"][@"speC_NAME"]]];
    NSArray *clsList =[NSArray arrayWithArray:proudctList[@"clsList"]];
    cell.brandLabel.text=clsList.count>0?[Utils getSNSString:clsList[0][@"brand"]]:@"";
    
    NSString *imgUrlstr = [[Utils getSNSString:proudctList[@"productInfo"][@"coloR_FILE_PATH"]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.goodImgView downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgUrlstr size:SNS_IMAGE_Size] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
    
    NSString *price=[NSString stringWithFormat:@"%@", detailInfoDic[@"acT_PRICE"]];
    NSString *numm=[NSString stringWithFormat:@"%@",detailInfoDic[@"qty"]];
    //单价
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSString:price]];
    //    数量
    cell.numberLabel.text=[NSString stringWithFormat:@"x%@",[Utils getSNSString:numm]];
    
    return cell ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString *)getdate:(NSString *)datestr
{
    NSString *dateString=nil;
    NSDate *date ;
    
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=arr[0];
        arr=[s componentsSeparatedByString:@"-"];
        s=arr[0];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}
-(NSString *)getYearMouth:(NSString *)datestr
{
    NSString *dateString=nil;
    NSDate *date ;
    
    if (datestr.length>1 && [[datestr substringToIndex:1] isEqualToString:@"/"])
    {
        NSArray *arr=[datestr componentsSeparatedByString:@"/Date("];
        NSString *s=[arr lastObject];
        arr=[s componentsSeparatedByString:@")/"];
        
        s=arr[0];
        arr=[s componentsSeparatedByString:@"-"];
        s=arr[0];
        date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }

    return dateString;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)detailOperation
{
    LogisticsViewControlle2 *logist=[LogisticsViewControlle2 new];
    logist.messageDic=detailMutableArray[0][@"ordeR_LIST"];
    
    [self.navigationController pushViewController:logist animated:YES];
    
    return;
    
//    LogisticsViewController *logisticsVC=[[LogisticsViewController alloc]init];
//    logisticsVC.messageDic =detailMutableArray[0][@"ordeR_LIST"];
//    [self.navigationController pushViewController:logisticsVC animated:YES];
//    
    
}
-(void)backHome:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
