//
//  OrderGoodsListViewController.m
//  Wefafa
//
//  Created by Miaoz on 15/2/6.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "OrderGoodsListViewController.h"
#import "NavigationTitleView.h"


#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"

#import "AppDelegate.h"
#import "AppSetting.h"
//商品数据类MyShoppingTrollyGoodsData
#import "MyShoppingTrollyGoodsTableViewCell.h"

//
#import "GoodsOrderBaseTableViewCell.h"
#import "GoodsOrderAddressTableViewCell.h"
#import "GoodsOrderAmountTableViewCell.h"
#import "GoodsOrderGoodsTableViewCell.h"
#import "GoodsOrderMemoTableViewCell.h"
#import "GoodsOrderPayFeeTableViewCell.h"
#import "GoodsOrderSendRequestTableViewCell.h"
#import "GoodsOrderDesignerTableViewCell.h"

#import "MyAdderssViewController.h"
#import "PayOrderViewController.h"
#import "InetAddress.h"

//
#import "Toast.h"
#import "Utils.h"
#import "JSONKit.h"
#import "NetUtils.h"
#import "GoodsOrderSimpleTableViewCell.h"

#import "WXPayClient.h"

#import "MBShoppingGuideInterface.h"
#import "Globle.h"
#import "GoodsInvoiceViewController.h"
#import "PayResultViewController.h"
#import "MyOrderViewController.h"
@interface OrderGoodsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic)UIView *viewHead;
@property(strong,nonatomic)NSMutableArray *orderInfoArray;
@end

@implementation OrderGoodsListViewController
@synthesize orderInfoArray = orderInfoArray;

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
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];
    self.title=@"商品列表";
    
}
-(void)onBack:(id)selector{
    NSLog(@"返回");
    //[self.navigationController popViewControllerAnimated:YES];
    [self popAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavbar];
    // Do any additional setup after loading the view.
    _viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    [self.view addSubview:_viewHead];
    
    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view.btnOk setTintColor:[UIColor redColor]];
    
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:@selector(btnOkClick:) selectorMenu:nil];
    view.lbTitle.text=@"商品列表";
    [self.viewHead addSubview:view];
    
    
//-10
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _viewHead.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
   
//    tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = [UIColor colorWithHexString:@"#e2e2e2"];
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _tableView.dataSource = self; //在self中响应UITableViewDataSource协议相关的接口
    _tableView.delegate = self;//在self中响应UITableViewDelegate协议相关的接口
   
    [self.view addSubview:_tableView];
    
    
    orderInfoArray=[[NSMutableArray alloc] initWithCapacity:10];
    [self createOrderInfoArray];
}
-(void)setGoodsArray:(NSMutableArray *)goodsArray{
    _goodsArray = goodsArray;
    

}
-(void)createOrderInfoArray
{
    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
    [orderInfoArray removeAllObjects];

//            NSString *firstDesigner=@"";
            for (int i=0;i<_goodsArray.count;i++)
            {
//                MyShoppingTrollyGoodsData *goods=_goodsArray[i];
//                if (![firstDesigner isEqualToString:goods.designerid])
//                {
//                    firstDesigner=goods.designerid;
//                    [orderInfoArray addObject:[self createCellForName:@"GoodsOrderDesignerTableViewCell" cellData:@{@"designername":goods.designername}]];
//                }
//                
                [orderInfoArray addObject:[self createCellForName:@"GoodsOrderGoodsTableViewCell" cellData:_goodsArray[i]]];
            }
            
            
            //商品总金额
//            int amount = [MyShoppingTrollyGoodsData totalPrice:_goodsArray];
//           int count = [MyShoppingTrollyGoodsData count:_goodsArray];
//            [orderInfoArray addObject:[self createCellForName:@"GoodsOrderAmountTableViewCell" cellData:@{@"count":@(count),@"amount":@(amount),@"haulage":@(DEFAULT_FEE)}]];
//            
    
            
            NSLog(@"。。。。。。。。。%@",orderInfoArray);
            
            [_tableView reloadData];
            [Toast hideToastActivity];

}

-(NSMutableDictionary *)createCellForName:(NSString*)cellName cellData:(id)data
{
    NSMutableDictionary *returndata=[[NSMutableDictionary alloc] initWithCapacity:2];
    [returndata setObject:cellName forKey:@"type"];
    [returndata setObject:data forKey:@"data"];
    return returndata;
}

-(id)getCellData:(NSString *)cellname
{
    for (int i=0;i<orderInfoArray.count;i++)
    {
        if ([orderInfoArray[i][@"type"] isEqualToString:cellname])
        {
            return orderInfoArray[i][@"data"];
        }
    }
    return nil;
}

