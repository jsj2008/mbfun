//
//  SMIneAddProductViewController.m
//  Wefafa
//
//  Created by Jiang on 15/9/1.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMIneAddProductViewController.h"
#import "SUploadColllocationControlCenter.h"
#import "SUtilityTool.h"
#import "SAddProductTagViewControlCenter.h"
#import "HttpRequest.h"
#import "Toast.h"

#import "SProductTagEditeInfo.h"

#import "UzysAssetsPickerController.h"
#import "SCRecorderViewController.h"
#import "AppDelegate.h"
#import "Dialog.h"

#import "SSelectProductCategoryViewController.h"
#import "SSelectProductBrandViewController.h"
#import "SSelectProductColorViewController.h"
#import "SDataCache.h"
#import "HttpRequest.h"
#import "ModelBase.h"
#import "WeFaFaGet.h"
#import "NSString+help.h"
#import "Toast.h"

#import "SMatchingProductListViewController.h"
#import "SAddProductTagViewControlCenter.h"
#import "SMineProductViewController.h"

#import "SV2CropViewController.h"

#import "SSelectProductImageViewController.h"
#import "SProductTagEditeInfo.h"
static UIWindow *g_cameraStartSlideWindow = nil;

@interface SMIneAddProductViewController ()<UITableViewDataSource,
            UITableViewDelegate, SCRecorderViewControllerDelegate,
            UzysAssetsPickerControllerDelegate>
{
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    
    NSString *_productId;
    
    UITableView *_tableView;
    
    UIImageView *_imageView;
    UIImage *_productImage;
    UIImage *_originalImage;
    
    NSURL *_videoURL;
    
    
    __weak SSelectProductImageViewController *_selectProductImageViewController;// 选择单品图片
    
    UIButton *_rePickImageButton;
    
    UILabel *_productCategoryLabel; //产品分类
    UILabel *_brandLabel;           //品牌
    UILabel *_colorLabel;           //颜色
    
    UIView *_footerView;
    UIButton *_okButton;
    
    BOOL _isExistSameProduct;   //是否存在相同单品
    BOOL _isEditImage;          //是否是默认图片
    BOOL _isCellClicked;        //cell是否可以点击
    
    NSString *_matchingProductTotal;    // 相似单品总数量
    
    SProductTagEditeInfo *_productTagEditeInfo;    // 信息模型
    
    UzysAssetsPickerController *_homeViewController;        // 图片控制器
    SCRecorderViewController *_homeCameraViewController;    // 相机控制器
    SV2CropViewController *_cropController;                 // 裁剪控制器
    SSelectProductImageViewController *_selectImageVC;      // 图片编辑控制器
    
    SSelectProductCategoryViewController *_selectProductCategoryViewController; // 选择分类
    SSelectProductColorViewController *_selectProductColorViewController;       // 选择颜色
    SSelectProductBrandViewController *_selectProductBrandViewController;       // 选择品牌
}
@property (nonatomic, strong) NSMutableArray *matchingProductDataArray;   // 相似单品数组
@end

@implementation SMIneAddProductViewController

#pragma mark - 属性接口

- (NSMutableArray *)matchingProductDataArray
{
    if (!_matchingProductDataArray) {
        _matchingProductDataArray = [NSMutableArray array];
    }
    return _matchingProductDataArray;
}

- (void)setProductId:(NSString *)productId
{
    _productId = productId;
    _productTagEditeInfo.productColorId = productId;
    //这里根据productId请求服务器数据  自动填充 单品图片 单品分类 品牌 颜色
}

- (void)setProductImage:(UIImage *)productImage
{
    _productTagEditeInfo.productImage = productImage;
    
    _productImage = productImage;
    _imageView.image = _productImage;
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _imageView.image = originalImage;
    _productTagEditeInfo.productOriginImage = originalImage;
}

- (void)setTagIndex:(int)tagIndex
{
    _productTagEditeInfo.tagIndex = tagIndex;
}

- (void)setTagViewCenter:(CGPoint)center
{
    // TODO
}

- (void)setTagViewFlip:(BOOL)flip
{
    _productTagEditeInfo.tagViewFlip = flip;
}

