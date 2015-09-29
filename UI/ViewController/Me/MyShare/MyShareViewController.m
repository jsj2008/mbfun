//
//  MyShareViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//
//  废弃 不用 我的分享 
#import "MyShareViewController.h"
#import "Utils.h"
#import "MBCustomClassifyModelView.h"
#import "AttendCustomButton.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "ImageWaterView.h"
#import "JSONKit.h"
#import "JSON.h"
#import "HeadBtnView.h"
#import "AppSetting.h"
@interface MyShareViewController ()
{
    UIScrollView *backScrollView;
    AttendCustomButton * otherBtn;
//    UIButton *colloctBtn;
//    UIButton *goodBtn;
    HeadBtnView *headBtnV;
    int just;
    NSDictionary *transRootDic;
    NSMutableArray *collocationList;
    NSMutableArray *goodsList;
    int collocationPage;
    int goodPage;
//    NSString *pageSize;
}
@end

@implementation MyShareViewController
@synthesize goodWaterView;
@synthesize waterView;
@synthesize user_Id;
@synthesize isMy;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
//    goodPage=1;
//    collocationPage=1;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //new headview
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
    view.lbTitle.text=@"分享搭配";
    [self.headView addSubview:view];
    [self.headView sendSubviewToBack:view];
    collocationPage=1;
    goodPage=1;
    _headView.backgroundColor=TITLE_BG;
    transRootDic = [NSDictionary new];
   /*
    headBtnV=[[HeadBtnView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-70, 0, 70*2,  view.frame.size.height)];
    [headBtnV.colloctBtn setTitle:@"搭配" forState:UIControlStateNormal];
    [headBtnV.colloctBtn addTarget:self
                            action:@selector(clickColloctBtn:)
                  forControlEvents:UIControlEventTouchUpInside];
    [headBtnV.goodBtn setTitle:@"单品" forState:UIControlStateNormal];
    [headBtnV.goodBtn addTarget:self
                         action:@selector(clickGoodBtn:)
               forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:headBtnV];
    */
    /*
    colloctBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [colloctBtn setTitle:@"搭配" forState:UIControlStateNormal];
    [colloctBtn setBackgroundColor:[UIColor blackColor]];
    [colloctBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    colloctBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    
    [colloctBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [colloctBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2-70, 25, 70, 30)];
    colloctBtn.layer.borderColor =[[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]CGColor];
    colloctBtn.layer.borderWidth = 1.0;
    [colloctBtn addTarget:self
                   action:@selector(clickColloctBtn:)
         forControlEvents:UIControlEventTouchUpInside];
    colloctBtn.selected=YES;
    
    [view addSubview:colloctBtn];
    goodBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [goodBtn setTitle:@"单品" forState:UIControlStateNormal];
    [goodBtn setBackgroundColor:[UIColor whiteColor]];
    goodBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [goodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [goodBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goodBtn addTarget:self
                action:@selector(clickGoodBtn:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [goodBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2-1, 25, 70, 30)];
    goodBtn.layer.borderColor =[[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]CGColor];
    goodBtn.layer.borderWidth = 1.0;
    [view addSubview:goodBtn];
    */
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.headView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-self.headView.frame.size.height)];
    backScrollView.delegate=self;
    backScrollView.pagingEnabled=YES;
    backScrollView.bounces=NO;
    backScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH,0);
    
    
    UIImageView *noCodeImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    [noCodeImgView setImage:[UIImage imageNamed:@"shoppingNil.png"]];
    noCodeImgView.hidden=YES;
    
    
//    UIImageView *noGoodCodeImgView=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH,0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-69)];
//    [noGoodCodeImgView setImage:[UIImage imageNamed:@"shoppingNil.png"]];
//    noGoodCodeImgView.hidden=YES;
    
    NSString *userId=[NSString stringWithFormat:@"%@",self.user_Id];
    collocationList=[[NSMutableArray alloc]init];
    goodsList=[[NSMutableArray alloc]init];
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    NSMutableArray *collArrayImage = [[NSMutableArray alloc]init];

    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
 
