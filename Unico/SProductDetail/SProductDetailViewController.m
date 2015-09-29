//
//  SProductDetailViewController.m
//  Wefafa
//
//  Created by unico_0 on 7/21/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SProductDetailViewController.h"
#import "SProductHeaderReusableView.h"
#import "SProductDetailModel.h"
#import "SProductDetailCommentModel.h"
#import "WeFaFaGet.h"
#import "HttpRequest.h"
#import "WaterFLayout.h"
#import "Toast.h"
#import "SDataCache.h"
#import "LNGood.h"
#import "SUtilityTool.h"

#import "SProductHeaderReusableView.h"
#import "SWaterCollectionViewCell.h"
#import "SWaterAdvertCollectionViewCell.h"
#import "SCollocationDetailViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "STopImageBottomTitleButton.h"
#import "MyShoppingTrollyViewController.h"
#import "MBAddShoppingViewController.h"
#import "ShoppIngBagShowButton.h"
#import "CollocationPopView.h"
#import "ShareRelated.h"
#import "LoginViewController.h"
#import "SProductSelectedModuleView.h"

//#import "SCollocationDetailModel.h"
#import "CommentsViewController.h"
#import "ProductSizeViewController.h"
#import "GoodCollectionController.h"

#import "SNoneProductDetailViewController.h"
#import "SProductSubViewController.h"

#import "SShoppingBagSharedInstance.h"

#define kScale [UIScreen mainScreen].bounds.size.width/750
#define WISH_MADE_SUCCESS 2323
@interface SProductDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, collocationPopViewDelegate, UIActionSheetDelegate, SProductSelectedModuleViewDelegate, SProductHeaderReusableViewDelegate, GoodCollectionControllerDelegate, UIAlertViewDelegate,
SProductSubViewControllerDelegate,SShoppingBagSharedInstanceDelegate>
{
    NSInteger _pageIndex;
    NSInteger _selectedIndex;
    UIImageView *shareImgView;
    UIAlertView *showAlertView;
    
    BOOL _isHideStatus;
    BOOL _isHideStatusAndNaviWhenVCPop; // 用于判断是当前视图push一个控制器后，当其被POP时的导航栏的隐藏还是显示
}
@property (nonatomic, weak) UILabel *redPointLb;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabbarButtonArray;
@property (weak, nonatomic) IBOutlet UIView *tabbarContentView;
@property (nonatomic, weak) IBOutlet UIButton *touchToTopButton;

@property (nonatomic, strong) SProductDetailModel *contentModel;
@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, strong) NSArray *sizeList;
@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, weak) CollocationPopView *popView;
@property (nonatomic, strong) SProductSelectedModuleView *selectedModuleView;   // 滑动头视图
@property (nonatomic, weak) UIScrollView *headerContentScrollView;
@property (nonatomic, weak) UIView *headerSelectedContentView;
@property (nonatomic, weak) UIView *headerFunwearCommitment;
@property (nonatomic, strong) UIImageView *showNavigationBackImageView;
@property (nonatomic, weak) UIView *showNoneDataView;
@property (nonatomic, strong) UIButton *navigationShareButton;

@property (nonatomic, strong) NSMutableArray *collocationSubProduct;        // 推荐搭配数据
@property (nonatomic, strong) NSMutableArray *similarSubProduct;            // 相似单品数据
@property (nonatomic, strong) GoodCollectionController *goodCollectionVc;   // 购物袋弹出视图
@property (nonatomic, strong) SProductSubViewController *productSubVc;
@property (nonatomic, strong) SProductHeaderReusableView *reusableView;     // 单品详情内容视图
- (IBAction)tabbarButtonAction:(UIButton *)sender;
@end

static NSString *headerIdentifier = @"SProductDetailHeaderIdentifier";
@implementation SProductDetailViewController

#pragma mark - getter and setter
- (void)setContentModel:(SProductDetailModel *)contentModel{
    _contentModel = contentModel;
    if (contentModel.isNoneData) {
        _navigationShareButton.enabled = NO;
        UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
        view.backgroundColor = COLOR_C4;
        [self.view addSubview:view];
        _showNoneDataView = view;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/ 2 - 20, UI_SCREEN_HEIGHT/ 2 - 40, 40, 40)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"Unico/noItems"];
        [view addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, UI_SCREEN_WIDTH, 20)];
        label.textColor = COLOR_C6;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_t4;
        label.text = @"此商品已下架！";
        [view addSubview:label];
        return;
    }
    [_showNoneDataView removeFromSuperview];
    _navigationShareButton.enabled = YES;
    _contentModel.sizeList = self.sizeList;
    _contentModel.commentList = self.commentList;
    UIButton *button = [_tabbarButtonArray lastObject];
    if ([contentModel.goodsDetailModel.clsInfo.status intValue] != 2 || [contentModel.goodsDetailModel.clsInfo.stockCount intValue] <= 0) {
        button.selected = YES;
        [button setBackgroundColor:COLOR_C1];
    }else{
        button.selected = NO;
        [button setBackgroundColor:COLOR_C2];
    }
    
    button = _tabbarButtonArray[1];
    button.selected = contentModel.goodsDetailModel.isFavorite;
    [self.contentCollectionView reloadData];
    //    self.selectedModuleView.selectedIndex = contentModel.selectedIndex;
    //    self.selectedModuleView.commentCount = contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue;procodeCount
    //    self.selectedModuleView.similarityProductCount = contentModel.goodsDetailModel.commonCountTotal.procodeCount.intValue;
    //    self.selectedModuleView.collocationProductCount = contentModel.goodsDetailModel.commonCountTotal.collocationCount.intValue;
}

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [self.contentCollectionView reloadData];
}

- (void)setSizeList:(NSArray *)sizeList{
    _sizeList = sizeList;
    if (_contentModel) {
        _contentModel.sizeList = sizeList;
        [self.contentCollectionView reloadData];
    }
}

- (void)setCommentList:(NSArray *)commentList{
    _commentList = commentList;
    if (_contentModel) {
        _contentModel.commentList = commentList;
        [self.contentCollectionView reloadData];
    }
}

