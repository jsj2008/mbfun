//
//  SMBCouponActivityVC.m
//  Wefafa
//
//  Created by Miaoz on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SMBCouponActivityVC.h"
#import "SMBCouponActivityCell.h"
#import "Globle.h"
#import "MyShoppingTrollyGoodsTableViewCell.h"
#import "PlatFormBasicInfo.h"
#import "SUtilityTool.h"
#import "Globle.h"
@interface SMBCouponActivityVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *couponDataArray;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation SMBCouponActivityVC
-(void)initNoDataView
{
    UIView * noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) WithImage:NONE_DATA_ORDER andImgSize:CGSizeMake(39, 50) andTipString:@"您还没有活动优惠哦！" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
    [self.view addSubview:noneDataView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    if (_data == nil) {
        _data = [NSMutableArray new];
    }
    if (_couponDataArray == nil) {
        _couponDataArray = [NSMutableArray new];
    }
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary new];
    }
    // Do any additional setup after loading the view from its nib.
    [self creatTableView];
    [self requestCouponData];
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
    
    
//    // 这里可以试试 UIBarButtonItem的customView来处理2个btn
//    UIButton *rightbtn=[[UIButton alloc]init];
//    rightbtn.backgroundColor=[UIColor clearColor];
//    rightbtn.frame=CGRectMake(0, 0, 75, 44);
//    [rightbtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    rightbtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
//    
//    [rightbtn setTitle:@"不参与" forState:UIControlStateNormal];
//    rightbtn.titleLabel.font=BUTTONMEDIUMFONT;
//    [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightbtn addTarget:self action:@selector(btnEditClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
//    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                           
//                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                           
//                                           target:nil action:nil];
//        
//        negativeSpacer.width = 0;
//        self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
//    }
//    else{
//        
//        self.navigationItem.rightBarButtonItem=backItem;
//        
//    }
    self.title=@"活动";
    //    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleTap:)];
    
    //    [self.navigationItem.titleView setUserInteractionEnabled:YES];
    
    //    [self.navigationItem.titleView addGestureRecognizer:recognizer];
 
}
-(void)onBack:(id)sender{
    [self popAnimated:YES];

}
-(void)btnEditClick:(UIButton *)sender{
    //Mark: 该版本暂时删除
//    if (_didSelectedEnter) {
//        self.didSelectedEnter(nil);
//    }
[self popAnimated:YES];
}