//    pageSize=@"16";
    
    NSString *statuses;
    if (isMy)
    {
        statuses = [NSString stringWithFormat:@"2,3,4"];
    }
    else
    {
        statuses=[NSString stringWithFormat:@"2"];
    }
    __weak MyShareViewController *blockSelf = self;

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //搭配跟单品为同一个接口 SOURCE_TYPE 分别
     //搭配s,@"pageSize":pageSize
 
         if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"CollocationSharedFilter" param:@{@"userId":userId,@"SourceType":@"2"} responseList:collocationList  responseMsg:returnMessage]) {
                  dispatch_async(dispatch_get_main_queue(), ^{
             
                      [Toast hideToastActivity];
                    
                  });
#ifdef DEBUG
             NSLog(@"collocation SHARE---%@",collocationList);
#endif
             for (int i=0; i<[collocationList count]; i++) {
                 NSDictionary *dataD = [collocationList objectAtIndex:i];
                 if (dataD) {
                     ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:NO WithBrand:NO];
                     [collArrayImage addObject:imageInfo];
                 }
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 self.waterView = [[ImageWaterView alloc]initWithDataArray:collArrayImage withFrame:CGRectMake(0, 0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) withshow:NO withIsMyLike:NO];
                 [self.waterView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
                 
                 [self.waterView.onDidSelectedRow addListener:self selector:@selector(tvColl_OnDidSelected:RowMessage:)];
                 [self.waterView.onDidFavriteRow addListener:self selector:@selector(tvcell_OnDidFavrite:RowMessage:)];
               
                  [self.waterView addInfiniteScrollingWithActionHandler:^{
                  //使用GCD开启一个线程，使圈圈转2秒
                  int64_t delayInSeconds = 1.0;
                  NSArray *array=[blockSelf refreshDataWithPageIndex:2 WithCollocation:YES];
                     
                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                      [blockSelf.waterView loadNextPage:array];
                      [blockSelf.waterView.infiniteScrollingView stopAnimating];
                  });
                  }];
                  //添加下拉刷新
                  [self.waterView addPullToRefreshWithActionHandler:^{
                  //使用GCD开启一个线程，使圈圈转2秒
                      int64_t delayInSeconds = 1.5;
                      NSArray *array=[blockSelf refreshDataWithPageIndex:1 WithCollocation:YES];
                      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                          [blockSelf.waterView refreshView:array];
                          [blockSelf.waterView.pullToRefreshView stopAnimating];
                          
                      });
                  }];
                 [backScrollView addSubview:self.waterView];
                 [backScrollView addSubview:noCodeImgView];
                 if ([collocationList count]==0)
                 {
                     noCodeImgView.hidden=NO;
                 }
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [Toast hideToastActivity];
                 [backScrollView addSubview:noCodeImgView];
                 noCodeImgView.hidden=NO;
             });
         }