- (void)setProductCategoryWithCategoryId:(NSString *)categoryId categoryName:(NSString *)categoryName subCategoryId:(NSString *)subCategoryId subCategoryCode:(NSString *)subCategoryCode subCategoryName:(NSString *)subCategoryName
{
    _productTagEditeInfo.productCategoryId = categoryId;
    _productTagEditeInfo.productCategoryName = categoryName;
    _productTagEditeInfo.productSubCategoryId = subCategoryId;
    _productTagEditeInfo.productSubCategoryCode = subCategoryCode;
    _productTagEditeInfo.productSubCategoryName = subCategoryName;
    
    _productCategoryLabel.text = [NSString stringWithFormat:@"%@ %@", categoryName, subCategoryName];
    
    [self updateOkButtonState];
}


- (void)setProductBrandWithBrandId:(NSString *)brandId brandCode:(NSString *)brandCode brandName:(NSString *)brandName
{
    _productTagEditeInfo.productBrandId = brandId;
    _productTagEditeInfo.productBrandCode = brandCode;
    _productTagEditeInfo.productBrandName = brandName;
    
    _brandLabel.text = brandName;
    
    [self updateOkButtonState];
}

- (void)setProductColorWithColorId:(NSString *)colorId colorCode:(NSString *)colorCode colorName:(NSString *)colorName;
{
    _productTagEditeInfo.productColorId = colorId;
    _productTagEditeInfo.productColorCode = colorCode;
    _productTagEditeInfo.productColorName = colorName;
    
    _colorLabel.text = colorName;
    
    [self updateOkButtonState];
}

- (void)updateOkButtonState
{
    /*
     if ([_productTagEditeInfo.productCategoryId length] > 0
        && [_productTagEditeInfo.productSubCategoryId length] > 0
        && [_productTagEditeInfo.productBrandId length] > 0
        && [_productTagEditeInfo.productColorId length] > 0)
     */
    if (([_productTagEditeInfo.productCategoryId length] > 0
         && [_productTagEditeInfo.productBrandName length] > 0
         && [_productTagEditeInfo.productColorName length] > 0))
    {
//        if (![UIImagePNGRepresentation(_imageView.image) isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"Unico/上传_缺省图"])])
        if (_isEditImage)
        {
            [_okButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:222.0/255.0 blue:0 alpha:1]];
            _okButton.userInteractionEnabled = YES;
        }
        
        //请求数据，存在相同单品
        [self requestProductInfo];
    }
    else
    {
        [_okButton setBackgroundColor:[UIColor colorWithRed:0xe2/255.0 green:0xe2/255.0 blue:0xe2/255.0 alpha:1]];
        _okButton.userInteractionEnabled = NO;
    }
}

