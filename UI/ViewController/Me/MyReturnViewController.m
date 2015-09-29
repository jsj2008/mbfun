//
//  MyReturnViewController.m
//  Wefafa
//
//  Created by fafatime on 14-12-18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyReturnViewController.h"
#import "Utils.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "MyOrderTableView.h"
#import "DetailOrderViewController.h"
#import "ReturnGoodAndMoneyTableView.h"
#import "SQLiteOper.h"
#import "RefundApplyViewController.h"
#import "DetailReturnMoneyViewController.h"
#import "HeadBtnView.h"
#import "SUtilityTool.h"
#import "MJRefresh.h"
#import "SDataCache.h"
#import "MBCustomClassifyModelView.h"
#import "AttendCustomButton.h"
#import "HttpRequest.h"

@interface MyReturnViewController ()<MBCustomClassifyModelViewDelegate>
{
    NSMutableArray *returnAll;
//    UIButton *returnMoneyBtn;
//    UIButton *returnGoodBtn;
     HeadBtnView *headBtnV;
    UIScrollView *backScrollView;
    UIImageView *noCodeImgView;
    UIImageView *noGoodCodeImgView;
    int just;
    ReturnGoodAndMoneyTableView *returnMoneyTableView;
    ReturnGoodAndMoneyTableView *returnGoodTableView;
    BOOL isReturnGoods;
    NSString *one_reapP_ID;
    
    
    NSMutableArray *requestMoneyList;
    NSMutableArray *requestGoodList;
    NSInteger _pageIndex;//退款
    NSInteger _goodPageIndex;//退货
    UIView *placeholdView;
    int xPoint;
    MBCustomClassifyModelView* customClassifyModelV;
    
}
@end

@implementation MyReturnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden=NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeData" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden=YES;
}
-(void)setupNavbar
{
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
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,UI_SCREEN_WIDTH, navRect.size.height)];
    NSArray * titleArray=@[@"退款    ",@"退货    "];
    customClassifyModelV=[[MBCustomClassifyModelView alloc]initWithFrame:CGRectMake((tempView.frame.size.width/2-130),0, 150, navRect.size.height) WithTitleArray:titleArray useScroll:NO WithPicAndText:NO WithPicArray:nil WithSelectPicArray:nil WithShowRightBtnLine:NO WithShowBottomBtnLine:YES];
    customClassifyModelV.backgroundColor=[UIColor clearColor];
    customClassifyModelV.delegate=self;
