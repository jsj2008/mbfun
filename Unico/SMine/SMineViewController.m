//
//  SMineViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/4/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SMineViewController.h"
#import "SSearchCollocationCollectionView.h"
#import "SCollocationDetailViewController.h"
#import "LNGood.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "MBOtherStoreModel.h"
#import "UIImageView+WebCache.h"
#import "SelectedSubContentView.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "SMineReleaseTableView.h"
#import "SmineSelectedButton.h"
#import "ScanViewController.h"
#import "MBStoreVisitorViewController.h"
#import "MyIncomeViewController.h"
#import "MBMyGoodsViewController.h"
#import "MBSettingMainViewController.h"
#import "MyShoppingTrollyViewController.h"
#import "MyOrderViewController.h"
#import "MBOtherUserInfoModel.h"
#import "SMineDesignerTableView.h"
#import "UIScrollView+MJRefresh.h"
#import "ShoppIngBagShowButton.h"

#import "SChatListController.h"
#import "SChatController.h"
#import "JSWebViewController.h"
#import "SChatSocket.h"
#import "SLeftMainView.h"
#import "CommMBBusiness.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "SCollocationDetailNoneShopController.h"
#import "HeadVipImgView.h"
#import "MNWheelView.h"
#import "ChoosePicViewController.h"

#import "SMineFollowFollowerViewController.h"
#import "MyLikeViewController.h"
#import "SMineReleaseCollectionView.h"
#import "SMineProductViewController.h"

#import "SMainViewController.h"
#import "CommunityAttentionTableView.h"

#import "SUploadColllocationControlCenter.h"
#import "SMineLikeViewController.h"

#import "ShareRelated.h"
@protocol PopViewDelegate <NSObject>
- (void)popviewDidselect:(NSInteger)index;
@end

@interface PopView2 : UIView

@property (nonatomic, assign) id<PopViewDelegate> delegate;

- (instancetype)initPopView:(CGRect)frame;
- (void)showPop;
- (void)hidePop;
@end

//static PopView *_popvie
@implementation PopView2
{
    UIView *_homeView;
    CGFloat _arrowHeight, _arrowWidth;
    BOOL _isRemove;
}
int _btnHeight2 = 40;
int _btnWidth2 = 105;
- (instancetype)initPopView:(CGRect)frame{
    CGRect rect = frame;
    rect.size.width = _btnWidth2;
    rect.size.height = 3 * _btnHeight2;
    rect.size.height += 5;
    if (self == [super initWithFrame:rect]) {
        self.backgroundColor = [UIColor clearColor];
        _arrowHeight = 5;
        _arrowWidth = 10;
        self.layer.anchorPoint = CGPointMake(0.8, 0);
        self.frame = rect;
        _homeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_homeView];
        
        NSArray *ary = @[ @"扫一扫", @"我的收益", @"我的邀请码"];
        NSArray *aryImg = @[ @"Unico/smine_scan.png",  @"Unico/smine_income.png", @"Unico/invitecode.png"];
        for (NSString *str in ary) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, (int)[ary indexOfObject:str] * _btnHeight2 + 5, _btnWidth2, _btnHeight2);
            btn.tag = [ary indexOfObject:str] + 170;
            [btn setImage:[UIImage imageNamed:aryImg[(int)[ary indexOfObject:str]]] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15+7 , 0, 0)];//+ 15
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:[Utils HexColor:0x999999 Alpha:1] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment=NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)clicked:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(popviewDidselect:)]) {
        [self.delegate popviewDidselect:sender.tag - 170];
    }
}

- (void)showPop {
    if (!self) {
        return;
    }
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.alpha = 0;
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePop {
    if (!self || _isRemove) {
        return;
    }
    _isRemove = YES;
    self.transform = CGAffineTransformMakeScale(1, 1);
    self.alpha = 1;
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contentRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contentRef);//标记
    CGContextMoveToPoint(contentRef, 0, 5);
    CGContextAddLineToPoint(contentRef, self.width - 20, 5);
    CGContextAddLineToPoint(contentRef, self.width - 15, 0);
    CGContextAddLineToPoint(contentRef, self.width - 10, 5);
    CGContextAddLineToPoint(contentRef, self.width, 5);
    CGContextAddLineToPoint(contentRef, self.width, self.height + 5);
    CGContextAddLineToPoint(contentRef, 0, self.height + 5);
    CGContextAddLineToPoint(contentRef, 0, 5);
    [[Utils HexColor:0x000000 Alpha:.8] setFill];
    [[Utils HexColor:0x000000 Alpha:.8] setStroke];
    CGContextClosePath(contentRef);
    CGContextDrawPath(contentRef, kCGPathFillStroke);
}

@end


/**
 ReleaseButton
 */
@interface SReleaseButton : UIButton

@end

@implementation SReleaseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.layer.cornerRadius = 3.f;
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:@"Unico/camera_switch_photo"] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width/3*2;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleW/2, 0, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //    CGFloat imageW = contentRect.size.width/3;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(13, (imageH-15)/2, 15, 15);
}

@end


@interface SMineViewController () <UIScrollViewDelegate, SelectedSubContentViewDelegate, SMineTableViewDelegate, SSearchCollocationCollectionViewDelegate, PopViewDelegate, SMineDesignerTableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger _selectedIndex;
    NSInteger _pageIndex;
    
    //关注粉丝
    NSInteger _followFollowerIndex;
    //选单个数
    NSInteger _menuCount;
    //    BOOL isChangeBackImgView;
    UIImageView *imageB;
    
    
    //没有数据背景图
    UIView *placeholdView;
    SMineReleaseCollectionView *releaseCollectionView;
    SMineReleaseTableView *releaseTableView;
}
@property (strong, nonatomic) IBOutlet UILabel *badgeView;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIView *contentHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSignatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImgView;

@property (strong, nonatomic) IBOutlet UIView *followFollowerView;
@property (strong, nonatomic) IBOutlet UILabel *followLabel;
@property (strong, nonatomic) IBOutlet UILabel *followerLabel;

@property (weak, nonatomic) IBOutlet UILabel *followClickLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerClickLabel;


@property (strong, nonatomic) IBOutlet UIView *ContentView;

- (IBAction)messageButtonAction:(UIButton *)sender;
- (IBAction)attentionButtonAction:(UIButton *)sender;

//----------------

@property (nonatomic, strong) MBOtherStoreModel *userInfoModel;
@property (nonatomic, strong) SelectedSubContentView *selectedContentView;
@property (nonatomic, strong) UIView *showStateView;
@property (nonatomic, weak) PopView2 *popView;

