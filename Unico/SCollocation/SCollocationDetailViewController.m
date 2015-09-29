//
//  SCollocationDetailViewController.m
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SCollocationDetailViewController.h"
#import "SCollocationDetailCollectionReusableView.h"
#import "SCollocationDetailModel.h"
#import "MBGoodsDetailsModel.h"
#import "SDataCache.h"
#import "WaterFLayout.h"
#import "HttpRequest.h"
#import "LNGood.h"
#import "SUtilityTool.h"
#import "WeFaFaGet.h"
#import "UIScrollView+MJRefresh.h"
#import "SDiscoveryUserModel.h"
#import "Toast.h"
#import "SWaterAdvertCollectionViewCell.h"
#import "SWaterCollectionViewCell.h"
#import "SDiscoverySelectedButton.h"
#import "MyShoppingTrollyViewController.h"
#import "MBAddShoppingViewController.h"
#import "ShoppIngBagShowButton.h"
#import "CollocationPopView.h"
#import "ShareRelated.h"

#import "SMainViewController.h"
#import "CommunityCollectionView.h"

NSString *isCollocationDetailLike = @"";
@interface SCollocationDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WaterFLayoutDelegate,collocationPopViewDelegate,UIActionSheetDelegate>
{
    NSInteger _pageIndex;
    UIImageView *shareImgView;
    UIAlertView *showAlertView;
    UIView *hiddenView;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic, weak) CollocationPopView *popView;
//----------
@property (nonatomic, weak) IBOutlet UIButton *touchToTopButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabbarButtons;
@property (weak, nonatomic) IBOutlet UIView *tabbarContentView;
- (IBAction)tabbarButtonsTouch:(UIButton *)sender;

//=-------
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, strong) NSArray *contentTypeArray;
@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, strong) NSArray *collocationSubProduct;
@property (nonatomic, strong) UIButton *navigationLikeButton;
@property (nonatomic, weak) UIView *noneDataView;

@end

static NSString *headerIdentifier = @"SCollocationDetailHeaderIdentifier";
static NSString *cellIdentifier = @"SCollocationDetailCellIdentifier";
@implementation SCollocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    shareImgView =[[UIImageView alloc]init];

    if (!_fromControllerName) {
        NSInteger count = self.navigationController.viewControllers.count - 2;
        if (count > 0) {
            _fromControllerName = NSStringFromClass([self.navigationController.viewControllers[count] class]);
        }
    }
    [self initNavigationBar];
    [self setupNavbar];
    [self initSubViews];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self requestCarCount];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setupNavbar{
    [super setupNavbar];
    self.navigationItem.titleView = nil;
    //隐藏导航栏黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (void)initSubViews{
    WaterFLayout *layout = [[WaterFLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentCollectionView.collectionViewLayout = layout;
    self.contentCollectionView.alwaysBounceVertical = YES;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = COLOR_C4;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SCollocationDetailCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterCellIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterAdvertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterAdvertCellIdentifier];
    
    [_contentCollectionView addHeaderWithTarget:self action:@selector(requestRefreshCollocationList)];
    [_contentCollectionView addFooterWithTarget:self action:@selector(requestAddDataCollocationList)];
    
    [self initTabbarButtons];
}

- (void)initTabbarButtons{
    for (UIButton *button in _tabbarButtons) {
        CGRect frame = button.frame;
        frame.size.width *= SCALE_UI_SCREEN;
        frame.origin.x *= SCALE_UI_SCREEN;
        button.frame = frame;
        
        if ([_tabbarButtons indexOfObject:button] < 2) {
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

- (void)initNavigationBar{
    _navigationLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationLikeButton addTarget:self action:@selector(setLikeState) forControlEvents:UIControlEventTouchUpInside];
    [_navigationLikeButton setFrame:CGRectMake(0, 20,88/2,88/2)];
    [_navigationLikeButton setImage:[UIImage imageNamed:@"Unico/navigation_icon_like_white_normal"] forState:UIControlStateNormal];
    [_navigationLikeButton setImage:[UIImage imageNamed:@"Unico/navigation_icon_like_white_selected"] forState:UIControlStateSelected];
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn addTarget:self action:@selector(showPopView) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake(0, 20,88/2,88/2)];
    [shareBtn setImage:[UIImage imageNamed:@"Unico/icon_home_point"] forState:UIControlStateNormal];
 
    UIBarButtonItem *rightItem0 = [[UIBarButtonItem alloc]initWithCustomView:_navigationLikeButton];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
      UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.leftBarButtonItems = @[left1];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem2, rightItem1, rightItem0];
}

- (void)onBack:(UIBarButtonItem*)barItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCart{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *controller = [[MyShoppingTrollyViewController alloc]initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self pushController:controller animated:YES];
    }
}

