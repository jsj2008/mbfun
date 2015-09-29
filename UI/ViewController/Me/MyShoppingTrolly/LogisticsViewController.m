//
//  LogisticsViewController.m
//  Wefafa
//
//  Created by fafatime on 14-11-19.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "LogisticsViewController.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "NavigationTitleView.h"
#import "Appsetting.h"
#import "LogisticsTableViewCell.h"
#import "CommMBBusiness.h"
#import "HttpRequest.h"
#import "MBCustomClassifyModelView.h"

@interface LogisticsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *requestList;
    MBCustomClassifyModelView *customClassifyModelV;
}
@end

@implementation LogisticsViewController
@synthesize messageDic;
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
     self.title=@"订单跟踪";
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewHeader.backgroundColor=[UIColor blackColor];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect headrect=CGRectMake(0,0,self.viewHeader.frame.size.width,self.viewHeader.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"订单跟踪";
//    [self.viewHeader addSubview:view];
    [self setupNavbar];
    
    _logoImgView.layer.masksToBounds=YES;
    _logoImgView.layer.cornerRadius = 3.0;
    _logoImgView.layer.borderColor = [UIColor clearColor].CGColor;//Utils HexColor:0xc7c7c7 Alpha:1.0
    _logoImgView.layer.borderWidth =1.0;
    //订单id 不是订单编号
    NSString *orderID=[NSString stringWithFormat:@"%@",self.messageDic[@"id"]];
    //    NSString *orderNo=[NSString stringWithFormat:@"%@",self.messageDic[@"orderno"]];
    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
    
    //    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    
    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
    requestList=[[NSMutableArray alloc]init];
    UIView *footView=[[UIView alloc]init];
    _showTransTableView.tableFooterView=footView;
    [self addTableHeaderView];
    _showTransView.hidden=YES;
    [_showTransTableView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    __weak typeof(self) p = self;
    [HttpRequest orderGetRequestPath:nil methodName:@"InvoiceFilter" params:@{@"ORDER_ID": orderID} success:^(NSDictionary *dict) {
        NSLog(@"InvoiceFilter dict ---- %@", dict);
        NSDictionary *dictionary = nil;
        NSArray *tmparray = dict[@"results"];
        if (tmparray.count != 0 ) {
            dictionary = dict[@"results"][0];
        }
        if (dictionary) {
            p.showTransView.hidden = NO;
            [p.showTransTableView setFrame:CGRectMake(0, 129, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 129)];
        }
        p.titleLabel.text = dictionary[@"expresS_NAME"];
        p.orederLabel.text = dictionary[@"expresS_LISTNO"];
    } failed:^(NSError *error) {
        
    }];
    
    NSDictionary *param = @{@"userId":userId,@"doc_id":orderID};
    NSDictionary *param2 = @{@"ORDER_ID" : orderID};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HttpRequest LogisticsGetRequestPath:nil methodName:@"OperationInfoFilter" params:param success:^(NSDictionary *dict) {
            NSLog(@"OperationInfoFilter dict ---- %@", dict);
            if ([dict[@"isSuccess"] isEqualToNumber:@1]) {
                for (NSDictionary *dic in dict[@"results"]) {
                    [requestList addObject:dic];
                }
                [_showTransTableView reloadData];
                [Toast hideToastActivity];
            }
        } failed:^(NSError *error){
            [Toast hideToastActivity];
        }];
        
        [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"InvoiceFilterByOrderId" params:param2 success:^(NSDictionary *dict) {
            NSLog(@"InvoiceFilterByOrderId dict ---- %@", dict);
        } failed:^(NSError *error) {
            
        }];
        
    });
}

- (void)addTableHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = view.bounds;
    rect.origin.x += 15;
    rect.size.width -= 30;
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = @"订单跟踪";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [Utils HexColor:0x919191 Alpha:1];
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, UI_SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [Utils HexColor:0xe2e2e2 Alpha:1];
    [view addSubview:lineView];
    
    self.showTransTableView.tableHeaderView = view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AIdentifier = @"LogisticsTableViewCell";
    LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LogisticsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.stateName.text=[NSString stringWithFormat:@"%@",requestList[indexPath.row][@"opinion"]];
    NSString *timeDate=[NSString stringWithFormat:@"%@",requestList[indexPath.row][@"opeR_TIME"]];
    
    cell.timeLabel.text=[CommMBBusiness getdate:timeDate];
    cell.topImgView.hidden=NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requestList count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
