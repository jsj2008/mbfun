//
//  WaitExtractViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "WaitExtractViewController.h"
#import "WaitExtrantTableViewCell.h"
#import "MBShoppingGuideInterface.h"
#import "Toast.h"
#import "Utils.h"
#import "DetailEarningViewController.h"
#import "NavigationTitleView.h"
#import "NoDataView.h"
#import "HeadBtnView.h"
#import "DatePickerViewController.h"
#import "SettingBalenceViewController.h"
#import "SVPullToRefresh.h"
#import "MJRefresh.h"
@interface WaitExtractViewController ()
{
//    DatePickerViewController *pickDateTimeStart;
//    NSMutableArray *pickerNameArray;
//    UITableView *incomeTableView;//收益
//    UITableView *balanceTableView;//结算
//    BOOL isIncome;
}
@property (nonatomic,assign) int pageIndex;
@property (nonatomic,assign) int pageSize;
@property (nonatomic,assign) int just;
@property (nonatomic,assign) BOOL isFrom;

@property (nonatomic, strong) NSMutableArray *detailResultsArray;
@property (nonatomic, strong) NSMutableArray *setBalanceArray;
@property (nonatomic, strong) NSMutableString *returnMessage;
@property (nonatomic, strong) HeadBtnView *headBtnV;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIImageView *noCodeImgView;
@property (nonatomic, strong) UIImageView *noGoodCodeImgView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSDictionary *incomePostDic;//收益的提交
@property (nonatomic, strong) NSDictionary *balancePostDic;//结算的提交
@end

@implementation WaitExtractViewController
@synthesize sellerId;
@synthesize titleName;
@synthesize isIncome;
@synthesize incomeTableView;
@synthesize balanceTableView;
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
    [self.view setBackgroundColor:[UIColor clearColor]];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAll)];
//    [self.view addGestureRecognizer:tap];
    [self initView];
    self.detailResultsArray = [[NSMutableArray alloc]init];
    self.setBalanceArray = [[NSMutableArray alloc]init];
    self.returnMessage =[[NSMutableString alloc]init];
    self.incomePostDic = [[NSDictionary alloc]init];
    self.balancePostDic = [[NSDictionary alloc]init];
    
    self.pageIndex = 1;
    
//    //    添加下拉刷新
//    [self incomeAddHeader];
//    //    添加上拉加载
    [self balanceAddFooter];

}
/*
- (void)incomeAddHeader
{
    __unsafe_unretained WaitExtractViewController *weakSelf = self;
    [self.incomeTableView addHeaderWithCallback:^{
        NSMutableString *commentMsg = [[NSMutableString alloc]initWithFormat:@""];
        NSMutableArray *commentArray = [[NSMutableArray alloc]initWithCapacity:5];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [SHOPPING_GUIDE_ITF requestGetUrlName:@"CommentFilter" param:@{@"SOURCE_ID":_sourceId,@"SOURCE_TYPE":_sourceType} responseList:commentArray responseMsg:commentMsg];
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.incomeTableView headerEndRefreshing];
                    [Toast makeToast:message duration:1.0 position:@"center"];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast makeToast:@"加载失败！" duration:1.0 position:@"center"];
                    [weakSelf.tableView headerEndRefreshing];
                });
            }
        });
    }];

}
- (void)balanceAddFooter
{
    
}
-(void)incomeRequestData
{
    
}
-(void)balanceRequestData
{
    
}
*/
- (void)balanceAddFooter
{
    self.incomeTableView.userInteractionEnabled = NO;
    self.balanceTableView.userInteractionEnabled = NO;
    [self addIncomeFooter];
    [self addBalanceFooter];
}

 -(void)addBalanceFooter{
    __unsafe_unretained WaitExtractViewController *weakSelf = self;
    [self.balanceTableView addFooterWithCallback:^{
        NSString *fromStr = [NSString stringWithFormat:@"%@", weakSelf.fromLabel.text];
        NSString *toStr = [NSString stringWithFormat:@"%@", weakSelf.toLabel.text];
        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        NSMutableString *msg = [[NSMutableString alloc] initWithCapacity:10];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
            NSString *urlStr=nil;
            NSDictionary *postDic;
            weakSelf.pageIndex++;
            postDic=@{@"userId":userId,
                      @"SETTLE_TIME_Start":fromStr,
                      @"SETTLE_TIME_END":toStr,
                      @"pageIndex":@(weakSelf.pageIndex),
                      @"pageSize":@(15)};
            urlStr=@"WxSettleBalanceFlowFilter";
    
            NSMutableArray *responseArray = [NSMutableArray array];
            BOOL success =  [SHOPPING_GUIDE_ITF requestGetUrlName:urlStr param:postDic responseList:responseArray responseMsg:msg];
            NSLog(@".......%@",weakSelf.setBalanceArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.balanceTableView footerEndRefreshing];
            });
            if (success)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (responseArray.count == 0) {
                        // 不显示，太难看
//                        [Toast makeToast:@"没有更多数据！" duration:2.0 position:@"center"];
                    }
                    for (int i = 0; i < responseArray.count; i++) {
                        NSDictionary *dict = responseArray[i];
                        if (!(BOOL)dict[@"flag"]) {
                            [weakSelf.setBalanceArray addObject:dict];
                        }else{
                            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[weakSelf.setBalanceArray lastObject]];
                            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"detaiL_LIST"]];
                            [array addObjectsFromArray:dict[@"detaiL_LIST"]];
                            dictionary[@"detaiL_LIST"] = array;
                            [weakSelf.setBalanceArray removeLastObject];
                            [weakSelf.setBalanceArray addObject:dictionary];
                        }
                    }
                    [Toast hideToastActivity];
                    [weakSelf.incomeTableView reloadData];
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Utils alertMessage:msg];
                });
            }
        });
    }];
}

