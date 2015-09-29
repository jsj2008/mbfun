//
//  SBestCollocationViewController.m
//  Wefafa
//
//  Created by 凯 张 on 15/5/31.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBestCollocationViewController.h"
#import "XLCycleScrollView.h"
#import "SItemListViewController.h"
#import "SUtilityTool.h"
#import "XLCycleScrollView.h"
#import "HttpRequest.h"
#import "DesignerModel.h"
#import "BrandListCellModel.h"
#import "UIImageView+AFNetworking.h"
#import "SItemViewController.h"
#import "BrandListViewController.h"
#import "SBrandShowListControllerViewController.h"
#import "BrandStoryOneViewController.h"
#import "SCollocationDetailViewController.h"
#import "SDesignerViewController.h"
#import "SDataCache.h"
#import "LNGood.H"
#import "SStarStoreViewController.h"
#import "SCollocationCollectionViewCell.h"
#import "SBrandViewController.h"
#import "SHeaderTitleView.h"
#import "SHeaderTitleModel.h"
#import "WeFaFaGet.h"
#import "LoginViewController.h"
#import "ShoppIngBagShowButton.h"
#import "MyShoppingTrollyViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "Toast.h"

@interface SBestCollocationViewController()<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate, SHeaderTitleCollectionViewDelegate>{
    XLCycleScrollView *idsScroll;
    NSArray *idsArray;
    NSMutableArray * recommendBrandArr;//推荐品牌数据源
    NSMutableArray * recommendDesignerArr;//推荐设计师数据源
    NSArray *dpData;
    //选择的按钮
    UIButton *p_selectButton;
    UIImageView *p_selectView_y;
    
    UIImageView *loadingBg;
    BOOL isScrollLoading;
    CGFloat _titleFrameOrigin_Y;
    
    NSString *_selectedTitleName;
}

@property (nonatomic, strong) SHeaderTitleView *titleView;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@property (nonatomic, strong) UIImageView *backView;

@end

@implementation SBestCollocationViewController
@synthesize goodsList = _goodsList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchBarViewSet];
}

-(void)initSearchBarViewSet
{
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 64)];
    _backView = backView;
    backView.image = [UIImage imageNamed:@"Unico/common_navi_mixblack.png"];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    backView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 44)];
    label.text = @"最+搭配";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [backView addSubview:label];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(4, backView.bottom - 44, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"Unico/camera_navbar_back.png"] forState:UIControlStateNormal];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [backView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    
    if (!_shoppingBagButton) {
        _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(backView.right-44, 20+(44-33)/2, 33, 33)];// 0 0
        [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
//        [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_shoppingBagButton setOrigin:CGPointMake(0, 0)];
    }
    [backView addSubview:_shoppingBagButton];
    [_shoppingBagButton addTarget:self action:@selector(onCart:) forControlEvents:UIControlEventTouchUpInside];
//    _selectedTitleName=@"全部";
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
//        [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
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


-(void)layoutUI{
    [super layoutUI];
    [self requestCarCount];
    [self.collectionView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    [self.collectionView addFooterWithTarget:self action:@selector(requestAddData)];
}


-(void) getData{
    self.goodsList = nil;
    [self getBestCollocationBanner];
    [self getCollocationList:NO tabString:@""];
    
    
}
-(void)getBestCollocationBanner{
    [SDATACACHE_INSTANCE getBestCollocationBanner:^(NSArray *data) {
        _listDict = (NSDictionary*)data;
        [self dealData];
    }];
}

- (void)requestAddData{
    LNGood *goods = [self.goodsList firstObject];
    NSInteger listCount = self.goodsList.count - (goods.show_type.boolValue? 1: 0);
    NSInteger pageIndex = (listCount + 9)/ 10;
    NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"getBestCollocationList",
                           @"tabstr": _selectedTitleName? _selectedTitleName: @"",
                           @"page":@(pageIndex)
                           };
    
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        //转换成LNGood的数据模型
         NSArray *array = object[@"data"];
        [self.collectionView footerEndRefreshing];
        if (!self.goodsList) {
            self.goodsList = [NSMutableArray arrayWithCapacity:array.count];
        }
        if (array.count == 0) {
            [Toast makeToast:@"没有更多数据!"];
        }
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            //先这么解决吧 刷新2个日期cell问题
            for (int a=0; a<[self.goodsList count];a++) {
                LNGood *gooda = self.goodsList[a];
                if ([[goods.show_type stringValue] isEqualToString:@"1"]&&[[gooda.show_type stringValue] isEqualToString:@"1"]) {
                    [self.goodsList removeObjectAtIndex:a];
                    break;
                }
            }
            [self.goodsList addObject:goods];
        }];
        self.goodsList = self.goodsList;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.collectionView footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