//,@"pageSize":pageSize
         
         /*
         if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"CollocationSharedFilter" param:@{@"userId":userId,@"SourceType":@"1"} responseList:goodsList  responseMsg:returnMessage])
         {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [Toast hideToastActivity];
              });
             for (int i=0; i<[goodsList count]; i++) {
                 NSDictionary *dataD = [goodsList objectAtIndex:i];
                 if (dataD) {
                     ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:YES];
                     [goodArrayImage addObject:imageInfo];
                 }
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.goodWaterView = [[ImageWaterView alloc]initWithDataArray:goodArrayImage withFrame:CGRectMake(UI_SCREEN_WIDTH, 0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-69) withshow:YES];
                 [self.goodWaterView.onDidSelectedRow addListener:self selector:@selector(tvColl_OnDidSelected:RowMessage:)];
                 [self.goodWaterView.onDidFavriteRow addListener:self selector:@selector(tvcell_OnDidFavrite:RowMessage:)];
                 [self.goodWaterView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
                 //添加上拉加载更多
                 [self.goodWaterView addInfiniteScrollingWithActionHandler:^{
                  //使用GCD开启一个线程，使圈圈转2秒
                     int64_t delayInSeconds = 1.0;
                     NSArray *array=[blockSelf refreshDataWithPageIndex:2 WithCollocation:NO];
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                         [blockSelf.goodWaterView loadNextPage:array];
                         [blockSelf.goodWaterView.infiniteScrollingView stopAnimating];
                     });
                  }];
                  //添加下拉刷新
                  [self.goodWaterView addPullToRefreshWithActionHandler:^{
                  //使用GCD开启一个线程，使圈圈转2秒
                      int64_t delayInSeconds = 1.5;
                      NSArray *array=[blockSelf refreshDataWithPageIndex:1 WithCollocation:NO];
                      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                          [blockSelf.goodWaterView refreshView:array];
                          [blockSelf.goodWaterView.pullToRefreshView stopAnimating];
                      });
                  }];
                  
                 if ([goodsList count]==0)
                 {
                     noGoodCodeImgView.hidden=NO;
                 }
                 [backScrollView addSubview:self.goodWaterView];
                 [backScrollView addSubview:noGoodCodeImgView];
                 
             });
             
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [Toast hideToastActivity];
                 [backScrollView addSubview:noGoodCodeImgView];
                 noGoodCodeImgView.hidden=NO;
             });

         }
*/
     });
    [self.view addSubview:backScrollView];
    
}
- (NSArray *)refreshDataWithPageIndex:(int)pageIndex WithCollocation:(BOOL)isCollocation
{
    NSString *userId=[NSString stringWithFormat:@"%@",self.user_Id];
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    NSMutableArray *collArrayImageS = [[NSMutableArray alloc]init];
    NSMutableArray *returnList=[[NSMutableArray alloc]init];
    NSString *source_type;
    int indexPage;
    if (isCollocation) {
        source_type = @"2";
        collocationPage ++;
        indexPage=collocationPage;
    }
    else
    {

        source_type=@"1";
        goodPage++;
        indexPage=goodPage;
    }
    if (pageIndex==2) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //搭配跟单品为同一个接口 SOURCE_TYPE 分别
            //搭配,@"pageSize":pageSize

            if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"CollocationSharedFilter" param:@{@"userId":userId,@"SourceType":source_type,@"pageIndex":[NSNumber numberWithInt:indexPage]} responseList:returnList  responseMsg:returnMessage]) {
#ifdef DEBUG
                NSLog(@"collocation SHARE---%@",returnList);
#endif
                for (int i=0; i<[returnList count]; i++) {
                    NSDictionary *dataD = [returnList objectAtIndex:i];
                    if (dataD) {
                        ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:!isCollocation WithBrand:NO];
                        [collArrayImageS addObject:imageInfo];
                    }
                }
            }
        });
    }
    else
    {
        if (isCollocation) {
            source_type = @"2";
            collocationPage=1;
            indexPage=collocationPage;
        }
        else
        {

            source_type=@"1";
            goodPage=1;
            indexPage=goodPage;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //搭配跟单品为同一个接口 SOURCE_TYPE 分别
            //搭配,@"pageSize":pageSize

            if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"CollocationSharedFilter" param:@{@"userId":userId,@"SourceType":source_type,@"pageIndex":[NSNumber numberWithInt:indexPage]} responseList:returnList  responseMsg:returnMessage])
            {
                
                for (int i=0; i<[returnList count]; i++) {
                    NSDictionary *dataD = [returnList objectAtIndex:i];
                    if (dataD) {
                        ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:!isCollocation WithBrand:NO];
                        [collArrayImageS addObject:imageInfo];
                    }
                }
                
            }
 
        });
        
    }
    return collArrayImageS;
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickColloctBtn:(UIButton *)sender
{
    just=10;
    [headBtnV.colloctBtn setBackgroundColor:[UIColor blackColor]];
    [headBtnV.goodBtn setBackgroundColor:[UIColor whiteColor]];
    headBtnV.colloctBtn.selected=YES;
    headBtnV.goodBtn.selected=NO;
//    [backScrollView setContentOffset:CGPointMake(self.waterView.frame.origin.x,0) animated:YES];
    [backScrollView setContentOffset:CGPointMake(0,0) animated:YES];
}
-(void)clickGoodBtn:(UIButton *)sender
{
    just=10;
    headBtnV.colloctBtn.selected=NO;
    headBtnV.goodBtn.selected=YES;
    [headBtnV.goodBtn setBackgroundColor:[UIColor blackColor]];
    [headBtnV.colloctBtn setBackgroundColor:[UIColor whiteColor]];
    [backScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH,0) animated:YES];
//    [backScrollView setContentOffset:CGPointMake(self.goodWaterView.frame.origin.x,0) animated:YES];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = backScrollView.frame.size.width;
    int page = floor((backScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    [customClassifyModelV buttonClickedOfIndex:page];
    
    if (just!=10) {
        if (page==0) {
            
            [headBtnV.colloctBtn setBackgroundColor:[UIColor blackColor]];
            [headBtnV.goodBtn setBackgroundColor:[UIColor whiteColor]];
            headBtnV.colloctBtn.selected=YES;
            headBtnV.goodBtn.selected=NO;
        }
        else
        {
            headBtnV.colloctBtn.selected=NO;
            headBtnV.goodBtn.selected=YES;
            [headBtnV.goodBtn setBackgroundColor:[UIColor blackColor]];
            [headBtnV.colloctBtn setBackgroundColor:[UIColor whiteColor]];
            
        }
    }
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    just=0;
    
}
- (void)tvColl_OnDidSelected:(ImageWaterView*)sender RowMessage:(id)message
{
    
}
-(void)tvcell_OnDidFavrite:(ImageWaterView*)sender RowMessage:(id)message
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