@end

@implementation SMineViewController

#pragma mark - 界面初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    //做一个容错。
    if( !_person_id ){
        _person_id = sns.ldap_uid;
        
    }
    
    if ([sns.ldap_uid isEqualToString:_person_id]) {
        _userHeaderView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapBackGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBackImage:)];
        [_userHeaderView addGestureRecognizer:tapBackGest];
        _menuCount=2;
    }else{
        _menuCount=2;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNavbar];
    [self initNavigationBar];
    [self initSubViews];
    
    // 为啥注释掉下面这个？
    //    [self requestData];
    
    //发布，索引 0=|1=九宫格显示方式|2=相机
    _selectedIndex = 0;
    //分页
    _pageIndex = 0;
    //我的关注=1|我的粉丝=2
    _followFollowerIndex=0;
    //默认显示0
    [self.selectedContentView scrollViewEndAction:_selectedIndex];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImgView:) name:@"changeHeadImgView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber:) name:@"changeNumber" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAttend) name:@"changeAttend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginOut)  name:@"noti_loginOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserInfoDataKVO)  name:@"MBFUN_LOGIN_SUC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginIn)  name:@"LoginIn" object:nil];
    
    
    
}
- (void)setupNavbar{
    [super setupNavbar];
    self.navigationItem.titleView = nil;
    //隐藏导航栏黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)initNavigationBar{
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:_shoppingBagButton];
    
    
    if (![sns.ldap_uid isEqualToString:self.person_id]||sns.ldap_uid.length==0||!_isHiddenBackItem) {//_isHiddenBackItem
        UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
        self.navigationItem.leftBarButtonItems = @[left1];
        
        
        
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom] ;
        [button setFrame:CGRectMake(0, 0, 33, 33)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [button setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItems = @[rightItem1,shareItem];
    }
    else
    {
        UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
        self.navigationItem.leftBarButtonItems = @[left1];
        self.navigationItem.rightBarButtonItems = @[rightItem1];
    }
}

- (ShoppIngBagShowButton *)shoppingBagButton{
    if (!_shoppingBagButton) {
        _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
        [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shoppingBagButton;
}

- (void)initSubViews{
    
    CGRect rect = _messageButton.frame;
    rect.origin.x = UI_SCREEN_WIDTH/ 2 - 33 - _userHeaderImageView.frame.size.width/2-rect.size.width;
    _messageButton.frame = rect;
    
    rect.origin.x = UI_SCREEN_WIDTH/ 2+_userHeaderImageView.frame.size.width/2+33;
    _attentionButton.frame=rect;
    [self initContentScrollView];
    
    self.userHeaderImageView.layer.cornerRadius = _userHeaderImageView.frame.size.width/ 2;
    self.userHeaderImageView.layer.borderWidth = 3.0;
    self.userHeaderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userHeaderImageView.layer.masksToBounds = YES;
    
    self.userHeaderView.alpha=0.4;
    
    if(UI_SCREEN_WIDTH>375)
    {
        [_levelImgView setFrame:CGRectMake(_levelImgView.frame.origin.x-5, _levelImgView.frame.origin.y, _levelImgView.frame.size.width, _levelImgView.frame.size.height)];
    }
    _levelImgView.layer.cornerRadius=_levelImgView.frame.size.width/ 2;
    _levelImgView.layer.borderWidth = 1.0;
    _levelImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _levelImgView.layer.masksToBounds = YES;
    
    
    
    _messageButton.hidden = YES;
    _attentionButton.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headclicked)];
    [self.userHeaderImageView addGestureRecognizer:tap];
    self.userHeaderImageView.userInteractionEnabled = YES;
    
    if ([sns.ldap_uid isEqualToString:_person_id] && sns.ldap_uid.length != 0) {
        
    }else{
        _messageButton.hidden = NO;
        _attentionButton.hidden = NO;
    }
    
    NSArray *nameArray= @[@"Unico/icon_multiview_grey.png|Unico/icon_multiview_black.png",@"Unico/icon_view_grey.png|Unico/icon_view_black.png"];
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(_contentHeaderView.frame), UI_SCREEN_WIDTH, ISSUE_HEIGHT);
    _selectedContentView = [[SelectedSubContentView alloc]initWithFrame:frame AndNameArray:nameArray buttonType:mineButtonImageType];
    _selectedContentView.backgroundColor = [UIColor whiteColor];
    _selectedContentView.delegate = self;
    [self.view addSubview:_selectedContentView];
    
    
    _showStateView = [[UIView alloc]initWithFrame:_selectedContentView.bounds];
    _showStateView.backgroundColor = [UIColor whiteColor];
    [_selectedContentView insertSubview:_showStateView atIndex:0];
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = COLOR_NORMAL.CGColor;
    layer.frame = CGRectMake(0, _selectedContentView.size.height, _selectedContentView.size.width, 5);
    layer.zPosition = 5;
    [_selectedContentView.layer addSublayer:layer];
    
    
    
    //将View的边框设置为圆脚，有色边框。
    _followFollowerView.layer.cornerRadius = 16;
    _followFollowerView.layer.masksToBounds = YES;
    _followFollowerView.layer.borderWidth = 1;
    _followFollowerView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    
    //    self.messageButton.layer.cornerRadius = _messageButton.frame.size.width/ 2;
    //    self.messageButton.layer.borderWidth = 2.0;
    //    self.messageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //    self.messageButton.layer.masksToBounds = YES;
    
    //    self.attentionButton.layer.cornerRadius = _attentionButton.frame.size.width/ 2;
    //    self.attentionButton.layer.borderWidth = 2.0;
    //    self.attentionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //    self.attentionButton.layer.masksToBounds = YES;
    
    //follow和follower触发单击事件
    UITapGestureRecognizer *followTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followclicked)];
    [_followClickLabel addGestureRecognizer:followTap];
    _followClickLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *followerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followerclicked)];
    [_followerClickLabel addGestureRecognizer:followerTap];
    _followerClickLabel.userInteractionEnabled = YES;
    
    
    NSArray *titleArray = @[@"发布", @"商品", @"喜欢", @"收藏"];
    for (int i=0; i<4; i++) {
        SmineSelectedButton *button = [[SmineSelectedButton alloc]
                                       initWithFrame:CGRectMake(UI_SCREEN_WIDTH/4*i, 0, UI_SCREEN_WIDTH/4, 40)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        if(i==0){
            [button setSelected:YES];
            [button setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        }else{
            [button setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        }
        [button.titleLabel setFont: FONT_t7];
        [button setTag:i];
        
        [SUTILITY_TOOL_INSTANCE addViewAction:button target:self action:@selector(enterButton:)];
        [_ContentView addSubview:button];
        
        if(i==0)continue;
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = COLOR_C9.CGColor;
        layer.frame = CGRectMake(UI_SCREEN_WIDTH/4*i, 9, 0.5, 22);
        layer.zPosition = 5;
        [_ContentView.layer addSublayer:layer];
        
    }
    layer = [CALayer layer];
    layer.backgroundColor = COLOR_C9.CGColor;
    layer.frame = CGRectMake(0, _ContentView.size.height - 1, _ContentView.size.width, 0.5);
    layer.zPosition = 5;
    [_ContentView.layer addSublayer:layer];
}

- (void)initContentScrollView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH *_menuCount, 0);
    _contentScrollView.bounces = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    
    [self.view insertSubview:_contentScrollView atIndex:0];
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(CGRectGetMaxY(_contentHeaderView.frame) + ISSUE_HEIGHT, 0, 0, 0);
    CGRect frame = _contentScrollView.bounds;
    
    
    frame.origin.x = UI_SCREEN_WIDTH * 0;
    releaseCollectionView = [[SMineReleaseCollectionView alloc]initWithFrame:frame];
    releaseCollectionView.parentVc=self;
    releaseCollectionView.userInteractionEnabled=YES;
    [releaseCollectionView addFooterWithTarget:self action:@selector(requestListAddData)];
    releaseCollectionView.contentInset = edgeInset;
    releaseCollectionView.collectionViewDelegate = self;
    releaseCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){
    };
    releaseCollectionView.backgroundColor=COLOR_NORMAL;
    [_contentScrollView addSubview:releaseCollectionView];
    
    
    frame.origin.x = UI_SCREEN_WIDTH * 1;
    releaseTableView = [[SMineReleaseTableView alloc]initWithFrame:frame];
    releaseTableView.parentVc = self;
    releaseTableView.isMine=true;
    [releaseTableView addFooterWithTarget:self action:@selector(requestListAddData)];
    releaseTableView.contentInset = edgeInset;
    releaseTableView.tableViewDelegate = self;
    releaseTableView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        
    };
    releaseTableView.backgroundColor=COLOR_NORMAL;
    [_contentScrollView addSubview:releaseTableView];
    
    
    //    frame.origin.x = UI_SCREEN_WIDTH * 2;
    //    SMineDesignerTableView *fansTableView = [[SMineDesignerTableView alloc]initWithFrame:frame];
    //    [fansTableView addFooterWithTarget:self action:@selector(requestListAddData)];
    //    fansTableView.contentInset = edgeInset;
    //    fansTableView.tableViewDelegate = self;
    //    fansTableView.opration = ^(NSIndexPath *indexPath, NSArray *array){
    //        MBOtherUserInfoModel *model = array[indexPath.row];
    //        SMineViewController *vc = [[SMineViewController alloc]init];
    //        vc.person_id = model.userId;
    //        [p.navigationController pushViewController:vc animated:YES];
    //    };
    //    [_contentScrollView addSubview:fansTableView];
}