-(void)addIncomeFooter{
    __unsafe_unretained WaitExtractViewController *weakSelf = self;
    [self.incomeTableView addFooterWithCallback:^{
        NSString *fromStr = [NSString stringWithFormat:@"%@", weakSelf.fromLabel.text];
        NSString *toStr = [NSString stringWithFormat:@"%@", weakSelf.toLabel.text];
        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        NSMutableString *msg = [[NSMutableString alloc] initWithCapacity:10];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
            NSString *urlStr=nil;
            NSDictionary *postDic;
            weakSelf.pageIndex++;
            urlStr=@"WxBalanceFlowFilter";// 收益流水
            postDic=@{@"userId":userId,
                      @"balance_TIME_Start":fromStr,
                      @"balance_TIME_End":toStr,
                      @"pageIndex":@(weakSelf.pageIndex),                            // pangeIndex 从1开始  第二页的数据中包含 第一页数据
                      @"pageSize":@(15)};
            
            NSMutableArray *responseArray = [NSMutableArray array];
            BOOL success =  [SHOPPING_GUIDE_ITF requestGetUrlName:urlStr param:postDic responseList:responseArray responseMsg:msg];
            NSLog(@".......%@",weakSelf.detailResultsArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.incomeTableView footerEndRefreshing];
            });
            if (success)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (responseArray.count == 0) {
                        // 不显示，太难看
//                        [Toast makeToast:@"没有更多数据！" duration:2.0 position:@"center"];
                    }
                    for (int i = 0; i < responseArray.count; i++) {
                        NSDictionary *dict = responseArray[i];
                        if (!(BOOL)dict[@"flag"]) {
                            [weakSelf.detailResultsArray addObject:dict];
                        }else{
                            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[weakSelf.detailResultsArray lastObject]];
                            NSMutableArray *array = [NSMutableArray arrayWithArray:dictionary[@"detaiL_LIST"]];
                            [array addObjectsFromArray:dict[@"detaiL_LIST"]];
                            dictionary[@"detaiL_LIST"] = array;
                            [weakSelf.detailResultsArray removeLastObject];
                            [weakSelf.detailResultsArray addObject:dictionary];
                        }
                    }
                    [Toast hideToastActivity];
                    [weakSelf.incomeTableView reloadData];
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Utils alertMessage:msg];
                });
            }
        });
    }];
}