-(int)getCellIndex:(NSString *)cellname
{
    for (int i=0;i<orderInfoArray.count;i++)
    {
        if ([orderInfoArray[i][@"type"] isEqualToString:cellname])
        {
            return i;
        }
    }
    return -1;
}

#pragma mark table view datasource & delegate methods

-(void)setCellBackground:(UITableViewCell *)cell
{
    //    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    //    backgrdView.backgroundColor=[self getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor" ]];
    //    backgrdView.backgroundColor = TABLEVIEW_BACKCOLOR;
    //    cell.backgroundView = backgrdView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, WINDOWW, 0.5)];
    lineview.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [cell.contentView addSubview:lineview];
    //设置selectionStyle = UITableViewCellSelectionStyleNone; 选中的背景无效
    //    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    //    selectedView.backgroundColor = [UIColor orangeColor];
    //    cell.selectedBackgroundView = selectedView;   //设置选中后cell的背景颜色
    //    [selectedView release];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [orderInfoArray count];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *headername = orderInfoArray[section][@"title"];
//    if ([headername characterAtIndex:0] == '_') return nil;
//    return headername;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    NSString *headername = orderInfoArray[section][@"title"];
//    if ([headername characterAtIndex:0] == '_') return 0;
//    return 28;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if(section==0)
    //    {
    //        return 0;
    //    }
    //    else if(section==1)
    //    {
    //        return 15;
    //    }
    //    else if(section==2)
    //    {
    //        return 0;
    //    }
    //    else if(section==3)
    //    {
    //        return 0;
    //    }
    //    else if(section==4)
    //    {
    //        return 15;
    //    }
    //
    //    NSString *cellname=orderInfoArray[section][@"type"];
    //    return [cellname isEqualToString:@"GoodsOrderDesignerTableViewCell"]?15:0;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//}
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [orderInfoArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSDictionary *rowData=orderInfoArray[indexPath.section];
    NSString *classId = rowData[@"type"];
    GoodsOrderBaseTableViewCell *cell = (GoodsOrderBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:classId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:classId owner:self options:nil] objectAtIndex:0];
            [self setCellBackground:cell];
            cell.onTextFieldScroll=[CommonEventHandler instance:self selector:@selector(scrollToRow:eventData:)];
            cell.onTextChanged=[CommonEventHandler instance:self selector:@selector(onTextChanged:eventData:)];
//            cell.backgroundColor = [UIColor redColor];
        }
        cell.rownum=indexPath.section;
        cell.data=rowData[@"data"];
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   }

#pragma mark --MLKMenuPopoverDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height=0;
    NSDictionary *rowData=orderInfoArray[indexPath.section];
    NSString *classId = rowData[@"type"];
    
    if ([classId isEqualToString:@"GoodsOrderAddressTableViewCell"])
    {
        height=[GoodsOrderAddressTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderAmountTableViewCell"])
    {
        height=[GoodsOrderAmountTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderPayFeeTableViewCell"])
    {
        height=[GoodsOrderPayFeeTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderGoodsTableViewCell"])
    {
        height=[GoodsOrderGoodsTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderDesignerTableViewCell"])
    {
        height=[GoodsOrderDesignerTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderMemoTableViewCell"])
    {
        height=[GoodsOrderMemoTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderSendRequestTableViewCell"])
    {
        height=[GoodsOrderSendRequestTableViewCell getCellHeight:rowData[@"data"]];
    }
    else if ([classId isEqualToString:@"GoodsOrderSimpleTableViewCell"])
    {
        height=[GoodsOrderSimpleTableViewCell getCellHeight:rowData[@"data"]];
    }
    return height;
}

-(void)scrollToRow:(id)sender eventData:(NSNumber*)rownum
{
    
    //    [_tvOrder scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[rownum intValue] inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
}

-(void)onTextChanged:(id)sender eventData:(NSString*)text
{
    GoodsOrderBaseTableViewCell *view=(GoodsOrderBaseTableViewCell *)sender;
    NSMutableDictionary *dict=orderInfoArray[view.rownum];
    [dict setObject:text forKey:@"data"];
}

//-(void)MyAdderssViewController_onAddressSelected:(id)sender eventData:(NSDictionary*)eventData
//{
//    int index=[self getCellIndex:@"GoodsOrderAddressTableViewCell"];
//    if (index>=0)
//    {
//        NSMutableDictionary *dict=orderInfoArray[index];
//        [dict setObject:eventData forKey:@"data"];
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
//        NSArray *arr=[[NSArray alloc] initWithObjects:indexPath, nil];
//        [_tvOrder reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
//    }
//}

-(void)btnBackClick:(id)sender
{
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
