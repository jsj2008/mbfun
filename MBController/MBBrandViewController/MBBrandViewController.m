//
//  MBBrandViewController.m
//  Wefafa
//
//  Created by fafatime on 15-4-2.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBBrandViewController.h"
#import "NavigationTitleView.h"
#import "MBShoppingGuideInterface.h"
#import "ImageInfo.h"
#import "ImageWaterView.h"
#import "GoodsListCollectionView.h"
#import "UIScrollView+MJRefresh.h"
#import "HttpRequest.h"
#import "BaseViewController.h"
#import "SProductDetailViewController.h"
#import "SSearchProductCollectionView.h"
#import "SSearchProductModel.h"
#import "SUtilityTool.h"
#import "MJRefresh.h"

@interface MBBrandViewController ()<GoodsListCollectionDelegate>
{
    NSMutableArray *brandListArray;
    CGFloat _offset_Y;
    int goodPage;
    int collocationPage;
    
    UIView *placeholdView;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) SSearchProductCollectionView *contentCollectionView;

@end

@implementation MBBrandViewController
@synthesize brandWaterView;
@synthesize brandId;
@synthesize brandName;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    if (self.brandName.length==0) {
//        
//        //TODO:
//           view.lbTitle.text=@"单品";
//    }else
//    {
//           view.lbTitle.text=self.brandName;
//    }
//    
//    
//    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
//    [self.headView addSubview:view];
    goodPage=1;
    
//
    [self initSubViews];
    [self requestBrandData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    NSString *title = brandName;
    if ([title length] == 0) {
        title = @"单品";
    }
    
    self.title = title;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews{
    _contentCollectionView = [[SSearchProductCollectionView alloc]initWithFrame:CGRectMake(0, 64,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    _contentCollectionView.isShowPrice = YES;
    __unsafe_unretained typeof(self) p = self;
    _contentCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        SSearchProductModel *model = array[indexPath.row];
        SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
//        controller.productID = model.aID.stringValue;
        controller.productID = [NSString stringWithFormat:@"%@",model.code];
        [p.navigationController pushViewController:controller animated:YES];
    };
   //上下拉刷新
    [self addContentCollectionViewHeader];
    [self addContentCollectionViewFooter];
    
    [self.view insertSubview:_contentCollectionView belowSubview:self.headView];
}

-(void)requestBrandData
{
    NSMutableDictionary *dic;
    if (_searchDictionary) {
        dic = [NSMutableDictionary dictionaryWithDictionary:_searchDictionary];
    }else{
        dic = [[NSMutableDictionary alloc]init];
    }
    if (self.brandId) {
        [dic setObject:self.brandId forKey:@"branD_ID"];
    }
    if (self.categaryID) {
        [dic setObject:self.categaryID forKey:@"CategoryId"];
//ProductClsCommonSearchFilter
    }
    [HttpRequest productGetRequestPath:nil methodName:@"ProductClsCommonSearchFilter" params:dic success:^(NSDictionary *dict) {
        [self.contentCollectionView  setCategaryContentArray:dict[@"results"]];
//        NSArray *listArr = [dict objectForKey:@"results"];
//        for (int i=0; i<[listArr count]; i++) {
//            NSDictionary *dataD = [listArr objectAtIndex:i];
//            if (dataD) {
//                ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:YES WithBrand:YES];
//                [goodArrayImage addObject:imageInfo];
//            }
//        }
//        [self initBrandCollocationViewWithModelArray:goodArrayImage];
        
//        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
//         [self initBrandCollocationViewWithModelArray:goodArrayImage];
    }];
    
}

- (void)initBrandCollocationViewWithModelArray:(NSArray *)modelArray
{
//    dispatch_async(dispatch_get_main_queue(), ^{
    if (modelArray.count == 0) {
        placeholdView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height, SCREEN_HEIGHT, self.view.frame.size.height - self.headView.frame.size.height)];
        [placeholdView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 58)/2, 100, 58, 50)];
        [imgView setImage:[UIImage imageNamed:@"btn-clothes@2x.png"]];
        [placeholdView addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.size.height + imgView.frame.origin.y+10, SCREEN_WIDTH, 20)];
        [label setText:@"暂无商品"];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:14.0f]];
        [placeholdView addSubview:label];
        
        [self.view addSubview:placeholdView];
    }
        self.brandWaterView = [[GoodsListCollectionView alloc]initWithFrame:CGRectMake(0, 0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) AndModelArray:modelArray AndCellType:brandType];
        self.brandWaterView.contentInset = UIEdgeInsetsMake(self.headView.frame.size.height, 0, 0, 0);
        CGFloat matchWidth = (UI_SCREEN_WIDTH-45)/2;
        CGFloat ratio = 16.0/9;
        self.brandWaterView.contentSize = CGSizeMake(matchWidth, matchWidth*ratio);
        _offset_Y = self.headView.frame.size.height;
        self.brandWaterView.goodsDelegate = self;
        [self addGoodsFooter];
        [self addGoodsHeader];
        [self.brandWaterView setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
        [self.view insertSubview:self.brandWaterView belowSubview:self.headView];
        
//    });
}
- (void)addGoodsHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [self.brandWaterView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf refreshDataWithPageIndex:1 WithCollocation:NO];
       
        });
    }];
}

