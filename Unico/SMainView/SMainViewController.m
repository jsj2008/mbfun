//
//  SMainViewController.m
//  Wefafa
//
//  Created by unico on 15/5/16.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SMainViewController.h"
#import "SContentOnePageCell.h"
#import "SCollocationDetailViewController.h"
#import "SBaseDetailViewController.h"
#import "SDiscoveryViewController.h"
#import "SUtilityTool.h"
#import "LoginViewController.h" //登陆界面
#import "AppDelegate.h"
#import "SStarStoreViewController.h"
//#import "MJRefresh.h"
#import "SDataCache.h"
#import "AlreadyBinDingBankCardViewController.h"
#import "SBannerViewCell.h"
#import "CommentsViewController.h"
#import "SMineViewController.h"
#import "HttpRequest.h"
#import "SChatSocket.h"
#import "AppSetting.h"
#import "ShoppIngBagShowButton.h"
#import "MyShoppingTrollyViewController.h"
#import "MainTableView.h"
#import "SHomeNavigationViewController.h"
#import "SHomeViewController.h"
#import "SLeftMainView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoveryHeaderTableView.h"
#import "UIScrollView+MJRefresh.h"
#import "SUploadColllocationControlCenter.h"
#import "CommunityCollectionView.h"
#import "CommunityHotTableView.h"
#import "CommunityAttentionTableView.h"
#import "SAgilityNavigationBarTool.h"
#import "SMenuBottomModel.h"
#import "WaterFLayout.h"
//键盘
#import "CommunityKeyBoardAccessoryView.h"

@interface SMainViewController ()<UIScrollViewDelegate, kLeftMainViewDelegate, SDiscoveryHeaderTableViewDelegate>
{
    UIView *p_titleView;
    //黄色的 那个线
    UIImageView *p_selectView_y;
    kTableViewType p_showType;
    
    UIView *view;
    UIImageView *headerImgView;
    UILabel *_unread_label;
    
    UIScrollView *mainScrollView;

    UIView *allNoDataView;
    UIView *attentNoDataView;
    UIView *hotNoDataView;
    
    UIButton *btnCamera;
    NSInteger _pageIndex;
    
    SLeftMainView *leftView;
}
@property(nonatomic) MainTableView *attentTableView;
@property(nonatomic) MainTableView *hotTableView;
@property (nonatomic, strong) SDiscoveryHeaderTableView *topicTableView;

@property (nonatomic) CommunityHotTableView *hotTbView;             //热门
//@property (nonatomic) CommunityCollectionView *CommunityCollectionView;      //搭配
//@property (nonatomic) CommunityAttentionTableView *attentionTbView; //关注
@property (nonatomic) WaterFLayout *flowLayout;

@property (nonatomic) NSMutableArray *btnArray;

@property (nonatomic, assign) NSInteger integer;   //关注tableviewcell评论对象的NSIndexPath.row
@end

@implementation CollocationModel


@end

@implementation SMainViewController

static NSString *cellIdentifier = @"SContentOnePageCell";
static NSString *SBannerViewCellIdentifier = @"SBannerViewCell";
static SMainViewController* g_SMainViewController = nil;

- (instancetype)init {
    if (self == [super init]) {
        g_SMainViewController = self;
    }
    return g_SMainViewController;
}