#pragma mark -KVO方法
-(void)changeHeadImgView:(NSNotification *)sender
{
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];
    self.userNameLabel.text = sns.myStaffCard.nick_name;
    self.userSignatureLabel.text = sns.myStaffCard.self_desc;
    //刷新
    for(int i = 0; i < _menuCount; i++){
        UIView *view = _contentScrollView.subviews[i];
        [view setValue:@NO forKey:@"isAbandonRefresh"];
    }
    [self selectedSubContentViewSelectedIndex:_selectedIndex];
}

-(void)changeNumber:(NSNotification *)sender
{
    
    /* 下面注释的代码是之前的代码，按照这个逻辑，如果用户在其他页面执行了类似“关注”和“取消关注”时、其他页面会负责向通知中心[NSNotificationCenter defaultCenter]发送通知，然后该函数-(void)changeNumber:(NSNotification *)sender会执行，在这里查看通知内容执行“+1”或“-1”的操作。这里存在两个问题：1、写其他页面的人可能经常忘了发送通知（事实确实是这样），会导致这个页面的数据没有及时更新。2、不排除以后版本会出现用户同时在多个终端登录（iPad， iPhone， PC），其他终端改变了数据这个页面的数据也不会及时更新。
     所以将该段代码替换成重新从服务器获取数据[self requestUserInfoData]，并且让函数-(void)changeNumber:(NSNotification *)sender在- (void)viewWillAppear:(BOOL)animated里面主动调用一次，如果数据还是不一致，估计服务端有问题。———— 2015年6月25日 陈诚
     
     NSDictionary *dic = [sender userInfo];
     BOOL type = [dic[@"type"] boolValue];//1是取消减一 0 是加一 关注
     int number=0;
     if (type) {
     
     number= [_userInfoModel.concernCount intValue]-1;
     
     }else
     {
     number= [_userInfoModel.concernCount intValue]+1;
     }
     if(number<0)
     {
     number=0;
     }
     */
    
    [self requestUserInfoData];//新加的一行代码，代替上面注释的代码 2015年6月25日 陈诚 如果是进入别人到页面 怎么搞
    
    if (![sns.ldap_uid isEqualToString:_person_id]) {
        return;
    }
    //_userInfoModel.concernCount =[NSNumber numberWithInt:number];
    for (id obj in _ContentView.subviews) {
        if ([obj isKindOfClass:[SmineSelectedButton class]]) {
            SmineSelectedButton* Button = (SmineSelectedButton*)obj;
            switch (Button.tag) {
                case 0:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.collocationCount.stringValue];
                    break;
                case 1:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.productCount.stringValue];
                    break;
                case 2:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.collocationLikeCount.stringValue];
                    break;
                case 3:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.bpLikeCount.stringValue];
                    break;
                default:
                    break;
            }
        }
    }
    
}

-(void)changeAttend
{
    [self requestUserInfoData];
    if ([sns.ldap_uid isEqualToString:_person_id]) {
        return;
    }
    
    //    return;
    //    [self requestListData];
    
}

- (void)noti_loginOut{
    self.userInfoModel = nil;
    for (int i = 0; i < _menuCount; i ++) {
        UIView *view = self.contentScrollView.subviews[i];
        [view setValue:nil forKey:@"contentArray"];
        [view setValue:@NO forKey:@"isAbandonRefresh"];
    }
}

-(void)loginIn
{
    _person_id = sns.ldap_uid;
}