- (void)requestData{
    if (_mb_collocationId) {
        [self requestCollocationIdForMBCollocationID];
    }else{
        [self requestDataForCollocationID];
    }
//    [self requestCollocationListForCollocation];
}

- (void)requestDataForCollocationID{
    NSDictionary *params = @{
                           @"m":@"Collocation",
                           @"a":@"getCollocationDetailsV2",
                           @"cid":_collocationId
                           };
    [[SDataCache sharedInstance] quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        [self.contentCollectionView headerEndRefreshing];
        if ([object[@"status"]intValue] <= 0) {
            [Toast makeToast:@"网络错误，请重试！"];
        }else{
            self.contentModel = [[SCollocationDetailModel alloc]initWithDictionary:object[@"data"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentCollectionView headerEndRefreshing];
        [Toast makeToast:kHomeNoneInternetTitle];
    }];
}

- (void)requestCollocationIdForMBCollocationID{
    NSDictionary *params = @{
                             @"m":@"Collocation",
                             @"a":@"getCollocationDetailsV2",
                             @"mbfun_id": _mb_collocationId
                             };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        [self.contentCollectionView headerEndRefreshing];
        if ([object[@"status"] intValue] != 1){
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
        }else{
            self.collocationId = [NSString stringWithFormat:@"%@",object[@"data"][@"id"]];
            self.contentModel = [[SCollocationDetailModel alloc]initWithDictionary:object[@"data"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentCollectionView headerEndRefreshing];
        [Toast makeToast:kHomeNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

- (void)requestCollocationSubProductInfo{
    if (_contentModel.itemIdArray.count <= 0){
        _contentModel.productArray = @[];
        [_contentCollectionView reloadData];
        return;
    }
    //这方法 要废弃的 要采用下面的借口
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductClsFilter" params:@{@"ids": _contentModel.itemIdArray} success:^(NSDictionary *dict) {
        if ([dict[@"isSuccess"] intValue] == 1) {
            self.collocationSubProduct = [MBGoodsDetailsModel modelArrayForDataArray:dict[@"results"]];
            [_contentCollectionView reloadData];
        }else{
            [Toast makeToast:@"相关单品获取失败！"];
        }
    } failed:^(NSError *error) {
        [Toast makeToast:kHomeNoneInternetTitle];
    }];
}

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
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }
        else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }

    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - list request
- (void)requestCollocationListForCollocation{
    NSDictionary *param = @{
                            @"cid":_collocationId,
                            @"page":@(_pageIndex)
                            };
    [[SDataCache sharedInstance] get:@"Collocation" action:@"getCollocationListForDetails" param:param success:^(AFHTTPRequestOperation *operation, id object) {
        [self.contentCollectionView footerEndRefreshing];
        if ([object[@"status"] intValue] == 1) {
            if (_pageIndex == 0) {
                self.contentModelArray = [LNGood modelArrayForDataArray:object[@"data"]];
            }else{
                if ([object[@"data"] count] == 0) {
                    [Toast makeToast:@"已经到底了！"];
                }else{
                    [self.contentModelArray addObjectsFromArray:[LNGood modelArrayForDataArray:object[@"data"]]];
                    [self.contentCollectionView reloadData];
                }
            }
        }else{
            [Toast makeToast:@"网络错误，请重试！"];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentCollectionView footerEndRefreshing];
        [Toast makeToast:kHomeNoneInternetTitle];
    }];
}

- (void)requestRefreshCollocationList{
    _pageIndex = 0;
    [self requestData];
}

- (void)requestAddDataCollocationList{
    _pageIndex = (_contentModelArray.count+ 9)/ 10;
    [self requestCollocationListForCollocation];
}

#pragma mark - set and get

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [self.contentCollectionView reloadData];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    if (!contentModel.isFind.boolValue) {
        [self showNoneData];
    }
//    UIButton *likeButton = _tabbarButtons[1];
//    likeButton.selected = contentModel.is_love.boolValue;
    _navigationLikeButton.selected = contentModel.is_love.boolValue;
    _contentModel.productArray  = _collocationSubProduct;
    _contentModel.mb_collocationId = _mb_collocationId;
    _contentModel.promotion_ID = _promotion_ID;
    _contentModel.promPlatModelArray = _promPlatModelArray;
//    [self requestCollocationSubProductInfo];
    [self.contentCollectionView reloadData];
}

