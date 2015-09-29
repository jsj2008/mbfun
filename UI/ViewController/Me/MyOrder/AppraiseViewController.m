//
//  AppraiseViewController.m
//  Wefafa
//
//  Created by fafatime on 14-12-17.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "AppraiseViewController.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "Toast.h"
#import "MyOrderViewTableViewCell.h"
#import "CommMBBusiness.h"
#import "AppSetting.h"
#import "OrderBtn.h"
#import "ModelBase.h"
#import "OrderModel.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "SDataCache.h"

@interface AppraiseViewController ()
{
    NSString *starLevel;
    UIView *tablefootView;
    UIView *sectionView;
    UITableView *listTableView;
    NSMutableDictionary *textDic;
    NSString *writeStr;
    NSDictionary *detailOrderDic;
    NSArray *resultsOrderArray;
    
    NSMutableDictionary *commonDict;
    NSMutableArray *changeNewOrderArray;//整理后的新数组

}
@end

@implementation AppraiseViewController
@synthesize prodectid;
@synthesize orderArray;
@synthesize message;
@synthesize messageOrderModel;

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
    self.title=@"评价订单";
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;

    
}
- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSMutableArray *onlyOneNumArray = [NSMutableArray new];
//    NSMutableArray *changeNewOrderArray = [NSMutableArray new];

    for(int a=0; a<[self.orderArray count];a++)
    {
        
        OrderModelDetailListInfo *detailListInfoData = self.orderArray[a];
        NSString *prod_num = [NSString stringWithFormat:@"%@",detailListInfoData.proudctList.productInfo.proD_NUM];//款id 相同款的id合并
        if ([onlyOneNumArray containsObject:prod_num]) {
            
            for (OrderModelDetailListInfo *model in changeNewOrderArray) {
                NSString *modelProductNum = [NSString stringWithFormat:@"%@",model.proudctList.productInfo.proD_NUM];//款id 相同款的id合并
                int num=[detailListInfoData.detailInfo.qty intValue];
                int detailInfoQty= [model.detailInfo.qty intValue];
                
                if ([modelProductNum isEqualToString:prod_num]) {
                    if (detailInfoQty>num) {
                        model.detailInfo.qty  = [NSString stringWithFormat:@"%d",detailInfoQty - num];
                    }
                
                    
                }
            }
        }else
        {
            
            [onlyOneNumArray addObject:prod_num];
//            [changeNewOrderArray addObject:detailListInfoData];
            
        }
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
    [_AppriseBtn setBackgroundColor:[Utils HexColor:0Xffde00 Alpha:1]];
    _AppriseBtn.layer.masksToBounds=YES;
    _AppriseBtn.layer.cornerRadius = 3;
    changeNewOrderArray = [NSMutableArray new];
    [self setupNavbar];
    
    NSMutableString *returnMsg=[NSMutableString new];
    NSString *judge_staus = [NSString stringWithFormat:@"%@",self.messageOrderModel.judgeStatus];
    if ([judge_staus isEqualToString:@"3"]) { //1 未评 价 2 部分 3 已
         _AppriseBtn.hidden=YES;
        _AppriseBtn.userInteractionEnabled=NO;
        [_AppriseBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1]];
    }
    else
    {
        _AppriseBtn.hidden=NO;
        _AppriseBtn.userInteractionEnabled=YES;
        [_AppriseBtn setBackgroundColor:[UIColor blackColor]];
    }
    
    resultsOrderArray = [NSArray new];//请求下来的评论信息 // 评论里面如果state=1才能评价。申请退货、申请退款等一系列都不能评论，直接禁掉操作, 进行申请退款或退货后不能进行评价操作.
    detailOrderDic = [NSMutableDictionary new];
    NSMutableDictionary *responseAllDic=[NSMutableDictionary new];
    NSString *idStr = [NSString stringWithFormat:@"%@",self.messageOrderModel.idStr];
    
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [HttpRequest orderGetRequestPath:nil methodName:@"CommentListFilter" params:@{@"userId":sns.ldap_uid,@"orderId":idStr} success:^(NSDictionary *dict) {
//            NSLog(@"dic－－－－%@",dict);
//            if ([[dict allKeys]containsObject:@"isSuccess"]) {
//                resultsOrderArray = [NSArray arrayWithArray:dict[@"results"]];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [Toast hideToastActivity];
//                });
//            }
//         else{
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 
//                 [Toast hideToastActivity];
//             });
//         }
//        }
//        failed:^(NSError *error) {
//            
//        }];
//        
        if([SHOPPING_GUIDE_ITF requestGetUrlName:@"CommentListFilter" param:@{@"userId":sns.ldap_uid,@"orderId":idStr} responseAll:responseAllDic responseMsg:returnMsg])
        {//self.message[@"id"]
#ifdef DEBUG
            NSLog(@"...........%@",responseAllDic);
#endif
            if ([[responseAllDic allKeys]containsObject:@"isSuccess"]) {
                resultsOrderArray = [NSArray arrayWithArray:responseAllDic[@"results"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Toast hideToastActivity];
                });
            }
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Toast hideToastActivity];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            
            NSMutableArray *showOne=[NSMutableArray new];
            NSMutableArray *onlyOneNumArray = [NSMutableArray new];
      

            for(int a=0; a<[self.orderArray count];a++)
            {
                
                OrderModelDetailListInfo *detailListInfoData = self.orderArray[a];
                NSString *prod_num = [NSString stringWithFormat:@"%@",detailListInfoData.proudctList.productInfo.proD_NUM];//款id 相同款的id合并
                if ([onlyOneNumArray containsObject:prod_num]) {

                    for (OrderModelDetailListInfo *model in changeNewOrderArray) {
                         NSString *modelProductNum = [NSString stringWithFormat:@"%@",model.proudctList.productInfo.proD_NUM];//款id 相同款的id合并
                        int num=[detailListInfoData.detailInfo.qty intValue];
                        int detailInfoQty= [model.detailInfo.qty intValue];
                        if ([modelProductNum isEqualToString:prod_num]) {
                            
                            model.detailInfo.qty  = [NSString stringWithFormat:@"%d",detailInfoQty + num];
                            
                        }
                    }
                }else
                {
                    
                    [onlyOneNumArray addObject:prod_num];
                    [changeNewOrderArray addObject:detailListInfoData];
                    
                }
            }

            //具体单品
            for (int a=0; a<[changeNewOrderArray count]; a++)
            {
                OrderModelDetailListInfo *detailListInfoData = changeNewOrderArray[a];
//                NSString *judge_staus = [NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.judgE_STATUS];
                NSString *textStr = @"";
                NSString *level=@"5";
                BOOL isAlreadyApprise=NO;
                NSString *orderDetailId=[NSString stringWithFormat:@"%@",detailListInfoData.detailInfo.idStr];//订单明细id
                NSString *sourceID= [NSString stringWithFormat:@"%@",detailListInfoData.proudctList.productInfo.proD_NUM];//11位
//                if ([judge_staus isEqualToString:@"2"]) {//已评价
                //兼容judge_staus不更新
                    for (int m=0; m<[resultsOrderArray count]; m++) {
                        NSString *order_detail_id=[NSString stringWithFormat:@"%@",resultsOrderArray[m][@"temp_id"]];
                        NSLog(@"order——detail——id－－%@－%@",order_detail_id,sourceID);
                        BOOL isRedo = NO;
                        if ([order_detail_id isEqualToString:sourceID])
                        {
                            
                            for(NSDictionary *dict in showOne){
                                if ([[dict objectForKey:@"orderDetailId"] isEqualToString:orderDetailId]) {
                                    isRedo = YES;
                                    break;
                                }
                            }
                            if (!isRedo) {
                                textStr= [NSString stringWithFormat:@"%@",resultsOrderArray[m][@"info"]];
                                level = [NSString stringWithFormat:@"%@",resultsOrderArray[m][@"score"]];
                                if(textStr.length!=0&&level.length!=0)
                                {
                                    isAlreadyApprise=YES;
                                }
                                else
                                {
                                   isAlreadyApprise=NO;
                                }
                                if(level.length==0)
                                {
                                    level=@"5";
                                }
                                NSDictionary *oneDic =@{@"text": textStr,@"level":level,@"orderDetailId":orderDetailId,@"sourceID":sourceID,@"judge_staus":@"2",@"isAlreadyApprise":@(isAlreadyApprise)};
                                [showOne addObject:oneDic];
                                NSLog(@"showeone-----%@",showOne);
                                
                            }
                       
                        }
                        
                    }
                
                
                if ([resultsOrderArray count]==0) {
                    NSDictionary *oneDic =@{@"text": textStr,@"level":level,@"orderDetailId":orderDetailId,@"sourceID":sourceID,@"judge_staus":@"1"};
                    [showOne addObject:oneDic];

                }
                
//                }
//                else//未评价
//                {
//                    NSDictionary *oneDic =@{@"text": textStr,@"level":level,@"orderDetailId":orderDetailId,@"sourceID":sourceID,@"judge_staus":@"1"};
//                    [showOne addObject:oneDic];
//                }
                
            }
            /*9.08 暂时屏蔽
            //总体评价
            NSString *alltext =@"";
            NSString *allLevel =@"5";
            NSMutableArray *showAll=[NSMutableArray new];//总体评价
            if ([judge_staus isEqualToString:@"1"]) {//如果是未评价
                NSDictionary *allDic =@{@"text":alltext,@"level":allLevel,@"SOURCE_ID":idStr,@"judge_staus":@"1"};
                [showAll addObject:allDic];
            }
            else  if (judge_staus.length==0)
            {
                NSDictionary *allDic =@{@"text":alltext,@"level":allLevel,@"SOURCE_ID":idStr,@"judge_staus":@"1"};
                [showAll addObject:allDic];
            }
            else
            {
                BOOL hasReturn=NO;
                NSInteger judgeNum=[resultsOrderArray count]-1;
                for (int a=0; a<[resultsOrderArray count]; a++) {
                    NSString *source_ID=[NSString stringWithFormat:@"%@",resultsOrderArray[a][@"sourcE_ID"]];
                    if ([source_ID isEqualToString:idStr])
                    {
                        hasReturn=YES;
                        alltext= [NSString stringWithFormat:@"%@",resultsOrderArray[a][@"content"]];
                        allLevel= [NSString stringWithFormat:@"%@",resultsOrderArray[a][@"satisfactioN_INDEX"]];
                        if (allLevel.length==0) {
                            allLevel=@"5";
                        }
                        NSDictionary *allDic =@{@"text":alltext,@"level":allLevel,@"SOURCE_ID":idStr,@"judge_staus":@"2"};
                        [showAll addObject:allDic];
                    }
                    else if ( a==judgeNum && (!hasReturn))
                    {
                        NSDictionary *allDic =@{@"text":alltext,@"level":allLevel,@"SOURCE_ID":idStr,@"judge_staus":@"1"};
                        [showAll addObject:allDic];
                    }
                    else
                    {
                        
                    }
                }
                
            }
                    NSDictionary *dic=@{@"评价宝贝":showOne,@"总体评价":showAll};
            */
            NSDictionary *dic=@{@"评价宝贝":showOne};
            textDic =[NSMutableDictionary dictionaryWithDictionary:dic];
            //            NSLog(@"textDic---%@",textDic);
            [self initFootView];
            [self initHeadView];
            listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64-60) style:UITableViewStyleGrouped];
            listTableView.delegate=self;
            listTableView.dataSource=self;
            listTableView.backgroundColor = TITLE_BG;
            listTableView.tableHeaderView=sectionView;
            listTableView.tableFooterView=[[UIView alloc]init];//tablefootView
            [self.view addSubview:listTableView];
            UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAll)];
            [self.view addGestureRecognizer:tapGest];
        });
    });
}
#pragma mark - 去除数组中相同的元素
- (NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *tempArrM = [@[] mutableCopy];
    for (NSInteger i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if (![tempArrM containsObject:array[i]]) {
                [tempArrM addObject:array[i]];
            }
        }
    }
    NSLog(@"temparray---%@,%@",tempArrM,array);
    
    return tempArrM;
}
- (IBAction)appriseBtnClick:(id)sender {
    [self publish];
}
- (void)removeAll
{
    [self.view endEditing:YES];
    
        [listTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)initFootView
{
    //总体评价 暂时屏蔽
    return;
    
    tablefootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 117+80)];
    tablefootView.backgroundColor=[UIColor whiteColor];
    
    UIView *headVI=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 36)];
    headVI.backgroundColor=[UIColor colorWithRed:243.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
//    [tablefootView addSubview:headVI];
    
    UILabel *names =[[UILabel alloc]initWithFrame:CGRectMake(15,0, 80, 36)];
    names.text=@"总体评价";
    names.textColor=[Utils HexColor:0x353535 Alpha:1];
    names.font=[UIFont systemFontOfSize:13.0f];
    names.backgroundColor=[UIColor clearColor];
//    [headVI addSubview:names];
    
    UILabel *appriseStar =[[UILabel alloc]initWithFrame:CGRectMake(15,5, 90, 36)];
    appriseStar.text=@"总满意度评星";
    appriseStar.textColor=COLOR_C2;
    appriseStar.font=FONT_t4;
    appriseStar.backgroundColor=[UIColor clearColor];
    [tablefootView addSubview:appriseStar];
    NSString *star=@"";
    NSString *appraiseText=@"";
    
    if ([textDic[@"总体评价"] count]==0) {
     
        
    }
    else
    {
        star=[NSString stringWithFormat:@"%@",textDic[@"总体评价"][0][@"level"]];
        appraiseText=[NSString stringWithFormat:@"%@",textDic[@"总体评价"][0][@"text"]];
    }
//;
    for (int a=0; a<5; a++) {
        OrderBtn *starBtn=[OrderBtn buttonWithType:UIButtonTypeCustom];
//        [starBtn setImage:[UIImage imageNamed:@"ico_appraise_star_unfull@3x.png"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        if ([star intValue]>0) {
            starBtn.userInteractionEnabled=NO;
        }
        if (a<[star intValue]) {
            
//            [starBtn setImage:[UIImage imageNamed:@"ico_appraise_star@3x.png"] forState:UIControlStateNormal];
            [starBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            //            starBtn.userInteractionEnabled=NO;
        }
        [starBtn setFrame:CGRectMake(90+15+(18+10)*a,0, 40, 40)];//(UI_SCREEN_WIDTH-127-15)
        [starBtn addTarget:self action:@selector(tapStarBtn:) forControlEvents:UIControlEventTouchUpInside];
        int k=100000;
        starBtn.sectionTag = k ;
        starBtn.tag=a+1;
        [tablefootView addSubview:starBtn];
    }
    UITextView *writeText=[[UITextView alloc]initWithFrame:CGRectMake(15, appriseStar.frame.size.height+appriseStar.frame.origin.y, UI_SCREEN_WIDTH-15-15,56)];
    writeText.font=[UIFont systemFontOfSize:11.0f];
    writeText.layer.borderColor = [[Utils HexColor:0xacacac Alpha:1]CGColor];
    writeText.delegate=self;
    writeText.tag=1000;
    writeText.layer.borderWidth = 0.5;
    //    writeTextfield.placeholder=@"写点评价吧,有助于提升购物体验呦！";

    if (appraiseText.length==0) {
        writeText.text=@"写点评价吧,有助于提升购物体验呦!";
        writeText.textColor=[Utils HexColor:0xacacac Alpha:1];
        writeText.userInteractionEnabled=YES;
    }
    else
    {
        writeText.text=appraiseText;
        writeText.textColor=[UIColor blackColor];
        writeText.userInteractionEnabled=NO;
        
    }
    [tablefootView addSubview:writeText];
    
}
-(void)initHeadView
{
    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
    UILabel *names =[[UILabel alloc]initWithFrame:CGRectMake(15,0, 80, 36)];
    names.text=@"评价宝贝";
    names.textColor=[Utils HexColor:0x353535 Alpha:1];
    names.font=[UIFont systemFontOfSize:13.0f];
    names.backgroundColor=[UIColor clearColor];

    UILabel *dateLable =[[UILabel alloc]initWithFrame:CGRectMake(17,0, UI_SCREEN_WIDTH-17, 50)];
    NSString *dateStr=[NSString stringWithFormat:@"%@",self.messageOrderModel.creatE_DATE];//[self getdate:self.messageOrderModel.creatE_DATE]];
    dateLable.text=[NSString stringWithFormat:@"成交时间: %@",dateStr];
    dateLable.textAlignment=NSTextAlignmentLeft;
    dateLable.font=FONT_t4;
    dateLable.textColor=[Utils HexColor:0x999999 Alpha:1];
    dateLable.backgroundColor=[UIColor clearColor];
    UIImageView *lineImgViw=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, UI_SCREEN_WIDTH, 0.5)];
    [lineImgViw setBackgroundColor:[Utils HexColor:0xd9d9d9 Alpha:1]];
    [sectionView addSubview:lineImgViw];
    [sectionView addSubview:dateLable];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.00000001;
    //    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 83+70+11;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [textDic[@"评价宝贝"] count];
    //    return [self.orderArray count];
    //    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyOrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MyOrderViewTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell.writeTextfield setTag:200 + indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderModelDetailListInfo *detailListInfoData = changeNewOrderArray[indexPath.row];
    OrderModelDetailInfo *detailInfoDic =  detailListInfoData.detailInfo;
    OrderModelProductListInfo *proudctList = detailListInfoData.proudctList;

    cell.goodNameLabel.text=[Utils getSNSString:[NSString stringWithFormat:@"%@",proudctList.productInfo.proD_NAME]];