+ (SMainViewController*)instance {
    return g_SMainViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"首页进来");
    
    self.navigationController.navigationBar.hidden = NO;
    [self setupTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginOut) name:@"noti_loginOut" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginComplete) name:@"MBFUN_LOGIN_SUC" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImgView:) name:@"changeHeadImgView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMsg:) name:@"MBFUN_CHAT_MESSAGE_SOCKET" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemote)  name:MBFUN_REMOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCollocation)  name:@"deleteCollocation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"likeRefreshTableView" object:nil];
    //键盘监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    _pageIndex = 0;
    [self requestData];
}
-(void)deleteCollocation
{
    [self updateDataWhenLogOut];
    
}
-(void)refreshTableView
{
    //刷新
    CGPoint point =  mainScrollView.contentOffset;
    MainTableView *tableView;
    kTableViewType showType;
    if (point.x == 0) {
        showType = kTableViewTypeTopic;
    }else if (point.x == UI_SCREEN_WIDTH) {
        showType = kTableViewTypeHot;
        tableView = _hotTableView;
    }else {
        showType = kTableViewTypeAttention;
        tableView = _attentTableView;
    }
    
    tableView.needUpload=YES;
    [tableView requestDataWithType:showType];
    
}
- (void)requestData{
    NSDictionary *data = @{
                           @"m":@"Topic",
                           @"a":@"getTopicLayout"
                           };
    [[SDataCache sharedInstance] quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSArray *array = [SDiscoveryFlexibleModel modelArrayForDataArray:[responseObject objectForKey:@"data"]];
        [_topicTableView headerEndRefreshing];
        self.topicTableView.contentArray = array;
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [_topicTableView headerEndRefreshing];
    }];
}

- (void)refreshData{
    _pageIndex = 0;
    [self requestData];
}

- (void)requestAddData{
    _pageIndex = (_topicTableView.contentArray.count + 9)/ 10;
    [self requestData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollToTop{

}

-(void)changeHeadImgView:(NSNotification *)sender
{
//    [headerImgView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path] placeholderImage:[UIImage imageNamed:@"Unico/default_header_image"]];
//    [self.hotTableView reloadData];
//    [self.attentTableView reloadData];
    
}
- (void)initNavigationBar{
    UIButton *right2 = [UIButton buttonWithType:UIButtonTypeCustom];//[UIImage imageNamed:@"Unico/common_navi_back"]
    [right2 setImage:[UIImage imageNamed:@"Unico/icon_back"] forState:UIControlStateNormal];
    right2.frame = CGRectMake(0, 0, 44, 44);
    [right2 setTitle:@"" forState:UIControlStateNormal];
    [right2 addTarget:self action:@selector(onHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2];
    rightItem2.title = @"";
    self.navigationItem.backBarButtonItem = rightItem2;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self kLeftMainViewSwipeDelegate];
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavbar];
//    [self requestCarCount];

    if (UNREAD_ALL_NUMBER > 0) {
        _unread_label.hidden = NO;
    }else {
        _unread_label.hidden = YES;
    }
    
    btnCamera.enabled = YES;
    btnCamera.userInteractionEnabled = YES;
}

- (void)onRemote {
    if (UNREAD_ALL_NUMBER > 0) {
        _unread_label.hidden = NO;
    }else  {
        _unread_label.hidden = YES;
    }
}

- (void)onMsg:(NSNotification*)notification {

    if (UNREAD_ALL_NUMBER > 0) {
        _unread_label.hidden = NO;
    }else  {
        _unread_label.hidden = YES;
    }
}

-(void)swipeLeftHandler:(id)rec{
    
    
    // TODO: show discover
    [self discoverContent:nil];
}

-(void)swipeRightHandler:(id)rec{
    // TODO: show mine
    [self onMine:nil];
}

- (void)noti_loginComplete
{
    sns.isLogin = YES;
//    [self requestCarCount];
    
//    [headerImgView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path] placeholderImage:[UIImage imageNamed:@"Unico/default_header_image"]];
     _unread_label.hidden=NO;
    
    if (p_showType == kTableViewTypeHot) {
        [_hotTableView requestDataWithType:kTableViewTypeHot];
        _attentTableView.needUpload = YES;
    }else{
        [_attentTableView requestDataWithType:kTableViewTypeAttention];
        _hotTableView.needUpload = YES;
    }
}

- (void)noti_loginOut
{
    _unread_label.hidden=YES;
    
    [Toast hideToastActivity];
    [[SDataCache sharedInstance] logout];
    [self updateDataWhenLogOut];
    //如果在关注页面时 退出登录 页面默认在热门页面
    if (mainScrollView.contentOffset.x >= UI_SCREEN_WIDTH * 2) {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)updateDataWhenLogOut
{
    if (p_showType == kTableViewTypeHot) {
        [_hotTableView refrashTableLogout];
        _attentTableView.needUpload = YES;
    }else{
        [_attentTableView refrashTableLogout];
        _hotTableView.needUpload = YES;
    }
}

-(void)showTableTypeView{
    CGRect navRect = self.navigationController.navigationBar.frame;
//    navRect = CGRectMake(0, 0, UI_SCREEN_WIDTH - MAX(self.tabBarController.navigationItem.leftBarButtonItems.count - 1, self.tabBarController.navigationItem.rightBarButtonItems.count - 1) * 88, self.navigationController.navigationBar.frame.size.height);
    navRect = CGRectMake(0, 0, 326 / 2, self.navigationController.navigationBar.frame.size.height);
    p_titleView = [[UIView alloc]initWithFrame:navRect];
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0,0,navRect.size.width / 3, navRect.size.height)];
    [tempBtn setTitle:@"热门" forState:UIControlStateNormal];
    [tempBtn.titleLabel setFont:FONT_t3];
    [tempBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    tempBtn.tag = BASE_BTN_TAG;
    [tempBtn addTarget:self action:@selector(SelectModel:) forControlEvents:UIControlEventTouchUpInside];
    [p_titleView addSubview:tempBtn];
    
    tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(navRect.size.width / 3, 0, navRect.size.width / 3, navRect.size.height)];
    [tempBtn setTitle:@"搭配" forState:UIControlStateNormal];
    [tempBtn.titleLabel setFont:FONT_t3];
    [tempBtn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    tempBtn.tag = BASE_BTN_TAG + 1;
    //默认选择->热门
    CGSize size = [tempBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : tempBtn.titleLabel.font}];
    p_selectView_y = [UIImageView new];
    p_selectView_y.backgroundColor = COLOR_C1;
//    p_selectView_y.frame = CGRectMake((70 - size.width)/2.0, p_titleView.frame.size.height - 4, 40, 3);
    size = [tempBtn intrinsicContentSize];
    p_selectView_y.frame = CGRectMake((tempBtn.width - size.width - 4) / 2.0f, p_titleView.frame.size.height - 3, size.width + 4, 3);
    [p_titleView addSubview:p_selectView_y];
    [tempBtn addTarget:self action:@selector(SelectModel:) forControlEvents:UIControlEventTouchUpInside];
    [p_titleView addSubview:tempBtn];
    
    tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(navRect.size.width / 3 * 2,0,navRect.size.width / 3, navRect.size.height)];
    [tempBtn setTitle:@"关注" forState:UIControlStateNormal];
    [tempBtn.titleLabel setFont:FONT_t3];
    [tempBtn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
    tempBtn.tag = BASE_BTN_TAG + 2;
    [tempBtn addTarget:self action:@selector(SelectModel:) forControlEvents:UIControlEventTouchUpInside];
    
    [p_titleView addSubview:tempBtn];
}