#pragma mark - UIViewController Plifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    shareImgView = [[UIImageView alloc]init];
    
    if (!_fromControllerName) {
        NSInteger count = self.navigationController.viewControllers.count - 2;
        if (count > 0) {
            _fromControllerName = NSStringFromClass([self.navigationController.viewControllers[count] class]);
        }
    }
    
    [self initNavigationBar];
    [self setupNavbar];
    [self initTabbarButtons];
    [self initSubViews];
    [self.contentCollectionView headerBeginRefreshing];
    
    // 推荐搭配
    // [self requestCollocationSubProductInfo];
    // 相似单品
    // [self requestSimilarSubProductInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //_isHide个人 发布  使用过的单品中会用到
    if (_isHide) {
        //导航条和tabbar隐藏  搭配流程
        _showNavigationBackImageView.alpha = 0;
        self.navigationController.navigationBarHidden = YES;
        self.tabbarContentView.hidden = YES;
        self.contentCollectionView.frame = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-160*kScale);
    }else{
        //正常流程
        self.navigationController.navigationBarHidden = NO;
        self.tabbarContentView.hidden = NO;
        self.contentCollectionView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50);
    }
    //    if (_isHideStatusAndNaviWhenVCPop||_isHide) {
    //        self.navigationController.navigationBarHidden = YES;
    //    } else {
    //        self.navigationController.navigationBarHidden = NO;
    //    }
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //[self requestCarCount];
    [[SShoppingBagSharedInstance sharedInstance] requestCarCount];
    [_productSubVc.collocationView loadLikeData];
    
    [[SShoppingBagSharedInstance sharedInstance] requestCarCount];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
    //    NSArray *viewControllers = self.navigationController.viewControllers;
    //    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
    //        // View is disappearing because a new view controller was pushed onto the stack
    //        NSLog(@"New view controller was pushed");
    //    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
    //        // View is disappearing because it was popped from the stack
    //        NSLog(@"View controller was popped");
    //    }
}

#pragma mark - Init View
#pragma mark - 初始化navigationbar
- (void)initNavigationBar{
    //leftBatItem 设置返回item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    //rightBarItem 添加购物篮
    /*
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shoppingBagItem = [[UIBarButtonItem alloc] initWithCustomView:_shoppingBagButton];
    */
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:[SShoppingBagSharedInstance sharedInstance]];
    [SShoppingBagSharedInstance sharedInstance].delegate = self;
    
    //rightBarItem 添加分享
    _navigationShareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_navigationShareButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_navigationShareButton addTarget:self action:@selector(onlist:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationShareButton setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationShareButton];
    
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, shareItem, rightItem];
}

#pragma mark 设置导航栏bar
- (void)setupNavbar{
    [super setupNavbar];
    self.navigationItem.titleView = nil;
    
    // 隐藏导航栏黑线
    self.tabBarController.navigationController.navigationBar.shadowImage = [UIImage new];
    //self.navigationController.navigationBar.clipsToBounds = YES;
}

#pragma mark 初始化tabbar上的buttons
- (void)initTabbarButtons{
    for (UIButton *button in _tabbarButtonArray) {
        CGRect frame = button.frame;
        frame.size.width *= SCALE_UI_SCREEN;
        frame.origin.x *= SCALE_UI_SCREEN;
        button.frame = frame;
        
        if ([_tabbarButtonArray indexOfObject:button] < 2) {
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(CGRectGetMaxX(frame), 7, 0.5, frame.size.height - 14);
            layer.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
            layer.zPosition = 5;
            [self.tabbarContentView.layer addSublayer:layer];
        }
    }
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5);
    layer.backgroundColor = UIColorFromRGB(0xd9d9d9).CGColor;
    layer.zPosition = 5;
    [self.tabbarContentView.layer addSublayer:layer];
}

#pragma mark 初始化主视图
- (void)initSubViews{
    
    //没加载数据 禁加入购物车
    UIButton *addShopingBagButton = _tabbarButtonArray[3];
    addShopingBagButton.enabled = NO;
    [addShopingBagButton setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    
    WaterFLayout *layout = [[WaterFLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 50) collectionViewLayout:layout];
    self.contentCollectionView.alwaysBounceVertical = YES;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SProductHeaderReusableView" bundle:nil]
             forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil]
             forCellWithReuseIdentifier:waterCellIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterAdvertCollectionViewCell" bundle:nil]
             forCellWithReuseIdentifier:waterAdvertCellIdentifier];
    
    [_contentCollectionView addHeaderWithTarget:self action:@selector(requestCollocationRefreshList)];
    //[_contentCollectionView addFooterJumpWithTarget:self action:@selector(jumpVC) titleName:@""];
    //    [_contentCollectionView addFooterWithTarget:self action:@selector(requestCollocationAddList)];
    [self.view insertSubview:_contentCollectionView atIndex:0];
    
    /*
     //商品详情，尺码参考，评论 视图
     _selectedModuleView = [[SProductSelectedModuleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
     _selectedModuleView.hidden = YES;
     [self.contentCollectionView addSubview:_selectedModuleView];
     self.selectedModuleView.delegate = self;
     */
    
    /** */
    _showNavigationBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"]];
    _showNavigationBackImageView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 64);
    _showNavigationBackImageView.layer.zPosition = 10;
    _showNavigationBackImageView.alpha = 0.0;
    [self.view addSubview:_showNavigationBackImageView];
    
    // 这边加入一个lb，用于显示购物袋数量(有问题)
    CGFloat redPointLbW = 15;
    UILabel *redPointLb = [[UILabel alloc] initWithFrame:CGRectZero];
    redPointLb.backgroundColor = UIColorFromRGB(0xfd5b5e);
    redPointLb.text = @"";
    redPointLb.hidden = YES;
    redPointLb.font = FONT_t8;
    redPointLb.textColor = COLOR_C3;
    redPointLb.layer.cornerRadius = redPointLbW/2;
    redPointLb.layer.masksToBounds = YES;
    redPointLb.textAlignment = NSTextAlignmentCenter;
    UIView *bagView = [self.tabbarContentView viewWithTag:42];
    redPointLb.frame = CGRectMake(bagView.frame.size.width/2+1, 6, redPointLbW, redPointLbW);
    [bagView addSubview:redPointLb];
    self.redPointLb = redPointLb;
}

