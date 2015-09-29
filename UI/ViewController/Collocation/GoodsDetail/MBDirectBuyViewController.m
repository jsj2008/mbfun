//
//  MBDirectBuyViewController.m
//  Wefafa
//
//  Created by fafatime on 14-10-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//废弃 不用 
#import "MBDirectBuyViewController.h"
#import "NavigationTitleView.h"

#import "DirectBuyOrderTableViewCell.h"
#import "Utils.h"

#import "MBShoppingGuideInterface.h"
#import "Toast.h"

#import "MBCreateGoodsOrderViewController.h"
#import "MyShoppingTrollyViewController.h"

@interface MBDirectBuyViewController ()

@end

@implementation MBDirectBuyViewController

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
    //new headview
    CGRect headrect=CGRectMake(0,0,self.naviView.frame.size.width,self.naviView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=_titleStr;
    [self.naviView addSubview:view];
    [self.naviView sendSubviewToBack:view];
    
    goodsInfoList=[[NSMutableArray alloc] init];
    goodsSelectedList=[[NSMutableArray alloc] init];
    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
    NSDictionary *cartxml=_functionXML[@"native"][@"shopping_cart"][@"load_product"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0;i<_collocaInfo.count;i++)
        {
            NSDictionary *colldict=_collocaInfo[i];
            NSMutableArray *productInfoList=[[NSMutableArray alloc] initWithCapacity:10];
            NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
            NSDictionary *param=@{cartxml[@"loadpara"]: colldict[@"detailInfo"][@"productClsId"]};//lM_PROD_CLS_ID 参数
            [SHOPPING_GUIDE_ITF requestUrl:cartxml[@"url"] param:param responseList:productInfoList responseMsg:msg];
            
            [goodsInfoList addObject:productInfoList];
            
            //init selectedlist
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            dict[@"ProdID"]=@"";
            dict[@"SpecID"]=@"";
            dict[@"ColorID"]=@"";
            dict[@"Qty"]=@"";
            dict[@"Object"]=[[NSDictionary alloc] init];
            [goodsSelectedList addObject:dict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [Toast hideToastActivity];
        });
    });

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return goodsInfoList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 260;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"ditectButCell";
    DirectBuyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[DirectBuyOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
     cell = [[[NSBundle mainBundle] loadNibNamed:@"DirectBuyOrderTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *cartxml=_functionXML[@"native"][@"shopping_cart"];
    cell.functionXML = cartxml[@"load_product"];
    cell.rootXML = _rootXML;
    cell.collocaInfo = _collocaInfo[indexPath.row];
    cell.mainview=self;
    cell.row=(int)indexPath.row;
    
    if (goodsInfoList.count>indexPath.row)
        cell.productInfoList = goodsInfoList[indexPath.row]; //商品款
    
    //设置初值
    NSMutableDictionary *dict=goodsSelectedList[indexPath.row];
    if (dict!=nil && dict[@"ColorID"]!=nil)
        [cell selectColor:dict[@"ColorID"]];
    if (dict!=nil && dict[@"SpecID"]!=nil)
        [cell selectSize:dict[@"SpecID"]];
    if (dict!=nil && dict[@"Qty"]!=nil)
        [cell setGoodsNumber:dict[@"Qty"]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary *)getProduct:(NSArray *)list colorId:(NSString *)colorId specId:(NSString *)specId
{
    if (colorId.length>0 && specId.length>0)
    {
        for (int i=0;i<list.count;i++)
        {
            if ([[list[i][@"productInfo"][@"speC_ID"] stringValue] isEqualToString:specId] && [[list[i][@"productInfo"][@"coloR_ID"] stringValue] isEqualToString:colorId])
            {
                return list[i];
            }
        }
    }
    return nil;
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateGoodsSelected:(DirectBuyOrderTableViewCell *)cell
{
    NSMutableDictionary *dict=goodsSelectedList[cell.row];
    NSString *specid=[Utils getSNSString:cell.sizeid];
    if (specid.length>0)
        dict[@"SpecID"]=specid;
    NSString *colorid=[Utils getSNSString:cell.colorid];
    if (colorid.length>0)
        dict[@"ColorID"]=colorid;
    NSString *prodid=[Utils getSNSString:cell.productid];
    if (prodid.length>0)
        dict[@"ProdID"]=prodid;
    NSString *num=[Utils getSNSString:cell.goodsNum];
    if (num.length>0)
        dict[@"Qty"]=num;

    if ([Utils getSNSString:cell.productid].length>0)
    {
        dict[@"Object"]=[self getProduct:goodsInfoList[cell.row] colorId:cell.colorid specId:cell.sizeid];
    }
    else
    {
        dict[@"Object"]=[[NSDictionary alloc] init];
    }
}

-(BOOL)checkSelectedGoods:(int*)row
{
    for (int i=0;i<goodsSelectedList.count;i++)
    {
        NSMutableDictionary *dict=goodsSelectedList[i];
//        dict[@"ID"]=[Utils getSNSString:cell.shoppingcartid];
        NSString *p1=dict[@"ProdID"];
        NSString *s1=dict[@"SpecID"];
        NSString *c1=dict[@"ColorID"];
        if (p1.length==0 || s1.length==0 || c1.length==0)
        {
            *row=i;
            return NO;
        }
    }
    return YES;
}

- (IBAction)trueBtnClick:(id)sender {
    int row=0;
    if ([self checkSelectedGoods:&row]==NO)
    {
        [Utils alertMessage:@"请选择要购买的商品款式！"];
        return;
    }
    
    if ([_titleStr isEqual:@"加入购物车"]) {
        //批量加入购物车
        NSDictionary *dict=_functionXML;
//        NSArray *paramArr=nil;
        //数组元素只有一个，被直接转成nsdictionary，
        NSDictionary *paramArr=nil;
        if (dict[@"native"]!=nil && dict[@"native"][@"shopping_cart"])
        {
            if (dict[@"native"][@"shopping_cart"][@"parameter"]!=nil)
            {
                paramArr=dict[@"native"][@"shopping_cart"][@"parameter"][@"parameteritem"];
            }
        }
        NSMutableArray *goodsarr=[[NSMutableArray alloc] init];
        for (int i=0;i<goodsSelectedList.count;i++)
        {
            DirectBuyOrderTableViewCell *cell=(DirectBuyOrderTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            NSLog(@"%@",cell.goodsNumFiled.text);
            NSMutableDictionary *goodsdict=[[NSMutableDictionary alloc] init];
            NSMutableDictionary *dict=goodsSelectedList[i];
            [goodsdict setObject:sns.ldap_uid forKey:@"UserId"];
            [goodsdict setObject:dict[@"ProdID"] forKey:@"PROD_ID"];
            [goodsdict setObject:dict[@"SpecID"] forKey:@"SPEC_ID"];
            [goodsdict setObject:dict[@"ColorID"] forKey:@"COLOR_ID"];
            [goodsdict setObject:dict[@"Qty"] forKey:@"QTY"];
            if (_data!=nil)
            {
                if (_data[@"collocationId"]!=nil)
                    [goodsdict setObject:_data[@"collocationId"] forKey:@"COLLOCATION_ID"];
                if (_data[@"userId"]!=nil)
                    [goodsdict setObject:_data[@"userId"] forKey:@"SHARE_SELLER_ID"];
            }
            [goodsarr addObject:goodsdict];
        }
        
        NSMutableDictionary *urlparam=[[NSMutableDictionary alloc] init];
        if ([paramArr[@"value"] isEqualToString:@"LIST_CREATE_DTO"])
        {
            [urlparam setObject:goodsarr forKey:paramArr[@"name"]];
        }
        
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        [Toast makeToastActivity:@"加入购物车..." hasMusk:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success=[SHOPPING_GUIDE_ITF requestPostUrl:dict[@"native"][@"shopping_cart"][@"url"] param:urlparam responseAll:nil responseMsg:msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success)
                {
                    MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:vc1 animated:YES];
                }
                else
                    [Utils alertMessage:@"加入购物车失败！"];
                [Toast hideToastActivity];
            });
        });
        
    }
    else
    {
        NSMutableArray *payList=[[NSMutableArray alloc] init];
        for (int i=0;i<goodsSelectedList.count;i++)
        {
            DirectBuyOrderTableViewCell *cell=(DirectBuyOrderTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            MyShoppingTrollyGoodsData *data=[[MyShoppingTrollyGoodsData alloc] init];
            data.value=goodsSelectedList[i][@"Object"];
            data.number=[cell.goodsNumFiled.text intValue];
            [payList addObject:data];
        }
        
        if (payList.count==0)
        {
            [Utils alertMessage:@"请您选择商品后再购买！"];
            return;
        }
        
        MBCreateGoodsOrderViewController *orderVC=[[MBCreateGoodsOrderViewController alloc] initWithNibName:@"MBCreateGoodsOrderViewController" bundle:nil];
        orderVC.goodsArray=payList;
        orderVC.sumInfo=nil;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}
@end