//显示无数据
-(void)showNoneData{
    CGRect noneDataRect = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    if (!_noneDataView) {
        UIView *view = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:noneDataRect WithImage:NONE_DATA_ITEM andImgSize:CGSizeMake(52, 52) andTipString:@"该搭配已经被删除！" font:FONT_SIZE(18) textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
        [self.view addSubview:view];
        _noneDataView = view;
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem1];
}

- (void)setCollocationSubProduct:(NSArray *)collocationSubProduct{
    _collocationSubProduct = collocationSubProduct;
    if (_contentModel) {
        _contentModel.productArray  = collocationSubProduct;
    }
    UIButton *button = [_tabbarButtons lastObject];
    if (collocationSubProduct.count > 0) {
        button.userInteractionEnabled = YES;
        [button setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
        button.backgroundColor = UIColorFromRGB(0xfedc32);
    }else{
        return;
    }
    int stockCount = 0;
    int stateCount = 0;
    for (MBGoodsDetailsModel *model in _collocationSubProduct) {
        stockCount += model.clsInfo.stockCount.intValue <= 0? 1: 0;
        stateCount += model.clsInfo.status.intValue != 2? 1: 0;
    }
    if (stockCount == collocationSubProduct.count || stateCount == collocationSubProduct.count) {
        button.enabled = NO;
        button.backgroundColor = UIColorFromRGB(0xe2e2e2);
    }else{
        button.enabled = YES;
        button.backgroundColor = UIColorFromRGB(0xfedc32);
    }
}

- (NSArray *)contentTypeArray{
    if (_contentModel.product_list.count > 0) {
        _contentTypeArray = @[@1, @(2), @(3), @(0), @(4), @(0), @(5), @(0), @6, @0, @7];
    }else{
        _contentTypeArray = @[@1, @(2), @(3), @(0), @(5), @(0), @6, @0, @7];
    }
    return _contentTypeArray;
}

#pragma mark - 分享
-(void)showPopView
{
    if (!_popView) {
        //获取设计者信息
        
        NSString *userIdStr = [NSString stringWithFormat:@"%@", self.contentModel.user_id];
        BOOL isMy;
        
        
        if ([userIdStr isEqualToString:sns.ldap_uid]) {
            isMy=YES;
        }
        else
        {
            isMy=NO;
        }
        
        [shareImgView sd_setImageWithURL:[NSURL URLWithString:self.contentModel.img]];
        
        CollocationPopView *view = [[CollocationPopView alloc] initCollocationPopView:CGRectMake(UI_SCREEN_WIDTH - 85, 50+5, 50, 80) withIsMy:isMy];
        view.delegate = self;
        [self.view addSubview:view];

        _popView = view;
        [_popView showPop];
        return;
    }
    [_popView hidePop];
}

-(void)clickShare:(id)selector{

    if ([BaseViewController pushLoginViewController]) {
     
        ShareData *aData = [[ShareData alloc] init];
        
        NSString *shareUrl=[NSString stringWithFormat:@"%@",SHARE_URL];
        NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
        NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
        
        NSString *noLastUrlStr=detailUrlStr;
        
        if ([lastStr isEqualToString:@"?"]) {
            
            noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
            
        }
        
        shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
        
        NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=co_detail&collocalID=%@", self.collocationId];
        
        NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
        aData.shareUrl = web_urlStr;
        aData.image = [Utils reSizeImage:[Utils snapshot:shareImgView] toSize:CGSizeMake(57,57)];
        aData.descriptionStr =  [NSString stringWithFormat:@"%@",self.contentModel.content_info];

        ShareRelated *share = [ShareRelated sharedShareRelated];
        [share showInTarget:self withData:aData];
    }
}

-(void)collocationPopViewSelected:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"分享");
            
            [self clickShare:nil];
            
        }
            break;
        case 1:
        {
            NSLog(@"举报");
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *title = @"举报不良内容";
            NSString *userIdStr =[NSString stringWithFormat:@"%@",self.contentModel.user_id];
            if ([sns.ldap_uid isEqualToString:userIdStr]) {
                title = @"删除我的发布";
            }
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
        NSString *userIdStr =[NSString stringWithFormat:@"%@",self.contentModel.user_id];
        NSString *collId = [NSString stringWithFormat:@"%@",self.collocationId];
        

        if (![sns.ldap_uid isEqualToString:userIdStr]) {
            [Toast makeToastActivity:@""];
            [[SDataCache sharedInstance] addMyComplaintsInfoWithCollocationId:collId complete:^(NSArray *data, NSError *error) {
                NSString *showStr=@"";
                [Toast hideToastActivity];
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
        }else{
            
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"是否确定删除搭配？"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定",nil];
            alert.tag=10000;
            [alert show];
        }
    }
}

-(void)hiddenShowAlertView
{
    [showAlertView dismissWithClickedButtonIndex:0 animated:NO];//important
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex == 1) {
            NSString *collId =[NSString stringWithFormat:@"%@",self.collocationId];
            [[SDataCache sharedInstance] delCollocationInfo:@"" collocationId:[collId integerValue] complete:^(NSArray *data, NSError *error) {
                [Toast hideToastActivity];
                if (error) {
                    [Toast makeToast:@"删除失败，请稍候再试"];
                    return ;
                }
                else
                {
                    [Toast makeToastSuccess:@"删除成功!"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCollocation" object:nil];
                    
                    [self onBack:nil];
                    
                }
            }];
            
        }
        return;
    }
}
#pragma mark - action
- (IBAction)tabbarButtonsTouch:(UIButton *)sender {
    NSInteger index = sender.tag - 40;
    switch (index) {
        case 0:
            [SUTIL showService];
            break;
        case 1:
            [self setLikeState];
            break;
        case 2:
            [self onCart];
            break;
        case 3:
            if ([BaseViewController pushLoginViewController] && _contentModel) {
                MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
                controller.promotion_ID = [NSString stringWithFormat:@"%@",_promotion_ID];
                controller.fromControllerName = self.fromControllerName;
                controller.itemAry = _contentModel.itemIdArray;
                controller.collocationID = _contentModel.aID;
                controller.mbCollocationID =[NSString stringWithFormat:@"%@", _contentModel.mb_collocationId];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        default:
            break;
    }
}

-(void)setLikeState{
    if (![BaseViewController pushLoginViewController]){
        return;
    }
    _navigationLikeButton.enabled = NO;
//    UIButton *likeButton = _tabbarButtons[1];
    UIButton *likeButton = _navigationLikeButton;
    //喜欢
    if (!likeButton.isSelected) {

        [SDATACACHE_INSTANCE likeCollocation:self.collocationId complete:^(NSArray *data) {
               [self performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
            likeButton.selected = YES;
            likeButton.enabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"likeRefreshTableView" object:nil];
            NSDictionary *mydic = @{@"head_img":sns.myStaffCard.photo_path_big,
                                    @"nick_name":sns.myStaffCard.nick_name,
                                    @"user_id":sns.ldap_uid};
            
            SDiscoveryUserModel *userModel = [[SDiscoveryUserModel alloc]initWithDictionary:mydic];
            [_contentModel.like_user_list insertObject:userModel atIndex:0];
            _contentModel.like_count = @(_contentModel.like_count.intValue + 1);
            [self.contentCollectionView reloadData];
            _contentModel.is_love = @YES;
            isCollocationDetailLike = @"1";
            [self reloadCommunityCollectionView:_contentModel islike:likeButton.isSelected];
            
            if (self.isLikeBlock) {
                self.isLikeBlock(likeButton.isSelected);
            }
        }failure:^(NSError *error) {
            likeButton.enabled = YES;
        }];
    }//取消喜欢
    else{
        
        [SDATACACHE_INSTANCE delLikeCollocation:self.collocationId complete:^(NSArray *data) {
            likeButton.selected = NO;
            likeButton.enabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"likeRefreshTableView" object:nil];
            for (SDiscoveryUserModel *userModel in _contentModel.like_user_list) {
                if ([userModel.user_id isEqualToString:sns.ldap_uid]) {
                    [_contentModel.like_user_list removeObject:userModel];
                    break;
                }
            }
            _contentModel.is_love = @NO;
            _contentModel.like_count = @(_contentModel.like_count.intValue - 1);
            isCollocationDetailLike = @"0";
            [self.contentCollectionView reloadData];
            [self reloadCommunityCollectionView:_contentModel islike:likeButton.isSelected];
            
            if (self.isLikeBlock) {
                self.isLikeBlock(likeButton.isSelected);
            }
        } failure:^(NSError *error) {
            likeButton.enabled = YES;
        }];
    }
}
//SCollocationDetailModel
- (void)reloadCommunityCollectionView:(SCollocationDetailModel*)good islike:(BOOL)islike {
    if ([SMainViewController instance].collectionView) {
        [SMainViewController instance].collectionView.reloadBlock(good, islike);
    }
}