#pragma mark 初始化单品详细(下部分)
-(void)initProductSubVc{
    if (!_productSubVc) {
        _productSubVc = [[SProductSubViewController alloc] init];
        _productSubVc.delegate = self;
        _productSubVc.target = self;
    }
    _productSubVc.contentModel = self.contentModel;
    _productSubVc.productCode = self.productID;
    _productSubVc.isHide = self.isHide;
}

#pragma mark - Get Data
#pragma mark - 根据商品下架与否初始化界面
- (void)requestData{
    //商品已下架时调用
    if (!_productID) {
        _navigationShareButton.enabled = NO;
        UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
        view.backgroundColor = COLOR_C4;
        [self.view addSubview:view];
        _showNoneDataView = view;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:
                                  CGRectMake(UI_SCREEN_WIDTH/ 2 - 20, UI_SCREEN_HEIGHT/ 2 - 40, 40, 40)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"Unico/noItems"];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:
                          CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, UI_SCREEN_WIDTH, 20)];
        label.textColor = COLOR_C6;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_t4;
        label.text = @"此商品已下架！";
        [view addSubview:label];
        return;
    }
    //商品没有下架时获取详细数据
    [self requestProductDetailNew];
    
    //    [self requestCollocationList];
    //    [self requestCommentList];
    //    [self requestSizeInfo];
}

#pragma mark 商品没有下架时获取详细数据
-(void)requestProductDetailNew
{
    if (sns.ldap_uid.length==0) {
        sns.ldap_uid=@"";
    }
    
    NSDictionary *params = @{@"IDS":_productID,
                             @"loginUserId":sns.ldap_uid};
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductClsFilter" params:params success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        [self.contentCollectionView headerEndRefreshing];
        
        if ([dict[@"isSuccess"] intValue] == 1){
            NSString *total = [NSString stringWithFormat:@"%@",dict[@"total"]];
            
            if ([total intValue]<=0) {
                [Toast makeToast:@"数据错误!"];
            }
            else
            {
                if ([dict[@"results"] count]<=0) {
                    [Toast makeToast:@"数据错误!"];
                    return ;
                }
                
                self.contentModel = [[SProductDetailModel alloc]initWithDictionary:dict[@"results"][0]];
                [shareImgView sd_setImageWithURL:[NSURL URLWithString:self.contentModel.goodsDetailModel.clsInfo.mainImage]];
                [self requestSizeInfo];         // 获取尺码数据
                //  下拉刷新后回到顶部（暂不知道什么回事，这样做只是达到效果）
                [self.contentCollectionView setContentOffset:CGPointZero animated:YES];
                
                //数据加载完成 可点击加入购物车
                UIButton *addShopingBagButton = _tabbarButtonArray[3];
                [addShopingBagButton setTitleColor:COLOR_C3 forState:UIControlStateNormal];
                addShopingBagButton.enabled = YES;
                
                //数据加载完成添加上拉刷新
                [_contentCollectionView addFooterJumpWithTarget:self action:@selector(jumpVC) titleName:@""];
                
                //数据加载完成刷新productSubVc
                [self initProductSubVc];
            }
        }else{
            [Toast makeToast:@"网络错误，请重试！"];
        }
    } failed:^(NSError *error) {
        //        [Toast makeToast:@"获取商品失败！" duration:3.0 position:@"center"];
        [self.contentCollectionView headerEndRefreshing];
        [Toast hideToastActivity];
        [Toast makeToast:kHomeNoneInternetTitle];
        //[Utils getSNSString:[NSString stringWithFormat:@"%@",error]]];
        //
    }];
}

#pragma mark 获取尺码数据
- (void)requestSizeInfo{//改成code
    
    //,_contentModel.goodsDetailModel.clsInfo.code]//810272   新  得
    
    [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductSizeTableFilter" params:@{@"proD_CLS_ID": [NSString stringWithFormat:@"%@",_contentModel.goodsDetailModel.clsInfo.code]} success:^(NSDictionary *dict) {
        if([dict[@"isSuccess"] intValue] == 1){
            self.sizeList = dict[@"results"];
        }else{
            //            [Toast makeToast:@"尺码信息获取失败!"];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - Event Processing
#pragma mark - 上拉 跳转到单品详情(下半部分)
- (void)jumpVC
{
    [self initProductSubVc];
    [self showInView:self.view];
    //[self.view addSubview:self.tabbarContentView];
    [self.view insertSubview:self.tabbarContentView aboveSubview:_productSubVc.view];
}

#pragma mark 监听下拉刷新状态
-(void)returRefreshingnState:(NSInteger)state{
    switch (state) {
        case 1:{
            for (UIView *view in [_reusableView.selectedContentView subviews]) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
                    [UIView animateWithDuration:0.15 animations:
                     ^{
                         view.transform = transform;
                     }];
                }
            }
        }
            break;
        case 2:{
            for (UIView *view in  [_reusableView.selectedContentView subviews]) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
                    [UIView animateWithDuration:0.15 animations:
                     ^{
                         view.transform = transform;
                     }];
                }
            }
        }
            break;
        case 3:
            
            break;
        default:
            break;
    }
}