-(void) getCollocationList:(BOOL)isScrollUpdate tabString:(NSString*)tabString{
    _selectedTitleName = tabString;
    [[SDataCache sharedInstance] getBestCollocationList:0 tabstr:tabString complete:^(NSArray *data) {
        //转换成LNGood的数据模型
        if (!self.goodsList) {
            self.goodsList = [NSMutableArray arrayWithCapacity:data.count];
        }
        [self.goodsList removeAllObjects];
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            [self.goodsList addObject:goods];
        }];
        self.goodsList = self.goodsList;
        if (isScrollUpdate) {
            [self.collectionView reloadData];
        }else{
            [self dealCollocationData];
        }
    }];
}

-(void) getCollocationList:(BOOL)isScrollUpdate{
    [[SDataCache sharedInstance] getCollocationListForDetails:0 complete:^(NSArray *data) {
        //转换成LNGood的数据模型
        if (!self.goodsList) {
            self.goodsList = [NSMutableArray arrayWithCapacity:data.count];
        }
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            [self.goodsList addObject:goods];
        }];
        self.goodsList = self.goodsList;
        if (isScrollUpdate) {
            [self.collectionView reloadData];
        }else{
            [self dealCollocationData];
        }
        
    }];
}

- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealCollocationData{
    if (!_listDict || !self.goodsList || self.goodsList.count <= 0) {
        return;
    }else{
        [self layoutUI];
    }
}

