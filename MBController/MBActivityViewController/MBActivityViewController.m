//
//  MBActivityViewController.m
//  Wefafa
//
//  Created by fafatime on 15-4-2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBActivityViewController.h"
#import "NavigationTitleView.h"
#import "HttpRequest.h"
#import "AppSetting.h"
#import "Toast.h"
#import "MBMyGoodsContentCollectionView.h"
#import "MBMyGoodsPersonalModel.h"
#import "MJRefresh.h"
#import "BaseViewController.h"
#import "MBMyGoodsPersonalModel.h"
#import "Utils.h"

@interface MBActivityViewController ()
{
    MBMyGoodsContentCollectionView *goodsCollectionView;
    int refreshPageIndex;
    NSMutableArray *activityDataArray;
//    int totalCount;
    BOOL isGood;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (assign,nonatomic) int pageIndex;
@end

@implementation MBActivityViewController
@synthesize activityId;
@synthesize activityName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)initView
{
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];

    if(self.activityName.length>0)
    {
       view.lbTitle.text=[Utils getSNSString:self.activityName];
    }
    else
    {
            view.lbTitle.text=@"活动名称";
    }
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    [self.headView addSubview:view];
    
    goodsCollectionView = [[MBMyGoodsContentCollectionView alloc]initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-view.frame.size.height)];
    goodsCollectionView.contentModelArray = [NSMutableArray array];
    goodsCollectionView.goodsCollectionDelegate=self;
    
    [self.view addSubview:goodsCollectionView];
    activityDataArray = [[NSMutableArray alloc]init];
    [self networkRequestIsPull:YES];
    [self addHeader];
    [self addFooter];
 
}
- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [goodsCollectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [weakSelf networkRequestIsPull:YES];
        });
    }];
}
-(void)networkRequestIsPull:(BOOL)isPull
{
    
    __weak typeof(self) weakSelf = self;
    if (!activityDataArray) {
        activityDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (isPull) {
        refreshPageIndex = 1;
        [activityDataArray removeAllObjects];
        goodsCollectionView.contentModelArray = [NSMutableArray array];
    }
    
//    self.activityId=@"72349";//有搭配
//    self.activityId=@"72346";//有商品
    
    NSDictionary *paramDic =@{@"id":self.activityId,@"pageIndex":[NSNumber numberWithInt:refreshPageIndex],@"pageSize":@14};

    [HttpRequest promotionGetRequestPath:nil methodName:@"PromotionCollocationProductFilter" params:paramDic success: ^(NSDictionary *dict){
        //
        [weakSelf parseResponseDataWithDict:dict];
        
    }failed:^(NSError *error){
        NSLog(@"活动错误------%@", error);
    } ];
   
}

- (void)parseResponseDataWithDict:(NSDictionary *)dict
{
    NSString *message = nil;
    
    NSDictionary *resultsDic=[[dict objectForKey:@"results"] firstObject];
    //       int totalCount = [[dict objectForKey:@"total"] integerValue];
    NSArray *dataArray = nil;
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
    if (dataArray.count > 0) {
        refreshPageIndex ++;
    }
    [activityDataArray addObjectsFromArray:dataArray];
    [self updateViewWithRequestSuccess:YES message:message];
}
- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [goodsCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf networkRequestIsPull:NO];
            });
    }];
}
/*
- (BOOL)isNoMoreData//根据服务器返回来的total总数与请求回来的数据进行对比

{
    if (totalCount == 0) {
        return NO;
    }
    if (totalCount > activityDataArray.count) {
        return NO;
    }
    return NO;
}
 */
- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
     [Toast hideToastActivity];
    if (isSuccess) {
//        goodsCollectionView.showTwoBtn=!isGood;
        goodsCollectionView.contentModelArray = activityDataArray;
    }
    [goodsCollectionView footerEndRefreshing];
    [goodsCollectionView headerEndRefreshing];
   
//    
//    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
//        return;
//    }
//    [Toast makeToast:message];

}
- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}
- (void)myGoodsCollection:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([BaseViewController pushLoginViewController])
    {
        MBMyGoodsContentCollectionView * myContentView=(MBMyGoodsContentCollectionView *)collectionView;
        MBMyGoodsPersonalModel *personalModel=myContentView.contentModelArray[indexPath.row];
        //pictureUrl 代表的是搭配 clsurl 代表的时单品
        if (personalModel.pictureUrl.length==0)
        {
  
        }
        else
        {

        
        }
        
    }

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