//    [customClassifyModelV setFont: FONT_T5];

    [customClassifyModelV setTextColor:[Utils HexColor:0xf2f2f2 Alpha:1.0]];
    [customClassifyModelV setSelectedTextColor:[UIColor whiteColor]];
    [tempView addSubview:customClassifyModelV];
    [customClassifyModelV buttonClickedOfIndex:0];
    [self clickReturnMoneyBtn:nil];
    
    

    /*
    headBtnV=[[HeadBtnView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-70-50, -10, 70*2, tempView.frame.size.height)];
    
    [headBtnV.colloctBtn setTitle:@"退款" forState:UIControlStateNormal];
    [headBtnV.colloctBtn addTarget:self
                            action:@selector(clickReturnMoneyBtn:)
                  forControlEvents:UIControlEventTouchUpInside];
    [headBtnV.goodBtn setTitle:@"退货" forState:UIControlStateNormal];
    [headBtnV.goodBtn addTarget:self
                         action:@selector(clickGoodBtn:)
               forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:headBtnV];
    [headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
    [headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    
    [headBtnV.colloctBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
    [headBtnV.goodBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
    */
    self.navigationItem.titleView = tempView;
}
-(void)TabItemClick:(id)sender button:(id)param
{
    NSInteger page=0;
    
   AttendCustomButton * otherBtn = (AttendCustomButton *)param;
    page=otherBtn.tag;
    if (page==1) {
             [self clickGoodBtn:nil];
    }
    else
    {
        [self clickReturnMoneyBtn:nil];
    }
    
}
//- (void)getInfoList {
//    __unsafe_unretained typeof(self) ws = self;
//  
//    NSInteger page=1;
//    [SDATACACHE_INSTANCE getAllFashionList:page complete:^(NSArray *data) {
//         ws.returnMoneyTableView.dataArray=nil;
//        [ws.returnMoneyTableView reloadData];
//        
//    }];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden=YES;
    [self setupNavbar];
    
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    returnAll = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:@"changeData" object:nil];

    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.headView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.headView.frame.size.height)];
    backScrollView.delegate=self;
    backScrollView.pagingEnabled=YES;
    backScrollView.bounces=NO;
    backScrollView.contentSize =  CGSizeMake(UI_SCREEN_WIDTH*2,0);//CGSizeMake(UI_SCREEN_WIDTH*2,0);
    [self.view addSubview:backScrollView];
    
    noCodeImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    [noCodeImgView setImage:[UIImage imageNamed:@"shoppingNil.png"]];
    noCodeImgView.hidden=YES;
    noGoodCodeImgView=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH,0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    [noGoodCodeImgView setImage:[UIImage imageNamed:@"shoppingNil.png"]];
    noGoodCodeImgView.hidden=YES;
    
 
    NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
    [Toast makeToastActivity:@"正在加载..." hasMusk:YES];
     requestMoneyList=[[NSMutableArray alloc]init];
     requestGoodList=[[NSMutableArray alloc]init];
    _pageIndex=1;
    _goodPageIndex=1;
    NSMutableDictionary *paramDic=[@{@"userId":userId,
                             @"pageSize": @10,
                             @"pageIndex": @(_pageIndex),
                             @"type":@"1"} mutableCopy];//1 是退款 2 是退货
    [HttpRequest orderGetRequestPath:nil methodName:@"OrderReturnFilterList" params:paramDic success:^(NSDictionary *dict) {
        NSLog(@"－－订单请求－－%@",dict);
        NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
         [requestMoneyList addObjectsFromArray:dict[@"results"]];
        if ([isSuccess boolValue]) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [Toast hideToastActivity];
                //全部
                returnMoneyTableView=[[ReturnGoodAndMoneyTableView alloc]initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
                returnMoneyTableView.dataArray=requestMoneyList;
                returnMoneyTableView.cellDefaultHeight=84;
                [returnMoneyTableView.onLoadNewMessage addListener:self selector:@selector(tv_OnLoadNewMessage:eventData:)];
                //                [returnMoneyTableView.onLoadMoreMessage addListener:self selector:@selector(tv_OnLoadMoreMessage:eventData:)];
                [returnMoneyTableView addFooterWithTarget:self action:@selector(tv_OnLoadMoreMessage:)];
                [returnMoneyTableView.onDidSelectedRow addListener:self selector:@selector(tv_OnDidSelected:RowMessage:)];
                [returnMoneyTableView.onDidCancleRow addListener:self selector:@selector(tv_OnDidCancled:RowMessage:)];
                [returnMoneyTableView.onDidOrderRow addListener:self selector:@selector(tv_OnDidOrder:RowMessage:)];
                [backScrollView addSubview:returnMoneyTableView];
                  xPoint=0;
                if (returnMoneyTableView.dataArray.count == 0) {
                    xPoint=0;
                    [self configPlaceholdView];
                }else{
                    [self removePlaceholdView];
                }
                
            });
 
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                noCodeImgView.hidden=NO;
                xPoint=0;
                [self configPlaceholdView];
                [Toast hideToastActivity];
            });
        }
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            noCodeImgView.hidden=NO;
            xPoint=0;
            [self configPlaceholdView];
            [Toast hideToastActivity];
        });
        
    }];
    [paramDic setObject:@"2" forKey:@"type"];
    [HttpRequest orderGetRequestPath:nil methodName:@"OrderReturnFilterList" params:paramDic success:^(NSDictionary *dict) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        if([isSuccess boolValue])
        {
            requestGoodList = dict[@"results"];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
                returnGoodTableView=[[ReturnGoodAndMoneyTableView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
                returnGoodTableView.dataArray=requestGoodList;
                returnGoodTableView.cellDefaultHeight=84;
                [returnGoodTableView.onLoadNewMessage addListener:self selector:@selector(tv_OnLoadNewMessage:eventData:)];
                //                [returnGoodTableView.onLoadMoreMessage addListener:self selector:@selector(tv_OnLoadMoreMessage:eventData:)];
                [returnGoodTableView.onDidSelectedRow addListener:self selector:@selector(tv_OnDidSelected:RowMessage:)];
                
                [returnGoodTableView addFooterWithTarget:self action:@selector(tv_OnLoadMoreMessage:)];
                
                [returnGoodTableView.onDidCancleRow addListener:self selector:@selector(tv_OnDidCancled:RowMessage:)];
                [returnGoodTableView.onDidOrderRow addListener:self selector:@selector(tv_OnDidOrder:RowMessage:)];
                [backScrollView addSubview:returnGoodTableView];
     
                if (returnGoodTableView.dataArray.count == 0) {
                    xPoint=1;
                    [self configPlaceholdView];
                    xPoint=0;
                }else{
                    [self removePlaceholdView];
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                noGoodCodeImgView.hidden=NO;
                xPoint=1;
                [self configPlaceholdView];
                xPoint=0;
                [Toast hideToastActivity];
                
            });

        }

        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            noGoodCodeImgView.hidden=NO;
           xPoint=1;
            [self configPlaceholdView];
               xPoint=0;
            [Toast hideToastActivity];
            
        });

        
    }];


}
- (void)configPlaceholdView
{

    CGFloat originY = backScrollView.frame.origin.y;
    CGRect  noneDataRect = CGRectMake(UI_SCREEN_WIDTH*xPoint, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    NSString *titleStr =@"暂无退款退货信息";
    
    if (xPoint==0) {
        titleStr=@"暂无退款信息";
    }
    else
    {
        titleStr=@"暂无退货信息";
    }
    //        CGRect  noneDataRect = CGRectMake(UI_SCREEN_WIDTH*touchTag, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    placeholdView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_ORDER andImgSize:CGSizeMake(60, 60) andTipString:titleStr font:FONT_t5 textColor:COLOR_C6 andInterval:20.0];
    [backScrollView addSubview:placeholdView];

}
- (void)removePlaceholdView
{
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
}
-(void)requestData
{
    NSString *userId = [NSString stringWithFormat:@"%@",sns.ldap_uid];
    __block  NSMutableArray *requestMoneyListNew=[NSMutableArray new];
    __block  NSMutableArray *requestGoodListNew=[NSMutableArray new];
//    NSMutableString *returnMessage =[NSMutableString new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (xPoint==0) {
            
            NSLog(@"。。。。走不走");
            
            
            NSMutableDictionary *paramDic=[@{@"userId":userId,
                                             @"pageSize": @10,
                                             @"pageIndex": @(_pageIndex),
                                             @"type":@"1"} mutableCopy];//1 是退款 2 是退货
            [HttpRequest orderGetRequestPath:nil methodName:@"OrderReturnFilterList" params:paramDic success:^(NSDictionary *dict) {
                NSLog(@"－－订单请求－－%@",dict);
                NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
//                [requestMoneyListNew addObjectsFromArray:dict[@"results"]];
        
                dispatch_async(dispatch_get_main_queue(), ^{

                    [returnMoneyTableView footerEndRefreshing];
                    
                });
                

                if ([isSuccess boolValue]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Toast hideToastActivity];
                        requestMoneyListNew= [NSMutableArray arrayWithArray:dict[@"results"]];
                        
                        //全部
                        if (_pageIndex==1) {
                            
                            requestMoneyList = requestMoneyListNew;
                            returnMoneyTableView.dataArray=requestMoneyListNew;
                            xPoint=0;
                            if (returnMoneyTableView.dataArray.count == 0) {
                                [self configPlaceholdView];
                            }else{
                                [self removePlaceholdView];
                            }
                        }
                        else
                        {
                            if ([requestMoneyListNew count]>0) {
                                
                                 [requestMoneyList addObjectsFromArray:requestMoneyListNew];
                            }
                        
                            returnMoneyTableView.dataArray=requestMoneyList;
                        }
//                        [returnMoneyTableView footerEndRefreshing];
                        [returnMoneyTableView reloadData];
                        
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        noCodeImgView.hidden=NO;
                        _pageIndex--;
                        [Toast hideToastActivity];
//                        [returnMoneyTableView footerEndRefreshing];
                    });
                }
                
            } failed:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    noCodeImgView.hidden=NO;
                    _pageIndex--;
                    [Toast hideToastActivity];
                    [returnMoneyTableView footerEndRefreshing];
                });
            }];
            
        }
        else
        {
            
            NSLog(@"wht－－");
            
            NSDictionary *paramDic=@{@"userId":userId,
                                     @"pageSize": @10,
                                     @"pageIndex": @(_goodPageIndex),
                                     @"type":@"2"};
            
            [HttpRequest orderGetRequestPath:nil methodName:@"OrderReturnFilterList" params:paramDic success:^(NSDictionary *dict) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                
                      [returnGoodTableView footerEndRefreshing];
                    
                  });
                                 
                NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
                if([isSuccess boolValue])
                {
                    requestGoodListNew = dict[@"results"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Toast hideToastActivity];
                        if (_goodPageIndex==1) {
                            
                            requestGoodList = requestGoodListNew;
                            returnGoodTableView.dataArray=requestGoodListNew;
                            xPoint=1;
                            if (returnGoodTableView.dataArray.count == 0) {
                                [self configPlaceholdView];
                            }else{
                                [self removePlaceholdView];
                            }
                        }
                        else
                        {
                            if ([requestGoodListNew count]>0) {
                                 [requestGoodList addObjectsFromArray:requestGoodListNew];
                            }
                      
                            returnGoodTableView.dataArray=requestGoodList;
                        }
//                        [returnGoodTableView footerEndRefreshing];
                        [returnGoodTableView reloadData];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _goodPageIndex--;
                        noGoodCodeImgView.hidden=NO;
//                        [returnGoodTableView footerEndRefreshing];
                        [Toast hideToastActivity];
                        
                    });
                    
                }
                
                
            } failed:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _goodPageIndex--;
                    noGoodCodeImgView.hidden=NO;
                    [returnGoodTableView footerEndRefreshing];
                    [Toast hideToastActivity];
                    
                });
                
                
            }];
            
        }
        
    });
}