-(void)dealData{
    if (!_listDict || !self.goodsList || self.goodsList.count <= 0) {
        return;
    }else{
        [self layoutUI];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc{
    // FIXED: 在此释放
    idsScroll.delegate = nil;
    idsScroll.datasource = nil;
}


-(void)clickBack:(id)selector{

    [self popAnimated:YES];
}

-(void)onCart:(id)sender{
    
    if (!IS_STRING(sns.ldap_uid)) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    
     MyShoppingTrollyViewController *vc1=[[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
    [self.navigationController pushViewController:vc1 animated:YES];
}



-(void) updateHeaderView:(UICollectionReusableView*) headerView{
    UIImageView *tempView;
    float offset = 0;
    UIView *tempUIView;
    UIView *tempUI;
    NSDictionary *tempDict;
    UIScrollView *tempScrollView;
//    UIScrollView *tempScrollView = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, offset, UI_SCREEN_WIDTH, 0)];
//    tempAry = @[@"全部",@"最有范",@"臭美妞",@"骚包男",@"熊孩纸",@"吃不胖",@"胖不吃",@"不吃胖"];
//    
//    for (int i = 0; i<[tempAry count]; i++) {
//        labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempAry[i] fontStyle:FONT_SIZE(12) ];
//        tempBtn = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:tempAry[i] bgColor:nil fontColor:UIColorFromRGB(0x3b3b3b) fontStyle:FONT_SIZE(12) rect:CGRectMake(43/2+i*(labelSize.width+36/2), 0, labelSize.width, 90/2) target:self action:@selector(selectCollocationType:)];
//        
//        tempColor = COLOR_C5;
//        tempBtn.tag = BASE_BTN_TAG + i;
//        if (i == 0 ) {
//            p_selectButton = tempBtn;
//            tempColor = COLOR_C2;
//            tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/selected_3" rect:CGRectMake(43/2+tempBtn.width/2-80/2/2, tempBtn.height - 6/2, 80/2, 6/2)];
//            [tempScrollView addSubview:tempView];
//            p_selectView_y = tempView;
//        }
//        [tempBtn setTitleColor:tempColor forState:UIControlStateNormal];
//        [tempScrollView addSubview:tempBtn];
//    }
//    [tempScrollView setSize:CGSizeMake(UI_SCREEN_WIDTH, 90/2)];
//    
//    tempScrollView.contentSize = CGSizeMake(tempBtn.frame.origin.x + tempBtn.frame.size.width, 90/2);
//    //两根线
//    UIView *tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:nil];
//    [tempUI setOrigin:CGPointMake(0, tempScrollView.frame.origin.y -1)];
//    [headerView addSubview:tempUI];
//    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:nil];
//    [tempUI setOrigin:CGPointMake(0, tempScrollView.frame.origin.y + tempScrollView.height + 1)];
//    [headerView addSubview:tempUI];
//    
//    
//    [headerView addSubview:tempScrollView];
//    //暂时隐藏
//    
//    offset += tempScrollView.frame.size.height;
    if (self.listDict[@"banner"][@"1004"]) {
       
        idsArray = (NSArray*)self.listDict[@"banner"][@"1004"];
        
        if (!idsScroll) {
            idsScroll = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, offset, UI_SCREEN_WIDTH, 344/2)];
            [idsScroll setDataource:self];
            [idsScroll setDelegate:self];
        }
        
        if (idsArray.count > 0) {
//            widthFloat = [idsArray[0][@"img_width"]floatValue];
//            heightFloat = [idsArray[0][@"img_height"]floatValue];
//            tempFloat = (UI_SCREEN_WIDTH/(widthFloat/2)*(heightFloat/2));
//            [idsScroll setHeight:tempFloat];
            [idsScroll setShouldHandleTap:YES];
        }
        [idsScroll reloadData];
        
        offset += idsScroll.height;
        offset += 20/2;
        
    }
    
    if (self.listDict[@"banner"][@"1005"]) {
        NSArray *picAry = (NSArray*)self.listDict[@"banner"][@"1005"];
        tempScrollView = [SUTIL createScrollView:self rect:CGRectMake(0, offset, UI_SCREEN_WIDTH, 274/2)];
        tempScrollView.contentSize = CGSizeMake(picAry.count * (230/2 + 10), 0);
        tempScrollView.userInteractionEnabled = YES;
        for (int i = 0; i < picAry.count;i++) {
            tempDict = picAry[i];
            
            tempView = [UIImageView new];
            tempView.tag = i + 70;
            tempView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchScrollBannerTap:)];
            [tempView addGestureRecognizer:tap];
//            [tempView sd_setImageWithURL:[NSURL URLWithString:tempDict[@"img"]]];
            [tempView sd_setImageWithURL:[NSURL URLWithString:tempDict[@"img"]] isLoadThumbnail:NO placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            
            tempView.frame = CGRectMake(12/2 + i*(230/2+12/2), 0, 230/2, 274/2);
            [tempScrollView addSubview:tempView];
        }
        offset += tempScrollView.height;
        offset += 10;
        [headerView addSubview:tempScrollView];
    }
    
    
    //推荐搭配
    tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:0 coordY:offset];
    
    tempUI = [SUTILITY_TOOL_INSTANCE createUILabeLine:@"推荐搭配" color:UIColorFromRGB(0xc4c4c4) fontStyle:FONT_SIZE(12) interval:20/2];
    [tempUI setOrigin:CGPointMake(0, 50/2)];
    [tempUIView addSubview:tempUI];
    [tempUIView setHeight:(50/2+30/2+tempUI.height)];
    tempUIView.backgroundColor = COLOR_NORMAL;
    [headerView addSubview:tempUIView];
    
    CGPoint position = [self.view convertPoint:CGPointMake(0, offset) fromView:self.collectionView];
    position.y += 64;
    _titleView = [[SHeaderTitleView alloc]initWithFrame:CGRectMake(0, position.y, UI_SCREEN_WIDTH, 44)];
    _titleFrameOrigin_Y = position.y - self.collectionView.frame.origin.y;
    _titleView.headerTitleDelegate = self;
    _titleView.contentArray = _listDict[@"tab_list"];
    [self.view addSubview:_titleView];
    
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setSize:CGSizeMake(UI_SCREEN_WIDTH, offset)];
    offset += tempUIView.height;
    headerView.backgroundColor = COLOR_C4;
    //跑马灯
    [headerView addSubview:idsScroll];
    self.headerViewHeight = offset -10;
}