- (void)recommendDesigner
{
    if ([BaseViewController pushLoginViewController]) {
        SStarStoreViewController * starStoreVC = [[SStarStoreViewController alloc]init];
        [self.navigationController pushViewController:starStoreVC animated:YES];
    }
}

- (void)setupTableView {
    
     CGRect rect = CGRectMake(0, 63, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.height-STATUS_BAR_HEIGHT_U);
   
    mainScrollView = [SUTIL createScrollView:self rect:rect];
    mainScrollView.pagingEnabled = YES;
    [mainScrollView setScrollsToTop:NO];
    [mainScrollView setDirectionalLockEnabled:YES];
    [mainScrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH*3,0)];// self.hotTableView.height-10
//    mainScrollView.userInteractionEnabled = YES;
     [self.view addSubview:mainScrollView];
    
    _topicTableView = [[SDiscoveryHeaderTableView alloc]initWithFrame:mainScrollView.bounds];
    _topicTableView.scrollEnabled = YES;
    _topicTableView.target = self;
    _topicTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _topicTableView.tableDelegate = self;
    [_topicTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [mainScrollView addSubview:_topicTableView];
    
    _flowLayout = [[WaterFLayout alloc]init];
    _flowLayout.sectionInset = UIEdgeInsetsZero;
    _flowLayout.minimumColumnSpacing = 1.5;
    _flowLayout.minimumInteritemSpacing = 1;
    _flowLayout.columnCount = 3;
    _collectionView = [[CommunityCollectionView alloc] initWithFrame:mainScrollView.bounds collectionViewLayout:_flowLayout];
    _collectionView.frame = mainScrollView.bounds;
    _collectionView.parentVC = self;
    [_collectionView setOrigin:CGPointMake(UI_SCREEN_WIDTH, 0)];
    [mainScrollView addSubview:_collectionView];
    
    _attentionTbView = [[CommunityAttentionTableView alloc] initWithFrame:mainScrollView.bounds style:UITableViewStyleGrouped];
//    _attentionTbView.frame = mainScrollView.bounds;
    _attentionTbView.parentVC = self;
    [_attentionTbView setOrigin:CGPointMake(UI_SCREEN_WIDTH*2, 0)];
    [mainScrollView addSubview:_attentionTbView];
    
    CGFloat width = UI_SCREEN_WIDTH / 2;
    CGFloat height = 44*SCALE_UI_SCREEN;
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, height)];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.layer.borderColor = COLOR_C9.CGColor;
    btnView.layer.borderWidth = 1;
    [mainScrollView addSubview:btnView];
    NSArray *array = @[@"女装", @"男装"];
    for (int i = 0; i < array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width * i, 0, width, height);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:FONT_t4];
        [btn setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
        //分割线
        CALayer *layer = [CALayer new];
        layer.frame = CGRectMake(width, (height - 25 * SCALE_UI_SCREEN) / 2, 1, 25);
        layer.backgroundColor = COLOR_C9.CGColor;
        [btnView.layer addSublayer:layer];
        //按钮文字左右margin为100
        if (i == 0) {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -(20 * SCALE_UI_SCREEN), 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        }else {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -(20 * SCALE_UI_SCREEN) / 2, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        }
        if (!_btnArray) {
            _btnArray = [NSMutableArray new];
        }
        [_btnArray addObject:btn];
        if ([_btnArray indexOfObject:btn] == 0) {
            btn.selected = YES;
            [btn setImage:[UIImage imageNamed:@"Unico/ico_female.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Unico/ico_female_pressed.png"] forState:UIControlStateSelected];
        }else {
            btn.selected = NO;
            [btn setImage:[UIImage imageNamed:@"Unico/ico_male.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Unico/ico_male_pressed.png"] forState:UIControlStateSelected];
        }
    }
    
    //回复键盘
    _IFView = [CommunityKeyBoardAccessoryView instance];
    [self.view addSubview:_IFView];
    _IFView.hidden = YES;
    __weak __typeof(self) ws = self;
    _IFView.block = ^(SMDataModel *model){
        [ws requestSendMessage:model];
    };
}