-(void)requestUserInfoDataKVO{
    [self requestUserInfoData];
}
#pragma mark -手势触发
-(void)changeBackImage:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"推荐图片", nil];
    [action showInView:self.view];
    
}
//进入搭配详情，判断是否登录暂时屏蔽
-(void)enterButton:(UITapGestureRecognizer *)selector{
    
    UIViewController *controller = nil;
    switch (selector.view.tag) {
        case 1:{//我的商品
            
            SMineProductViewController *myProduct=[[SMineProductViewController alloc]init];
            myProduct.personId=_person_id;
            controller=myProduct;
        }
            break;
        case 2:{//我的喜欢
            SMineLikeViewController *mylike = [[SMineLikeViewController alloc] init];
            mylike.person_id = self.person_id;
            controller = mylike;
        }
            break;
        case 3:{//我的收藏
            MyLikeViewController *mylike=[[MyLikeViewController alloc]init];
            mylike.use_Id=_person_id;
            if([sns.ldap_uid isEqualToString:_person_id]){
                mylike.isMy=true;
            }else{
                mylike.isMy=false;
            }
            controller=mylike;
            
        }
            break;
        default:
            break;
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
- (void)followclicked{
    _followFollowerIndex=1;
    [self SMineFollowFollower];
}
- (void)followerclicked {
    _followFollowerIndex=2;
    [self SMineFollowFollower];
}

-(void)showMenu:(id)sender
{
    if(self.navigationController.viewControllers.count>1)
    {
        [self popAnimated:YES];
        return;
    }
    
    [[SUtilityTool shared] showOrHideLeftSideView];
}
- (void)onBack:(UIButton*)sender {
    
    [self popAnimated:YES];
}

-(void)sreleaseClicked{
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
}



-(void)shareButtonClick:(id)sender
{
    //点击分享按钮
    ShareData *shareData = [[ShareData alloc]init];
    
    shareData.title =@"有范";
    
    NSString *shareUrl=[NSString stringWithFormat:@"%@",U_SHARE_USER_URL];
    
    
    
    NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
    
    
    
    NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
    
    NSString *noLastUrlStr=detailUrlStr;
    
    if ([lastStr isEqualToString:@"?"]) {
        
        noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
        
    }
    
    shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
    
    NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=user_center&userID=%@",self.person_id];
    
    NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
    
    
    
    shareData.shareUrl = [NSString stringWithFormat:@"%@",web_urlStr];
    
    
    shareData.descriptionStr = @"";
    
    //    shareData.image = [Utils reSizeImage:titleShareImgView.image toSize:CGSizeMake(57,57)];
    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:shareData];
    
}
#pragma mark -访问数据
- (void)requestCarCount{
    //    if(![sns.ldap_uid isEqualToString:_person_id]){
    //        return;
    //    }
    if (sns.ldap_uid.length==0) {
        return;
    }
    NSLog(@"。。。dices。。。。");
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSLog(@"底册天  －－－－－－%@",dict);
        
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }
        //        [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
        
    }];
}

-(void)tapGest
{
    [_popView hidePop];
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_transparentblack.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if([_person_id isEqualToString:sns.ldap_uid]){
        self.userNameLabel.text = [Utils getSNSString:sns.myStaffCard.nick_name] ;
        self.userSignatureLabel.text = [Utils getSNSString:sns.myStaffCard.self_desc];
    }
    [self requestCarCount];
    
    [self refreshAttend];
    
    [self requestUserInfoData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [Toast hideToastActivity];
    
    [_popView hidePop];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.alpha = 1;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"smine view controller addobserver dealloc");
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 0)
    {  //相机
        [self cameraPhoto];
    }
    else if ( buttonIndex == 1)
    { //本地
        [self localPhoto];
    }
    else if (buttonIndex ==2)
    {
        ChoosePicViewController *choose=[[ChoosePicViewController alloc]init];
        choose.clickPic=^(NSString *pic,UIImage *image)
        {
            [self uploadPicWithImage:image withImgUrl:pic];
        };
        [self.navigationController pushViewController:choose animated:YES];
        
        
    }
}
-(void)uploadPicWithImage:(UIImage *)image withImgUrl:(NSString *)imgUrl
{
    if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected])) {
        [Toast makeToastActivity:@"背景上传中，请稍等..." hasMusk:YES];
        
        //        isChangeBackImgView= YES;
        
        NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
        
        if (!userToken) {
            [Toast hideToastActivity];
            [Toast makeToast:@"错误参数!" duration:1.5 position:@"center"];
            return;
        }
        [[SDataCache sharedInstance] uploadBackImgView:image stickerImage:nil contentUrl:imgUrl withData:nil complete:^(NSString *str) {
            [_backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]] placeholderImage:[UIImage imageNamed:@"Unico/smin_backimg.png"]];
            [Toast hideToastActivity];
            
        }];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)cameraPhoto {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagepicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagepicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        imagepicker.delegate = self;
        imagepicker.allowsEditing = YES;
        imagepicker.showsCameraControls = YES;
        imagepicker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*45/180);
        imagepicker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
        
        [self presentViewController:imagepicker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = viewController.navigationItem.title;
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.font = FONT_T2;
    
    viewController.navigationItem.titleView = titleLabel;
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *editimage = [info objectForKey:UIImagePickerControllerEditedImage];
        [_backImageView setImage:editimage];
        if (editimage != nil) {
            [self uploadPicWithImage:_backImageView.image  withImgUrl:nil];
        }
        else
        {
            [Toast hideToastActivity];
        }
    }
}

- (void)scrollToTop{
    
    UIScrollView *scrollView = self.contentScrollView.subviews[_selectedIndex];
    if (scrollView.contentOffset.y <= - scrollView.contentInset.top) {
        _pageIndex = 0;
        [scrollView setValue:@NO forKey:@"isAbandonRefresh"];
        [self requestUserInfoData];
        [self requestListData];
    }
    [scrollView setContentOffset:CGPointMake(0, - scrollView.contentInset.top) animated:YES];
}

//
//- (void)requestData{
//    if ([_person_id isEqualToString:sns.ldap_uid]) {
//        self.userNameLabel.text = sns.myStaffCard.nick_name;
//        self.userSignatureLabel.text = sns.myStaffCard.self_desc;
//        [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];
//    }
//
//    [self requestUserInfoData];
//
//
//}