-(void)clickReturnMoneyBtn:(UIButton *)sender
{
    xPoint=0;
    just=10;
    [headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
    [headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    headBtnV.colloctBtn.selected=YES;
    headBtnV.goodBtn.selected=NO;
    [backScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    if (returnMoneyTableView.dataArray.count == 0) {
        [self configPlaceholdView];
    }else{
        [self removePlaceholdView];
    }
}
-(void)clickGoodBtn:(UIButton *)sender
{
    just=10;
    xPoint=1;
    [headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
    [headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    headBtnV.colloctBtn.selected=NO;
    headBtnV.goodBtn.selected=YES;
    [backScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH,0) animated:YES];
    
    
    if (returnGoodTableView.dataArray.count == 0) {
        [self configPlaceholdView];
    }else{
        [self removePlaceholdView];
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = backScrollView.frame.size.width;
    int page = floor((backScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (just!=10) {
        if (page==0) {

            [headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
            [headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
            xPoint=0;
            
            headBtnV.colloctBtn.selected=YES;
            headBtnV.goodBtn.selected=NO;
             [customClassifyModelV buttonClickedOfIndex:page];
            if (returnMoneyTableView.dataArray.count == 0) {
                [self configPlaceholdView];
            }else{
                [self removePlaceholdView];
            }
            
        }
        else
        {
            xPoint=1;
            [headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
            [headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
            headBtnV.colloctBtn.selected=NO;
            headBtnV.goodBtn.selected=YES;

            [customClassifyModelV buttonClickedOfIndex:page];
            if (returnGoodTableView.dataArray.count == 0) {
                [self configPlaceholdView];
            }else{
                [self removePlaceholdView];
            }
        }
    }
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    just=0;
    
}
- (void)tv_OnLoadNewMessage:(PullDragTableView*)sender eventData:(id)eventData
{

    if (sender ==returnMoneyTableView) {
        _pageIndex=1;
    }
    else
    {
       _goodPageIndex=1;
    }
    [self requestData];
    
}
- (void)tv_OnLoadMoreMessage:(PullDragTableView*)sender eventData:(id)eventData
{
    if (sender ==returnMoneyTableView) {
        
        _pageIndex++;
        
    }
    else
    {
        _goodPageIndex++;
    }
    
    [self requestData];

    
}
-(void)tv_OnLoadMoreMessage:(PullDragTableView*)sender
{
   PullDragTableView *tableView = (PullDragTableView*)sender.superview;
//    if (headBtnV.colloctBtn.selected==YES) {
//         _pageIndex++;
//    }
//    else
//    {
//        _goodPageIndex++;
//    }
//    
//    
//    if( tableView ==returnMoneyTableView)
//    {
//        _pageIndex++;
//    }
//    else
//    {
//        _goodPageIndex++;
//    }
    
    if ( xPoint==0) {
        
        _pageIndex++;
    }
    else
    {
        
        _goodPageIndex++;
    }
    NSLog(@"。。。。。。。——pageindex－－－%ld",(long)_pageIndex);
    NSLog(@"。。。。。。。——pageindex－－－%ld",(long)_goodPageIndex);
    
    [self requestData];
}
-(void)tv_OnDidTrans:(UIButton*)sender RowMessage:(id)message
{
    NSLog(@"trans");
}
//取消
-(void)tv_OnDidCancled:(UIButton*)sender RowMessage:(id)message
{
    NSString *titleString=[NSString stringWithFormat:@"%@",sender.titleLabel.text];
    NSDictionary *showMessage=[NSDictionary dictionaryWithDictionary:message];
#ifdef DEBUG
    NSLog(@"titleString------quxiao----%@",titleString);
    NSLog(@"。。。。。。。。。quxiao。。showm-----%@",showMessage);
#endif
    if ([[showMessage allKeys]containsObject:@"refundProdDtlList"])
    {
        one_reapP_ID = [NSString stringWithFormat:@"%@",showMessage[@"refundProdDtlList"][0][@"refunD_ID"]];
    }
    else
    {
         one_reapP_ID = [NSString stringWithFormat:@"%@",showMessage[@"prodList"][0][@"returN_ID"]];
    }

    
    if ([titleString isEqualToString:@"取消退款"]) {
        isReturnGoods = NO;
        message=@"确定要取消退款吗?";
        
    }else{
        isReturnGoods = YES;
        message=@"确定要取消退货吗?";
    }
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:@"取消", nil];
    showAlert.tag=101;
    [showAlert show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Toast makeToastActivity:@"正在取消,请稍后..." hasMusk:NO];
//    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    if (alertView.tag==101) {
        [Toast hideToastActivity];
        if (buttonIndex==0)
        {
            //退货申请单id 退货申请人用户id
            NSDictionary *param=@{@"ID":one_reapP_ID,@"userid":sns.ldap_uid};
//            NSMutableDictionary *returnDic;
            NSString *returnGood;
            if (isReturnGoods) {
                returnGood=@"OrderReturnCancel";
            }else{
                returnGood=@"RefundAppCancel";
            }
            
            
            [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:returnGood params:param success:^(NSDictionary *dict) {
                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Toast hideToastActivity];
                        [self requestData];
                    });
                }
                else
                {
                    
                    [Utils alertMessage:[NSString stringWithFormat:@"%@",dict[@"message"]]];
                    [Toast hideToastActivity];
                }
            } failed:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Utils alertMessage:[NSString stringWithFormat:@"操作失败"]];
                    [Toast hideToastActivity];
                });
                
            }];
            /*
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([SHOPPING_GUIDE_ITF requestPostUrlName:returnGood param:param responseAll:returnDic responseMsg:returnMessage])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Toast hideToastActivity];
                        [self requestData];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Utils alertMessage:[NSString stringWithFormat:@"%@",returnMessage]];
                        [Toast hideToastActivity];
                    });
                }
            });
            */
        }
        else
        {
            [Toast hideToastActivity];
        }
        
    }
    else{
        
    }
    
}
//申请
-(void)tv_OnDidOrder:(UIButton *)sender RowMessage:(id)message
{
    NSString *titleString=[NSString stringWithFormat:@"%@",sender.titleLabel.text];
    NSDictionary *showMessage=[NSDictionary dictionaryWithDictionary:message];
#ifdef DEBUG
    NSLog(@"titleString----------%@",titleString);
    NSLog(@"。。。。。。。。。。。showm-----%@",showMessage);
#endif
    if ([titleString isEqualToString:@"申请退款"])
    {
        RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
        returnOrder.collocationDic =showMessage;
        returnOrder.isReturn=@"退款";
        returnOrder.titleStr=@"申请退款";
        [self.navigationController pushViewController:returnOrder animated:YES];
    }
    else if([titleString isEqualToString:@"申请退货"])
    {
        RefundApplyViewController *returnOrder=[[RefundApplyViewController alloc]initWithNibName:@"RefundApplyViewController" bundle:nil];
        returnOrder.collocationDic =showMessage;
         returnOrder.isReturn=@"退货";
        returnOrder.titleStr=@"申请退货";
        [self.navigationController pushViewController:returnOrder animated:YES];
    }
    else
    {
        NSString *return_type = [NSString stringWithFormat:@"%@",showMessage[@"orderReturnInfo"][@"returN_TYPE"]];
        
        if ([[Utils getSNSString:return_type] isEqualToString:@"1"]) {
            DetailReturnMoneyViewController *detailReturnVC=[[DetailReturnMoneyViewController alloc]init];
            detailReturnVC.titleStr=@"退款详情";
            detailReturnVC.detailGoodDic =nil;
            detailReturnVC.isReturn=@"退款";
            detailReturnVC.colloctionDic =showMessage;
            [self.navigationController pushViewController:detailReturnVC animated:YES];
        }
        else
        {
            DetailReturnMoneyViewController *detailReturn=[[DetailReturnMoneyViewController alloc]initWithNibName:@"DetailReturnMoneyViewController" bundle:nil];
            detailReturn.titleStr=@"退货详情";
            detailReturn.detailGoodDic =nil;
            detailReturn.isReturn=@"退货";
            detailReturn.colloctionDic = showMessage;
            [self.navigationController pushViewController:detailReturn animated:YES];
            
        }
    }
    
}
- (void)tv_OnDidSelected:(MyOrderTableView*)sender RowMessage:(id)message
{
    
}
- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