#pragma mark - 请求数据，存在相同单品
- (void)requestProductInfo{
    NSDictionary *data=@{@"colorCode": [[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productColorCode ],
                         @"cateId": [[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productSubCategoryId],
                         @"brandCode":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productBrandCode],
                         @"page":@0,@"num":@0};
    [HttpRequest productGetRequestPath:@"Procduct" methodName:@"searchProductListByUpload" params:data success:^(NSDictionary *dict) {
        
//        NSLog(@"1111 dict = %@", dict);
        
        if ([dict[@"isSuccess"] intValue]<1)
        {
            return;
        }
        _matchingProductTotal = [NSString stringWithFormat:@"%@", dict[@"total"]];
        self.matchingProductDataArray = dict[@"results"];
        
//        NSLog(@"_matchingProductDataArray = %@", _matchingProductDataArray);
//        NSLog(@"[_matchingProductDataArray count] = %lu", (unsigned long)[_matchingProductDataArray count]);
        
//        if ([_matchingProductDataArray count] > 0)
        {
            [_tableView reloadData];
        }
        
        
        
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _navigationItem = [[UINavigationItem alloc] init];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        _navigationItem.leftBarButtonItems = @[backButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_C3;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"上传单品";
        
        _navigationItem.titleView = titleLabel;
        
        
        _productTagEditeInfo = [[SProductTagEditeInfo alloc] init];
        
        _isExistSameProduct = NO;
        
        
        float sizeK = UI_SCREEN_WIDTH/750;
        
        
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(34 * sizeK, (330 * sizeK - 250 * sizeK)/2.0, 250 * sizeK, 250 * sizeK)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 250 * sizeK)/2, (330 * sizeK - 250 * sizeK)/2.0, 250 * sizeK, 250 * sizeK)];
        _imageView.layer.borderColor = COLOR_C9.CGColor;
        _imageView.layer.borderWidth = 0.5f;
        _imageView.image = [UIImage imageNamed:@"Unico/上传_缺省图"];//_productImage;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePickImageButtonClick:)]];
        _imageView.userInteractionEnabled = YES;
        
        _rePickImageButton = [[UIButton alloc] initWithFrame:CGRectMake(_imageView.width-25, _imageView.height-25, 25, 25)];
        [_rePickImageButton setImage:[UIImage imageNamed:@"Unico/stick_resize"] forState:UIControlStateNormal];
        [_rePickImageButton addTarget:self action:@selector(rePickImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:_rePickImageButton];
        
        _productCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 250 - (64 + 10)*sizeK, 0, 250, 100*sizeK)];
        _productCategoryLabel.font = FONT_t5;
        _productCategoryLabel.textColor = COLOR_C2;
        _productCategoryLabel.textAlignment = NSTextAlignmentRight;
        _productCategoryLabel.text = @"选择单品分类";
        
        
        _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 250 - (64 + 10)*sizeK, 0, 250, 100*sizeK)];
        _brandLabel.font = FONT_t5;
        _brandLabel.textColor = COLOR_C2;
        _brandLabel.textAlignment = NSTextAlignmentRight;
        _brandLabel.text = @"输入品牌";
        
        _colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 250 - (64 + 10)*sizeK, 0, 250, 100*sizeK)];
        _colorLabel.font = FONT_t5;
        _colorLabel.textColor = COLOR_C2;
        _colorLabel.textAlignment = NSTextAlignmentRight;
        _colorLabel.text = @"选择颜色";
        
        
        
        
        _footerView = [[UIView alloc] init];
        
        _footerView.layer.masksToBounds = YES;
        
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.titleLabel.font = FONT_T3;
        [_okButton setTitleColor:COLOR_C2 forState:UIControlStateNormal];
        [_okButton setTitle:@"上传单品" forState:UIControlStateNormal];
        
        [_okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setBackgroundColor:[UIColor colorWithRed:0xe2/255.0 green:0xe2/255.0 blue:0xe2/255.0 alpha:1]];
        _okButton.userInteractionEnabled = NO;
        
        _okButton.layer.cornerRadius = 6 * sizeK;
        _okButton.layer.masksToBounds = YES;
        
        float okButtonWidth = 710 * sizeK;
        
        _okButton.frame = CGRectMake((UI_SCREEN_WIDTH - okButtonWidth)/2.0, 60 * sizeK, okButtonWidth, 88 * sizeK);
        
        [_footerView addSubview:_okButton];
        
        
    }
    return self;
}

#pragma mark - 视图控制器接口

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isEditImage = NO;
    _isCellClicked = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNavbar];
    
    self.view.backgroundColor = [UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0 blue:0xf2/255.0 alpha:1];
    
    float sizeK = UI_SCREEN_WIDTH/750.0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.sectionFooterHeight = 16 * sizeK;
    _tableView.sectionHeaderHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view insertSubview:_tableView atIndex:0];
    
    
    [self.view addSubview:_navigationBar];
}

#pragma mark - 其他UI接口
/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [_navigationBar pushNavigationItem:_navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}