- (void)setupNavbar {
    [super setupNavbar];
    [self.tabBarController setValue:_layoutModel forKey:@"layoutModel"];
    if (!p_titleView) {
        [self showTableTypeView];
    }
    NSLog(@"NSStringFromCGRect(p_titleView.frame) ==== %@", NSStringFromCGRect(p_titleView.frame));
    self.tabBarController.navigationItem.titleView = p_titleView;
    [headerImgView setImage:[UIImage imageNamed:@"icon_menu@2x.png"]];
}

- (void)cameraClick:(UIButton*)sender {
    
    AVAuthorizationStatus isAllow = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (isAllow == AVAuthorizationStatusDenied) {
        [Utils alertMessage:@"相机功能已经禁止，请去设置中打开"];
        return;
    }
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    sender.enabled = NO;
    sender.userInteractionEnabled = NO;
    
    [[SUtilityTool shared] showCamera:nil];
}

-(void)onMine:(id)sender{
//    [self.tabBarController setSelectedIndex:4];
    [self showLeftView];
}

-(void)selectModelView:(NSInteger)modelType {
    UIButton *selectBtn;
    NSInteger tag = modelType+BASE_BTN_TAG;
    for (int i = BASE_BTN_TAG; i< BASE_BTN_TAG+3; i++) {
        selectBtn = (UIButton*)[p_titleView viewWithTag:i];
        if (i == tag) {
            [selectBtn setTitleColor:COLOR_C3 forState:UIControlStateNormal];
            /*
            CGRect frame = p_selectView_y.frame;
            frame.origin.x = modelType * p_titleView.width / 3 + (p_titleView.width / 3 - frame.size.width) / 2.0f;
            [p_selectView_y setFrame:frame];
            */
            [p_selectView_y setCenterX:selectBtn.centerX];
        }else{
            [selectBtn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        }
    }
}

- (void)requestCarCount{
    if(!sns.isLogin || !sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];


    } failed:^(NSError *error) {
        
    }];
}