//- (void)onRemote {
//    self.badgeView.text = [NSString stringWithFormat:@"%d", UNREAD_ALL_NUMBER];
//    if ([self.badgeView.text intValue] >= 10) {
//        self.badgeView.textColor = [Utils HexColor:0xfb5b4e Alpha:1];//COLOR_C12;
//        _badgeView.size = CGSizeMake(8, 8);
//    }else {
//        self.badgeView.textColor = [UIColor whiteColor];
//        _badgeView.size = CGSizeMake(19, 11);
//    }
//    if ([sns.ldap_uid isEqualToString:self.person_id] && [self.badgeView.text intValue] > 0) {
//        self.badgeView.hidden = NO;
//    }else {
//        self.badgeView.hidden = YES;
//    }
//}

//- (void)onMsg:(NSNotification*)notification {
//    self.badgeView.text = [NSString stringWithFormat:@"%d", UNREAD_ALL_NUMBER];
//    if ([self.badgeView.text intValue] >= 10) {
//        self.badgeView.textColor = [Utils HexColor:0xfb5b4e Alpha:1];//COLOR_C12;
//        _badgeView.size = CGSizeMake(8, 8);
//    }else {
//        self.badgeView.textColor = [UIColor whiteColor];
//        _badgeView.size = CGSizeMake(19, 11);
//    }
//    if ([sns.ldap_uid isEqualToString:self.person_id] && UNREAD_ALL_NUMBER > 0) {
//        self.badgeView.hidden = NO;
//    }else {
//        self.badgeView.hidden = YES;
//    }
//
//}

#pragma mark - 用户头信息数据请求
- (void)requestUserInfoData{
    
    //    [Toast makeToastActivity];
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    
    NSDictionary *data = @{
                           @"m": @"User",
                           @"a": @"getUserMineInfo",
                           @"token": userToken,
                           @"targetUserId": _person_id
                           };
    NSLog(@"...data...%@",data);
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        NSDictionary * responseDic = (NSDictionary *)responseObject;
        if([[responseDic allKeys] containsObject:@"data"])
        {
            NSLog(@"responseDicdata－－－－%@",responseDic[@"data"]);
            
            if ([[NSString stringWithFormat:@"%@",responseDic[@"data"]] isEqualToString:@"error"]) {
                [Toast hideToastActivity];
                return ;
            }
            if ([[NSString stringWithFormat:@"%@",responseDic[@"status"]] isEqualToString:@"-101"]) {
                [Toast hideToastActivity];
                return;
            }
            if ([responseDic[@"data"] isKindOfClass:[NSArray class]]) {
                self.userInfoModel = [[MBOtherStoreModel alloc]initWithDictionary:responseDic[@"data"]];
            }
            else
            {
                self.userInfoModel = [[MBOtherStoreModel alloc]initWithDictionary:responseDic[@"data"]];
            }
            //            if (!isChangeBackImgView) {
            
            if (_backImageView.image) {
                
            }
            [_backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userInfoModel.userInfo.back_img]] placeholderImage:[UIImage imageNamed:@"Unico/smin_backimg.png"]];
            //            }
        }
        [Toast hideToastActivity];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast hideToastActivity];
        if([_person_id isEqualToString:sns.ldap_uid])
            [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];
        
    }];
}

#pragma mark - list data request
- (void)requestListData{
    
    UIView *view = self.contentScrollView.subviews[_selectedIndex];
    NSNumber *isAbandonRefresh = [view valueForKey:@"isAbandonRefresh"];
    if (isAbandonRefresh.boolValue) {
        
    }else{
        [view setValue:@YES forKey:@"isAbandonRefresh"];
    }
    switch (_selectedIndex) {
        case 0://搭配
        case 1://关注
            [self requestShoppingList];
            break;
        case 2://粉丝
            [self requestDesignerList:_selectedIndex];
            break;
        case 3://喜欢
            //            [self requestShoppingList];
            break;
        default:
            break;
    }
}

- (void)requestListAddData{
    UIView *view = self.contentScrollView.subviews[_selectedIndex];
    [view setValue:@NO forKey:@"isAbandonRefresh"];
    NSArray *array = [view valueForKey:@"contentArray"];
    
    _pageIndex = (array.count + 9)/ 10;
    //粉丝和关注pageindex问题
    if (_selectedIndex==2||_selectedIndex==3) {
        _pageIndex--;
        
    }
    
    [self requestListData];
}

- (void)requestShoppingList{
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
    
    SDataCache *dataCache = [SDataCache sharedInstance];
    [dataCache userInfo];
    NSString *tokenStr = @"";
    if(dataCache.userInfo[@"token"]){
        tokenStr =[NSString stringWithFormat:@"%@", dataCache.userInfo[@"token"]];
    }
    NSDictionary *data = nil;
    NSString *methodName = @"";
    NSString *serverName = @"";
    if (_selectedIndex == 0||_selectedIndex==1) {
        serverName = @"Collocation";
        methodName = @"getUserCollocationList";
    }
    
    data = @{
             @"m": serverName,
             @"a": methodName,
             @"token":[Utils getSNSString:tokenStr],
             @"userId":_person_id,
             @"page":@(_pageIndex)};
    UIScrollView *view = self.contentScrollView.subviews[_selectedIndex];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [Toast hideToastActivity];
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if([status isEqualToString:@"-101"])
        {
            [view footerEndRefreshing];
            return ;
        }
        NSString *dataStr = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
        if ([dataStr isEqualToString:@"error"]) {
            [view footerEndRefreshing];
            return;
            
        }
        NSArray *array = responseObject[@"data"];
        [view footerEndRefreshing];
        
        NSArray *oldArray = [view valueForKey:@"contentArray"];
        if (_pageIndex == 0) {
            [view performSelector:@selector(setContentArray:) withObject:nil];
            [view performSelector:@selector(setContentArray:) withObject:array];
        }else{
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:oldArray];
            [mutableArray addObjectsFromArray:array];
            [view performSelector:@selector(setContentArray:) withObject:mutableArray];
        }
        if(array.count==0&&_pageIndex==0){
            [self configNotifyViewWithTitle];
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast hideToastActivity];
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