#pragma mark - UITableViewDataSource接口

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_matchingProductDataArray count] > 0)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (section == 0)
    {
        numberOfRows = 1;
    }
    else if (section == 1)
    {
        numberOfRows = 3;
    }
    else if (section == 2)
    {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *cellId = [NSString stringWithFormat:@"%ld_%ld", (long)section, (long)row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell != nil)
    {
        return cell;
    }
    
    float sizeK = UI_SCREEN_WIDTH/750;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    if (section == 0)
    {
        [cell addSubview:_imageView];
        
    }
    else if (section == 1)
    {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(34*sizeK, 0, 100, 100*sizeK)];
        leftLabel.font = FONT_t4;
        leftLabel.textColor = COLOR_C2;
        
        [cell addSubview:leftLabel];
        
        
        
        
        if (row == 0)
        {
            leftLabel.text = @"单品分类";
            [cell addSubview:_productCategoryLabel];
        }
        else if (row == 1)
        {
            leftLabel.text = @"品牌";
            [cell addSubview:_brandLabel];
            
        }
        else if (row == 2)
        {
            leftLabel.text = @"颜色";
            [cell addSubview:_colorLabel];
        }
        
        UILabel *starLabel = [[UILabel alloc] init];
        starLabel.text = @"*";
        starLabel.font = [UIFont systemFontOfSize:30];
        starLabel.textColor = COLOR_C10;
        
        CGSize leftLabelSize = [leftLabel.text sizeWithAttributes:@{NSFontAttributeName : leftLabel.font}];
        
        starLabel.frame = CGRectMake(leftLabel.frame.origin.x + leftLabelSize.width + 14*sizeK, leftLabel.frame.origin.y + 8, 50, leftLabel.frame.size.height);
        [cell addSubview:starLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (section == 2)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100*sizeK)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_t4;
        label.textColor = COLOR_C2;
        label.text = [NSString stringWithFormat:@"对应的单品共%@件", _matchingProductTotal];//@"对应的单品共6件";
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell addSubview:label];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate接口

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    float sizeK = UI_SCREEN_WIDTH/750.0;
    
    if ([indexPath section] == 0)
    {
        height = 330 * sizeK;
    }
    else
    {
        height = 100 * sizeK;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float sizeK = UI_SCREEN_WIDTH/750.0;
    
    CGFloat heightForFooter = 16 * sizeK;
    
    if ([_matchingProductDataArray count])
    {
        if (section == 2)
        {
            heightForFooter = (60+88) * sizeK;
        }
    }
    else
    {
        if (section == 1)
        {
            heightForFooter = (60+88) * sizeK;
        }
    }
    
    return heightForFooter;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([_matchingProductDataArray count] > 0)//是否存在对应的单品
    {
        if (section == 2)
        {
            return _footerView;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if (section == 1)
        {
            return _footerView;
        }
        else
        {
            return nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1 && [indexPath row] == 0)
    {
        if (!_isCellClicked) {
            return ;
        }
        // 分类
        [self showSelectProductCategoryViewWithAnimated:YES];
    }
    else if ([indexPath section] == 1 && [indexPath row] == 1)
    {
        if (!_isCellClicked) {
            return ;
        }
        // 品牌
        [self showSelectProductBrandViewWithAnimated:YES];
    }
    else if ([indexPath section] == 1 && [indexPath row] == 2)
    {
        if (!_isCellClicked) {
            return ;
        }
        // 颜色
        [self showSelectProductColorViewWithAnimated:YES];
    }
    else if ([indexPath section] == 2 && [indexPath row] == 0)
    {
        // 进入对应的单品界面
        SMatchingProductListViewController *mathingproductVc =
        [[SMatchingProductListViewController alloc] init];
        mathingproductVc.matchingProductDataArray = self.matchingProductDataArray;
        mathingproductVc.productTagEditeInfo=_productTagEditeInfo;
        mathingproductVc.didFinishPickingProduct = ^(SProductTagEditeInfo *productTagEditeInfo){
            productTagEditeInfo.subCategoryId_ = _productTagEditeInfo.productSubCategoryId;
            productTagEditeInfo.colorID_ = _productTagEditeInfo.productColorId;
            productTagEditeInfo.catageID_ = _productTagEditeInfo.productCategoryId;
            productTagEditeInfo.productBrandId_ = _productTagEditeInfo.productId;
            
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showProductDetailViewWithProductCode:productTagEditeInfo.productCode productType:SProductTypeMatchingProduct SProductTagEditeInfo:productTagEditeInfo animated:YES];
        };
        mathingproductVc.back = ^{
//            [self.navigationController popViewControllerAnimated:YES];
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
        };
        
        __weak SMIneAddProductViewController *weakSelf = self;
        mathingproductVc.didFinishMinePickingProduct=^(SProductTagEditeInfo *productTagEditeInfo)
        {
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
            
            
            _imageView.image = productTagEditeInfo.productImage;
            _imageView.userInteractionEnabled = NO;
            _rePickImageButton.hidden = YES;
            
            [weakSelf setProductColorWithColorId:productTagEditeInfo.productColorId colorCode:productTagEditeInfo.productColorCode colorName:productTagEditeInfo.productColorName];
            [weakSelf setProductBrandWithBrandId:productTagEditeInfo.productBrandId brandCode:productTagEditeInfo.productBrandCode brandName:productTagEditeInfo.productBrandName];
            [weakSelf setProductCategoryWithCategoryId:productTagEditeInfo.productCategoryId categoryName:productTagEditeInfo.productCategoryName subCategoryId:productTagEditeInfo.productSubCategoryId subCategoryCode:productTagEditeInfo.productSubCategoryCode subCategoryName:productTagEditeInfo.productSubCategoryName];
            
            _isCellClicked = NO;
            _isEditImage = YES;
            _productTagEditeInfo = productTagEditeInfo;
            
            [self updateOkButtonState];
            
        };
        [self.navigationController pushViewController:mathingproductVc animated:YES];
    }
}


#pragma mark - cell赋值
/**
 *   显示选择单品颜色
 */
- (void)showSelectProductColorViewWithAnimated:(BOOL)animated
{
    /*
     SSelectProductColorViewController *selectProductColorViewController = nil;
    
    if (_selectProductColorViewController == nil)
    {
        selectProductColorViewController = [[SSelectProductColorViewController alloc] init];
        
        _selectProductColorViewController = selectProductColorViewController;
    }
    
    _selectProductColorViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    __weak SMIneAddProductViewController *weakSelf = self;
    _selectProductColorViewController.didFinishColor = ^(NSString *colorId, NSString *colorCode, NSString *colorName){
        
        [weakSelf setProductColorWithColorId:colorId colorCode:colorCode colorName:colorName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_selectProductColorViewController animated:animated];
     */
    SSelectProductColorViewController *selectProductColorViewController = [[SSelectProductColorViewController alloc] init];
    selectProductColorViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    __weak SMIneAddProductViewController *weakSelf = self;
    selectProductColorViewController.didFinishColor = ^(NSString *colorId, NSString *colorCode, NSString *colorName){
        
        [weakSelf setProductColorWithColorId:colorId colorCode:colorCode colorName:colorName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    [self.navigationController pushViewController:selectProductColorViewController animated:animated];
}


/**
 *   显示选择单品品牌
 */
- (void)showSelectProductBrandViewWithAnimated:(BOOL)animated
{
    /*
    SSelectProductBrandViewController *selectProductBrandViewController = nil;
    
    if (_selectProductBrandViewController == nil)
    {
        selectProductBrandViewController = [[SSelectProductBrandViewController alloc] init];
        
        _selectProductBrandViewController = selectProductBrandViewController;
    }
    
    _selectProductBrandViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    __weak SMIneAddProductViewController *weakSelf = self;
    _selectProductBrandViewController.didFinishBrand = ^(NSString *brandId,NSString *brandCode,NSString *brandName){
        
        [weakSelf setProductBrandWithBrandId:brandId brandCode:brandCode brandName:brandName];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_selectProductBrandViewController animated:animated];
     */
    SSelectProductBrandViewController *selectProductBrandViewController = [[SSelectProductBrandViewController alloc] init];
    selectProductBrandViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    __weak SMIneAddProductViewController *weakSelf = self;
    selectProductBrandViewController.didFinishBrand = ^(NSString *brandId,NSString *brandCode,NSString *brandName){
        
        if (!brandId && !brandCode) {
            [weakSelf setProductBrandWithBrandId:@"" brandCode:@"" brandName:brandName];
        }
        
        [weakSelf setProductBrandWithBrandId:brandId brandCode:brandCode brandName:brandName];
    };
    [self.navigationController pushViewController:selectProductBrandViewController animated:animated];
}


/**
 *   显示选择单品分类
 */
- (void)showSelectProductCategoryViewWithAnimated:(BOOL)animated
{
    /*SSelectProductCategoryViewController *selectProductCategoryViewController = nil;
    
    if (_selectProductCategoryViewController == nil)
    {
        selectProductCategoryViewController = [[SSelectProductCategoryViewController alloc] init];
        
        _selectProductCategoryViewController = selectProductCategoryViewController;
    }
    
    _selectProductCategoryViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    __weak SMIneAddProductViewController *weakSelf = self;
    _selectProductCategoryViewController.didFinishCategory = ^(NSString *productCategoryId, NSString *productCategoryName, NSString *productSubCategoryId, NSString *subCategoryCode, NSString *productSubCategoryName){
        
        weakSelf.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
        weakSelf.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        
        [weakSelf setProductCategoryWithCategoryId:productCategoryId categoryName:productCategoryName subCategoryId:productSubCategoryId subCategoryCode:subCategoryCode subCategoryName:productSubCategoryName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    [[AppDelegate rootViewController] pushViewController:_selectProductCategoryViewController animated:animated];
     */
    
    SSelectProductCategoryViewController *selectProductCategoryViewController = [[SSelectProductCategoryViewController alloc] init];
    selectProductCategoryViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    __weak SMIneAddProductViewController *weakSelf = self;
    selectProductCategoryViewController.didFinishCategory = ^(NSString *productCategoryId, NSString *productCategoryName, NSString *productSubCategoryId, NSString *subCategoryCode, NSString *productSubCategoryName){
        
        weakSelf.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
        weakSelf.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        
        [weakSelf setProductCategoryWithCategoryId:productCategoryId categoryName:productCategoryName subCategoryId:productSubCategoryId subCategoryCode:subCategoryCode subCategoryName:productSubCategoryName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    [self.navigationController pushViewController:selectProductCategoryViewController animated:YES];
}

#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    };
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 回调
-(void)backItem{
    if (self.back != nil)
    {
        self.back();
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 手势打开
- (void)rePickImageButtonClick:(id)sender
{
    if (_isEditImage) {
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectMyGoodsProductImageViewWithOriginalImage:_imageView.image animated:YES viewController:self];

        return;
    }
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UzysAssetsPickerController *homeViewController = nil;
    
    if (_homeViewController == nil)
    {
        homeViewController = [[UzysAssetsPickerController alloc] init];
        
        homeViewController.delegate = (id<UzysAssetsPickerControllerDelegate>)self;
        
        homeViewController.maximumNumberOfSelectionMedia = 1;
        homeViewController.showCameraCell = YES;
        
        homeViewController.assetsFilter = [ALAssetsFilter allAssets];
        
        _homeViewController = homeViewController;
    }
    
    [[AppDelegate rootViewController] presentViewController:_homeViewController animated:YES completion:^{

//        if (completion != nil)
//        {
//            completion();
//        }
    }];
    return ;
    
    if (self.originalImage != nil)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageViewWithOriginalImage:self.originalImage animated:YES];
    }
    else if (self.videoURL != nil)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageViewWithVideoURL:self.videoURL animated:YES];
    }
}

- (void)okButtonClick:(id)sender
{
    [self uploadImage];
    
    if (self.didFinishEdit != nil)
    {
        self.didFinishEdit(_productTagEditeInfo);
    }
}

#pragma mark - 上传图片
/** 
    post
    m=Product&uploadUserProduct()
    'token':用户标识
    'product_img':"商品图",
    'product_code':"商品6位码"（可无）
    'cate_id':分类id
    'cate_value':分类名称
    'color_code':色系code
    'color_value':颜色名称
    'brand_code':品牌code
    'brand_value':品牌名
 */
- (void)uploadImage
{
    [Toast makeToastActivity:@"单品上传中，请稍等..." hasMusk:YES];
    [[SDataCache sharedInstance] uploadProductImgView:_imageView.image
                                         stickerImage:nil
                                           contentUrl:nil                                                withData:nil
                                             complete:^(NSString * str
                                                        )
     {
         //先获取图片的url 然后再上传
         NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
         NSMutableDictionary *parameters = [@{
                                      @"token":userToken,
                                      @"product_img":str,
                                      @"cate_id":_productTagEditeInfo.productSubCategoryId,//temp_id
                                      @"cate_value":_productTagEditeInfo.productSubCategoryName,
                                      @"color_code":_productTagEditeInfo.productColorCode,
                                      @"color_value":_productTagEditeInfo.productColorName,
                                      @"brand_code":_productTagEditeInfo.productBrandCode,
                                      @"brand_value":_productTagEditeInfo.productBrandName,
//                                     @"product_code":@"",
                                      @"a":@"uploadUserProduct",
                                      @"m":@"Product",
                                      } mutableCopy];
         if (_productTagEditeInfo.productBrandCode.length!=0) {
             NSLog(@"__%@", _productTagEditeInfo.productCode);
//             [parameters setObject:_productTagEditeInfo.productCode forKey:@"product_code"];
         }
         [[SDataCache sharedInstance] uploadProductDetailWithDic:parameters complete:^(id object)
          {
//              NSLog(@"object----%@",object);
              if (object[@"status"]) {
//                  [Toast makeToastSuccess:@"上传成功"];
                  
                  // 上传成功返回到上一级界面
                  if (self.back != nil)
                  {
                      self.back();
                  };
                  [[UIApplication sharedApplication] setStatusBarHidden:NO];
                  [self.navigationController popViewControllerAnimated:YES];

              } else {
//                  [Toast makeToast:@"上传失败"];
              }
              [Toast hideToastActivity];
          }];
    }];
}

#pragma mark - 代理方法往下
#pragma mark -  uzysAssetsPicker delegate
#pragma mark - 选择相机 , 打开
- (void)uzysAssetsPickerControllerDidPickingCamera:(UzysAssetsPickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    
    
    SCRecorderViewController *homeCameraViewController = nil;
    
    if (_homeCameraViewController == nil)
    {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
        homeCameraViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCameraStoryBoardID"];
        homeCameraViewController.recorderStyle = RecorderViewOnlyPhotoStyle;
        homeCameraViewController.delegate = self;
        homeCameraViewController.animatedBack = YES;
        [homeCameraViewController setHidesBottomBarWhenPushed:YES];
        _homeCameraViewController = homeCameraViewController;
    }
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[AppDelegate rootViewController] pushViewController:_homeCameraViewController animated:NO];
    
    
    

    {
        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = [AppDelegate rootViewController].view.frame;
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
                
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                
                g_cameraStartSlideWindow = nil;
            }];
        }];
    }
}

