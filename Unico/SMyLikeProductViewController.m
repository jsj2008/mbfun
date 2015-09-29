//
//  SMyLikeProductViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/6.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMyLikeProductViewController.h"
#import "SSearchProductCollectionView.h"
#import "HttpRequest.h"
#import "SUtilityTool.h"
#import "WeFaFaGet.h"
#import "SDataCache.h"
#import "AFNetworking.h"
#import "LNGood.h"
#import "SSearchProductModel.h"
#import "StopicListModel.h"
#import "UIScrollView+MJRefresh.h"
#import "Toast.h"
#import "SProductDetailViewController.h"

@interface SMyLikeProductViewController ()<SProductCollectionDelegate>
{
    SSearchProductCollectionView *productCollectionView;
    int refreshPageIndex;
    NSMutableArray *productArray;
}
@end

@implementation SMyLikeProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64);
    productCollectionView = [[SSearchProductCollectionView alloc]initWithFrame:frame];
    
    [productCollectionView setProductDelegate:self];
    productCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){

//        SItemDetailViewController *controller = [[SItemDetailViewController alloc]init];
//        controller.productID = model.aID.stringValue;
//        [p.navigationController pushViewController:controller animated:YES];
    };
    productCollectionView.isShowPrice = YES;
    [self.view addSubview:productCollectionView];
}
-(void)networkRequestIsPull:(BOOL)isPull
{
    
    __weak typeof(self) weakSelf = self;
    if (!productArray) {
        productArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (isPull) {
        refreshPageIndex = 1;
        [productArray removeAllObjects];
        [productCollectionView reloadData];
        
    }
    if (sns.ldap_uid.length==0) {
        return;
    }
    NSDictionary *paramDic;
    NSString *mothodName=@"";
    
    // 注意userId不要写死。
    NSString *userId = @"0005b031-c73f-4633-9e00-bbf087e11a25";
    userId=sns.ldap_uid;

        paramDic =@{@"UserId":userId,@"pageIndex":[NSNumber numberWithInt:refreshPageIndex],@"pageSize":@14};
        mothodName=@"MyselfCouponFilter";
        [HttpRequest promotionGetRequestPath:nil methodName:mothodName params:paramDic success: ^(NSDictionary *dict){
            //
            [weakSelf parseResponseDataWithDict:dict];
            
        }failed:^(NSError *error){
            NSLog(@"促销错误------%@", error);
            [Toast hideToastActivity];
            [productCollectionView footerEndRefreshing];
            [productCollectionView headerEndRefreshing];
            
        } ];
}
- (void)parseResponseDataWithDict:(NSDictionary *)dict
{
    NSString *message = nil;
    
    NSDictionary *resultsDic=[[dict objectForKey:@"results"] firstObject];
    //       int totalCount = [[dict objectForKey:@"total"] integerValue];
    NSArray *dataArray = nil;
    /*
    if ([(NSArray *)resultsDic[@"collocatioN_LIST"] count]>0) //搭配
    {
        dataArray = [MBMyGoodsPersonalModel modelArrayWithDataArray:resultsDic[@"collocatioN_LIST"]];
        isGood=NO;
        
    }
    else //单品
    {
        dataArray = [MBMyGoodsPersonalModel modelArrayWithDataArray:resultsDic[@"producT_CLS_LIST"]];
        isGood=YES;
    }
     */
    if (dataArray.count > 0) {
        refreshPageIndex ++;
    }
    [productArray addObjectsFromArray:dataArray];
    [self updateViewWithRequestSuccess:YES message:message];
}
- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    [Toast hideToastActivity];
    if (isSuccess) {
        
        productCollectionView.contentArray = productArray;
    }
    [productCollectionView footerEndRefreshing];
    [productCollectionView headerEndRefreshing];
    
}
- (void)requestData{
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
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1];
    self.title=@"我的收藏";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