- (void)onCamera {
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
}

//发现
-(void)discoverContent:(id)sender{
//    CommentsViewController *vc = [[CommentsViewController alloc]init];
    SDiscoveryViewController *vc = [SDiscoveryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)SelectModel:(id)selector{
    UIButton *tempBtn = (UIButton*)selector;
    NSInteger modelType = tempBtn.tag;
    modelType -= BASE_BTN_TAG;
    if (modelType == 2) {
        if (!IS_STRING(sns.ldap_uid)) {
            LoginViewController *VC = [LoginViewController new];
            [self pushController:VC animated:YES];
            return;
        }
    }
    [mainScrollView setContentOffset:CGPointMake(modelType * UI_SCREEN_WIDTH, 0) animated:YES];
}

- (void)setScrollToTopWithType:(NSInteger)type
{
    BOOL isHot = type == kTableViewTypeHot;
    [_hotTableView setScrollsToTop:isHot];
    [_attentTableView setScrollsToTop:!isHot];
}

-(void)moveScrollView:(NSInteger)modelType{
    switch (modelType) {
        case 1:
            [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 2:
            [mainScrollView setContentOffset:CGPointMake(mainScrollView.frame.size.width, 0) animated:YES];
            break;
        case 3:
            [mainScrollView setContentOffset:CGPointMake(mainScrollView.frame.size.width*2, 0) animated:YES];
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0) {
        [self showLeftView];
    }
    if ( 0 < scrollView.contentOffset.x < UI_SCREEN_WIDTH * 2) {
        [_IFView.textView resignFirstResponder];
        _IFView.hidden = YES;
    }
    CGPoint point = scrollView.contentOffset;
    if (point.x > UI_SCREEN_WIDTH + 10) {
        if (!IS_STRING(sns.ldap_uid)) {
            LoginViewController *VC = [LoginViewController new];
            [self pushController:VC animated:YES];
        }
    }
}

- (void)showLeftView
{
    if (leftView) {
        return;
    }
    leftView = [SLeftMainView instance];
    [leftView showWithtarget:self];
}

-(void)clicked:(UIButton*)sender {
    for (UIButton *btn in _btnArray) {
        btn.selected = btn == sender;
    }
    NSInteger num = 0;
    if ([sender.titleLabel.text isEqualToString:@"男装"]) {
        num = 1;
    }else if ([sender.titleLabel.text isEqualToString:@"女装"]) {
        num = 2;
    }else if ([sender.titleLabel.text isEqualToString:@"童装"]) {
        num = 3;
    }
    _collectionView.block(num);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToIndexTableWithScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollToIndexTableWithScrollView:scrollView];
}

#pragma mark - delegate 收起tabbar
- (void)tableScrollViewDidScroll:(SDiscoveryHeaderTableView *)tableView{
    [self.tabBarController setValue:tableView forKey:@"controlScrollView"];
}

- (void)tableBeginScroll:(SDiscoveryHeaderTableView *)tableView{
    [self.tabBarController setValue:tableView forKey:@"scrollViewBegin"];
}

- (void)scrollToIndexTableWithScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:mainScrollView]){
        CGPoint point =  scrollView.contentOffset;
        MainTableView *tableView;
        kTableViewType showType;
        if (point.x == 0) {
            showType = kTableViewTypeTopic;
        }else if (point.x == UI_SCREEN_WIDTH) {
            showType = kTableViewTypeHot;
            tableView = _hotTableView;
        }else {
            showType = kTableViewTypeAttention;
            tableView = _attentTableView;
        }
        if (p_showType != showType) {
            [tableView requestDataWithType:showType];
            [self selectModelView:showType];
            [self setScrollToTopWithType:showType];
        }
        p_showType = showType;
    }
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
//    //adjust ChatTableView's height
//    if (notification.name == UIKeyboardWillShowNotification) {
//        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
//    }else{
//        self.bottomConstraint.constant = 40;
//    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = _IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    _IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

