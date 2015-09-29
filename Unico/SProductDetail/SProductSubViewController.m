//
//  SProductSubViewController.m
//  Wefafa
//
//  Created by Jiang on 15/9/9.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SProductSubViewController.h"
#import "SUtilityTool.h"
#import "UIScrollView+MJRefresh.h"
#import "HttpRequest.h"
#import "Toast.h"

#import "MBGoodsDetailsModel.h"

#import "ProductSimilarityView.h"

#import "SProductDetaileModuleView.h"
#import "SProductDetailViewController.h"
#import "SUploadColllocationControlCenter.h"
#import "SCollocationDetailNoneShopController.h"

#import "SProductListReturnTopControl.h"
static const CGFloat kSelectModuleViewH = 44.f;

@interface SProductSubViewController ()
<UIScrollViewDelegate, SProductSelectedModuleViewDelegate, UITableViewDelegate,
ProductSimilarityViewDelegate, ProductCollocationViewDelegate, SProductDetaileModuleViewDelegate,SProductListReturnTopControlDelegate>
{
    NSInteger _pageIndex;
    NSInteger _tagIndex; //模块index
    NSInteger _collocationPageIndex;
    CGFloat _hiddenH;
}

@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, strong) SProductDetaileModuleView *detailView;
@property (nonatomic, strong) ProductSimilarityView *similiarView;
@property (nonatomic, strong) SProductListReturnTopControl *returnTopControl;
@property (nonatomic, strong) NSMutableArray *similarProductArrM;
@property (nonatomic, strong) NSMutableArray *collocationProductArrM;

@end

@implementation SProductSubViewController

#pragma mark -
#pragma mark - getter and setter
- (void)setContentModel:(SProductDetailModel *)contentModel
{
    _contentModel = contentModel;
}

- (NSMutableArray *)similarProductArrM
{
    if (!_similarProductArrM) {
        _similarProductArrM = [NSMutableArray array];
    }
    return _similarProductArrM;
}

- (NSMutableArray *)collocationProductArrM
{
    if (!_collocationProductArrM) {
        _collocationProductArrM = [NSMutableArray array];
    }
    return _collocationProductArrM;
}

#pragma mark - UIViewController Plifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isHide) {
        _hiddenH = 44;
    } else {
        _hiddenH = 64;
    }
    
    _pageIndex = 0;
    _tagIndex = 0;
    _collocationPageIndex = 0;
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initBgScrollView];
    [self initScrollView];
    [self initSelectView];// 把selectview处于试图栈的最上方
    [self requestSimilarSubProductInfo];
    [self requestCollocationSubProductInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if ([self.view.gestureRecognizers count] > 0)
    {
        for(UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers)
        {
            if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
            }
        }
    }
    if (screenEdgePanGestureRecognizer != nil)
    {
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止屏幕边界右滑时返回上一级界面的手势
    }
    
    self.contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*3, self.detailView.height);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
#pragma mark - 初始化
- (void)initBgScrollView
{
    UITableView *bgTableView =
    [[UITableView alloc] initWithFrame:self.view.bounds
                                 style:UITableViewStylePlain];
    bgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bgTableView.delegate = self;
    //    [self.view addSubview:bgTableView];
    [bgTableView addHeaderJumpWithTarget:self action:@selector(jumpBackWithAnimal:)
                               titleName:@"返回商品简介"];
    
    if (self.isHide) {
        self.contentScrollView.frame = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44);
    } else {
        self.contentScrollView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64);
    }
}

- (void)initSelectView
{
    _selectedModuleView =
    [[SProductSelectedModuleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, kSelectModuleViewH)];
    _selectedModuleView.selectedIndex = 0;
    _selectedModuleView.selectedIndex = _contentModel.selectedIndex;
    _selectedModuleView.similarityProductCount =
    _contentModel.goodsDetailModel.commonCountTotal.procodeCount.intValue;//collocationCount
    
    _selectedModuleView.collocationProductCount =
    _contentModel.goodsDetailModel.commonCountTotal.collocationCount.intValue;//procodeCount
    
    //    [self.view addSubview:_selectedModuleView];//self.bgTableView
    [self.view insertSubview:_selectedModuleView aboveSubview:_contentScrollView];
    self.selectedModuleView.delegate = self;
}