-(void)dismissAll
{
    [self cacleBtn];
}
-(void)initView
{
    _navView.backgroundColor=TITLE_BG;
    [self setupNavbar];
    /*
    CGRect headrect=CGRectMake(0,0,_navView.frame.size.width,_navView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=self.titleName;
    [view.btnOk setTitle:@"规则" forState:UIControlStateNormal];
    [self.navView addSubview:view];
   
     self.headBtnV=[[HeadBtnView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-85, 0, 85*2,  view.frame.size.height)];
     [self.headBtnV.colloctBtn setTitle:@"收益流水" forState:UIControlStateNormal];
     [self.headBtnV.colloctBtn addTarget:self
     action:@selector(clickColloctBtn:)
     forControlEvents:UIControlEventTouchUpInside];
      [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
    
     [self.headBtnV.goodBtn setTitle:@"结算流水" forState:UIControlStateNormal];
     [self.headBtnV.goodBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
     [self.headBtnV.colloctBtn setTitleColor:[Utils HexColor:0X333333 Alpha:1] forState:UIControlStateNormal];
     [self.headBtnV.goodBtn addTarget:self
     action:@selector(clickGoodBtn:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
     [view addSubview:self.headBtnV];
    
    */
    _searchBtn.layer.masksToBounds=YES;
    _searchBtn.layer.cornerRadius=4;
    [_searchBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-_searchBtn.frame.size.width-5, _searchBtn.frame.origin.y, _searchBtn.frame.size.width, _searchBtn.frame.size.height)];
    

    UITapGestureRecognizer *fromSelectGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fromTapGes:)];
    [_fromCalendar addGestureRecognizer:fromSelectGes];
    UITapGestureRecognizer *toSelectGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toTapGes:)];
    [_toCalendar addGestureRecognizer:toSelectGes];

    _fromCalendar.layer.borderColor =[[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]CGColor];
    _fromCalendar.layer.borderWidth = 0.5;
    _toCalendar.layer.borderColor =[[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]CGColor];
    _toCalendar.layer.borderWidth = 0.5;

    [self initBackGroundView];
    [self initDataPickerView];
}
-(void)setupNavbar
{
    [super setupNavbar];
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
    /*
    self.headBtnV=[[HeadBtnView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-70-50, -10, 70*2, tempView.frame.size.height)];
    
    [self.headBtnV.colloctBtn setTitle:@"退款" forState:UIControlStateNormal];
    [self.headBtnV.colloctBtn addTarget:self
                            action:@selector(clickReturnMoneyBtn:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.headBtnV.goodBtn setTitle:@"退货" forState:UIControlStateNormal];
    [self.headBtnV.goodBtn addTarget:self
                         action:@selector(clickGoodBtn:)
               forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:self.headBtnV];
    [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
    [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    
    [self.headBtnV.colloctBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
    [self.headBtnV.goodBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
     */
    self.headBtnV=[[HeadBtnView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-70-50, -10, 70*2, tempView.frame.size.height)];

    [self.headBtnV.colloctBtn setTitle:@"收益流水" forState:UIControlStateNormal];
    [self.headBtnV.colloctBtn addTarget:self
                                 action:@selector(clickColloctBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
    
    [self.headBtnV.goodBtn setTitle:@"结算流水" forState:UIControlStateNormal];
    [self.headBtnV.goodBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1] forState:UIControlStateNormal];
    [self.headBtnV.colloctBtn setTitleColor:[Utils HexColor:0X333333 Alpha:1] forState:UIControlStateNormal];
    [self.headBtnV.goodBtn addTarget:self
                              action:@selector(clickGoodBtn:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    [tempView addSubview:self.headBtnV];
    self.navigationItem.titleView = tempView;
}
-(void)ruleClick:(id)sender
{
    
}
- (void)initBackGroundView
{
    [_selectCalendarView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, _selectCalendarView.frame.size.height)];
    [_selectCalendarView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    
    [self.view addSubview:_selectCalendarView];
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _navView.frame.size.height+_selectCalendarView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-_navView.frame.size.height-_selectCalendarView.frame.size.height)];
    self.backScrollView.delegate=self;
    self.backScrollView.pagingEnabled=YES;
    self.backScrollView.bounces=NO;
    [self.backScrollView setBackgroundColor:[UIColor clearColor]];
    
    
    incomeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-_navView.frame.size.height-_selectCalendarView.frame.size.height) style:UITableViewStyleGrouped];
    incomeTableView.delegate=self;
    incomeTableView.dataSource=self;
    incomeTableView.backgroundColor=[UIColor whiteColor];
    [self.backScrollView addSubview:incomeTableView];
    balanceTableView=[[UITableView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH,0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-_navView.frame.size.height-_selectCalendarView.frame.size.height) style:UITableViewStyleGrouped];
    balanceTableView.delegate=self;
    balanceTableView.dataSource=self;
    [balanceTableView setBackgroundColor:[UIColor whiteColor]];
    [self.backScrollView addSubview:balanceTableView];
    
    self.backScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*2, UI_SCREEN_HEIGHT-_navView.frame.size.height-_selectCalendarView.frame.size.height);//

    [self.view addSubview:self.backScrollView];
    if ([self.titleName isEqualToString:@"收益流水"]) {
        [self clickColloctBtn:nil];
    }
    else
    {
        [self clickGoodBtn:nil];
        
    }
}
-(void)initDataPickerView
{
    self.toolView=[[UIView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-162-44, UI_SCREEN_WIDTH, 44)];
    [self.toolView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    self.toolView.hidden=YES;
    [self.view addSubview:self.toolView];
    
    UIButton *doneBar =[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBar setFrame:CGRectMake(self.toolView.frame.size.width-80, 0, 80, 44)];
    [doneBar setTitle:@"确定" forState:UIControlStateNormal];
    [doneBar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBar addTarget:self
                action:@selector(doneBtn)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cacleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cacleBtn setFrame:CGRectMake(0, 0, 50, 44)];
    [cacleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cacleBtn addTarget:self
                 action:@selector(cacleBtn)
       forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:doneBar];
    [self.toolView addSubview:cacleBtn];
    
    self.datePicker=[[UIDatePicker alloc] init];
    self.datePicker.frame=CGRectMake(0, UI_SCREEN_HEIGHT-162, UI_SCREEN_WIDTH, 162);
    [self.datePicker setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0  blue:244.0/255.0 alpha:1]];
    
    NSLocale  *locale =[[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [self.datePicker setLocale:locale];

    self.datePicker.hidden=YES;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    self.datePicker.datePickerMode=UIDatePickerModeDate;//选择器模式
    [self.view addSubview:self.datePicker];//将日期选择器添加到视图
}
-(void)doneBtn
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr=[NSString stringWithFormat:@"%@",self.datePicker.date];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    NSString *dateString = [NSString stringWithFormat:@"%@",dateArray[0]];
    
     if(self.isFrom)
     {
         _fromLabel.text=dateString;
     }
    else
    {
        _toLabel.text=dateString;
    }
    self.toolView.hidden=YES;
    self.datePicker.hidden=YES;
}
-(void)cacleBtn
{
    self.datePicker.hidden=YES;
    self.toolView.hidden=YES;
}
-(void)dateChanged:(id)sender{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *dateString=[formatter stringFromDate:datePicker.date];//获取时间选择器的时间
    NSString *dateStr=[NSString stringWithFormat:@"%@",self.datePicker.date];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    NSString *dateString = [NSString stringWithFormat:@"%@",dateArray[0]];

    if(self.isFrom)
    {
       _fromLabel.text=dateString;
    }
    else
    {
       _toLabel.text=dateString;
    }
}
-(void)fromTapGes:(UITapGestureRecognizer *)tap
{
    self.isFrom=YES;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString=[formatter stringFromDate:self.datePicker.date];//获取时间
    _fromLabel.text=dateString;
    
    self.toolView.hidden=NO;
    self.datePicker.hidden=NO;
}
-(void)toTapGes:(UITapGestureRecognizer *)tap
{
    self.isFrom=NO;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString=[formatter stringFromDate:self.datePicker.date];//获取时间
    _toLabel.text=dateString;
    
    self.toolView.hidden=NO;
    self.datePicker.hidden=NO;
}
- (IBAction)searchClick:(id)sender
{
  
    self.toolView.hidden=YES;
    self.datePicker.hidden=YES;
    NSString *fromStr = [NSString stringWithFormat:@"%@",_fromLabel.text];
    NSString *toStr = [NSString stringWithFormat:@"%@",_toLabel.text];
    if(fromStr.length==0||toStr.length==0)
    {
        [Utils alertMessage:@"请选择起始时间"];
    }
    else
    {
        [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
        NSMutableString *msg = [[NSMutableString alloc] initWithCapacity:10];
        __unsafe_unretained typeof(self) p = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
            NSString *urlStr=nil;
            NSDictionary *postDic;

            if (isIncome==YES) {
                self.incomeTableView.userInteractionEnabled = YES;
                  self.pageIndex=1;
                urlStr=@"WxBalanceFlowFilter";// 收益流水
                postDic=@{@"userId":userId,
                          @"balance_TIME_Start":fromStr,
                          @"balance_TIME_End":toStr,
                          @"pageIndex":@(self.pageIndex),                            // pangeIndex 从1开始  第二页的数据中包含 第一页数据
                          @"pageSize":@(15)};
                
                p.incomePostDic = postDic;
                
                [p.detailResultsArray removeAllObjects];
               BOOL success =  [SHOPPING_GUIDE_ITF requestGetUrlName:urlStr param:postDic responseList:p.detailResultsArray responseMsg:msg];
                NSLog(@".......%@",p.detailResultsArray);
                
                if (success)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [incomeTableView reloadData];
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Utils alertMessage:msg];
                    });
                }

            }else
            {
                self.balanceTableView.userInteractionEnabled = YES;
                postDic=@{@"userId":userId,
                          @"SETTLE_TIME_Start":fromStr,
                          @"SETTLE_TIME_END":toStr,
                          @"pageIndex":@(self.pageIndex),                            // pangeIndex 从1开始  第二页的数据中包含 第一页数据
                          @"pageSize":@(15)};
                urlStr=@"WxSettleBalanceFlowFilter"; //结算流水
                p.balancePostDic = postDic;
                [p.setBalanceArray removeAllObjects];
                 BOOL success =  [SHOPPING_GUIDE_ITF requestGetUrlName:urlStr param:postDic responseList:p.setBalanceArray responseMsg:msg];
                if (success)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                
                        [balanceTableView reloadData];
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Utils alertMessage:msg];
                    });
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast hideToastActivity];
            });
        });
  
    }
}
-(void)clickColloctBtn:(UIButton *)sender
{
    isIncome=YES;
    self.just=10;
    [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
//    [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xE52027 Alpha:1]];
    [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    self.headBtnV.colloctBtn.selected=YES;
    self.headBtnV.goodBtn.selected=NO;
    [self.backScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
    [incomeTableView reloadData];
}
-(void)clickGoodBtn:(UIButton *)sender
{
    isIncome=NO;
    self.just=10;
    self.headBtnV.colloctBtn.selected=NO;
    self.headBtnV.goodBtn.selected=YES;
    [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
//    [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xE52027 Alpha:1]];
    [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    [self.backScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH,0) animated:YES];
    [balanceTableView reloadData];
    
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.backScrollView.frame.size.width;
    int page = floor((self.backScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.just!=10) {
        if (page==0) {
            isIncome=YES;
  
            [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
            //    [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xE52027 Alpha:1]];
            [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
            self.headBtnV.colloctBtn.selected=YES;
            self.headBtnV.goodBtn.selected=NO;
            [incomeTableView reloadData];
        }
        else
        {
            isIncome=NO;
            self.headBtnV.colloctBtn.selected=NO;
            self.headBtnV.goodBtn.selected=YES;
            [self.headBtnV.goodBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1]];
            //    [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xE52027 Alpha:1]];
            [self.headBtnV.colloctBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
            
            [balanceTableView reloadData];
            
        }
    }
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.just=0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 20;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 35)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    
    NSString *timeStr=nil;
    NSString *totoalAmount = nil;
    NSString *title=nil;
    float totalA;
    if(isIncome==YES)
    {
        title=@"月收益:";
        timeStr=[NSString stringWithFormat:@"%@",self.detailResultsArray[section][@"balancE_TIME"]];
        totoalAmount = [NSString stringWithFormat:@"%@",self.detailResultsArray[section][@"totaL_AMOUNT"]];
        totalA = [totoalAmount floatValue];
        
    }
    else
    {
        title=@"月结算:";
        
        timeStr=[NSString stringWithFormat:@"%@",self.setBalanceArray[section][@"yearMonth"]];
        totoalAmount = [NSString stringWithFormat:@"%@",self.setBalanceArray[section][@"amount"]];
        totalA =[totoalAmount floatValue];
        
    }
    UILabel *timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(15,0, 50, 36)];
    timeLabel.text=timeStr;
    timeLabel.textColor=[Utils HexColor:0x353535 Alpha:1];
    timeLabel.font=[UIFont systemFontOfSize:13.0f];
    timeLabel.backgroundColor=[UIColor clearColor];
    [sectionView addSubview:timeLabel];
    UILabel *accountNum=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-10-50, 0, 50, 35)];
    accountNum.textAlignment=NSTextAlignmentRight;
    accountNum.textColor=[Utils HexColor:0xf46c56 Alpha:1];
    accountNum.font=[UIFont systemFontOfSize:12.0f];
    accountNum.text=[NSString stringWithFormat:@"%.2f",totalA];
    CGSize maxs=CGSizeMake(320, accountNum.frame.size.height);
    CGSize textSizes=[accountNum.text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:maxs lineBreakMode:NSLineBreakByCharWrapping];
    [accountNum setFrame:CGRectMake(UI_SCREEN_WIDTH-10-textSizes.width, 0, textSizes.width, 35)];
    
    UILabel *showTextM =[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-50-textSizes.width-10,0, 50, 35)];
    showTextM.text=title;
    showTextM.font=[UIFont systemFontOfSize:13.0f];
    showTextM.textColor=[Utils HexColor:0x353535 Alpha:1];
    showTextM.backgroundColor=[UIColor clearColor];
    [sectionView addSubview:showTextM];
    [sectionView addSubview:accountNum];
    UIImageView *lineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 34.5, UI_SCREEN_WIDTH, 0.5)];
    [lineImgView setBackgroundColor:[UIColor blackColor]];
//    [sectionView addSubview:lineImgView];
    

    return sectionView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
    [sectionView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    return sectionView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 64;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isIncome==YES)
    {
        return  [self.detailResultsArray count];
    }
    else
    {
        return [self.setBalanceArray count];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isIncome) {
       return [self.detailResultsArray[section][@"detaiL_LIST"] count];
    }
    else
    {
        return [self.setBalanceArray[section][@"detaiL_LIST"] count];
    }
  
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WaitExtrantTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[WaitExtrantTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor whiteColor];
    
    if (isIncome==YES) {
     
        NSArray *detailList=[NSArray arrayWithArray:self.detailResultsArray[indexPath.section][@"detaiL_LIST"]];
        NSString *cardNumberLabeLStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"recordinfo"][@"proD_NAME"]];
        NSString *buyerNameStr= [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"recordinfo"][@"nickname"]];
        NSString *statesStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"srC_DOC_TYPE_NAME"]];
        NSString *depDateStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"balancE_TIME"]];
        NSString *amountStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"amount"]];
        float amount = [amountStr floatValue];
        if ([statesStr isEqualToString:@"退款"])
        {
            cell.priceLabel.text=[NSString stringWithFormat:@"%@:-￥%.2f",statesStr,amount];
        }
        else
        {
            
            cell.priceLabel.text=[NSString stringWithFormat:@"%@:￥%.2f",statesStr,amount];
        }