#pragma mark - 返回按钮
- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击图片
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
//    float sizeK = UI_SCREEN_WIDTH/750;
    NSLog(@"uzysAssetsPickerController didFinishPickingAssets assets = %@", assets);
    
    if ([assets count] == 0)
    {
        return;
    }
    else if ([assets count] == 1) //单选模式
    {
        ALAsset *asset = assets[0];
        
        NSString *assetTypeString = [asset valueForProperty:ALAssetPropertyType];
        
        if([assetTypeString isEqualToString:ALAssetTypePhoto]) //图片
        {
            ALAssetRepresentation *defaultRepresentation = asset.defaultRepresentation;
            UIImage *pickingImage = nil;
            
            if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
            }
            else if (defaultRepresentation.fullResolutionImage != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                                   scale:defaultRepresentation.scale
                                             orientation:(UIImageOrientation)defaultRepresentation.orientation];
            }
            else if ([asset aspectRatioThumbnail] != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            }
            

            _imageView.image = pickingImage;
            _isEditImage = YES;
            [self updateOkButtonState];
            
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
          
            
 
   /*
            // 图片裁剪
            SV2CropViewController *cropController = nil;
            if (_cropController == nil)
            {
                cropController = [[SV2CropViewController alloc] init];
                _cropController = cropController;
                
            }
            _cropController.image = pickingImage;
            [picker presentViewController:_cropController animated:YES completion:^{
                
            }];
            
            __weak UIImageView *weakImgV = _imageView;
            __weak SMIneAddProductViewController *weakSelf = self;
            _cropController.didFinishCropImage = ^(UIImage *cropImage){
                weakImgV.image = cropImage;
                [weakSelf updateOkButtonState];
                [[AppDelegate rootViewController] dismissViewControllerAnimated:YES completion:nil];
            };
            
            _cropController.back = ^{
                [[AppDelegate rootViewController] dismissViewControllerAnimated:YES completion:nil];
            };
            */
            

            
            
        }/*
        else if ([assetTypeString isEqualToString:ALAssetTypeVideo])//视频
        {
            AVAsset *avAsset = [AVAsset assetWithURL:asset.defaultRepresentation.url];
            
            if (avAsset.duration.value/avAsset.duration.timescale > 60)
            {
                UIView *dialogView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360*sizeK, 200*sizeK)];
                dialogView.backgroundColor = [UIColor blackColor];
                dialogView.layer.cornerRadius = 8;
                dialogView.layer.masksToBounds = YES;
                dialogView.alpha = 0.8;
                
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/warning"]];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.frame = CGRectMake(158*sizeK, 40*sizeK, 44*sizeK, 44*sizeK);
                [dialogView addSubview:imageView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 114*sizeK, dialogView.frame.size.width, 26*sizeK)];
                titleLabel.text = @"只能选择小于等于60秒的视频";
                titleLabel.font = FONT_t5;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = [UIColor whiteColor];
                [dialogView addSubview:titleLabel];
                
                
                [CCDialog showDialogView:dialogView modal:YES showDialogViewAnimationOption:QFShowDialogViewAnimationFromRight completion:^(BOOL finished) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [CCDialog closeDialogViewWithAnimationOptions:QFCloseDialogViewAnimationToRight completion:^(BOOL finished) {
                            
                        }];
                    });
                    
                }];
                
            }
            else
            {
                NSLog(@"avAsset.preferredRate = %f", avAsset.preferredRate);
                
                NSLog(@"avAsset.commonMetadata = %@", avAsset.commonMetadata);
                
                [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showV3VideoCropViewWithAsset:avAsset animated:NO];
                
                [picker dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }
        }*/
    }
}