- (void)showInView:(UIView *)view
{
    _isHideStatusAndNaviWhenVCPop = YES;
    
    [view addSubview:_productSubVc.view];
    
    if (self.isHide) {
        _showNavigationBackImageView.alpha = 0;
        _showNavigationBackImageView.hidden = YES;
        _productSubVc.selectedModuleView.frame = CGRectMake(0, 44, UI_SCREEN_WIDTH, 44.f);
        self.navigationController.navigationBarHidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    } else {
        _showNavigationBackImageView.hidden = NO;
        _productSubVc.selectedModuleView.frame = CGRectMake(0, 64, UI_SCREEN_WIDTH, 44.f);
        self.navigationController.navigationBarHidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    _isHideStatus = YES;
    
    _productSubVc.view.transform = CGAffineTransformMakeTranslation(0, _productSubVc.view.bounds.size.height); // 1
    [UIView animateWithDuration:.25f animations:^{
        [_productSubVc.view setTransform:CGAffineTransformIdentity]; // 2
        self.contentCollectionView.top = -self.view.height; // 4
    } completion:^(BOOL finished) {
        MBGoodsDetailsModel *goodsModel = _contentModel.goodsDetailModel;
        self.navigationItem.title = goodsModel.clsInfo.name;
        //        self.navigationController.navigationBarHidden = YES;
        //        NSLog(@"11__%@", self.productSubVc.view);
        //        self.productSubVc.view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50);
        //        NSLog(@"11__%@", self.contentCollectionView);
        //        self.contentCollectionView.frame = CGRectMake(0, -UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50);
    }];
}

#pragma mark 下拉 刷新当前商品数据
- (void)requestCollocationRefreshList{
    _pageIndex = 0;
    [self requestData];
}

#pragma mark 返回上一级
- (void)onBack:(UIBarButtonItem*)barItem{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 添加分享
- (void)onlist:(UIButton*)sender {
    
    //    if ([BaseViewController pushLoginViewController]) {
    
    ShareData *shareData = [[ShareData alloc]init];
    
    shareData.title =self.contentModel.goodsDetailModel.clsInfo.name;
    shareData.descriptionStr = self.contentModel.goodsDetailModel.clsInfo.aDescription;
    
    //        NSString *url=[SHOPPING_GUIDE_ITF createShareGoodsUrl:sns.ldap_uid CollocationID:@"" ProductClsID:[Utils getSNSString:[NSString stringWithFormat:@"%@",self.contentModel.goodsDetailModel.clsInfo.aID]] designerId:@""];
    //单品分享url
    
    NSString *shareUrl=[NSString stringWithFormat:@"%@",SHARE_PROD_URL];
    NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
    
    NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
    
    NSString *noLastUrlStr=detailUrlStr;
    
    if ([lastStr isEqualToString:@"?"]) {
        
        noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
        
    }
    
    shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
    
    NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=item_detail&productID=%@",self.productID];
    
    NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
    
    
    
    shareData.shareUrl = [NSString stringWithFormat:@"%@",web_urlStr];
    
    shareData.image = [Utils reSizeImage:shareImgView.image toSize:CGSizeMake(57,57)];
    shareData.shopId = [NSString stringWithFormat:@"%@",self.contentModel.goodsDetailModel.clsInfo.aID];
    ShareRelated *view = [ShareRelated sharedShareRelated];
    [view showInTarget:self withData:shareData];
    
    //    }
}

#pragma mark 加入购物袋动画
- (void)showSendMessageSuccess{
    /*
     UIImageView *imgV = [[UIImageView alloc] init];
     NSString *strUrl = _contentModel.goodsDetailModel.clsInfo.mainImage;
     [imgV sd_setImageWithURL:[NSURL URLWithString:strUrl]];
     placeholderImage:[UIImage imageNamed:@"DEFAULT_LOADING_IMAGE"];
     imgV.frame = CGRectMake(10, UI_SCREEN_WIDTH/3, 120, 120);
     [self.view addSubview:imgV];
     // self.tabbarContentView.bounds.size
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(120, 120), NO, 3.0);  //NO，YES 控制是否透明
     [imgV.layer renderInContext:UIGraphicsGetCurrentContext()]; // self.tabbarContentView
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
     imageView.frame = imgV.frame;//self.tabbarContentView.frame;
     [self.view addSubview:imageView];
     [imgV removeFromSuperview];
     
     [UIView animateWithDuration:0.25 animations:^{
     imageView.frame = CGRectMake(UI_SCREEN_WIDTH - 80, 20, 40, 40);
     }completion:^(BOOL finished) {
     [self requestCarCount];
     [imageView removeFromSuperview];
     }];
     */
    
    UIImageView *picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/pic_addtobag"]];
    [picImageView setFrame:CGRectMake(UI_SCREEN_WIDTH/2-17, UI_SCREEN_HEIGHT/2-35, 35, 35)];
    [[UIApplication sharedApplication].keyWindow addSubview:picImageView];
    
    [UIView animateWithDuration:1.f animations:^(void){
        CAKeyframeAnimation *vibrateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        vibrateAnimation.values = @[@0.8,@1.2,@0.8,@1];
        vibrateAnimation.keyTimes = @[@0,@0.2,@.4,@0.5];
        vibrateAnimation.duration = .5;
        vibrateAnimation.beginTime= 0;
        vibrateAnimation.removedOnCompletion = YES;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:picImageView.center];
        [bezierPath addQuadCurveToPoint:CGPointMake(UI_SCREEN_WIDTH-60, 28) controlPoint:CGPointMake(UI_SCREEN_WIDTH/2-17, 30)];
        
        CAKeyframeAnimation * pathPositionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathPositionAnimation.path = bezierPath.CGPath;
        pathPositionAnimation.duration = .5;
        pathPositionAnimation.beginTime = vibrateAnimation.duration;
        pathPositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        pathPositionAnimation.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.duration = .5;
        scaleAnimation.beginTime = vibrateAnimation.duration;
        scaleAnimation.removedOnCompletion = YES;
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[vibrateAnimation, pathPositionAnimation, scaleAnimation];
        animationGroup.duration = vibrateAnimation.duration+pathPositionAnimation.duration;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode=kCAFillModeForwards;
        [picImageView.layer addAnimation:animationGroup forKey:@"picImageAnimationGroup"];
        
        picImageView.alpha = 0.8;
    }completion:^(BOOL finished){
        [picImageView removeFromSuperview];
        [[SShoppingBagSharedInstance sharedInstance] requestCarCount];
    }];
}

#pragma mark - 底部tabbar功能栏实现
#pragma mark 视图功能栏绑定的事件
- (IBAction)tabbarButtonAction:(UIButton *)sender {
    //    [self sproductSubVcDismissWithTimer:0.f];
    
    NSInteger index = sender.tag - 40;
    switch (index) {
        case 0:
            // 客服
            [SUTIL showService];
            break;
        case 1:
            //  收藏
            [self likeContent:nil];
            break;
        case 2:
            // 购物袋
            [self onCart];
            break;
        case 3:
        {
            // 加入心愿单（加入购物袋）
            if ([BaseViewController pushLoginViewController] && _contentModel) {
                if (sender.selected == YES) {
                    // 心愿单
                    [self addWishAction];
                }else{
                    if (!_goodCollectionVc) {
                        __unsafe_unretained typeof(SShoppingBagSharedInstance) *p_self = [SShoppingBagSharedInstance sharedInstance];
;
                        //__weak SProductDetailViewController *weakSelf = self;
                        _goodCollectionVc = [[GoodCollectionController alloc] initWithParameter:_contentModel productCode:self.productID promotion_ID:self.promotion_ID];
                        _goodCollectionVc.block = ^(NSDictionary *dict){
                            [p_self  requestCarCount];
                        };
                        _goodCollectionVc.delegate = self;
                    }
                    [_goodCollectionVc showInView:self.navigationController.view];
                }
                
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 点击收藏
-(void)likeContent:(id)selector{
    if (![BaseViewController pushLoginViewController]){
        return;
    }
    
    if (!sns.isLogin) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    
    
    BOOL isLike = _contentModel.goodsDetailModel.isFavorite;
    UIButton *collectButton = _tabbarButtonArray[1];
    //喜欢
    if (!isLike) {
        [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
        [Toast makeToastActivity:@"正在收藏..." hasMusk:NO];
        NSMutableArray *favoriteList = [NSMutableArray new];
        if(sns.ldap_uid.length==0)
            return;
        //        NSDictionary *param=@{
        //                              @"userId":sns.ldap_uid,//大写U以前 小写u
        //                              @"sourcE_TYPE":@(1),
        //                              @"sourcE_ID": [NSNumber numberWithInteger:[_contentModel.goodsDetailModel.clsInfo.aID intValue]],
        //                              @"creatE_USER":sns.myStaffCard.nick_name
        //                              };
        NSDictionary *param=@{
                              @"userId":sns.ldap_uid,
                              @"sourcE_TYPE":@"1",
                              @"product_code": [NSNumber numberWithInteger:[_contentModel.goodsDetailModel.clsInfo.code intValue]],
                              @"creatE_USER":sns.myStaffCard.nick_name
                              };
        NSLog(@"param------%@",param);
        
        
        [favoriteList addObject:param];
        
        NSDictionary * postParam =@{@"favoriteList":favoriteList};
        
        //kMBServerNameTypeOrder
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCProduct methodName:@"FavoriteCreateList" params:postParam success:^(NSDictionary *dict) {
            [Toast hideToastActivity];
            
            NSLog(@"FavoriteCreateList -- %@", dict[@"message"]);
            if ([dict[@"isSuccess"] intValue] == 1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"productRefresh" object:nil userInfo:nil];
                _contentModel.goodsDetailModel.isFavorite = YES;
                collectButton.selected = YES;
                _contentModel.goodsDetailModel.commonCountTotal.favoritCount = @(_contentModel.goodsDetailModel.commonCountTotal.favoritCount.intValue + 1);
                [self.contentCollectionView reloadData];
            }
            else
            {
                [Toast hideToastActivity];
                [Toast makeToast:dict[@"message"]];
            }
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
            [Toast makeToast:@"收藏失败"];
        }];
    }else {
        if(sns.ldap_uid.length==0)
            return;
        [Toast makeToastActivity:@"正在取消收藏..." hasMusk:NO];
        //        NSDictionary *param=@{
        //                              @"sourcE_TYPE":@1,
        //                              @"sourceIdS":_contentModel.goodsDetailModel.clsInfo.aID,
        //                              @"userId": sns.ldap_uid,
        //                              };
        //
        
        NSMutableArray *favoriteList = [NSMutableArray new];
        NSDictionary *param=@{
                              @"userId":sns.ldap_uid,
                              @"sourcE_TYPE":@"1",
                              @"product_code": [NSNumber numberWithInteger:[_contentModel.goodsDetailModel.clsInfo.code intValue]],
                              @"creatE_USER":sns.myStaffCard.nick_name
                              };
        NSLog(@"param------%@",param);
        
        
        [favoriteList addObject:param];
        
        NSDictionary * postParam =@{@"favoriteList":favoriteList};
        
        [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCProduct methodName:@"FavoriteDelete" params:postParam success:^(NSDictionary *dict) {
            
            [Toast hideToastActivity];
            //            [Toast makeToast:dict[@"message"]];
            NSLog(@"FavoriteDelete -- %@", dict[@"message"]);
            if ([dict[@"isSuccess"] intValue] == 1) {
                
                NSDictionary *dic=@{@"clsinfoid":[NSNumber numberWithInteger:[_contentModel.goodsDetailModel.clsInfo.aID intValue]],
                                    @"method": @"delete",
                                    @"type": @"good"};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDelete" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"productRefresh" object:nil userInfo:nil];
                
                _contentModel.goodsDetailModel.commonCountTotal.favoritCount = @(_contentModel.goodsDetailModel.commonCountTotal.favoritCount.intValue - 1);
                collectButton.selected = NO;
                [self.contentCollectionView reloadData];
                _contentModel.goodsDetailModel.isFavorite = NO;
            }
            else
            {
                [Toast hideToastActivity];
                [Toast makeToast:@"收藏失败"];
            }
        } failed:^(NSError *error) {
            [Toast hideToastActivity];
            [Toast makeToast:@"收藏失败"];
        }];
    }
}

#pragma mark 点击购物袋
- (void)onCart{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *controller =
        [[MyShoppingTrollyViewController alloc]initWithNibName:@"MyShoppingTrollyViewController"
                                                        bundle:nil];
        [self pushController:controller animated:YES];
    }
}


#pragma mark 点击心愿单
- (void)addWishAction{
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    //取消delLikeWish($token, $tempId,$type=1)
    NSDictionary *data = @{
                           @"m": @"Wish",
                           @"a": @"likeWish",
                           @"token":userToken,
                           @"tempId":self.productID,
                           @"type":@"1",
                           };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        
        if ([object[@"status"] intValue] == 1) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"加入心愿单成功!"
                                                             message:@"此商品现已售罄,我们会尽快补货!"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
            alertView.tag = WISH_MADE_SUCCESS;
            alertView.delegate = self;
            [alertView show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"加入心愿单失败!"
                                                         message:@"请稍候重试!"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

#pragma mark - Delegate and DataSource
#pragma mark - SProductSelectedModuleViewDelegate
- (void)productSelectedIndex:(int)index{
    [self.headerContentScrollView setContentOffset:CGPointMake(index * UI_SCREEN_WIDTH, 0) animated:YES];
    _contentModel.selectedIndex = index;
    if (!_headerSelectedContentView) return;
    [self.contentCollectionView setContentOffset:CGPointMake(0, _headerSelectedContentView.top - 64) animated:YES];
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    //    [self.contentCollectionView reloadData];
}


#pragma mark SProductSubViewControllerDelegate
- (void)sproductSubVcDismissWithTimer:(NSTimeInterval)timer isReturnTop:(BOOL)returnTop
{
    //跳回首页 navigationItem title设为空
    self.navigationItem.title = nil;
    
    _isHideStatusAndNaviWhenVCPop = NO;
    
    _isHideStatus = NO;
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.contentCollectionView.top = 0;
        self.productSubVc.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.productSubVc.view.frame.size.height); // 3
    } completion:^(BOOL finished) {
        if (returnTop) {
            self.contentCollectionView.contentOffset = CGPointMake(0, 0);
        }
        //        [[self view] removeFromSuperview];
        //        self.navigationController.navigationBarHidden = NO;
        //        NSLog(@"22__%@", self.productSubVc.view);
        //        self.productSubVc.view.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        //        NSLog(@"22__%@", self.contentCollectionView);
        //        self.contentCollectionView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-50);
    }];
    
    if (_isHide) {
        self.contentCollectionView.frame = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-160*kScale-44.f);
        self.navigationController.navigationBarHidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView != _headerContentScrollView) return;
    int index = scrollView.contentOffset.x/ UI_SCREEN_WIDTH;
    self.selectedModuleView.selectedIndex = index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (_isHide) {
        return;
    }
    
    if (scrollView != _contentCollectionView) return;
    /*
     CGPoint location = scrollView.contentOffset;
     CGFloat alphaBack = 0.0;
     CGFloat max_Y = _headerSelectedContentView.top;
     if (location.y >= max_Y) {
     alphaBack = 1;
     }else if(location.y <= 0){
     alphaBack = 0;
     }else{
     alphaBack = (1 - (max_Y - location.y)/ max_Y);
     }
     NSLog(@"%f",alphaBack);
     */
    _showNavigationBackImageView.alpha = scrollView.contentOffset.y/200;
    
    /*
     CGPoint commitmentLocation = [_contentCollectionView convertPoint:_headerFunwearCommitment.frame.origin toView:self.view];
     if (commitmentLocation.y <= 64 + _headerSelectedContentView.height) {
     self.selectedModuleView.top = _headerFunwearCommitment.top - _headerSelectedContentView.height;
     
     }else{
     CGPoint point = [_contentCollectionView convertPoint:_headerSelectedContentView.frame.origin toView:self.view];
     if (point.y <= 64) {
     self.selectedModuleView.top = [_contentCollectionView convertPoint:CGPointMake(0, 64) fromView:self.view].y;
     }else{
     self.selectedModuleView.top = _headerSelectedContentView.top;
     }
     }
     */
    
    _touchToTopButton.hidden = scrollView.contentOffset.y < UI_SCREEN_HEIGHT;
}

#pragma mark GoodCollectionControllerDelegate
- (void)goodsCollectionController:(GoodCollectionController *)goodCollectionVC
                      doneClicked:(UIButton *)doneBtn
{
    [goodCollectionVC hide];
}
/*
 - (void)goodsCollectionController:(GoodCollectionController *)goodCollectionVC
 cancaelClicked:(UIButton *)cancaelBtn
 {
 [goodCollectionVC hide];
 }*/

-(void)goodsCollectionController:(GoodCollectionController *)goodCollectionVC isBuySuccesss:(BOOL)isBuy{
    if (isBuy) {
        //        [self requestCarCount];
        [self showSendMessageSuccess];
    }
}

#pragma mark SProductHeaderReusableViewDelegate
- (void)productHeaderOprationActivityList{
    [self.contentCollectionView reloadData];
}

#pragma mark 跳转评论列表界面
- (void)productHeaderPUshToCommmentViewWithParamete:(id)parameter
{
    CommentsViewController *commentsVc = [[CommentsViewController alloc]initWithNibName:@"CommentsViewController" bundle:nil];
    commentsVc.productID = [NSString stringWithFormat:@"%@",_contentModel.goodsDetailModel.clsInfo.code];
    //    int commentCount = _contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue;
    //    int commentScore = _contentModel.goodsDetailModel.commonCountTotal.avgComment.intValue * _contentModel.goodsDetailModel.commonCountTotal.commentCount.intValue;
    //    commentsVc.commentCount = commentCount;
    //    commentsVc.commentTotalScore = commentScore;
    [self.navigationController pushViewController:commentsVc animated:YES];
}

#pragma mark 跳转尺码参数界面
- (void)productHeaderPushToSizeViewWithParameter:(id)parameter
{
    ProductSizeViewController *productSizeVc = [[ProductSizeViewController alloc] init];
    productSizeVc.modelArr = _contentModel.sizeList;
    [self.navigationController pushViewController:productSizeVc animated:YES];
}

#pragma mark 上拉加载
- (void)similarFootRefreshWithDataBlock:(SimilarDataBlock)similarData
{
    NSDictionary *params = @{
                             @"m":@"Product",
                             @"a":@"getRecommedProductList",
                             @"token":@""
                             };
    
    [HttpRequest productGetRequestPath:@"Product" methodName:@"getRecommedProductList"
                                params:params success:^(NSDictionary *dict)
     {
         //MODEL要重新写一下
         //         NSLog(@"dict___%@", dict);
         if ([dict[@"status"] intValue] == 1) {
             self.similarSubProduct = dict[@"data"];
             similarData(self.similarSubProduct);
         }else{
             [Toast makeToast:@"相似单品获取失败！"];
         }
     } failed:^(NSError *error) {
         [Toast makeToast:kNoneInternetTitle];
     }];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;//_contentModelArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _contentModel? 1: 0;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    _reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    _reusableView.delegate = self;
    _headerSelectedContentView = _reusableView.selectedContentView;
    _headerFunwearCommitment = _reusableView.funwearCommitmentView;
    self.selectedModuleView.frame = _reusableView.selectedContentView.frame;
    _selectedModuleView.hidden = YES;// NO
    _reusableView.contentModel = _contentModel;
    
    _reusableView.collocationArr = @[];//self.collocationSubProduct;
    _reusableView.smiilartyArr = self.similarSubProduct;
    _reusableView.target = self;
    if (_contentModel.isShowActivity) {
        self.selectedModuleView.top = _reusableView.activityContentView.top + 50 + _contentModel.activtiyArray.count * 44 + _reusableView.brandContentView.height + 16 + _reusableView.funwearCommitmentView.height + 100.5 + 8*2;
    } else {
        self.selectedModuleView.top = _reusableView.activityContentView.top + 50 + _reusableView.brandContentView.height + 16 + _reusableView.funwearCommitmentView.height + 100.5 + 8*2;
    }
    /* old
     if(_isOpenHeaderActivity){
     self.selectedModuleView.top = reusableView.activityContentView.top + 50 + _contentModel.activtiyArray.count * 44 + reusableView.brandContentView.height + 16;
     }else{
     self.selectedModuleView.top = reusableView.activityContentView.top + 50 + reusableView.brandContentView.height + 16;
     }*/
    return _reusableView;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LNGood *model = _contentModelArray[indexPath.row];
    UICollectionViewCell *cell;
    if ([model.show_type boolValue]) {
        SWaterAdvertCollectionViewCell *advertCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterAdvertCellIdentifier forIndexPath:indexPath];
        advertCell.contentGoodsModel = model;
        cell = advertCell;
    }else{
        SWaterCollectionViewCell *waterCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCellIdentifier forIndexPath:indexPath];
        waterCell.contentGoodsModel = model;
        cell = waterCell;
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (_contentModel.isShowActivity) {
        height += (_contentModel.activtiyArray.count-1) * 44;
    }
    CGSize size = [_contentModel.goodsDetailModel.clsInfo.name boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH-35, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading| NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    height += 375 + UI_SCREEN_WIDTH + size.height;
    return height;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30), 0);
    LNGood *goodsModel = _contentModelArray[indexPath.row];
    size.height = goodsModel.h * (size.width /goodsModel.w) + 60;
    if (goodsModel.content_info.length <= 0) size.height -= 20;
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LNGood *model = _contentModelArray[indexPath.row];
    SCollocationDetailViewController *controller = [SCollocationDetailViewController new];
    controller.collocationId = model.product_ID;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UIAlertViewDelegate