//        cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",amount];
        cell.cardNumberLabel.text=[Utils getSNSString:cardNumberLabeLStr];
//        cell.statesLabel.text=[NSString stringWithFormat:@"%@",[self justNilString:statesStr]];
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",depDateStr];
//        cell.buyLabel.text=@"买家:";
        cell.buyNameLabel.text=[NSString stringWithFormat:@"买家:%@",[Utils getSNSString:buyerNameStr]];

    }
    else
    {
        NSArray*detailList=[NSArray arrayWithArray:self.setBalanceArray[indexPath.section][@"detaiL_LIST"]];
        NSString *idStr =[NSString stringWithFormat:@"%@",detailList[indexPath.row][@"srC_DOC_CODE"]];
        NSString *cardNumberLabeLStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"carD_NO"]];
        NSString *statesStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"paY_DESC"]];//分号后
        statesStr = [self getDescStringWithStr:statesStr];
        NSString *depDateStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"balancE_TIME"]];
        depDateStr = [self getdate:depDateStr];
        NSString *amountStr = [NSString stringWithFormat:@"%@",detailList[indexPath.row][@"amount"]];
        
        float amount = [amountStr floatValue];
        cell.cardNumberLabel.text=[Utils getSNSString:cardNumberLabeLStr];
//        cell.buyLabel.text=@"提取编号:";
        cell.buyNameLabel.text=[NSString stringWithFormat:@"提取编号:%@",[Utils getSNSString:idStr]];
        cell.priceLabel.text=[NSString stringWithFormat:@"%@:￥%.2f",[Utils getSNSString:statesStr],amount];
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",depDateStr];
        cell.statesLabel.text=[NSString stringWithFormat:@"%@",[Utils getSNSString:statesStr]];
        //提取编号 、、settlE_AMOUNT 金额 balancE_TIME
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isIncome==YES)
    {
        if ([self.detailResultsArray count]>indexPath.section) {
            if ([self.detailResultsArray[indexPath.section][@"detaiL_LIST"] count]>indexPath.row) {
                
                NSDictionary *clickDic=[NSDictionary dictionaryWithDictionary:self.detailResultsArray[indexPath.section][@"detaiL_LIST"][indexPath.row]];
                DetailEarningViewController *detailDic=[[DetailEarningViewController alloc]init];
                detailDic.paramDic = clickDic ;
                [self.navigationController pushViewController:detailDic animated:YES];
                
            }
        }

    }
    else
    {
        if ([self.setBalanceArray count]>indexPath.section) {
           
            if ([self.setBalanceArray[indexPath.section][@"detaiL_LIST"] count]>indexPath.row)
            {
                NSDictionary *clickDic=[NSDictionary dictionaryWithDictionary:self.setBalanceArray[indexPath.section][@"detaiL_LIST"][indexPath.row]];
                SettingBalenceViewController *setBalenceVC=[[SettingBalenceViewController alloc]initWithNibName:@"SettingBalenceViewController" bundle:nil];
                setBalenceVC.balenceDic=clickDic;
                [self.navigationController pushViewController:setBalenceVC animated:YES];
            }
    
        }
    }

}
//处理传递的空数据
-(NSString *)justNilString:(NSString*)str
{
    NSString *lastStr =[NSString stringWithFormat:@"%@",str];
    if ([str isEqualToString:@"<null>"]||str==nil||[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]||[str isEqualToString:@"(null)"])
    {
        lastStr= [NSString stringWithFormat:@""];
        
    }
    return lastStr;
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
        
        s=[arr firstObject];
        arr=[s componentsSeparatedByString:@"-"];
        s=[arr firstObject];
       date =[NSDate dateWithTimeIntervalSince1970:[s longLongValue]/1000];
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateString=[NSString stringWithFormat:@"%@",[format stringFromDate:date]];
        
    }
    return dateString;
}
-(NSString *)getDescStringWithStr:(NSString *)payDesc
{
    
    NSString *descString=nil;
    if (payDesc.length>1)
    {
//        NSString *compareOne=@";";
//        NSString *compareTwo=@"；";
        NSArray *arrCompare=[NSArray new];
//        NSRange rang=[compareOne rangeOfString:payDesc];
       
//        if (rang.location!=NSNotFound)
//        {
//            arrCompare=[payDesc componentsSeparatedByString:compareOne];
//        }
//        else
//        {
//            arrCompare=[payDesc componentsSeparatedByString:compareTwo];
//        }
        arrCompare=[payDesc componentsSeparatedByString:@";"];
        descString = [NSString stringWithFormat:@"%@",[arrCompare lastObject]];
        
    }

    return descString;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)backHome:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