- (void)initScrollView
{
    CGRect scrollViewRect = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    //    [self.bgTableView addSubview:scrollView];
    [self.view addSubview:scrollView];
    self.contentScrollView = scrollView;
    
    [self initSubView];
}

- (void)initSubView
{
    self.contentScrollView.contentSize  = CGSizeMake(UI_SCREEN_WIDTH * 3, 0);
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(kSelectModuleViewH, 0, 0, 0);
    
    // 1.商品详情
    _detailView = [[SProductDetaileModuleView alloc]initWithFrame:CGRectMake(0, kSelectModuleViewH+_hiddenH, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-kSelectModuleViewH-50-_hiddenH-_isHide*(160*(UI_SCREEN_WIDTH/750.0f)-50))];
    _detailView.detailModuleDelegate = self;
    _detailView.contentModel = self.contentModel.goodsDetailModel;
    [self.contentScrollView addSubview:_detailView];
    
    // 2.相似单品
    _similiarView = [[ProductSimilarityView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH, _hiddenH, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50-_hiddenH-_isHide*(160*(UI_SCREEN_WIDTH/750.0f)-50))];
    _similiarView.showsVerticalScrollIndicator = NO;
    _similiarView.alwaysBounceVertical = YES;
    _similiarView.contentArray = @[];
    _similiarView.target = self.target;
    _similiarView.contentInset = edgeInset;
    _similiarView.similarityDelegate = self;
    [_similiarView addHeaderJumpWithTarget:self action:@selector(jumpBackWithAnimal:) titleName:@""];
    [_similiarView addFooterWithTarget:self action:@selector(requestAddData)];
    [self.contentScrollView addSubview:_similiarView];
    
    // 3.相关搭配
    _collocationView = [[ProductCollocationView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH*2, _hiddenH, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50-_hiddenH-_isHide*(160*(UI_SCREEN_WIDTH/750.0f)-50))];
    _collocationView.showsVerticalScrollIndicator = NO;
    _collocationView.contentArray = @[];
    _collocationView.contentInset = edgeInset;
    _collocationView.collocationDelegate = self;
    [_collocationView addHeaderJumpWithTarget:self action:@selector(jumpBackWithAnimal:) titleName:@""];
    [_collocationView addFooterWithTarget:self action:@selector(collocationRequestAddData)];
    //    __weak SProductSubViewController *weakSelf = self;
    _collocationView.releaseColl = ^(){
        //        [weakSelf jumpBackWithAnimal:YES];
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
    };
    [self.contentScrollView addSubview:_collocationView];
    
    //添加返回到顶部按钮
    if (self.isHide) {
        _returnTopControl = [[SProductListReturnTopControl alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-50, UI_SCREEN_HEIGHT-(160*UI_SCREEN_WIDTH/750+50), 30, 30)];
    }else{
        _returnTopControl = [[SProductListReturnTopControl alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-50, UI_SCREEN_HEIGHT-100, 30, 30)];
    }
    _returnTopControl.hidden = NO;
    _returnTopControl.delegate = self;
    [self.view addSubview:_returnTopControl];
    
    //    self.contentScrollView.contentSize = CGSizeMake(0, self.detailView.height);
}

#pragma mark - Get Data
#pragma mark - 相似单品请求数据
- (void)requestSimilarSubProductInfo
{
    //    NSLog(@"requestSimilarSubProductInfo____%ld", (long)_pageIndex);
    NSDictionary *params = @{
                             @"m":@"Product",
                             @"a":@"getProductListBySameCodeV2",
                             @"token":@"",
                             @"code":[NSString stringWithFormat:@"%@", self.productCode],
                             @"page":@(_pageIndex),
                             @"num":@(10),
                             };
    [HttpRequest productGetRequestPath:@"Product" methodName:@"getProductListBySameCodeV2"
                                params:params success:^(NSDictionary *dict)
     {
         [_similiarView footerEndRefreshing];
         //MODEL要重新写一下
         if ([dict[@"isSuccess"] intValue] == 1) {
             NSArray * responseArr = (NSArray *)dict[@"results"];
             if (_pageIndex == 0) {
                 self.similarProductArrM = [responseArr mutableCopy];
             }else{
                 [self.similarProductArrM addObjectsFromArray:responseArr];
             }
             _similiarView.contentArray = self.similarProductArrM;
         }else{
             [Toast makeToast:@"相似单品获取失败！"];
         }
     } failed:^(NSError *error) {
         [Toast makeToast:kNoneInternetTitle];
     }];
}

