//
//  SActivityDiscountBrandViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/11/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SActivityDiscountBrandViewController.h"
#import "SSearchProductCollectionViewCell.h"
#import "SActivityDiscountHeaderView.h"
#import "SHeaderTitleView.h"
#import "SActivityListModel.h"
#import "FilterBrandCategoryModel.h"
#import "SHeaderTitleModel.h"
#import "SActivityBrandListModel.h"
#import "SProductDetailViewController.h"
#import "ShoppIngBagShowButton.h"
#import "MyShoppingTrollyViewController.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "Toast.h"

@interface SActivityDiscountBrandViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SHeaderTitleCollectionViewDelegate>
{
    CGFloat _titleFrameOrigin_Y;
}

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, strong) NSMutableArray *titleModelArray;
@property (nonatomic, strong) NSMutableArray *contentListArray;
@property (nonatomic, strong) SHeaderTitleView *titleView;
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;

@end

static NSString *cellIdentifier = @"SMineTableViewCellIdentifier";
static NSString *headerIdentifier = @"SActivityBrandHeaderIdentifier";
@implementation SActivityDiscountBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupNavbar];
    
    _contentModelArray = [NSMutableArray array];
    _titleModelArray = [NSMutableArray array];
    [self initSearchBarViewSet];
    [self initSubViews];
    [self requestData];
    [self requestCarCount];
}

- (void)setupNavbar{
    self.navigationItem.title = @"折扣活动";
    [super setupNavbar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)requestData{
    //    NSArray *array = @[_contentModel.aID];
    [HttpRequest promotionPostRequestPath:nil methodName:@"PlatFormRangeDetail" params:@{@"id": _contentModel.aID} success:^(NSDictionary *dict) {
        self.contentModelArray = dict[@"results"][0][@"brandLst"];
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:2.0 position:@"center"];
    }];
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
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

- (void)requestContentListData:(FilterBrandCategoryModel*)model{
    NSDictionary *params = @{@"branD_ID": model.aID,
                             @"pageIndex": @1,
                             @"pageSize": @20};
    [HttpRequest productGetRequestPath:nil methodName:@"ProductClsByBrandIdFilter" params:params success:^(NSDictionary *dict) {
        if ([dict[@"isSuccess"] boolValue]) {
            self.contentListArray = [SActivityBrandListModel modelArrayForDataArray:dict[@"results"]];
        }else{
            [Toast makeToast:dict[@"message"] duration:1.5 position:@"center"];
        }
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}

- (void)initSubViews{
    _titleView = [[SHeaderTitleView alloc]initWithFrame:CGRectMake(0, 224 + 64, UI_SCREEN_WIDTH, 44)];
    _titleView.headerTitleDelegate = self;
    CGRect frame = _titleView.lineLayer.frame;
    frame.origin.y = 44 - 0.5;
    _titleView.lineLayer.frame = frame;
    CGPoint position = [self.view convertPoint:CGPointMake(0, 224 + 64) fromView:_contentCollectionView];
    _titleFrameOrigin_Y = position.y - _contentCollectionView.frame.origin.y;
    [self.view addSubview:_titleView];
    
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self.contentCollectionView registerClass:[SActivityBrandHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
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
    label.text = @"折扣活动";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [backView addSubview:label];

    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(4, backView.bottom - 44, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"Unico/icon_back.png"] forState:UIControlStateNormal];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [backView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart.png"] forState:UIControlStateNormal];
    [backView addSubview:_shoppingBagButton];
    [_shoppingBagButton addTarget:self action:@selector(shoppingbag) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shoppingbag{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *controller = [[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self pushController:controller animated:YES];
    }
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    for (NSDictionary *dict in contentModelArray) {
        FilterBrandCategoryModel *model = [[FilterBrandCategoryModel alloc]initWithDictionary:dict];
        [_contentModelArray addObject:model];
        
        SHeaderTitleModel *titleModel = [SHeaderTitleModel new];
        titleModel.name = dict[@"branD_NAME"];
        titleModel.aID = dict[@"id"];
        [_titleModelArray addObject:titleModel];
    }
    self.titleView.contentModelArray = _titleModelArray;
    [self requestContentListData:_contentModelArray[0]];
}

- (void)setContentListArray:(NSMutableArray *)contentListArray{
    _contentListArray = contentListArray;
    [self.contentCollectionView reloadData];
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentListArray.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SActivityBrandHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        headerView.contentView.contentModel = _contentModel;
        reusableView = headerView;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(UI_SCREEN_WIDTH, 274);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(UI_SCREEN_WIDTH/ 2 - 15, 300);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.isShowPrice = YES;
    cell.brandContentModel = _contentListArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SActivityBrandListModel *model = _contentListArray[indexPath.row];
    SProductDetailViewController *controller = [SProductDetailViewController new];
//    controller.productID = model.aID.stringValue;
    controller.productID = [NSString stringWithFormat:@"%@",model.code];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - SHeaderTitleCollectionView delegate
- (void)headerTitleCollectionView:(UICollectionView*)collectionView selectedIndex:(NSIndexPath*)indexPath{
    [self requestContentListData:_contentModelArray[indexPath.row]];
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 3.0);  //NO，YES 控制是否透明
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat origin_Y = CGRectGetMaxY(_titleView.frame);

    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, origin_Y * 3, image.size.width * 3, image.size.height * 3))];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    CGRect frame = CGRectMake(0, origin_Y, UI_SCREEN_WIDTH, self.view.frame.size.height - origin_Y);
    imageView.frame = frame;
    
    [self.contentListArray removeAllObjects];
    self.contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, UI_SCREEN_HEIGHT, 0);
    [self.contentCollectionView reloadData];
    [self.view addSubview:imageView];
//    frame = imageView.frame;
//    frame.origin.x = - UI_SCREEN_WIDTH;
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
//        imageView.frame = frame;
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        self.contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    }else if (frame.origin.y < 40){
        [_titleView setOriginOffset:-(40 - frame.origin.y)];
    }else{
        [_titleView setOriginOffset:0];
    }
    if(frame.origin.y < 30){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    self.titleView.frame = frame;
}

@end

@implementation SActivityBrandHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [SActivityDiscountHeaderView new];
        [self addSubview:_contentView];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

@end