- (void)requestDesignerList:(NSInteger)index{
    NSString *methodName = @"";
    NSString *userParamsName = @"";
    BOOL isattend = NO;
    switch (index) {
        case 1://关注
            userParamsName = @"UserId";
            methodName = @"UserConcernFilter";
            isattend = YES;
            break;
        case 2://粉丝
            userParamsName = @"ConcernId";
            methodName = @"UserConcernByConcernIdFilter";
            isattend = NO;
            break;
        default:
            break;
    }
    NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
    NSDictionary *params = @{userParamsName: _person_id,
                             @"LoginUserId": loginUserID,
                             @"pageSize": @15,
                             @"pageIndex": @(_pageIndex+1)};
    SMineDesignerTableView *view = self.contentScrollView.subviews[index];
    NSLog(@"params－－－%@",params);
    [HttpRequest accountGetRequestPath:nil methodName:methodName params:params success:^(NSDictionary *dict) {
        NSMutableArray *array = [MBOtherUserInfoModel modelArrayWithDataArray:dict[@"results"] WithType:isattend];
        [view footerEndRefreshing];
        if (_pageIndex == 0) {
            [view performSelector:@selector(setContentArray:) withObject:array];
        }else{
            [view.contentArray addObjectsFromArray:array];
            view.contentArray = view.contentArray;
        }
    } failed:^(NSError *error) {
        NSLog(@"他人店铺我的粉丝请求错误---%@", error);
        [Toast hideToastActivity];
    }];
}

#pragma mark selected delegate
- (void)selectedSubContentViewSelectedIndex:(NSInteger)index{
    [self moveAndRequest];
    
    if(index!=2){
        _selectedIndex = index;
        _pageIndex = 0;
        [_contentScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * index, 0) animated:YES];
        [self requestListData];
    }else{
        [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
        [self.selectedContentView scrollViewEndAction:_selectedIndex];
    }
}

#pragma mark - scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self moveAndRequest];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/ UI_SCREEN_WIDTH;
    [self.selectedContentView scrollViewEndAction:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [_popView hidePop];
    NSInteger index = ceilf(scrollView.contentOffset.x/ UI_SCREEN_WIDTH);
    if(index==2)return;
    CGFloat scrollViewContentWidth = scrollView.contentSize.width - SCREEN_WIDTH;
    CGFloat scrollViewLocation = scrollView.contentOffset.x;
    CGFloat percentage = scrollViewLocation / scrollViewContentWidth;
    [self.selectedContentView setLineLocationPercentage:percentage];
}

- (void)moveAndRequest{
    CGFloat max_Y = CGRectGetMaxY(self.contentHeaderView.frame) + ISSUE_HEIGHT;
    for (int i = 0; i < _menuCount; i ++) {
        if (_selectedIndex == i) continue;
        UIScrollView *scrollView = _contentScrollView.subviews[i];
        scrollView.contentOffset = CGPointMake(0, -max_Y);
    }
}

- (void)onPop {
    if (!_popView) {
        PopView2 *view = [[PopView2 alloc] initPopView:CGRectMake(UI_SCREEN_WIDTH - 115, 50+5, 100, 100)];
        view.delegate = self;
        [self.view addSubview:view];
        _popView = view;
        [_popView showPop];
        return;
    }
    [_popView hidePop];
}