//    if ([cell.goodNameLabel.text length]>12){
//        cell.goodNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        cell.goodNameLabel.numberOfLines = 2;
//        [cell.goodNameLabel sizeToFit];
//    }
//    else{
//        cell.goodNameLabel.numberOfLines = 1;
//    }
    
    cell.orderNoLabel.text= [Utils getSNSString:[NSString stringWithFormat:@"%@",proudctList.productInfo.proD_CLS_NUM]];
    cell.colcorLabel.text=[NSString stringWithFormat:@"颜色：%@ 尺码：%@",[Utils getSNSString:[NSString stringWithFormat:@"%@",proudctList.productInfo.coloR_NAME]],[Utils getSNSString:[NSString stringWithFormat:@"%@",proudctList.productInfo.speC_NAME]]];

    NSString *imgUrlstr = [[Utils getSNSString:[NSString stringWithFormat:@"%@",proudctList.productInfo.coloR_FILE_PATH]]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *price=[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",detailInfoDic.acT_PRICE] floatValue]];
    NSString *numm=[NSString stringWithFormat:@"%@",detailInfoDic.qty];
    NSString *stateProDuct=[NSString stringWithFormat:@"%@",detailInfoDic.state];
    //        //单价  参数有问题
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",[Utils getSNSString:price]];
    //        //    数量
    cell.numberLabel.text=[NSString stringWithFormat:@"x%@",[Utils getSNSString:numm]];
    [cell.goodImgView downloadImageUrl:[CommMBBusiness changeStringWithurlString:imgUrlstr size:SNS_IMAGE_Size] cachePath:[AppSetting getMBCacheFilePath] defaultImageName:DEFAULT_LOADING_IMAGE];
    
    cell.appriseView.hidden=NO;
    cell.oneStarBtn.sectionTag=indexPath.row;
    cell.twoStarBtn.sectionTag=indexPath.row;
    cell.threeStarBtn.sectionTag=indexPath.row;
    cell.fourStarBtn.sectionTag=indexPath.row;
    cell.fiveStarBtn.sectionTag=indexPath.row;
    cell.oneStarBtn.clickIndexPath = indexPath;
    cell.twoStarBtn.clickIndexPath = indexPath;
    cell.threeStarBtn.clickIndexPath = indexPath;
    cell.fourStarBtn.clickIndexPath = indexPath;
    cell.fiveStarBtn.clickIndexPath = indexPath;
    [cell.oneStarBtn addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.twoStarBtn addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.threeStarBtn addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.fourStarBtn addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.fiveStarBtn addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    NSString *star;
    NSString *contentText;
    
    if([textDic[@"评价宝贝"] count]==0)
    {
        
    }
    else
    {
        if (commonDict) {
            contentText = [commonDict objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:indexPath.row]]];
            
        }else{
            contentText=[NSString stringWithFormat:@"%@",textDic[@"评价宝贝"][indexPath.row][@"text"]];
        }
        star=[NSString stringWithFormat:@"%@",textDic[@"评价宝贝"][indexPath.row][@"level"]];
    }

    switch ([star intValue]) {
        case 0:
        {
            cell.oneStarBtn.userInteractionEnabled=YES;
            [cell.oneStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.twoStarBtn.userInteractionEnabled=YES;
            [cell.twoStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.threeStarBtn.userInteractionEnabled=YES;
            [cell.threeStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.fourStarBtn.userInteractionEnabled=YES;
            [cell.fourStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.fiveStarBtn.userInteractionEnabled=YES;
            [cell.fiveStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [cell.oneStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            cell.oneStarBtn.userInteractionEnabled=NO;
            cell.twoStarBtn.userInteractionEnabled=NO;
            [cell.twoStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.threeStarBtn.userInteractionEnabled=NO;
            [cell.threeStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.fourStarBtn.userInteractionEnabled=NO;
            [cell.fourStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.fiveStarBtn.userInteractionEnabled=NO;
            [cell.fiveStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [cell.oneStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.twoStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            cell.oneStarBtn.userInteractionEnabled=NO;
            cell.twoStarBtn.userInteractionEnabled=NO;
            cell.threeStarBtn.userInteractionEnabled=NO;
            [cell.threeStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.fourStarBtn.userInteractionEnabled=NO;
            [cell.fourStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.fiveStarBtn.userInteractionEnabled=NO;
            [cell.fiveStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            
        }
            break;
        case 3:
        {
            [cell.oneStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.twoStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.threeStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            cell.oneStarBtn.userInteractionEnabled=NO;
            cell.twoStarBtn.userInteractionEnabled=NO;
            cell.threeStarBtn.userInteractionEnabled=NO;
            cell.fourStarBtn.userInteractionEnabled=NO;
            [cell.fourStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            cell.fiveStarBtn.userInteractionEnabled=NO;
            [cell.fiveStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            [cell.oneStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.twoStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.threeStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.fourStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            cell.oneStarBtn.userInteractionEnabled=NO;
            cell.twoStarBtn.userInteractionEnabled=NO;
            cell.threeStarBtn.userInteractionEnabled=NO;
            cell.fourStarBtn.userInteractionEnabled=NO;
            cell.fiveStarBtn.userInteractionEnabled=NO;
            [cell.fiveStarBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            [cell.oneStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.twoStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.threeStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.fourStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            [cell.fiveStarBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            cell.oneStarBtn.userInteractionEnabled=NO;
            cell.twoStarBtn.userInteractionEnabled=NO;
            cell.threeStarBtn.userInteractionEnabled=NO;
            cell.fourStarBtn.userInteractionEnabled=NO;
            cell.fiveStarBtn.userInteractionEnabled=NO;
        }
            break;
        default:
            break;
    }
    
    
    UITextField *textfield=cell.writeTextfield;
    if ([star isEqualToString:@"0"])//没评论
    {
        if ([stateProDuct isEqualToString:@"1"]) {
            
            textfield.userInteractionEnabled=YES;
        }
        if (!contentText || [contentText length] == 0) {
            contentText = @"";
        }
        cell.writeTextfield.text=[NSString stringWithFormat:@"%@",contentText];
    }
    else if(contentText.length==0)//评论了但是评论内容为空
    {
        cell.writeTextfield.text=@"";
        textfield.userInteractionEnabled=YES;
    }
    else
    {
        if (!contentText || [contentText length] == 0) {
            contentText = @"";
        }
        cell.writeTextfield.text=[NSString stringWithFormat:@"%@",contentText];
        textfield.userInteractionEnabled=NO;
    }
    if (![stateProDuct isEqualToString:@"1"]) {
        
        textfield.userInteractionEnabled=NO;
    }
    
    
    //state为1 才可以评论
    if ([stateProDuct isEqualToString:@"1"]) {
        NSString *judge_staus = [NSString stringWithFormat:@"%@",self.messageOrderModel.judgeStatus];
        if ([[Utils getSNSString:judge_staus] isEqualToString:@"3"]) {
            cell.oneStarBtn.userInteractionEnabled=NO;
            cell.twoStarBtn.userInteractionEnabled=NO;
            cell.threeStarBtn.userInteractionEnabled=NO;
            cell.fourStarBtn.userInteractionEnabled=NO;
            cell.fiveStarBtn.userInteractionEnabled=NO;
            cell.writeTextfield.userInteractionEnabled=NO;
        }
        else
        {
            NSString *isalreadyAppris=[NSString stringWithFormat:@"%@",textDic[@"评价宝贝"][indexPath.row][@"isAlreadyApprise"]];
            if ([isalreadyAppris boolValue]) {//兼容judge_staus不更新
                cell.oneStarBtn.userInteractionEnabled=NO;
                cell.twoStarBtn.userInteractionEnabled=NO;
                cell.threeStarBtn.userInteractionEnabled=NO;
                cell.fourStarBtn.userInteractionEnabled=NO;
                cell.fiveStarBtn.userInteractionEnabled=NO;
                cell.writeTextfield.userInteractionEnabled=NO;
            }
            else
            {
                cell.oneStarBtn.userInteractionEnabled=YES;
                cell.twoStarBtn.userInteractionEnabled=YES;
                cell.threeStarBtn.userInteractionEnabled=YES;
                cell.fourStarBtn.userInteractionEnabled=YES;
                cell.fiveStarBtn.userInteractionEnabled=YES;
//                cell.writeTextfield.userInteractionEnabled=YES;
            }
        }
   
    }else{
        cell.oneStarBtn.userInteractionEnabled=NO;
        cell.twoStarBtn.userInteractionEnabled=NO;
        cell.threeStarBtn.userInteractionEnabled=NO;
        cell.fourStarBtn.userInteractionEnabled=NO;
        cell.fiveStarBtn.userInteractionEnabled=NO;
        cell.writeTextfield.userInteractionEnabled=NO;
    }
//    cell.writeTextfield.userInteractionEnabled=YES;

    textfield.delegate=self;
    //    textfield.tag=indexPath.row;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger tap=textField.tag;
    
    if (tap==1000) {
        
        [listTableView setContentOffset:CGPointMake(0, [changeNewOrderArray count]*(83+90)) animated:NO];
        
    }else
    {
        tap -= 200;
        if(tap==0)
            return;
        [listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tap inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //        [listTableView setContentOffset:CGPointMake(0, (83+90)*tap) animated:NO];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSInteger tagNum = textField.tag - 200;
    if (!commonDict) {
        commonDict = [NSMutableDictionary new];
    }
    NSString *detailStr = [textField.text stringByAppendingString:string];

    [commonDict setObject:detailStr forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:tagNum]]];
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger tagNum = textField.tag - 200;
    if (!commonDict) {
        commonDict = [NSMutableDictionary new];
    }
    [commonDict setObject:textField.text forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:tagNum]]];
    //    writeStr =textField.text;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"写点评价吧,有助于提升购物体验呦!"]) {
        textView.text=@"";
    }
    UITextView *texs=(UITextView *)textView;
    texs.textColor=[UIColor blackColor];
    NSInteger tap=textView.tag;
    if (tap==1000) {
        
        [listTableView setContentOffset:CGPointMake(0, [changeNewOrderArray count]*(83+90)) animated:NO];
        
    }else
    {
        if(tap==200)
            return;
        
        [listTableView setContentOffset:CGPointMake(0, (83+90+83)*tap) animated:NO];
    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==1000) {
        NSMutableArray *changeArray=[NSMutableArray arrayWithArray:textDic[@"总体评价"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:changeArray[0]];
        
        [dic setObject:textView.text forKey:@"text"];
        [changeArray replaceObjectAtIndex:0 withObject:dic];
        [textDic setObject:changeArray forKey:@"总体评价"];
        
    }else
    {
        NSMutableArray *changeArray=[NSMutableArray arrayWithArray:textDic[@"评价宝贝"]];
        [changeArray replaceObjectAtIndex:textView.tag withObject:textView.text];
        [textDic setObject:changeArray forKey:@"评价宝贝"];
        
        
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length==0) {
        textView.text=@"写点评价吧,有助于提升购物体验呦!";
        textView.textColor=[Utils HexColor:0xacacac Alpha:1];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        
        return NO;
    }
    else
    {
        return YES;
        
    }
    
}
-(void)clickStar:(id)sender
{
    OrderBtn *starBtn=(OrderBtn *)sender;
    
    MyOrderViewTableViewCell *cell =(MyOrderViewTableViewCell *) [listTableView cellForRowAtIndexPath:starBtn.clickIndexPath];
    for (UIView *subView in [cell.contentView.subviews[1] subviews]) {
        
        if ([subView isKindOfClass:[OrderBtn class]])
        {
            OrderBtn *tempBtn=(OrderBtn *)subView;
            if (tempBtn.tag<=starBtn.tag)
            {
//                [tempBtn setImage:[UIImage imageNamed:@"ico_appraise_star@3x.png"] forState:UIControlStateNormal];@"Unico/add1"
                        [tempBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            }
            else
            {
//                [tempBtn setImage:[UIImage imageNamed:@"ico_appraise_star_unfull@3x.png"] forState:UIControlStateNormal];
                        [tempBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            }
        }
    }

    starLevel = [NSString stringWithFormat:@"%ld",(long)starBtn.tag];
    if (starBtn.sectionTag==100000) {
        
        NSMutableArray *changeArray=[NSMutableArray arrayWithArray:textDic[@"总体评价"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:changeArray[0]];
        
        [dic setObject:starLevel forKey:@"level"];
        [changeArray replaceObjectAtIndex:0 withObject:dic];
        [textDic setObject:changeArray forKey:@"总体评价"];
        
    }else
    {
        NSMutableArray *changeArray=[NSMutableArray arrayWithArray:textDic[@"评价宝贝"]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:changeArray[starBtn.sectionTag]];
        [dic setObject:starLevel forKey:@"level"];
        [changeArray replaceObjectAtIndex:starBtn.sectionTag withObject:dic];
        [textDic setObject:changeArray forKey:@"评价宝贝"];
        
    }
    
}
-(IBAction)tapStarBtn:(id)sender;
{
    
    UIButton *btn = (UIButton *)sender;
    
    starLevel =[NSString stringWithFormat:@"%ld",(long)btn.tag];
    //    UIView *view = [listTableView viewForFooterInSection:btn.tag];
    for (UIView *subView in tablefootView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *tempBtn=(UIButton *)subView;
            if (tempBtn.tag<=btn.tag)
            {
//                [tempBtn setImage:[UIImage imageNamed:@"ico_appraise_star@3x.png"] forState:UIControlStateNormal];
                [tempBtn setImage:[UIImage imageNamed:@"addyellow@2x"] forState:UIControlStateNormal];
            }
            else
            {
                
//                [tempBtn setImage:[UIImage imageNamed:@"ico_appraise_star_unfull@3x.png"] forState:UIControlStateNormal];
                [tempBtn setImage:[UIImage imageNamed:@"addwhite@2x"] forState:UIControlStateNormal];
            }
        }
    }
    NSMutableArray *changeArray=[NSMutableArray arrayWithArray:textDic[@"总体评价"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:changeArray[0]];
    [dic setObject:starLevel forKey:@"level"];
    [changeArray replaceObjectAtIndex:0 withObject:dic];
    [textDic setObject:changeArray forKey:@"总体评价"];
    
}
//-(void)canShowPraiseBox
//{
//     [SUTILITY_TOOL_INSTANCE showPraiseBox];
//}
- (void)publish
{
    [self.view resignFirstResponder];
    
    NSMutableArray *appriseAll=[NSMutableArray new];
    NSString *allSourceid = [NSString stringWithFormat:@"%@",self.messageOrderModel.idStr];
    
      /*
    NSDictionary *allDic=[NSDictionary dictionaryWithDictionary:textDic[@"总体评价"][0]];
    //    NSString *allText =[NSString stringWithFormat:@"%@",allDic[@"text"]];
    NSString *allText =[[NSString alloc]initWithFormat:@"%@",allDic[@"text"]];
    //过滤字符串前后的空格
    //    allText = [allText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //过滤中间空格
    allText = [allText stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *allStar =[NSString stringWithFormat:@"%@",allDic[@"level"]];
    NSString *allSourceid=[NSString stringWithFormat:@"%@",allDic[@"SOURCE_ID"]];
    NSString *allJudgeStates=[NSString stringWithFormat:@"%@",allDic[@"judge_staus"]];
    int allprive;
    if (allText.length==0&&[allStar isEqualToString:@"0"]) {
        
        [Utils alertMessage:@"请填写完整的评价信息和星级"];
        return;
    }else if (allText.length>0&&![allStar isEqualToString:@"0"]&&[allJudgeStates isEqualToString:@"1"])
    {
        
        NSDictionary *param=@{@"content":allText,
                              @"source_id":allSourceid,
                              @"satisfaction_index":allStar,
                              @"userid":sns.ldap_uid,
                              @"SOURCE_TYPE":@"3",
                              @"orderid":allSourceid};
        [appriseAll addObject:param];
        allprive = 10;
        
        
    }else
    {
        if ([allJudgeStates isEqualToString:@"2"]) {
            
        }
        else
        {
            [Utils alertMessage:@"请填写完整的评价信息和星级"];
            return;
        }
    }
    */
    
    
  /*
    commentCreateList  list集合参数名[{info 评价内容，score 评价星级，userId 用户id，temp_id// 11wei 商品id，type 评论来源，orderId 订单id}]
    */
    NSArray *prodArray = [NSArray arrayWithArray:textDic[@"评价宝贝"]];
    for (int k=0 ; k<[prodArray count]; k++) {
        NSString *detailStarLevel=[NSString stringWithFormat:@"%@",prodArray[k][@"level"]];
        //        NSString *textStr=[NSString stringWithFormat:@"%@",prodArray[k][@"text"]];
        
        NSString *textStr = [commonDict objectForKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:k]]];
        
        //过滤字符串前后的空格
        //        textStr = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //过滤中间空格
        textStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
//        NSString *orderDetailId=[NSString stringWithFormat:@"%@",prodArray[k][@"orderDetailId"]];
        NSString *sourceId=[NSString stringWithFormat:@"%@",prodArray[k][@"sourceID"]];
        NSString *judgeStates=[NSString stringWithFormat:@"%@",prodArray[k][@"judge_staus"]];
        
        if ([detailStarLevel isEqualToString:@"0"]&&textStr.length==0) {
            
        }else if (textStr.length>0&&![detailStarLevel isEqualToString:@"0"]&&[judgeStates isEqualToString:@"1"])
        {
            NSDictionary *param=@{@"info":textStr,
                                  @"temp_id":sourceId,
                                  @"score":detailStarLevel,
                                  @"userId":sns.ldap_uid,
                                  @"type":@"1",
                                  @"orderId":allSourceid,
                              };
            [appriseAll addObject:param];
        }else
        {/*
            //allprive判断上传总体评价
            if ([allJudgeStates isEqualToString:@"2"]||allprive==10) {
                
            }
            else
            {
                [Utils alertMessage:@"请填写完整的评价信息和星级"];
                return;
            }
            */
        }
    }
//    if([appriseAll count]==0)
//    {
//        [Utils alertMessage:@"请先进行填写"];
//        
//        return;
//    }
    
//    NSMutableString *returnMessage;
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    

    NSDictionary *paramList=@{@"commentCreateList": appriseAll,@"token": userToken};
//    NSMutableDictionary *responseAll=[NSMutableDictionary new];
    
    /*
     commentCreateList  list集合参数名[{info 评价内容，score 评价星级，userId 用户id，temp_id 商品id，type 评论来源，orderId 订单id}]
    */
    [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"CommentCreateList" params:paramList success:^(NSDictionary *dict) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
            {
//                [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
                [Utils alertMessage:@"评价成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil];
                NSDictionary *postDic=@{@"tag":@[@"0",@"4"]};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if ([[dict allKeys]containsObject:@"message"]) {
                    NSString *messages =[NSString stringWithFormat:@"%@",dict[@"message"]];
                    [Utils alertMessage:messages];
                }
                else{
                    [Utils alertMessage:[NSString stringWithFormat:@"评价失败"]];
                }
                
            }
        });
    } failed:^(NSError *error) {
        
        [Toast hideToastActivity];
          [Utils alertMessage:[NSString stringWithFormat:@"评价失败"]];
    }];
 
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
