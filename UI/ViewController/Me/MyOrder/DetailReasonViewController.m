//
//  DetailReasonViewController.m
//  Wefafa
//
//  Created by fafatime on 15-1-4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "DetailReasonViewController.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "Toast.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "HttpRequest.h"

@interface DetailReasonViewController ()
{
    NSArray *resultsOrderArray;
    
}
@end

@implementation DetailReasonViewController
@synthesize type;

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
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    NSString *titleStr =nil;
    if([self.type isEqualToString:@"申请退款"])
    {
        titleStr=@"退款原因";
        
    }
    else
    {
        titleStr=@"退货原因";
    }
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:titleStr forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [tempBtn addTarget:self action:@selector(bestSelect:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:tempBtn];

    self.navigationItem.titleView = tempView;
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *views = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [views createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
//    [self.headView addSubview:views];
    NSString *codeStr;
    if([self.type isEqualToString:@"申请退款"])
    {
       views.lbTitle.text=@"退款原因";
        
       codeStr=@"1";
        
    }
    else
    {
      views.lbTitle.text=@"退货原因";
      codeStr=@"2";
        
    }
    [self setupNavbar];
    
    resultsOrderArray = [[NSArray alloc]init];
    
    _listTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    NSString  *fileName = @"getOrderReturnReasonList";

    NSDictionary *codeDic =@{@"type":codeStr};
    
    [HttpRequest orderGetRequestPath:nil methodName:fileName params:codeDic success:^(NSDictionary *dict) {
        
        NSLog(@"dict－－－－%@",dict);
        NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        if ([isSuccess isEqualToString:@"1"]) {
            NSArray *resultsA= [NSArray arrayWithArray:dict[@"results"]];
            
            if ([resultsA count]>0)
            {
                resultsOrderArray =resultsA;
            }
            else
            {
                
            }

        
                [_listTableView reloadData];
                
                [Toast hideToastActivity];
        }

    } failed:^(NSError *error) {
          [Toast hideToastActivity];
    }];
    
    

    

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
    return [resultsOrderArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.font=[UIFont systemFontOfSize:16.0f];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@",resultsOrderArray[indexPath.row]];

//    cell.accessoryType= UITableViewCellAccessoryCheckmark;
    return cell ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
//    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
//        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
    NSString *selectStr = [NSString stringWithFormat:@"%@",resultsOrderArray[indexPath.row]];

    NSDictionary *reasonDic=@{@"reason":selectStr};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectReason" object:nil userInfo:reasonDic];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