- (void)addGoodsFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [self.brandWaterView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [weakSelf refreshDataWithPageIndex:2 WithCollocation:NO];
    
        });
    }];
}
- (void)addContentCollectionViewHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [self.contentCollectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf collocationRefreshDataWithPageIndex:1];
            
        });
    }];
}

- (void)addContentCollectionViewFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [self.contentCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [weakSelf refreshDataWithPageIndex:2 WithCollocation:NO];
            
            [weakSelf collocationRefreshDataWithPageIndex:2];
            
        });
    }];
}

- (NSArray *)collocationRefreshDataWithPageIndex:(int)pageIndex
{
    [self performSelectorOnMainThread:@selector(deletePlaceholdView) withObject:nil waitUntilDone:NO];
    NSMutableArray *collArrayImageS = [[NSMutableArray alloc]init];
    
    int indexPage;
    collocationPage++;
    indexPage=collocationPage;
    
    if (pageIndex==2) {//上提刷新

        NSMutableDictionary *dic;
        if (_searchDictionary) {
            dic = [NSMutableDictionary dictionaryWithDictionary:_searchDictionary];
        }else{
            dic = [[NSMutableDictionary alloc]init];
        }
        if (self.brandId) {
            [dic setObject:self.brandId forKey:@"branD_ID"];
        }
        if (self.categaryID) {
            [dic setObject:self.categaryID forKey:@"CategoryId"];
            //ProductClsCommonSearchFilter
        }
        [dic setObject:@(indexPage)  forKey:@"pageIndex"];
        [dic setObject:@14 forKey:@"pageSize"];
        
        [HttpRequest productGetRequestPath:nil methodName:@"ProductClsCommonSearchFilter" params:dic success:^(NSDictionary *dict) {
            [self.contentCollectionView  footerEndRefreshing];
//            [self.contentCollectionView  setCategaryContentArray:dict[@"results"]];
            [self.contentCollectionView loadNextContentArray:dict[@"results"]];
            
            
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
            
            [self.contentCollectionView  footerEndRefreshing];
        }];
    }
    else
    {//下拉刷新
        collocationPage=1;
        indexPage=1;
  
        NSMutableDictionary *dic;
        if (_searchDictionary) {
            dic = [NSMutableDictionary dictionaryWithDictionary:_searchDictionary];
        }else{
            dic = [[NSMutableDictionary alloc]init];
        }
        if (self.brandId) {
            [dic setObject:self.brandId forKey:@"branD_ID"];
        }
        if (self.categaryID) {
            [dic setObject:self.categaryID forKey:@"CategoryId"];
            //ProductClsCommonSearchFilter
        }
       [dic setObject:@1 forKey:@"pageIndex"];
       [dic setObject:@14 forKey:@"pageSize"];

        [HttpRequest productGetRequestPath:nil methodName:@"ProductClsCommonSearchFilter" params:dic success:^(NSDictionary *dict) {
            [self.contentCollectionView  headerEndRefreshing];
            [self.contentCollectionView  setCategaryContentArray:dict[@"results"]];
   
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
            [self.contentCollectionView  headerEndRefreshing];
        }];
        
        
    }
    return collArrayImageS;
}
- (void)showRequestToast
{
    
}

- (void)deletePlaceholdView
{
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
}