#pragma mark - record vc delegate
#pragma mark - 拍照
- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureImage:(UIImage *)image
{
    // 图片更新
    _imageView.image = image;
    _isEditImage = YES;
    [self updateOkButtonState];
    
    [[AppDelegate rootViewController] popViewControllerAnimated:NO];
    

        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                g_cameraStartSlideWindow = nil;
            }];
        }];
}

- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureVideo:(AVAsset *)avAsset
{
    // 视频，此方法不调用
}

#pragma mark - 拍照中得返回图册
- (void)recorderViewControllerDidPickingSystemPhoto:(SCRecorderViewController *)recorderViewController
{
    [[AppDelegate rootViewController] popViewControllerAnimated:NO];
    
    
    UzysAssetsPickerController *homeViewController = nil;
    
    if (_homeViewController == nil)
    {
        homeViewController = [[UzysAssetsPickerController alloc] init];
        
        homeViewController.delegate = (id<UzysAssetsPickerControllerDelegate>)self;
        
        homeViewController.maximumNumberOfSelectionMedia = 1;
        homeViewController.showCameraCell = YES;
        
        homeViewController.assetsFilter = [ALAssetsFilter allAssets];
        
        _homeViewController = homeViewController;
    }
    
    [[AppDelegate rootViewController] presentViewController:_homeViewController animated:NO completion:^{
        
        //        if (completion != nil)
        //        {
        //            completion();
        //        }
    }];
    return ;
    
    if (self.originalImage != nil)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageViewWithOriginalImage:self.originalImage animated:YES];
    }
    else if (self.videoURL != nil)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageViewWithVideoURL:self.videoURL animated:YES];
    }
}

#pragma mark - 拍照取消
- (void)recorderViewControllerDidCancel:(SCRecorderViewController *)recorderViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[AppDelegate rootViewController] popViewControllerAnimated:YES];
}

@end