- (void)callKeyBoardwithModel:(SMDataModel*)model integer:(NSInteger)integer {
    self.integer = integer;
    _IFView.model = model;
    _IFView.hidden = NO;
    [_IFView.textView becomeFirstResponder];
}

- (void)hideKeyBoard {
    _IFView.hidden = YES;
    [_IFView.textView resignFirstResponder];
}

#pragma mark leftmainview delegate

- (void)kLeftMainViewDidSelectWithType:(kLeftViewJumpType)type
{
    [[SUtilityTool shared] jumpControllerWithType:type target:self];
}

- (void)kLeftMainViewSwipeDelegate
{
    if (leftView) {
        [leftView hide];
        leftView = nil;
    }
}

#pragma mark - 评论
- (void)requestSendMessage:(SMDataModel*)model{
    //默认五星评分
    int score = 5;
    
//    if(self.commentSendMessageTextFiled.text.length==0)
    if(_IFView.textView.text.length==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入评论内容" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (_IFView.textView.text.length > 120){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"最多输入140个文字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    _IFView.modelView.userInteractionEnabled = NO;
    [self hideKeyBoard];
    [Toast makeToastActivity];
    
    if (!IS_STRING(sns.ldap_uid)) {
        [Toast hideToastActivity];
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    
    NSDictionary *data = @{
                           @"m": @"Comment",
                           @"a": @"addCommentInfo",
                           @"type": @1,
                           @"toUserId": @"",
                           @"score": @(score),
                           @"tid": model.idValue,
                           @"token": [SDataCache sharedInstance].userInfo[@"token"],
                           @"info": _IFView.textView.text
                           };
    __weak __typeof(self) ws = self;
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        [Toast hideToastActivity];
        ws.IFView.modelView.userInteractionEnabled = YES;
        if ([object[@"status"] intValue] == 1) {
            [ws performSelector:@selector(canShowPraiseBox) withObject:nil afterDelay:3.0];
            //此处刷新
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:model.commentArray];
            SMCommentInfo *info = [SMCommentInfo new];
//            head_img;
//            head_v_type;
//            info;
//            nick_name;
//            to_user_id;
//            user_id;
            info.info = ws.IFView.textView.text;
            info.nick_name = sns.myStaffCard.nick_name;
            //计算UILabel高度
            UILabel *tempLabel = [UILabel new];
            tempLabel.font = FONT_t6;
            tempLabel.text = [NSString stringWithFormat:@"%@:  %@", info.nick_name, ws.IFView.textView.text];
            [tempLabel setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width - 30];
            tempLabel.numberOfLines = 1;
            CGSize tempSize = [tempLabel intrinsicContentSize];
            tempSize.width = [UIScreen mainScreen].bounds.size.width - 30;//手动设置宽度，numberOfLines == 1不支持这个方法
            info.info_Height = tempSize.height + 6;
            
            [tempArray addObject:info];
//            model.commentArray = tempArray;
            [model.commentArray insertObject:info atIndex:0];
            model.comment_count = @([model.comment_count integerValue] + 1);
            ws.attentionTbView.reloadDataBlock(ws.integer);
            
            ws.IFView.textView.text = @"";
        }else {
            [Toast makeToast:@"评论失败！" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast hideToastActivity];
        ws.IFView.modelView.userInteractionEnabled = YES;
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

-(void)canShowPraiseBox
{
    [SUTILITY_TOOL_INSTANCE showPraiseBox];
}

@end