-(void)requestCouponData{
    NSMutableArray *dicarray = [NSMutableArray new];
    for (MyShoppingTrollyGoodsData *data in _data) {
        NSDictionary *newDic=@{@"barcode":data.prodNum,
                               @"num":[NSString stringWithFormat:@"%d",data.number],
                               @"cid":data.collocationid,
                               @"aid":[NSString stringWithFormat:@"%@",data.platFormInfo.promotionId]
                               };
        [dicarray addObject:newDic];
    }

    NSString *platPromid;
    if (_selectPlatFormBasicInfo == nil) {
       platPromid = @"0";
    }else {
     platPromid = _selectPlatFormBasicInfo.code;
    }
//     NSDictionary *paramDic =@{@"useR_ID":sns.ldap_uid,@"prodList":dicarray,@"platPromId":[NSNumber   numberWithInteger:[[Utils getSNSInteger:platPromid] integerValue]]};
    NSDictionary *paramDic =@{@"userId":sns.ldap_uid,@"cartList":dicarray,@"aid":platPromid};
    
 
    [Toast makeToastActivity];
    
    [HttpRequest promotionPostRequestPath:nil methodName:@"getDetailActivity" params:paramDic success: ^(NSDictionary *dict){
         [Toast hideToastActivity];
        if ([dict[@"isSuccess"] integerValue] == 1)
        {
 
             _couponDataArray =   [ActivityOrderModel modelDataWithArray:dict[@"results"]];
            /*
             _dataDic = [[dict objectForKey:@"results"] objectAt:0];

             NSArray *tmpprodDisLst = [[_dataDic objectForKey:@"calcInfo"] objectForKey:@"prodDisLst"];
             NSArray *tmpcollDisLst = [[_dataDic objectForKey:@"calcInfo"] objectForKey:@"collDisLst"] ;
            if ([tmpcollDisLst isKindOfClass:[NSArray class
            {
                 NSMutableArray *voildData = [NSMutableArray new];
                
                for (NSDictionary *dic2 in tmpcollDisLst)
                {
                    PlatFormBasicInfo *platFormBasicInfo = [PlatFormBasicInfo new];
                    platFormBasicInfo = [JsonToModel objectFromDictionary:dic2[@"platFormBasicInfo"] className:@"PlatFormBasicInfo"];
                    NSMutableArray *prodLst = [NSMutableArray new];
                    
                    for (NSDictionary *prodLstDic in dic2[@"collLst"][@"prodLst"]) {
                        ProdInfo *tmpproInfo = [JsonToModel objectFromDictionary:prodLstDic className:@"ProdInfo"];
                        if (tmpproInfo) {
                             [prodLst addObject:tmpproInfo];
                        }
                       
                        
                        
                    }
                    platFormBasicInfo.prodLst = prodLst;
                    
                    NSMutableArray *tmppromPlatComDtlList = [NSMutableArray new];
                    for (NSDictionary *promPlatComDtlDic in dic2[@"platFormBasicInfo"][@"promPlatComDtlFilterList"]) {
                        PromPlatComDtlInfo *tmppromPlatComDtlInfo = [JsonToModel objectFromDictionary:promPlatComDtlDic className:@"PromPlatComDtlInfo"];
                        if (tmppromPlatComDtlInfo) {
                             [tmppromPlatComDtlList addObject:tmppromPlatComDtlInfo];
                        }
                       
                    }
                    
                    platFormBasicInfo.promPlatComDtlFilterList = tmppromPlatComDtlList;
                    if (platFormBasicInfo.isVaild.integerValue == 0) {
                        [voildData addObject:platFormBasicInfo];
                    }else{
                    [_couponDataArray addObject:platFormBasicInfo];
                    }
                }
                [_couponDataArray addObjectsFromArray:voildData];
            }
            
            if ([tmpprodDisLst isKindOfClass:[NSArray class]])
            {
                 NSMutableArray *voildData = [NSMutableArray new];
                for (NSDictionary *dic2 in tmpprodDisLst)
                {
                    PlatFormBasicInfo *platFormBasicInfo = [PlatFormBasicInfo new];
                    platFormBasicInfo = [JsonToModel objectFromDictionary:dic2[@"platFormBasicInfo"] className:@"PlatFormBasicInfo"];
                    NSMutableArray *prodLst = [NSMutableArray new];
                    for (NSDictionary *prodLstDic in dic2[@"prodLst"])
                    {
                        ProdInfo *tmpproInfo = [JsonToModel objectFromDictionary:prodLstDic className:@"ProdInfo"];
                        if (tmpproInfo)
                        {
                            [prodLst addObject:tmpproInfo];
                        }
                        
                      
                    }
                    platFormBasicInfo.prodLst = prodLst;
                    
                     NSMutableArray *tmppromPlatComDtlList = [NSMutableArray new];
                    for (NSDictionary *promPlatComDtlDic in dic2[@"platFormBasicInfo"][@"promPlatComDtlFilterList"])
                    {
                        PromPlatComDtlInfo *tmppromPlatComDtlInfo = [JsonToModel objectFromDictionary:promPlatComDtlDic className:@"PromPlatComDtlInfo"];
                        if (tmppromPlatComDtlInfo)
                        {
                            [tmppromPlatComDtlList addObject:tmppromPlatComDtlInfo];
                        }
                        
                    }
                    
                    platFormBasicInfo.promPlatComDtlFilterList = tmppromPlatComDtlList;
                   
                    if (platFormBasicInfo.isVaild.integerValue == 0)
                    {
                        [voildData addObject:platFormBasicInfo];
                    }else{
                        [_couponDataArray addObject:platFormBasicInfo];
                    }
                    
                }
                
                [_couponDataArray addObjectsFromArray:voildData];
                
            }
                                              */

            [_tableView reloadData];
        }else{
            [self initNoDataView];
        }
        
    }failed:^(NSError *error){
        NSLog(@"促销错误------%@", error);
        
        [self initNoDataView];
        [Toast hideToastActivity];
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
      
    } ];

}
#pragma mark-创建TableView
-(void)creatTableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 64, WINDOWW, WINDOWH -64) style:UITableViewStylePlain];
                [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.dataSource = self;
        _tableView = tableView;
        tableView.delegate = self;
        tableView.hidden = NO;
        //注册
        [self.tableView  registerClass:[SMBCouponActivityCell class] forCellReuseIdentifier:@"SMBCouponActivityCell"];
        
        [self.view addSubview:tableView];
    }
}


#pragma mark - Table view data source
//每个section显示的标题

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 105;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    // Return the number of rows in the section.
   
    return _couponDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SMBCouponActivityCell" owner:nil options:nil];
    SMBCouponActivityCell *cell = [nib objectAtIndex:0];
    ActivityOrderModel *platFormBasicInfo = _couponDataArray[indexPath.row];
//    cell.platFormBasicInfo = platFormBasicInfo;
    cell.activityOrdermodel =platFormBasicInfo;
    
    if (_selectPlatFormBasicInfo != nil) {
        if ([_selectPlatFormBasicInfo.code isEqualToString:platFormBasicInfo.json]) {
            
            cell.selectImgView.image = [UIImage imageNamed:@"Unico/present_uncheck"];
        }else{
          
            cell.selectImgView.image = [UIImage imageNamed:@"Unico/uncheck_zero"];
        }
 

    }else{
        cell.selectImgView.image = [UIImage imageNamed:@"Unico/uncheck_zero"];
    }
    
    
    return cell;
}
#pragma mark - Table view Delegate
/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 GoodCategoryElement * goodCategoryElement = _dataarray[section];
 UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, tableView.bounds.size.height)];
 //    headView.backgroundColor = [UIColor redColor];
 UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, headView.bounds.size.width, headView.bounds.size.height)];
 titleLab.backgroundColor = [UIColor clearColor];
 titleLab.textColor = [UIColor colorWithHexString:@"#353535"];
 titleLab.font = [UIFont systemFontOfSize:13.0f];
 
 titleLab.text = goodCategoryElement.firstCategoryObj.name;
 [headView addSubview:titleLab];
 
 return headView;
 
 }
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ActivityOrderModel *platFormBasicInfo = _couponDataArray[indexPath.row];
    if (platFormBasicInfo.can_use.integerValue == 0) {
       
        [Toast makeToast:@"活动优惠不可用"];
        return;
    }

//    if (_didSelectedEnter) {
//         self.didSelectedEnter(platFormBasicInfo);
//    }
    [self popAnimated:YES];
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
