//
//  MyAdderssViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-25.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyAdderssViewController.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "AddRessTableCell.h"
#import "NewAddressViewController.h"
#import "UIColor+extend.h"
#import "MyAddressFooterView.h"
#import "HttpRequest.h"
#import "SUtilityTool.h"
#import "MBToastHud.h"

@interface MyAdderssViewController ()<NewAddressViewControllerDelegate>

{
    NSMutableArray *requestList;
    UIView *noneDataView;
    
}
@property (weak, nonatomic) IBOutlet UIButton *addNewAddressButton;
@end

@implementation MyAdderssViewController

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
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"收货地址";
//    [self.headView addSubview:view];
//    [self.headView setBackgroundColor:[UIColor blackColor]];
    
    
    [self setupNavbar];
    [noneDataView removeFromSuperview];
    _listTableView.tableFooterView=[[UIView alloc]init];
    _viewBottom.frame=CGRectMake(0,UI_SCREEN_HEIGHT-_viewBottom.frame.size.height,SCREEN_WIDTH,_viewBottom.frame.size.height);
    [self.view addSubview:_viewBottom];

    requestList=[[NSMutableArray alloc]init];
   
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.listTableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    [self requestAddressList];
//    [self.addNewAddressButton setFrame:CGRectMake(UI_SCREEN_WIDTH/2-self.addNewAddressButton.frame.size.width/2, self.addNewAddressButton.frame.origin.y, self.addNewAddressButton.frame.size.width, self.addNewAddressButton.frame.size.height)];
//    
    self.addNewAddressButton.layer.cornerRadius = 3.0;
    self.addNewAddressButton.layer.masksToBounds = YES;
    self.listTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];;
}
-(void)initNoDataView
{
    if(!noneDataView)
    {
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, 64, UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT-_viewBottom.frame.size.height-64) WithImage:NONE_DATA_ADDRESS andImgSize:CGSizeMake(60, 60) andTipString:@"您还没有收货地址" font:FONT_t5 textColor:COLOR_C6 andInterval:10.0];
        [self.view addSubview:noneDataView];
    }
    else
    {
        [noneDataView removeFromSuperview];
        noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-_viewBottom.frame.size.height-64) WithImage:NONE_DATA_ADDRESS andImgSize:CGSizeMake(60, 60) andTipString:@"您还没有收货地址" font:FONT_t5 textColor:COLOR_C6 andInterval:10.0];
        [self.view addSubview:noneDataView];
        
    }
    
}
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
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"我的地址";
    
}

