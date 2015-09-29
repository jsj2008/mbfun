//
//  STopicDetailViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "STopicDetailViewController.h"
#import "SDataCache.h"
#import "SUtilityTool.h"
#import "StopicDetailModel.h"
#import "UIImageView+WebCache.h"
#import "StopicSelectedButton.h"
#import "SSearchCollocationCollectionView.h"
#import "LNGood.h"
#import "SCollocationDetailViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "SBrandHeaderReusableView.h"
#import "SMineViewController.h"
#import "MBSettingMainViewController.h"
#import "SCollocationLoversController.h"
#import "WeFaFaGet.h"
#import "SCollocationDetailNoneShopController.h"
#import "SUploadColllocationControlCenter.h"
#import "WaterFLayout.h"
#import "STopicDetailHeaderViewCollectionReusableView.h"
#import "UIScrollView+MJRefresh.h"
#import "Toast.h"
#import "ShareRelated.h"

typedef enum : NSUInteger {
    scrollNone = 0,
    scrollVertica,
    scrollHorizontal,
} ScrollDirection;

@interface STopicDetailViewController () <STopicDetailHeaderViewCollectionReusableViewDelegate, SSearchCollocationCollectionViewDelegate>
{
    int _selectedIndex;
    NSInteger _pageIndex;
    CGPoint _originLocation;
  __block  UIImageView *titleShareImgView;
    
}
@property (nonatomic, strong) SSearchCollocationCollectionView *contentCollectionView;
@property (nonatomic, strong) StopicDetailModel *contentModel;

- (IBAction)showMyTopicButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *showMyTopicCameraButton;

@end

static NSString *headerIdentifier = @"STopicDetailHeaderViewCollectionReusableViewIdentifier";
@implementation STopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleShareImgView= [[UIImageView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubViews];
    [self setupNavbar];
    [self requestData];
    [self.contentCollectionView headerBeginRefreshing];
}

- (void)setupNavbar{
    [super setupNavbar];
//    self.navigationItem.title = _titleName;


    self.title=_titleName;
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO
     ];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[left1];
    
    
    //rightBarItem 添加分享
   UIButton*  _navigationShareButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_navigationShareButton setFrame:CGRectMake(self.view.frame.size.width-22, 20,88/2,88/2)];
    [_navigationShareButton addTarget:self action:@selector(onlist:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationShareButton setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:_navigationShareButton];
   negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,shareItem];
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, navRect.size.height)];
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 200, navRect.size.height)];
    [tempBtn setTitle:_titleName forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempView addSubview:tempBtn];
    self.navigationItem.titleView = tempView;
}
-(void)onlist:(id)sender
{
    //分享的参数有问题
    ShareData *shareData = [[ShareData alloc]init];
    
    NSString *shareUrl=[NSString stringWithFormat:@"%@",U_SHARE_TOPIC_URL];
    NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
    NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
    NSString *noLastUrlStr=detailUrlStr;

    if ([lastStr isEqualToString:@"?"]) {
        
        noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
    }

    shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
    
    NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=topic_detail&topicID=%@",[NSString stringWithFormat:@"%@",_topicID]];
    NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];

    shareData.shareUrl = [NSString stringWithFormat:@"%@",web_urlStr];
    
    shareData.title =self.titleName;
    shareData.descriptionStr = @"";
    
    shareData.shareUrl = [NSString stringWithFormat:@"%@",web_urlStr];
    
    shareData.image = [Utils reSizeImage:titleShareImgView.image toSize:CGSizeMake(57,57)];
    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:shareData];
}
-(void)onBack:(id)sender
{
    [self popAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //
    [self setupNavbar];
}

- (void)initSubViews{
    [self initContentSubViews];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
}

- (void)initContentSubViews{
    CGRect frame = CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64);
    _contentCollectionView = [[SSearchCollocationCollectionView alloc]initWithFrame:frame];
    [self.view insertSubview:_contentCollectionView atIndex:0];
    [_contentCollectionView addFooterWithTarget:self action:@selector(requestAddListData)];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"STopicDetailHeaderViewCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:headerIdentifier];
    [_contentCollectionView addHeaderWithTarget:self action:@selector(requestListData)];
    __unsafe_unretained typeof(self) p = self;
    _contentCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        NSString * collocationId  = ((LNGood*)array[indexPath.row]).product_ID ;
        if (collocationId<0) {
            return;
        }
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        detailNoShoppingViewController.collocationId = collocationId;
        [p.navigationController pushViewController:detailNoShoppingViewController animated:YES];
    };
    _contentCollectionView.collectionDelagate = self;
}

- (void)requestData{
    SDataCache *dataCache = [SDataCache sharedInstance];
    [dataCache getTopicDetails:_topicID.integerValue complete:^(NSDictionary *data) {
        self.contentModel = [[StopicDetailModel alloc]initWithDictionary:data];
 
        [titleShareImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.contentModel.big_img]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        
    }];
}

- (void)requestAddListData{
    _pageIndex = (_contentCollectionView.contentArray.count + 9)/ 10;
    [self requestListData];
}

- (void)requestListData{
    NSString *method = @"";
    switch (_selectedIndex) {
        case 0:
            method = @"getCollocationListForSelectTopic";
            break;
        case 1:
            method = @"getCollocationListForTopic";
            break;
        default:
            break;
    }
    if (!_topicID) return;
    NSDictionary *data = @{
                           @"m": @"Topic",
                           @"a": method,
                           @"page": @(_pageIndex),
                           @"tid": _topicID
                           };
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [_contentCollectionView footerEndRefreshing];
        [_contentCollectionView headerEndRefreshing];
        if (_pageIndex == 0) {
            _contentCollectionView.contentArray = responseObject[@"data"];
        }else{
            NSMutableArray *array = [NSMutableArray arrayWithArray:_contentCollectionView.contentArray];
            [array addObjectsFromArray:responseObject[@"data"]];
            _contentCollectionView.contentArray = array;
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast makeToast:kNoneInternetTitle];
        [_contentCollectionView headerEndRefreshing];
        [_contentCollectionView footerEndRefreshing];
    }];
}

- (void)setContentModel:(StopicDetailModel *)contentModel{
    _contentModel = contentModel;
    [_contentCollectionView reloadData];
}

#pragma mark - delegate

- (void)selectedButton:(UIButton *)sender selectedIndex:(int)index{
    _selectedIndex = index;
    _contentModel.selectedIndex = index;
    _pageIndex = 0;
    [self.contentCollectionView headerBeginRefreshing];
}

- (void)listViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 50) {
        self.showMyTopicCameraButton.hidden = YES;
    }else{
        self.showMyTopicCameraButton.hidden = NO;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    return [_contentModel.info heightWithRestrictedWidth:UI_SCREEN_WIDTH - 34 font:[UIFont systemFontOfSize:12]] + 320;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:WaterFallSectionHeader]) {
        STopicDetailHeaderViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        headerView.contentModel = _contentModel;
        headerView.delegate = self;
        headerView.target = self;
        reusableView = headerView;
    }
    return reusableView;
}

- (IBAction)showMyTopicButtonAction:(UIButton *)sender {
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
}

@end