//加入心愿单
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == WISH_MADE_SUCCESS) {
        [self canShowPraiseBox];
    }
}

-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}

#pragma mark SShoppingBagSharedInstanceDelegate
- (void)returnShoppingBag:(SShoppingBagSharedInstance *)shoppingBag{
    [self onCart];
}






















#pragma mark - ***备用方法 暂时弃用***
#pragma mark - 获取购物袋数量信息 每次viewWillAppear时都要调用
- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]]
                                    forState:UIControlStateNormal];
            
            NSString *tempStr = [NSString stringWithFormat:@"%@", [Utils getSNSInteger:dict[@"results"][0][@"count"]]];
            if (tempStr.length > 2) {
                self.redPointLb.text = @"99+";
                self.redPointLb.size = CGSizeMake(17, 17);
                self.redPointLb.layer.cornerRadius = 17/2;
                self.redPointLb.layer.masksToBounds = YES;
            } else {
                self.redPointLb.text = tempStr;
            }
            self.redPointLb.hidden = NO;
        }
        else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
            
            self.redPointLb.text = @"";
            self.redPointLb.hidden = YES;
        }
        
    } failed:^(NSError *error) {
        
    }];
}

- (CGFloat)getCommentListSumHeight{
    if (_commentList.count <= 0) return 0.0;
    CGFloat sumHeight = 0.0;
    for (SProductDetailCommentModel *model in _commentList){
        CGSize size = [model.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 100, 0)
                                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                                  context:nil].size;
        sumHeight += size.height - 10 + 50;
    }
    return sumHeight + 84;
}