- (IBAction)touchToTopAction:(UIButton *)sender {
    [self.contentCollectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _touchToTopButton.hidden = scrollView.contentOffset.y < UI_SCREEN_HEIGHT;
    [_popView hidePop];
    
}

#pragma mark collection delegatr
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _contentModel? 1: 0;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SCollocationDetailCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    reusableView.contentTypeArray = self.contentTypeArray;
    reusableView.contentModel = _contentModel;
    reusableView.target = self;
    return reusableView;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeights = 0.0;
    for (NSNumber *typeNumber in self.contentTypeArray) {
        headerHeights += [self cellHeightWithType:typeNumber.intValue];
    }
    return headerHeights;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
    LNGood *goodsModel = _contentModelArray[indexPath.row];
    size.height = goodsModel.h * (size.width /goodsModel.w) + 60;
    if (goodsModel.content_info.length <= 0) size.height -= 20;
    return size;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LNGood *model = _contentModelArray[indexPath.row];
    SCollocationDetailViewController *controller = [SCollocationDetailViewController new];
    controller.collocationId = model.product_ID;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 高度返回

- (CGFloat)cellHeightWithType:(int)type{
    CGFloat cellHeight = 0.0;
    switch (type) {
        case collocationCellNone:
            cellHeight = 10.0;
            break;
        case collocationCellShowImage:
            cellHeight = UI_SCREEN_WIDTH/ _contentModel.img_width.floatValue * _contentModel.img_height.floatValue;
            break;
        case collocationCellDescription:
        {
            if (_contentModel.content_info.length > 0) {
                CGSize size = [_contentModel.content_info boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 40, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
                cellHeight = size.height + 25;
            }
        }
            break;
        case collocationCellShowTag:
            cellHeight = [self getShowTagHeight];
            break;
        case collocationCellProductList:
        {
            if (_contentModel.product_list.count > 0) {
                NSInteger count = (_contentModel.product_list.count + 2)/ 3;
                cellHeight = 50 + count * ((UI_SCREEN_WIDTH - 30)/ 3 + 30) + 5 * (count - 1);
            }
        }
            break;
        case collocationCellDesigner:
        {
            if (_contentModel.isNoneShopping) {
                cellHeight = 64;
            }else{
                SDiscoveryUserModel *designerModel = _contentModel.designer;
                if (designerModel.userSignature.length <= 0) {
                    cellHeight = 90;
                }else{
                    CGSize size = [designerModel.userSignature boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 58, 0) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
                    cellHeight = size.height + 90 - 23;
                }
            }
        }
            break;
        case collocationCellCommitments:
            cellHeight = [self getCommitmentsHeight];
            break;
        case collocationCellJump:
            cellHeight = _contentModel.like_user_list.count <= 0? 80: 120;
            break;
        case collocationCellLine:
            cellHeight = 0.5;
            break;
        case collocationCellBrandTag:
            cellHeight = [self getShowBrandTagHeight];
            break;
        case collocationCellModaInfo:
            cellHeight = [self getModaInfoHeight];
            break;
        default:
            break;
    }
    if (isnan(cellHeight)) {
        cellHeight = 0.0;
    }
    return cellHeight;
}

- (CGFloat)getShowBrandTagHeight{
    if (_contentModel.useBrand.count <= 0) return 0.0;
    CGFloat tag_X = 10.0;
    CGFloat tag_Y = 40;
    for(int i = 0; i < _contentModel.useBrand.count; i++){
        SCollocationGoodsTagModel *tagModel = _contentModel.useBrand[i];
        NSString *tagString = tagModel.text;
        CGSize size = [tagString boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 30, 0)
                                              options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width + 20 + tag_X > UI_SCREEN_WIDTH - 10) {
            tag_X = 10.0;
            tag_Y += 30;
        }
        tag_X += size.width + 25;
    }
    return tag_Y + 40;
}

- (CGFloat)getCommitmentsHeight{
    CGFloat height = 67 * SCALE_UI_SCREEN + 30;
    SDiscoveryBannerModel *model = [_contentModel.banner firstObject];
    if (model.img_width.floatValue > 0) {
        height += model.img_height.floatValue * (UI_SCREEN_WIDTH/ model.img_width.floatValue);
    }
    return height;
}

- (CGFloat)getShowTagHeight{
    if (_contentModel.tab_str.count <= 0) return 0.0;
    CGFloat tag_X = 10.0;
    CGFloat tag_Y = 40;
    for(int i = 0; i < _contentModel.tab_str.count; i++){
        SCollocationDetailTagTypeModel *tagModel = _contentModel.tab_str[i];
        CGSize size = [tagModel.contentText boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 30, 0)
                                                         options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width + 20 + tag_X > UI_SCREEN_WIDTH - 10) {
            tag_X = 10.0;
            tag_Y += 30;
        }
        tag_X += size.width + 25;
    }
    return tag_Y + 40;
}

- (CGFloat)getModaInfoHeight{
    if (_contentModel.user_json) {
        NSString *stringAge = [NSString stringWithFormat:@"%@", _contentModel.user_json[@"age"]];
        NSString *stringHeight = [NSString stringWithFormat:@"%@", _contentModel.user_json[@"height"]];
        NSString *stringWeight = [NSString stringWithFormat:@"%@", _contentModel.user_json[@"weight"]];
        if (!_contentModel.user_json[@"info"]) {
            return 0.0;
        }else if ([stringAge length] <= 0 &&
                  [stringHeight length] <= 0 &&
                  [stringWeight length] <= 0){
            return 0.0;
        }else{
            return 70.0;
        }
    }
    return 0.0;
}

-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popView hidePop];
}*/

@end

/**
    UIScrollView+UITouch (scrollview触摸事件的传递)
 */
/*
@interface UIScrollView (UITouch)

@end

@implementation UIScrollView (UITouch)


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

@end
 */