#pragma mark 推荐搭配请求数据
- (void)requestCollocationSubProductInfo
{
    //NSLog(@"requestCollocationSubProductInfo____%ld", (long)_collocationPageIndex);
    NSDictionary *params = @{
                             @"m":@"Product",
                             @"a":@"getCollocationListByCode",
                             @"token":@"",
                             @"code":[NSString stringWithFormat:@"%@", self.productCode],
                             @"page":@(_collocationPageIndex),
                             @"num":@(10),
                             };
    [HttpRequest productGetRequestPath:@"Product" methodName:@"getCollocationListByCode"
                                params:params success:^(NSDictionary *dict)
     {
         [_collocationView footerEndRefreshing];
         //MODEL要重新写一下
         if ([dict[@"status"] intValue] == 1) {
             NSArray * responseArr = (NSArray *)dict[@"data"];
             if (_collocationPageIndex == 0) {
                 self.collocationProductArrM = [responseArr mutableCopy];
             }else{
                 [self.collocationProductArrM addObjectsFromArray:responseArr];
             }
             _collocationView.contentArray = self.collocationProductArrM;
         }else{
             [Toast makeToast:@"推荐搭配获取失败！"];
         }
     } failed:^(NSError *error) {
         [Toast makeToast:kNoneInternetTitle];
     }];
}

#pragma mark - Event Processing
#pragma mark - 上拉刷新
- (void)requestAddData
{
    _pageIndex = (self.similarProductArrM.count + 9)/10;
    [self requestSimilarSubProductInfo];
}

- (void)collocationRequestAddData
{
    _collocationPageIndex = (self.collocationProductArrM.count + 9)/10;
    [self requestCollocationSubProductInfo];
}

#pragma mark 返回到顶部菜单
- (void)jumpBackWithAnimal:(BOOL)animal
{
    if (_delegate && [_delegate respondsToSelector:@selector(sproductSubVcDismissWithTimer:isReturnTop:)]) {
        _selectedModuleView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, kSelectModuleViewH);
        [_delegate sproductSubVcDismissWithTimer:0.25 isReturnTop:NO];
    }
}

#pragma mark 获取scrollView contentOffset
- (void)resizeSelectedModuleViewFrameWithScrollView:(UIScrollView *)scrollView
{
    CGRect rect = self.selectedModuleView.frame;
    if (scrollView.contentOffset.y<=0) {
        rect.origin.y = _hiddenH+fabs(scrollView.contentOffset.y);
    }
    /*
    CGRect rect = self.selectedModuleView.frame;
    if (scrollView.contentOffset.y>-kSelectModuleViewH-_hiddenH) {
        rect.origin.y = _hiddenH;
        self.selectedModuleView.frame = rect;
    } else if (scrollView.contentOffset.y<-kSelectModuleViewH+_hiddenH) {
        rect.origin.y = (-scrollView.contentOffset.y-kSelectModuleViewH+_hiddenH);
        self.selectedModuleView.frame = rect;
    }
     */
}

#pragma mark - Delegate and DataSource
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/UI_SCREEN_WIDTH;
    self.selectedModuleView.selectedIndex = index;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == _bgTableView) {
//        CGRect rect = self.selectedModuleView.frame;
//        if (scrollView.contentOffset.y>-_hiddenH) {
//            rect.origin.y = _hiddenH;
//            self.selectedModuleView.frame = rect;
//        } else if (scrollView.contentOffset.y<+_hiddenH) {
//            rect.origin.y = (-scrollView.contentOffset.y+_hiddenH);
//            self.selectedModuleView.frame = rect;
//        }
//    }
//}

#pragma mark  ProductSimilarityViewDelegate
- (void)productSimilartyViewViewWillBeginDraggingScroll:(UIScrollView *)scrollView{
//    _contentOffsetY = scrollView.contentOffset.y;
//    NSLog(@"_contentOffsetY:%f",_contentOffsetY);
}

- (void)productSimilartyViewViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.y);
//    if (_contentOffsetY>scrollView.contentOffset.y&&scrollView.contentOffset.y>600) {
//        _returnTopControl.hidden = NO;
//    }else{
//        _returnTopControl.hidden = YES;
//    }
    //    _bgTableView.delegate = nil;
    [self resizeSelectedModuleViewFrameWithScrollView:scrollView];
    //    _bgTableView.delegate = self;
}