- (CGFloat)getAllImageHeightWith:(NSArray*)modelArray{
    CGFloat height = 0.0;
    for (MBGoodsDetailsPictureModel *model in modelArray) {
        if (model.width.floatValue==0) {
            
        } else {
            height += model.height.floatValue * (UI_SCREEN_WIDTH/ model.width.floatValue);
        }
        
    }
    if (isnan(height)) {
        height = 0;
    }
    return height;
}

-(void)collocationPopViewSelected:(NSInteger)index
{
    
    switch (index) {
        case 0:
        {
            [self onlist:nil];
        }
            break;
        case 1:
        {
            NSLog(@"举报");
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *title = @"举报不良内容";
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title, nil];
            [sheet showInView:self.view];
        }
            break;
            
        default:
            break;
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [Toast makeToastActivity:@""];
        [[SDataCache sharedInstance] addMyComplaintsInfoWithCollocationId:self.productID complete:^(NSArray *data, NSError *error) {
            [Toast hideToastActivity];
            //            if (error) {
            //                [Toast makeToast:@"举报失败!"];
            //                return ;
            //            }
            //            [Toast makeToast:@"举报成功!"];
            //            [Toast makeToastSuccess:@"举报成功!"];
            NSString *showStr=@"";
            if (error) {
                
                showStr=[NSString stringWithFormat:@"举报失败!"];
            }
            else
            {
                NSString *dataState=[NSString stringWithFormat:@"%@",data];
                if ([dataState isEqualToString:@"1"]) {
                    
                    showStr=[NSString stringWithFormat:@"举报成功!"];
                    
                }
                else if ([dataState isEqualToString:@"-1"]) {
                    
                    showStr = [NSString stringWithFormat:@"您已举报!"];
                    
                }
                else
                {
                    showStr=[NSString stringWithFormat:@"举报成功!"];
                }
                
            }
            
            showAlertView = [[UIAlertView alloc]initWithTitle:showStr
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
            [showAlertView show];
            [self performSelector:@selector(hiddenShowAlertView) withObject:nil afterDelay:1.0f];
        }];
    }
}