- (NSArray *)refreshDataWithPageIndex:(int)pageIndex WithCollocation:(BOOL)isCollocation
{
    [self performSelectorOnMainThread:@selector(deletePlaceholdView) withObject:nil waitUntilDone:NO];
    NSMutableArray *collArrayImageS = [[NSMutableArray alloc]init];

    int indexPage;
    goodPage++;
    indexPage=goodPage;
    
    if (pageIndex==2) {//上提刷新
        //搭配跟单品为同一个接口 SOURCE_TYPE 分别
        //搭配,@"pageSize":pageSize
        [HttpRequest productGetRequestPath:nil methodName:@"ProductClsByBrandIdFilter" params:@{@"branD_ID":self.brandId,@"pageIndex":[NSNumber numberWithInt:indexPage],@"pageSize":@14} success:^(NSDictionary *dict) {
            NSArray *listArr = [dict objectForKey:@"results"];
            for (int i=0; i<[listArr count]; i++) {
                NSDictionary *dataD = [listArr objectAtIndex:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:YES WithBrand:YES];
                    [collArrayImageS addObject:imageInfo];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.brandWaterView  footerEndRefreshing ];
                [self.brandWaterView loadNextPage:collArrayImageS];
            });
//            [self initBrandCollocationViewWithModelArray:collArrayImageS];
            
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    else
    {//下拉刷新
        goodPage=1;
        indexPage=1;
        [HttpRequest productGetRequestPath:nil methodName:@"ProductClsByBrandIdFilter" params:@{@"branD_ID":self.brandId,@"pageIndex":[NSNumber numberWithInt:1],@"pageSize":@14} success:^(NSDictionary *dict) {
            NSArray *listArr = [dict objectForKey:@"results"];
            for (int i=0; i<[listArr count]; i++) {
                NSDictionary *dataD = [listArr objectAtIndex:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:YES WithBrand:YES];
                    [collArrayImageS addObject:imageInfo];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.brandWaterView headerEndRefreshing];
                [self.brandWaterView refreshView:collArrayImageS];
            });
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        

    }
    return collArrayImageS;
}
//显示无数据界面
-(void)layoutNoneDataView
{
    CGFloat originY = self.headView.size.height;
    CGRect  noneDataRect = CGRectMake(0, originY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-originY);
    UIView * noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_SHOPPING_BAG andImgSize:CGSizeMake(52, 52) andTipString:@"购物袋还是空的 去逛逛吧" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
    [self.view insertSubview:noneDataView belowSubview:self.headView];
    
    
}
- (void)tvColl_OnDidSelected:(GoodsListCollectionView*)sender RowMessage:(id)message
{
    ImageInfo *info = message;
    NSMutableDictionary *showMessage=[NSMutableDictionary new];
    showMessage = [NSMutableDictionary dictionaryWithDictionary:info.imageData];

    if ([[showMessage[@"clsInfo"] allKeys]containsObject:@"code"]){
        if ([BaseViewController pushLoginViewController])
        {
//            MBGoodsViewController *goodsDetailVC=[[MBGoodsViewController alloc] initWithNibName:@"MBGoodsViewController" bundle:nil];
//            goodsDetailVC.product_Id=[NSString stringWithFormat:@"%@",showMessage[@"clsInfo"][@"code"]];
            
            SProductDetailViewController *detailVC = [SProductDetailViewController new];
            //    detailVC.productCode = @"8816";
//            detailVC.productID = @"80090";
            //detailVC.productCode =[NSString stringWithFormat:@"%@",showMessage[@"clsInfo"][@"code"]];
            detailVC.productID =[NSString stringWithFormat:@"%@",showMessage[@"clsInfo"][@"code"]];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

}

- (void)goodsListScrollView:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    if (offset_Y > scrollView.contentSize.height - scrollView.frame.size.height || offset_Y < -64.0) {
        return;
    }
    CGRect rect = self.headView.frame;
    CGFloat header_Y = rect.origin.y;
    CGFloat diraction = _offset_Y - offset_Y;
    header_Y += diraction;
    if (header_Y < 0 && header_Y > -64) {
        rect.origin.y = header_Y;
    }else if(header_Y >= 0){
        rect.origin.y = 0;
    }else{
        rect.origin.y = -64.0;
    }
    self.headView.frame = rect;
    _offset_Y = offset_Y;
}

- (void)backHome:(id)sender
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