- (void)touchScrollBannerTap:(UITapGestureRecognizer *)tap{
    NSArray *picAry = self.listDict[@"banner"][@"1005"];
    NSDictionary *dict = picAry[tap.view.tag - 70];
    [[SUtilityTool shared] jumpControllerWithContent:dict target:self];
}

#pragma mark - SHeaderTitleCollectionView delegate

- (void)headerTitleCollectionView:(UICollectionView *)collectionView contentModel:(SHeaderTitleModel *)contenModel{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 3.0);  //NO，YES 控制是否透明
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat origin_Y;
    if (self.collectionView.contentOffset.y + 64 > CGRectGetMaxY(headContent.frame)) {
        origin_Y = self.collectionView.contentOffset.y + 64;
    }else{
        origin_Y = CGRectGetMaxY(headContent.frame);
    }
    CGPoint point = [self.collectionView convertPoint:CGPointMake(0, origin_Y + 44) toView:self.view];
    
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, point.y * 3, image.size.width * 3, image.size.height * 3))];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    CGRect frame = CGRectMake(0, point.y, UI_SCREEN_WIDTH, self.view.frame.size.height - point.y);
    imageView.frame = frame;

    [self.goodsList removeAllObjects];
    [self.collectionView reloadData];
    [self getCollocationList:YES tabString:[contenModel.name isEqualToString:@"全部"]? @"": contenModel.name];
    [self.view addSubview:imageView];
//    frame = imageView.frame;
//    frame.origin.x = - UI_SCREEN_WIDTH;
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
//        imageView.frame = frame;
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        [imageView removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = self.titleView.frame;
    frame.origin.y = _titleFrameOrigin_Y - scrollView.contentOffset.y;
    CGRect rect = _backView.frame;
    if (frame.origin.y < 64) {
        rect.origin.y = frame.origin.y - 64;
    }else{
        rect.origin.y = 0;
    }
    _backView.frame = rect;
    if (frame.origin.y < 20) {
        frame.origin.y = 20;
        [_titleView setOriginOffset:-(40 - frame.origin.y)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else if (frame.origin.y < 40){
        [_titleView setOriginOffset:-(40 - frame.origin.y)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else{
        [_titleView setOriginOffset:0];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    self.titleView.frame = frame;
}

- (void)setGoodsList:(NSMutableArray *)goodsList{
    _goodsList = goodsList;
    [self.collectionView reloadData];
//    UIEdgeInsets edgeInset = self.collectionView.contentInset;
//    CGFloat contentInsetBottom = self.collectionView.contentSize.height - self.headerViewHeight;
//    if (contentInsetBottom <= UI_SCREEN_HEIGHT - 64) {
//        edgeInset.bottom = contentInsetBottom;
//    }else{
//        edgeInset.bottom = 0;
//    }
//    self.collectionView.contentInset = edgeInset;
}

#pragma mark - XLCycleScrollDelagate
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    NSDictionary *info = idsArray[index];
    NSLog(@"Click %@",info);
    [[SUtilityTool shared] jumpControllerWithContent:info target:self];
//    [SUTIL showTodo];
}

#pragma mark -XLCycleScrollViewDatasource
- (NSUInteger)numberOfPages
{
    return idsArray.count;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    if (idsArray.count == 1) {
        [idsScroll.pageControl setHidden:YES];
        [idsScroll.scrollView setScrollEnabled:NO];
    } else {
        if (idsScroll.pageControl.isHidden) {
            [idsScroll.pageControl setHidden:NO];
        }
    }
    UIImageView *imageView  = [UIImageView new];
    NSString *tempStr = idsArray[index][@"img"];
    float widthFloat = [idsArray[index][@"img_width"] floatValue];
    float heightFloat = [idsArray[index][@"img_height"] floatValue];
    float tempFloat = (UI_SCREEN_WIDTH/(widthFloat/2)*(heightFloat/2));
//    [imageView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:tempStr] isLoadThumbnail:NO placeholderImage:[UIImage  imageNamed:DEFAULT_LOADING_IMAGE]];
    
    [imageView setSize:CGSizeMake(UI_SCREEN_WIDTH,tempFloat)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.backgroundColor = [UIColor whiteColor];
    [idsScroll setSize:imageView.size];
    return imageView;
}
@end