-(void)hiddenShowAlertView
{
    [showAlertView dismissWithClickedButtonIndex:0 animated:NO];//important
}

#pragma mark list request
- (void)requestCollocationList{
    //    老得
    //    NSDictionary *param = @{
    //                            @"cid": self.productID,
    //                            @"page": @(_pageIndex)
    //                            };
    NSDictionary *param = @{
                            @"cid": _contentModel.goodsDetailModel.clsInfo.code,
                            @"page": @(_pageIndex)
                            };
    
    [[SDataCache sharedInstance] get:@"Collocation" action:@"getCollocationListForDetails" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        [self.contentCollectionView footerEndRefreshing];
        if ([object[@"status"] intValue] == 1) {
            if (_pageIndex == 0) {
                self.contentModelArray = [LNGood modelArrayForDataArray:object[@"data"]];
            }else{
                if ([object[@"data"] count] <= 0) {
                    [Toast makeToast:@"已经到底了！"];
                    return;
                }
                NSArray *modelArray = [LNGood modelArrayForDataArray:object[@"data"]];
                [self.contentModelArray addObjectsFromArray:modelArray];
                [self.contentCollectionView reloadData];
            }
        }else{
            [Toast makeToast:@"网络错误，请重试！"];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentCollectionView footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

- (void)requestCommentList{
    //    NSDictionary *params = @{
    //                           @"sourcE_TYPE": @1,
    //                           @"sourcE_IDS": _productID,
    //                           @"pageIndex": @1
    //                           };//_contentModel.goodsDetailModel.clsInfo.code
    
    NSDictionary *params = @{
                             @"sourcE_TYPE": @1,
                             @"sourcE_IDS": _contentModel.goodsDetailModel.clsInfo.code,
                             @"pageIndex": @1
                             };
    [HttpRequest orderGetRequestPath:nil methodName:@"CommentFilter" params:params success:^(NSDictionary *dict) {
        if ([dict[@"isSuccess"] intValue] == 1) {
            self.commentList = [SProductDetailCommentModel modelArrayForDataArray:dict[@"results"]];
        }else{
            //            [Toast makeToast:@"评论列表获取失败!"];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark old
- (void)requestProductDetail{
    NSDictionary *params = @{@"m": @"Item",
                             @"a": @"getItemDetailsV2",
                             @"tid": _productID};
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        [self.contentCollectionView headerEndRefreshing];
        
        if ([object[@"status"] intValue] == 1){
            self.contentModel = [[SProductDetailModel alloc]initWithDictionary:object[@"data"]];
            [self requestSizeInfo];
        }else{
            [Toast makeToast:@"网络错误，请重试！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentCollectionView headerEndRefreshing];
        [Toast makeToast:kHomeNoneInternetTitle];
    }];
}

#pragma mark 相似单品
- (void)requestSimilarSubProductInfo
{
    //    NSString *codeStr = self.productID;
    NSDictionary *params = @{
                             @"m":@"Product",
                             @"a":@"getRecommedProductList",
                             @"token":@""
                             };
    [HttpRequest productGetRequestPath:@"Product" methodName:@"getRecommedProductList"
                                params:params success:^(NSDictionary *dict)
     {
         //MODEL要重新写一下
         //         NSLog(@"dict___%@", dict);
         if ([dict[@"status"] intValue] == 1) {
             self.similarSubProduct = dict[@"data"];
         }else{
             [Toast makeToast:@"相似单品获取失败！"];
         }
     } failed:^(NSError *error) {
         [Toast makeToast:kNoneInternetTitle];
     }];
}


#pragma mark 推荐搭配
- (void)requestCollocationSubProductInfo
{
    NSString *codeStr = self.productID;//[_collocationDetailModel.itemIdArray componentsJoinedByString:@","];
    //获取颜色尺码
    [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductFilter" params:@{@"prodClsIdList": codeStr} success:^(NSDictionary *dict) {
        NSLog(@"dict___%@", dict);
        //MODEL要重新写一下
        if ([dict[@"isSuccess"] intValue] == 1) {
            self.collocationSubProduct = dict[@"results"];
        }else{
            [Toast makeToast:@"相关单品获取失败！"];
        }
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle];
    }];
}

#pragma mark 获取单品详情活动
-(void)requestProductActivity
{
#warning
    return;
    [HttpRequest productPostRequestPath:@"Product" methodName:@"PromotionClsCodeFilter" params:@{@"code":_productID} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        
        if ([dict[@"isSuccess"] intValue] == 1){
            NSString *total = [NSString stringWithFormat:@"%@",dict[@"total"]];
            
            if ([total intValue]<=0) {
                [Toast makeToast:@"数据错误!"];
            }
            else
            {
                if ([dict[@"results"] count]<=0) {
                    [Toast makeToast:@"数据错误!"];
                    return ;
                }
                NSArray *activityArray=[SProductDetailActivityModel modelArrayForDataArray:dict[@"results"]];
                self.contentModel.activtiyArray = activityArray;
            }
        }else{
            [Toast makeToast:@"网络错误，请重试！"];
        }
        
    } failed:^(NSError *error) {
        //        [Toast makeToast:@"获取商品失败！" duration:3.0 position:@"center"];
        [self.contentCollectionView headerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle];
        [Toast hideToastActivity];
        
        NSLog(@"单品详情活动--MBGoodsDetailsViewController---%@", error);
    }];
}

-(void)showPopView
{
    if (!_popView) {
        CollocationPopView *view = [[CollocationPopView alloc] initCollocationPopView:CGRectMake(UI_SCREEN_WIDTH - 115, 50+5, 100, 40) withIsMy:NO];
        view.delegate = self;
        [self.view addSubview:view];
        _popView = view;
        [_popView showPop];
        return;
    }
    [_popView hidePop];
}

-(void)hiddenPop
{
    [_popView hidePop];
}

//返回到顶部
- (IBAction)touchToTopAction:(UIButton *)sender {
    [self.contentCollectionView setContentOffset:CGPointZero animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return _isHideStatus;
}


- (void)requestCollocationAddList{
    _pageIndex = (_contentModelArray.count + 9)/ 10;
    [self requestCollocationList];
}


@end