- (void)onBack:(UIButton*)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAddRess" object:nil];
    [self popAnimated:YES];
}
-(void)requestAddressList{
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    
    NSMutableArray *list=[[NSMutableArray alloc]init];
    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL rst=[SHOPPING_GUIDE_ITF requestGetUrlName:@"ReceiverFilter" param:
                  @{@"userId":sns.ldap_uid,@"pageIndex":@1,@"pageSize":@100}
                                          responseList:list responseMsg:returnMessage];
        if (rst)
        {
            if (requestList.count > 0) {
                [requestList removeAllObjects];
                [noneDataView removeFromSuperview];
                
            }
            for (int i=0;i<list.count;i++)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:list[i] copyItems:YES];
                [requestList addObject:dict];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
                if ([requestList count]==0)
                {
                    [self initNoDataView];
                }
                else
                {
                    [noneDataView removeFromSuperview];
                    [_listTableView reloadData];
                    
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initNoDataView];
                [Toast hideToastActivity];
                [Toast makeToast:@"加载失败" duration:2 position:@"center"];
            });
        }
    });
    

}
-(void)NewAddressViewController_onRefreshRow:(id)sender eventData:(NSDictionary*)param
{
    NewAddressViewController *vc=(NewAddressViewController *)sender;
    if (vc.row>=0)
    {
        [requestList replaceObjectAtIndex:vc.row withObject:param];
    }
    else
    {
//        [requestList addObject:param];
        // add by miao 3.2
        if (requestList.count != 0) {
             [requestList removeAllObjects];
            [noneDataView removeFromSuperview];
        }
        [self requestAddressList];
        
    }
    [_listTableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int idx=(int)indexPath.section;
    NSString *str=[self getDetailAddress:idx];
    CGSize size=[str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(256, MAXFLOAT)];
    return size.height+60;
//    return 80.0;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return @"删除";
}

/*删除用到的函数*/

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int idx=(int)indexPath.section;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [Toast makeToastActivity:@"正在删除..." hasMusk:NO];
        
        NSString *idst = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:idx]objectForKey:@"id"]];
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"ReceiverDelete" params:@{@"ID":idst} success:^(NSDictionary *dict) {
            if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
            {
                [requestList removeObjectAtIndex:idx];  //删除数组里的数据
                [tableView reloadData];
                [Toast makeToastSuccess:@"已删除"];
                if([requestList count]==0)
                {
                    [noneDataView removeFromSuperview];
                    
                    [self initNoDataView];
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [Toast makeToast:@"删除失败"];
                });
            }
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                [Toast makeToast:@"删除失败"];
            });
        }];
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          NSString *idst = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:idx]objectForKey:@"id"]];
            NSMutableString *rstSt=[[NSMutableString alloc]init];
          
            if ( [SHOPPING_GUIDE_ITF requestPostUrlName:@"ReceiverDelete" param:@{@"ID":idst} responseAll:nil responseMsg:rstSt])
            {
                NSLog(@"-----%@---",rstSt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    
                    [requestList removeObjectAtIndex:idx];  //删除数组里的数据
                    [tableView reloadData];
//                    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

//                    [Toast makeToast:@"已删除"];//rstSt
                    [Toast makeToastSuccess:@"已删除"];
                    if([requestList count]==0)
                    {
                        [noneDataView removeFromSuperview];
                        
                        [self initNoDataView];
                    }
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [Toast makeToast:@"删除失败"];
                });
            }
        });
         */
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [requestList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int idx=(int)indexPath.section ;
     AddRessTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddRessTableCell" owner:self options:nil] objectAtIndex:0];
        cell.btnModifyClickEvent=[CommonEventHandler instance:self selector:@selector(showNewAddressView:eventData:)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //
    if([[[requestList objectAtIndex:idx] allKeys] containsObject:@"NAME"])
    {
        NSString *namest=[NSString stringWithFormat:@"%@",[[requestList objectAtIndex:idx] objectForKey:@"NAME"]];
        cell.userName.text=[Utils getSNSString:namest];
        NSString *telst=[NSString stringWithFormat:@"%@",[[requestList objectAtIndex:idx] objectForKey:@"MOBILENO"]];
        cell.userPhoneNum.text=[Utils getSNSString:telst];
        cell.row=idx;
        cell.adress.text=[self getDetailAddress:idx];
        CGSize size=[cell.adress.text sizeWithFont:cell.adress.font constrainedToSize:CGSizeMake(cell.adress.frame.size.width, MAXFLOAT)];
        cell.adress.frame=CGRectMake(cell.adress.frame.origin.x,cell.adress.frame.origin.y,cell.adress.frame.size.width,size.height);
        CGRect rect = cell.adress.frame;
        //    cell.backgroundColor = [UIColor redColor];
        //    cell.adress.backgroundColor = [UIColor yellowColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        if ([[[requestList objectAtIndex:idx] objectForKey:@"IS_DEFAULT"] boolValue]==YES)
        {
            //        cell.btnDefaultAddr.enabled=NO;
            //        cell.btnDefaultAddr.hidden=NO;
            rect.origin.x = 50.0;
            rect.size.width = 240.0;
        }
        else
        {
            rect.origin.x = 15.0;
            rect.size.width = 260.0;
            //        cell.btnDefaultAddr.enabled=YES;
            //        cell.btnDefaultAddr.hidden=YES;
        }
    }
    else
    {
        NSString *namest=[NSString stringWithFormat:@"%@",[[requestList objectAtIndex:idx] objectForKey:@"name"]];
        cell.userName.text=[Utils getSNSString:namest];
        NSString *telst=[NSString stringWithFormat:@"%@",[[requestList objectAtIndex:idx] objectForKey:@"mobileno"]];
        cell.userPhoneNum.text=[Utils getSNSString:telst];
        cell.row=idx;
        cell.adress.text=[self getDetailAddress:idx];
        CGSize size=[cell.adress.text sizeWithFont:cell.adress.font constrainedToSize:CGSizeMake(cell.adress.frame.size.width, MAXFLOAT)];
        cell.adress.frame=CGRectMake(cell.adress.frame.origin.x,cell.adress.frame.origin.y,cell.adress.frame.size.width,size.height);
        CGRect rect = cell.adress.frame;
        //    cell.backgroundColor = [UIColor redColor];
        //    cell.adress.backgroundColor = [UIColor yellowColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        if ([[[requestList objectAtIndex:idx] objectForKey:@"is_default"] boolValue]==YES)
        {
            //        cell.btnDefaultAddr.enabled=NO;
            //        cell.btnDefaultAddr.hidden=NO;
            rect.origin.x = 50.0;
            rect.size.width = 240.0;
        }
        else
        {
            rect.origin.x = 15.0;
            rect.size.width = 260.0;
            //        cell.btnDefaultAddr.enabled=YES;
            //        cell.btnDefaultAddr.hidden=YES;
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 20;
    }
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOWW, 20.0f)];
//    header.backgroundColor = [UIColor whiteColor];
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 40.0f;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MyAddressFooterView *footer = [[MyAddressFooterView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    footer.backgroundColor = [UIColor whiteColor];
    footer.dataDic = requestList[section];
    footer.indexPath =  [NSIndexPath indexPathWithIndex:section];
    footer.didDefaultSelectedEnter = ^(id sender,UIButton *button,NSIndexPath *indexPth) {
        NSDictionary *tmpdic = (NSDictionary *)sender;
        if ([tmpdic[@"is_default"] integerValue] == 1) {
            [button setImage:[UIImage imageNamed:@"Unico/address_select"] forState:UIControlStateNormal];
            [button setTitle:@"默认地址" forState:UIControlStateNormal];
            return ;
        }
        if ([tmpdic[@"IS_DEFAULT"] integerValue] == 1) {
            [button setImage:[UIImage imageNamed:@"Unico/address_select"] forState:UIControlStateNormal];
            [button setTitle:@"默认地址" forState:UIControlStateNormal];
            return ;
        }
        if ([tmpdic[@"isdefalut"] integerValue] == 1) {
            [button setImage:[UIImage imageNamed:@"Unico/address_select"] forState:UIControlStateNormal];
            [button setTitle:@"默认地址" forState:UIControlStateNormal];
            return ;
        }
        if ([tmpdic[@"ISDEFAULT"] integerValue] == 1) {
            [button setImage:[UIImage imageNamed:@"Unico/address_select"] forState:UIControlStateNormal];
            [button setTitle:@"默认地址" forState:UIControlStateNormal];
            return ;
        }
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:tmpdic];
        [mutableDic setObject:@"1" forKey:@"isdefault"];
         [mutableDic setObject:@"1" forKey:@"is_default"];
        NSArray *keyArray = [mutableDic allKeys];
        for (int a=0; a<[keyArray count]; a++) {
            NSString *keyValue = [NSString stringWithFormat:@"%@",keyArray[a]];
            NSString *uppercaseKey =[keyValue uppercaseString];//变大写
//            keyValue = [keyValue uppercaseString];//变大写
            [mutableDic setObject:mutableDic[keyValue] forKey:uppercaseKey ];
        }
         NSString *user_ID=@"";
        
        if ([[mutableDic allKeys] containsObject:@"user_id"]) {
            user_ID=[NSString stringWithFormat:@"%@",mutableDic[@"user_id"]];
            
        }
        
        if ([[mutableDic allKeys] containsObject:@"UserId"]) {
            user_ID=[NSString stringWithFormat:@"%@",mutableDic[@"UserId"]];
            
        }
        [mutableDic removeObjectsForKeys:keyArray];
        [mutableDic removeObjectForKey:@"USERID"];
        [mutableDic setObject:user_ID forKey:@"UserId"];

        NSLog(@"mutabledi--%@",mutableDic);
        
        
//        [mutableDic setObject:mutableDic[@"id"] forKey:@"ID"];
//        [mutableDic setObject:mutableDic[@"address"] forKey:@"ADDRESS"];
//        [mutableDic setObject:mutableDic[@"address"] forKey:@"ADDRESS"];
//        [mutableDic setObject:@"1" forKey:@"ISDEFAULT"];
//        [mutableDic setObject:mutableDic[@"county"] forKey:@"COUNTY"];
//        [mutableDic setObject:mutableDic[@"creatE_USER"] forKey:@"CREATE_USER"];
//        [mutableDic setObject:mutableDic[@"address"] forKey:@"ADDRESS"];
//        [mutableDic setObject:mutableDic[@"address"] forKey:@"ADDRESS"];
//        [mutableDic setObject:mutableDic[@"address"] forKey:@"ADDRESS"];
//        [mutableDic setObject:mutableDic[@"address"] forKey:@"ADDRESS"];
//        [mutableDic setObject:mutableDic[@"address"] forKey:@"ADDRESS"];
//        
//        
//        [mutableDic removeObjectForKey:@"id"];
//        [mutableDic removeObjectForKey:@"address"];
        
        
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"ReceiverUpdate" params:mutableDic success:^(NSDictionary *dict) {
            if ([dict[@"isSuccess"] integerValue] == 1) {
                [MBToastHud show:@"设置默认地址成功!" image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                
                [self requestAddressList];
            }
            
        } failed:^(NSError *error) {
            [MBToastHud show:@"设置默认地址失败!" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
        }];
       /*
        //修改默认地址
        [HttpRequest postRequestPath:kMBServerNameTypeOrder methodName:@"ReceiverCancelDefault" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
            if ([dict[@"isSuccess"] integerValue] == 1) {
                [HttpRequest postRequestPath:kMBServerNameTypeOrder methodName:@"ReceiverUpdate" params:mutableDic success:^(NSDictionary *dict) {
                    if ([dict[@"isSuccess"] integerValue] == 1) {
                        [MBToastHud show:@"设置默认地址成功!" image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                        
                        [self requestAddressList];
                    }
                  
                } failed:^(NSError *error) {
                    [MBToastHud show:@"设置默认地址失败!" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                }];
            }
        } failed:^(NSError *error) {
            
            [MBToastHud show:@"设置默认地址失败!" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
            
        }];
        */
        
    
    };
    footer.didDeleteSelectedEnter = ^(id sender,UIButton *button,NSIndexPath *indexPth) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"确定删除收货地址!"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        alertView.tag= indexPth.section;
        [alertView show];
        return ;
        
        
        //删除
        [Toast makeToastActivity:@"正在删除..." hasMusk:NO];
        
        
       NSString *idst = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:indexPth.section]objectForKey:@"id"]];
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"ReceiverDelete" params:@{@"ID":idst} success:^(NSDictionary *dict) {
            if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    
                    [requestList removeObjectAtIndex:indexPth.section];  //删除数组里的数据
                    
                    //                    [Toast makeToast:@"已删除"];//rstSt
                    [MBToastHud show:@"删除成功" image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                    if ([requestList count]==0) {
                        [self initNoDataView];
                    }
                    [tableView reloadData];
                    
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                       [MBToastHud show:@"删除失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                });
            }
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                [MBToastHud show:@"删除失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];

            });
        }];
        
     /*
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *idst = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:indexPth.section]objectForKey:@"id"]];
            NSMutableString *rstSt=[[NSMutableString alloc]init];
            
            if ( [SHOPPING_GUIDE_ITF requestPostUrlName:@"ReceiverDelete" param:@{@"ID":idst} responseAll:nil responseMsg:rstSt])
            {
                NSLog(@"-----%@---",rstSt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    
                    [requestList removeObjectAtIndex:indexPth.section];  //删除数组里的数据
                    
//                    [Toast makeToast:@"已删除"];//rstSt
                    [MBToastHud show:@"删除成功" image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                    if ([requestList count]==0) {
                        [self initNoDataView];
                    }
                    [tableView reloadData];
                    
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
//                    [Toast makeToast:@"删除失败"];
                    [MBToastHud show:@"删除失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                    
                });
            }
        });
*/
        
    };
    footer.didEditSelectedEnter = ^(id sender,UIButton *button,NSIndexPath *indexPth) {
//                NSDictionary *dic = (NSDictionary *)sender;
        //编辑
        [self showNewAddressView:self eventData:[NSNumber numberWithInteger:indexPth.section]];
    };
    
    return footer;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //删除
        [Toast makeToastActivity:@"正在删除..." hasMusk:NO];
        
         NSString *idst = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:alertView.tag]objectForKey:@"id"]];
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"ReceiverDelete" params:@{@"ID":idst} success:^(NSDictionary *dict) {
            if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    
                    [requestList removeObjectAtIndex:alertView.tag];  //删除数组里的数据
                    
                    //                    [Toast makeToast:@"已删除"];//rstSt
                    [MBToastHud show:@"删除成功" image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                    if ([requestList count]==0) {
                        [self initNoDataView];
                    }
                    [_listTableView reloadData];
                    
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [MBToastHud show:@"删除失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                    
                });
            }
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
                [MBToastHud show:@"删除失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                
            });
        }];

        
        
        
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *idst = [NSString stringWithFormat:@"%@",[[requestList objectAtIndex:alertView.tag]objectForKey:@"id"]];
            NSMutableString *rstSt=[[NSMutableString alloc]init];
            
            if ( [SHOPPING_GUIDE_ITF requestPostUrlName:@"ReceiverDelete" param:@{@"ID":idst} responseAll:nil responseMsg:rstSt])
            {
                NSLog(@"-----%@---",rstSt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                    
                    [requestList removeObjectAtIndex:alertView.tag];  //删除数组里的数据
                    
                    //                    [Toast makeToast:@"已删除"];//rstSt
                    [MBToastHud show:@"删除成功" image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
                    if ([requestList count]==0) {
                        [self initNoDataView];
                    }
                    [_listTableView reloadData];
                    
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    //                    [Toast makeToast:@"删除失败"];
                    [MBToastHud show:@"删除失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
                    
                });
            }
        });
        
        */
    }
}
-(NSString *)getDetailAddress:(int)row
{
    NSDictionary *dic = (NSDictionary *)[requestList objectAtIndex:row];
    NSString *str_addrdetail=nil;
    //php不兼容大小写 上传字段是大写的 但是返回对是小写
    if ([[dic allKeys]containsObject:@"ADDRESS"]) {
        const char *c = [[[requestList objectAtIndex:row] objectForKey:@"ADDRESS"] cStringUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
        NSString *desSt=[NSString stringWithFormat:@"%@",str];
        str_addrdetail=[NSString stringWithFormat:@"%@ %@ %@ %@",[Utils getSNSString:[[requestList objectAtIndex:row] objectForKey:@"PROVINCE"]],[Utils getSNSString:[[requestList objectAtIndex:row] objectForKey:@"CITY"]],[Utils getSNSString:[[requestList objectAtIndex:row] objectForKey:@"COUNTY"]],desSt];
    }
    else
    {
        const char *c = [[[requestList objectAtIndex:row] objectForKey:@"address"] cStringUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
        NSString *desSt=[NSString stringWithFormat:@"%@",str];
        str_addrdetail=[NSString stringWithFormat:@"%@ %@ %@ %@",[Utils getSNSString:[[requestList objectAtIndex:row] objectForKey:@"province"]],[Utils getSNSString:[[requestList objectAtIndex:row] objectForKey:@"city"]],[Utils getSNSString:[[requestList objectAtIndex:row] objectForKey:@"county"]],desSt];
    }

    return str_addrdetail;
}

-(NSString *) existDefaultAddress:(NSArray *)arr
{
    NSString *addrId=@"";
    for (NSDictionary *dict in arr)
    {
        if ([[dict objectForKey:@"is_default"] boolValue]==YES)
        {
            addrId = [Utils getSNSInteger:dict[@"id"]];
            break;
        }
    }
    return addrId;
}

-(void) setDefaultAddress:(NSString *)addrId isDefault:(BOOL)isDefault
{
    for (NSDictionary *dict in requestList)
    {
        if ([[Utils getSNSInteger:[dict objectForKey:@"id"]] isEqualToString:addrId])
        {
            [dict setValue:isDefault?@"1":@"0" forKey:@"is_default"];
            break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int idx=(int)indexPath.section;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_onSelectedRow==nil)
    {
        return;
        [self showNewAddressView:self eventData:[NSNumber numberWithInt:idx]];
    }
    else
    {
        [_onSelectedRow fire:self eventData:requestList[idx]];
        [self.navigationController popViewControllerAnimated:YES];
    }      
}

-(void)showNewAddressView:(id)sender eventData:(NSNumber *)rownum
{
    int index=[rownum intValue];
    NewAddressViewController *addVC=[[NewAddressViewController alloc]initWithNibName:@"NewAddressViewController" bundle:nil];
    addVC.delegate = self;
    addVC.showDic = [requestList objectAtIndex:index];
    addVC.row=index;
    addVC.defaultAddrID=[self existDefaultAddress:requestList];
    addVC.mainview=self;
    [self.navigationController pushViewController:addVC animated:YES];
}
-(void)callBackNewAddressViewControllerDelegateWithDeleteAddressByrow:(int)sender{
    [requestList removeObjectAtIndex:sender];  //删除数组里的数据
    [_listTableView reloadData];
    if ([requestList count]==0) {
        [self initNoDataView];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backHome:(UIButton*)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAddRess" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addNewAddress:(id)sender
{
    NewAddressViewController *addVC=[[NewAddressViewController alloc]initWithNibName:@"NewAddressViewController" bundle:nil];
    addVC.defaultAddrID=[self existDefaultAddress:requestList];
    addVC.mainview=self;
    addVC.row=-1;
    [self.navigationController pushViewController:addVC animated:YES];
}

@end