- (void)productSimilartyViewCellDidSelectedWithProductCode:(NSString *)productCode
{
    //    [self jumpBackWithAnimal:YES];
    SProductDetailViewController *productVC = [[SProductDetailViewController alloc] init];
    productVC.productID = productCode;
    [self.target.navigationController pushViewController:productVC animated:YES];
}

#pragma mark ProductCollocationViewDelegate
- (void)ProductCollocationViewViewDidScroll:(UIScrollView *)scrollView
{
    //    _bgTableView.delegate = nil;
    [self resizeSelectedModuleViewFrameWithScrollView:scrollView];
    //    _bgTableView.delegate = self;
}

- (void)productCollocationViewCellDidSelectedWithProductCode:(NSString *)productCode
{
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
//        detailNoShoppingViewController.smdataModel=good;
        
        detailNoShoppingViewController.collocationId = productCode;
        [self.target.navigationController pushViewController:detailNoShoppingViewController animated:YES];
    }else{
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
//        collocationDetailVC.smdataModel=good;
        
        collocationDetailVC.collocationId = productCode;
        [self.target.navigationController pushViewController:collocationDetailVC animated:YES];
    }
    
    return ;
    //[self jumpBackWithAnimal:YES];
    SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
    detailNoShoppingViewController.collocationId = productCode;
    [self.target.navigationController pushViewController:detailNoShoppingViewController animated:YES];
}

#pragma mark SProductSelectedModuleViewDelegate
- (void)productSelectedIndex:(int)index
{
    _tagIndex = index;
    [self.contentScrollView setContentOffset:CGPointMake(index * UI_SCREEN_WIDTH, 0) animated:YES];
    /*
     if (index == 0) {
     //        self.contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*3, self.detailView.height);
     CGRect rect = self.contentScrollView.frame;
     rect.size.height = self.detailView.height;
     self.contentScrollView.frame = rect;
     //        self.bgTableView.frame = rect;
     } else {
     //        self.contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*3, 0);
     self.contentScrollView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50);
     //        self.bgTableView.frame = self.view.bounds;
     }
     */
}

#pragma mark SProductDetaileModuleViewDelegate
- (void)SProductDetaileModuleViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect = self.selectedModuleView.frame;
    if (scrollView.contentOffset.y<=0) {
        rect.origin.y = _hiddenH+fabs(scrollView.contentOffset.y);
    }
    /*
    if (scrollView.contentOffset.y>-_hiddenH) {
        rect.origin.y = _hiddenH;
        self.selectedModuleView.frame = rect;
    } else if (scrollView.contentOffset.y<+_hiddenH) {
        rect.origin.y = (-scrollView.contentOffset.y+_hiddenH);
        self.selectedModuleView.frame = rect;
    }
     */
}

- (void)SProductDetaileModuleViewaddHeaderJump
{
    if (_delegate && [_delegate respondsToSelector:@selector(sproductSubVcDismissWithTimer:isReturnTop:)]) {
        _selectedModuleView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, kSelectModuleViewH);
        [_delegate sproductSubVcDismissWithTimer:0.25 isReturnTop:NO];
    }
}

#pragma mark SProductListReturnTopControlDelegate
-(void)returnTopControlClick{
    if (_delegate && [_delegate respondsToSelector:@selector(sproductSubVcDismissWithTimer:isReturnTop:)]) {
        _selectedModuleView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, kSelectModuleViewH);
        [_delegate sproductSubVcDismissWithTimer:0.25 isReturnTop:YES];
    }
}

#pragma mark - other
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


















#pragma mark - ***备用方法 暂时弃用***
- (CGFloat)getHeight
{
    CGFloat height = 0;
    CGSize size = [_contentModel.goodsDetailModel.clsInfo.name boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 35, 0) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    height = size.height+30;
    size = [_contentModel.goodsDetailModel.clsInfo.aDescription boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    height += size.height+30;
    
    return height;
}



@end
