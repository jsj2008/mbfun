//
//  ShowPreferentialViewController.m
//  Wefafa
//
//  Created by fafatime on 15-3-2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "ShowPreferentialViewController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "OrderModel.h"

@interface ShowPreferentialViewController ()

@end

@implementation ShowPreferentialViewController
@synthesize detailPreferentArray;

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.title=@"优惠详情";
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
  
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *views = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    views.lbTitle.text=@"优惠详情";
    [views createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
//    [self.headView addSubview:views];
    [self setupNavbar];
    [self removeMoreData];
    
//    [self removeMoreData];
    UIView *emptyView=[[UIView alloc]init];
    [emptyView setBackgroundColor:[UIColor clearColor]];
    _showDetailTV.tableFooterView=emptyView;
    
}
//id重复的只保留一个
-(void)removeAllData
{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    int i;
    for(i=0;i<self.detailPreferentArray.count;i++)
    {
        if(i==0)
        {
            [arr addObject:self.detailPreferentArray[i]];
        }else
        {
            int j=0;
            for(j=0;j<arr.count;j++)
            {
                NSDictionary *dic=arr[j];
                NSDictionary *dic2=self.detailPreferentArray[i];
                NSString *dicPromotionId=[NSString stringWithFormat:@"%@",dic[@"promotioN_ID"]];
                NSString *dic2PromotionId = [NSString stringWithFormat:@"%@",dic2[@"promotioN_ID"]];
                if([dicPromotionId isEqualToString:dic2PromotionId])
                {
                    break;
                }
            }
            if(j==arr.count)
            {
                [arr addObject:self.detailPreferentArray[i]];
            }
            
        }
    }
    self.detailPreferentArray  = arr;
    
}
//id重复的只保留一个
-(void)removeMoreData
{
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc]init];

//    for (NSDictionary *dic in self.detailPreferentArray) {
//        NSString *promotionID = [NSString stringWithFormat:@"%@",dic[@"promotioN_ID"]];
//        [muDict setObject:dic forKey:promotionID];
//    }
    for (OrderModelPromListInfo *listInfo in self.detailPreferentArray) {
        NSString *promotionID = [NSString stringWithFormat:@"%@",listInfo.promotioN_ID];
        [muDict setObject:listInfo forKey:promotionID];
    }
   NSMutableArray * array = [NSMutableArray arrayWithArray:[muDict allValues]];
   self.detailPreferentArray  = array;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 43;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detailPreferentArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.font=[UIFont systemFontOfSize:16.0f];
 
    if([detailPreferentArray count]>0)
    {
        OrderModelPromListInfo *listInfo=detailPreferentArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[Utils getSNSString:listInfo.promotioN_NAME]];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[Utils getSNSMoney:detailPreferentArray[indexPath.row][@"diS_AMOUNT"]]];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    //    cell.accessoryType= UITableViewCellAccessoryCheckmark;
    return cell ;
}


-(void)backHome:(id)sender
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