- (void)onCart {
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

- (void)onHome {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headclicked {
    
    if ([sns.ldap_uid isEqualToString:_person_id] && sns.ldap_uid.length != 0) {
        
        MBSettingMainViewController *setVC = [[MBSettingMainViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
        
    }else{
        
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image =  imageB.image;
        photo.srcImageView = self.userHeaderImageView;// self.userHeaderImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photos = photos; // 设置所有的图片
        [browser show];
        [browser hiddenSaveImageButton:YES];
    }
}

-(void)SMineFollowFollower{
    SMineFollowFollowerViewController *SMineFollowFollower = [[SMineFollowFollowerViewController alloc]initWithNibName:@"SMineFollowFollowerViewController" bundle:nil];
    SMineFollowFollower.selectedIndex=_followFollowerIndex;
    SMineFollowFollower.person_id=_person_id;
    [self.navigationController pushViewController:SMineFollowFollower animated:YES];
    
}
#pragma mark - scroll delegate

- (void)listViewWillBeginDraggingScroll:(UIScrollView *)scrollView{
    //    [self.tabBarController setValue:scrollView forKey:@"scrollViewBegin"];
}

- (void)listViewDidScroll:(UIScrollView *)scrollView{
    
    [_popView hidePop];
    //    [self.tabBarController setValue:scrollView forKey:@"controlScrollView"];
    
    UIScrollView *currentScrollView = self.contentScrollView.subviews[_selectedIndex];
    if (scrollView != currentScrollView) {
        return;
    }
    CGFloat minMove_Y = -(self.contentHeaderView.frame.size.height+ISSUE_HEIGHT);
    CGFloat maxMove_Y = -(self.contentHeaderView.frame.size.height - fabs(minMove_Y) + _selectedContentView.frame.size.height);
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGRect frame = self.contentHeaderView.frame;
    if (-self.contentHeaderView.frame.size.height - ISSUE_HEIGHT <= offset_Y && offset_Y <= maxMove_Y - 75) {
        frame.origin.y = -self.contentHeaderView.frame.size.height - ISSUE_HEIGHT - offset_Y;
    }else{
        frame.origin.y = offset_Y < minMove_Y? 0: minMove_Y + _selectedContentView.frame.size.height + 20;
    }
    offset_Y += ISSUE_HEIGHT;
    
    [self setttingNavigationAlpha:offset_Y];
    
    CGRect showStateFrame = _showStateView.frame;
    if (offset_Y > -20) {
        showStateFrame.origin.y = -20;
    }else if (offset_Y > - 40){
        showStateFrame.origin.y = -(40 + offset_Y);
    }else{
        showStateFrame.origin.y = 0;
    }
    
    if (offset_Y > -30){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    _showStateView.frame = showStateFrame;
    
    self.contentHeaderView.frame = frame;
    CGRect rect = self.selectedContentView.frame;
    rect.origin.y = CGRectGetMaxY(frame);
    self.selectedContentView.frame = rect;
}

- (void)setttingNavigationAlpha:(CGFloat)offset_Y{
    if (-64 <= offset_Y && offset_Y <= 20) {
        self.navigationController.navigationBar.alpha = 1 - (64 + offset_Y)/ 44;
    }else if(-64 >= offset_Y){
        self.navigationController.navigationBar.alpha = 1;
    }else{
        self.navigationController.navigationBar.alpha = 0;
    }
}

-(void)cellDeleteAtIndex:(NSInteger)indexCell
{
    UIScrollView *view = self.contentScrollView.subviews[1];
    NSArray *oldArray = [view valueForKey:@"contentArray"];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:oldArray];
    [mutableArray removeObjectAtIndex:indexCell];
    
    [view performSelector:@selector(setContentArray:) withObject:mutableArray];
    
    
    view = self.contentScrollView.subviews[0];
    oldArray = [view valueForKey:@"contentArray"];
    mutableArray = [NSMutableArray arrayWithArray:oldArray];
    if(mutableArray.count>indexCell){
        [mutableArray removeObjectAtIndex:indexCell];
    }
    
    [view performSelector:@selector(setContentArray:) withObject:mutableArray];
    
    
    if(mutableArray.count==0){
        [self requestListAddData];
    }
    [Toast  makeToastSuccess:@"删除成功"];
    
    _userInfoModel.collocationCount = @(_userInfoModel.collocationCount.intValue - 1);
    self.userInfoModel = _userInfoModel;
}
#pragma mark - need reload data delegate
- (void)needRequestLoadData:(UITableView *)tableView{
    //    if ([_person_id isEqualToString:sns.ldap_uid]) {
    //        [self requestDesignerList:1];
    //    }
    [self requestDesignerList:1];
}

//TODO:逻辑有问题
#pragma mark - get set
- (void)setUserInfoModel:(MBOtherStoreModel *)userInfoModel{
    _userInfoModel = userInfoModel;
    
    if ([_person_id isEqualToString:sns.ldap_uid]) {
        self.userNameLabel.text = sns.myStaffCard.nick_name;
        self.userSignatureLabel.text = sns.myStaffCard.self_desc;
        [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];
        
    }else{
        self.userSignatureLabel.text = userInfoModel.userInfo.signature;
        self.userNameLabel.text = userInfoModel.userInfo.nick_name;
        [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:userInfoModel.userInfo.head_img] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];
        imageB=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        [imageB sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.userInfo.head_img] placeholderImage:nil];
    }
    
    switch ([userInfoModel.userInfo.head_v_type intValue]) {
        case 0:
        {
            _levelImgView.hidden=YES;
        }
            break;
        case 2:
        {
            _levelImgView.hidden=NO;
            [_levelImgView setImage:[UIImage imageNamed:@"peoplevip@2x"]];
        }
            break;
        case 1:
        {
            _levelImgView.hidden=NO;
            [_levelImgView setImage:[UIImage imageNamed:@"brandvip@2x"]];
        }
            break;
            
        default:
            break;
    }
    //0无关系 1他是我粉丝 2他是我关注人 3互相关注
    switch ([userInfoModel.status integerValue]) {
        case 0:
        case 1:{
            self.attentionButton.layer.borderWidth = 0.0;
            //            self.attentionButton.backgroundColor = COLOR_C1;
            [self.attentionButton setImage:[UIImage imageNamed:@"Unico/icon_add_attention.png"] forState:UIControlStateNormal];
        }
            break;
        case 2:
            self.attentionButton.backgroundColor = [UIColor clearColor];
            //            self.attentionButton.layer.borderWidth = 2.0;
            [self.attentionButton setImage:[UIImage imageNamed:@"Unico/icon_focus.png"] forState:UIControlStateNormal];
            break;
        case 3:
            self.attentionButton.backgroundColor = [UIColor clearColor];
            //            self.attentionButton.layer.borderWidth = 2.0;
            [self.attentionButton setImage:[UIImage imageNamed:@"Unico/icon_common.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    if (userInfoModel.status.boolValue) {
        
        
    }else{
        
    }
    self.attentionButton.selected = userInfoModel.status.boolValue;
    
    //    NSLog(@"self＝guanzhu＝＝＝＝%@----fensi-%@",userInfoModel.concernCount,userInfoModel.concernedCount);
    
    for (id obj in _ContentView.subviews) {
        if ([obj isKindOfClass:[SmineSelectedButton class]]) {
            SmineSelectedButton* Button = (SmineSelectedButton*)obj;
            switch (Button.tag) {
                case 0:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.collocationCount.stringValue];
                    break;
                case 1:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.productCount.stringValue];
                    break;
                case 2:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.collocationLikeCount.stringValue];
                    break;
                case 3:
                    Button.subLabel.text=[Utils getSNSInteger:_userInfoModel.bpLikeCount.stringValue];
                    break;
                default:
                    break;
            }
        }
    }
    
    
    
    //黄磊
    _followLabel.text=[NSString stringWithFormat:@"%d",userInfoModel.followCount.intValue];
    
    _followerLabel.text=[NSString stringWithFormat:@"%d",userInfoModel.followerCount.intValue];
    
}


#pragma mark - PopViewDelegate
- (void)popviewDidselect:(NSInteger)index {
    [_popView hidePop];
    switch (index) {
        case 0:
        {
            ScanViewController *scanView = [[ScanViewController alloc]initWithNibName:@"ScanViewController" bundle:nil];
            scanView.scanTypeChat = @"0";
            [self.navigationController pushViewController:scanView animated:YES];
        }
            break;
        case 1:
        {
            MyIncomeViewController* incoVC = [[MyIncomeViewController alloc]initWithNibName:@"MyIncomeViewController" bundle:nil];
            [self.navigationController pushViewController:incoVC animated:YES];
        }
            break;
        case 2:
        {
            if (![BaseViewController pushLoginViewController]) {
                return;
            }
            NSString *inviteUrl = kInviteCodeUrl;
            JSWebViewController *webCon = [[JSWebViewController alloc] initWithUrl:inviteUrl];
            [webCon setNaviTitle:@"我的邀请码"];
            [self.navigationController pushViewController:webCon animated:YES];
        }
            break;
            
            
        default:
            break;
    }
    
    return;
    
    switch (index) {//@[@"分享", @"扫一扫", @"访客数", @"我的收益", @"我的商品"];
            //扫一扫   我的收益  我的邀请码
        case 0:
        {
            [self headclicked];
        }
            break;
        case 1:
        {
            ScanViewController *scanView = [[ScanViewController alloc]initWithNibName:@"ScanViewController" bundle:nil];
            scanView.scanTypeChat = @"1";
            [self.navigationController pushViewController:scanView animated:YES];
        }
            break;
        case 2:
        {
            MBStoreVisitorViewController *visVC = [[MBStoreVisitorViewController alloc] initWithNibName:@"MBStoreVisitorViewController" bundle:nil];
            //            visVC.user_ID = _person_id;
            visVC.user_ID=sns.ldap_uid;
            
            [self.navigationController pushViewController:visVC animated:YES];
        }
            break;
        case 3:
        {
            MyIncomeViewController* incoVC = [[MyIncomeViewController alloc]initWithNibName:@"MyIncomeViewController" bundle:nil];
            [self.navigationController pushViewController:incoVC animated:YES];
        }
            break;
        case 4:
        {
            [self orderButtonAction:self.messageButton];
            return;
            MBMyGoodsViewController *goodVC = [[MBMyGoodsViewController alloc] initWithNibName:@"MBMyGoodsViewController" bundle:nil];
            [self.navigationController pushViewController:goodVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)refreshAttend
{
    //刷新
    for(int i = 0; i < _menuCount; i++){
        //        if (i==0) {
        //            continue;
        //        }
        
        UIView *view = _contentScrollView.subviews[i];
        [view setValue:@NO forKey:@"isAbandonRefresh"];
    }
    [self selectedSubContentViewSelectedIndex:_selectedIndex];
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
        NSDictionary *data=@{@"m":@"Account",
                             @"a":@"UserConcernDelete",
                             @"userId":loginUserID,
                             @"concernIds":_person_id};
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
            [Toast hideToastActivity];
            
            BOOL issuccess=NO;
            if ([[responseObject allKeys] containsObject:@"isSuccess"]) {
                issuccess  = [responseObject[@"isSuccess"] boolValue];
            }
            if(!issuccess)
            {
                [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
                return ;
            }
            self.attentionButton.selected = NO;
            self.attentionButton.layer.borderWidth = 0.0;
            //            self.attentionButton.backgroundColor = COLOR_C1;
            [self.attentionButton setImage:[UIImage imageNamed:@"Unico/icon_add_attention.png"] forState:UIControlStateNormal];
            
            //            [Toast makeToast:@"已取消关注!" duration:1.5 position:@"center"];
            //                        userInfoModel.status=@0;
            [Toast makeToastSuccess:@"已取消关注!"];
            [self refreshAttend];
            [self changeAttend];
            //社区-推荐达人
            if ([SMainViewController instance].attentionTbView) {
                [SMainViewController instance].attentionTbView.masterCellReloadBlock(NO);
            }
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            [Toast makeToast:@"取消关注失败!" duration:1.5 position:@"center"];
        }];
        
        
        
    }
}

- (IBAction)orderButtonAction:(UIButton *)sender {
    MyOrderViewController *controller = [[MyOrderViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ta人 消息按钮
- (void)onMessage{
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    
    SChatController *vc = [SChatController new];
    vc.targetUserId = _person_id;
    vc.targetName = _userInfoModel.userInfo.nick_name;
    vc.img = [NSString stringWithFormat:@"%@",_userHeaderImageView.sd_imageURL];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)messageButtonAction:(UIButton *)sender {
    [self onMessage];
    //huang
    //    SChatListController *vc = [SChatListController new];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)attentionButtonAction:(UIButton *)sender {
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    NSInteger status=[_userInfoModel.status integerValue];
    switch (status) {
        case 0:
        case 1:{
            NSString *loginUserID = sns.ldap_uid? sns.ldap_uid: @"";
            NSDictionary *data=@{@"m":@"Account",
                                 @"a":@"UserConcernCreate",
                                 @"userId":loginUserID,
                                 @"concernId":_person_id};
            AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
            [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
                [Toast hideToastActivity];
                
                if ([[responseObject allKeys]containsObject:@"isSuccess"]) {
                    BOOL  isSuccess = [responseObject[@"isSuccess"] boolValue];
                    if(!isSuccess)
                    {
                        NSString *message =nil;
                        message = responseObject[@"message"];
                        [Toast makeToast:message duration:1.5 position:@"center"];
                        return ;
                    }
                }
                self.attentionButton.selected = YES;
                //                self.attentionButton.layer.borderWidth = 2.0;
                self.attentionButton.backgroundColor = [UIColor clearColor];
                if(status==0){
                    _userInfoModel.status=[NSNumber numberWithInteger:2];
                    [self.attentionButton setImage:[UIImage imageNamed:@"Unico/icon_focus.png"] forState:UIControlStateNormal];
                }else{
                    _userInfoModel.status=[NSNumber numberWithInteger:3];
                    [self.attentionButton setImage:[UIImage imageNamed:@"Unico/icon_common.png"] forState:UIControlStateNormal];
                }
                
                [Toast makeToastSuccess:@"关注成功!"];
                [self refreshAttend];
                //社区-推荐达人
                //                [SMainViewController instance].attentionTbView.masterCellReloadBlock(_userInfoModel);
                if ([SMainViewController instance].attentionTbView) {
                    [SMainViewController instance].attentionTbView.masterCellReloadBlock(YES);
                }
            } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                [Toast makeToast:@"关注失败!" duration:1.5 position:@"center"];
            }];
        }
            break;
            
        case 2:
        case 3:{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消关注" message:@"您将取消对此用户的关注！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.delegate = self;
            [alertView show];
        }
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popView hidePop];
}
//没有数据显示背景图
-(void)configNotifyViewWithTitle{
    
    if (placeholdView) {
        [placeholdView removeFromSuperview];
        placeholdView = nil;
    }
    
    placeholdView = [[UIView alloc] initWithFrame:CGRectMake(0,0,UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-CGRectGetMaxY(_contentHeaderView.frame)-ISSUE_HEIGHT)];
    placeholdView.backgroundColor=COLOR_NORMAL;
    
    
    
    UILabel *messageLabel;
    NSString *text=@"";
    if ([sns.ldap_uid isEqualToString:_person_id] && sns.ldap_uid.length != 0) {
        CGRect bgViewRect = CGRectMake((UI_SCREEN_WIDTH-100)/2, (placeholdView.frame.size.height-75)/2, 100, 30);
        SReleaseButton *releaseBtn = [[SReleaseButton alloc] initWithFrame:bgViewRect];
        releaseBtn.backgroundColor = [UIColor blackColor];
        [releaseBtn setTitle:@"发布搭配" forState:UIControlStateNormal];
        [releaseBtn addTarget:self action:@selector(sreleaseClicked)
             forControlEvents:UIControlEventTouchUpInside];
        [placeholdView addSubview:releaseBtn];
        text=@"您还未发布过搭配";
        messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, releaseBtn.frame.origin.y-20-10, SCREEN_WIDTH, 20)];
    }else{
        messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, (placeholdView.frame.size.height-25)/2, SCREEN_WIDTH, 20)];
        text=@"Ta还未发布过搭配";
    }
    [messageLabel setFont:FONT_t5];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:COLOR_C6];
    [messageLabel setText:text];
    [placeholdView addSubview:messageLabel];
    
    
    if(_selectedIndex==0){
        [releaseCollectionView addSubview:placeholdView];
    }
    else if(_selectedIndex==1){
        [releaseTableView addSubview:placeholdView];
    }
}

@end
