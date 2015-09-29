//
//  SEditeProductTagViewController.m
//  Wefafa
//
//  Created by chen cheng on 15/8/16.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SEditeProductTagViewController.h"
#import "SUploadColllocationControlCenter.h"
#import "SUtilityTool.h"
#import "SAddProductTagViewControlCenter.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"

#import "SProductTagEditeInfo.h"
#import "LoginViewController.h"

@interface SEditeProductTagViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    
//    NSString *_productId;
    
    UITableView *_tableView;
    
    UIImageView *_imageView;
    UIImage *_productImage;
    UIImage *_originalImage;
    
    NSURL *_videoURL;
    
    
    UIButton *_rePickImageButton;
    
    UILabel *_productCategoryLabel;//产品分类
    
    UILabel *_brandLabel;//品牌
    
    int num;
    
    UILabel *_colorLabel;//颜色
    
    UIView *_footerView;
    UIButton *_okButton;
    
    NSArray *_matchingProductDataArray;
    ///匹配的产品数量
    UILabel *_lblMatch;
    
    SProductTagEditeInfo *_productTagEditeInfo;
}

@end

@implementation SEditeProductTagViewController



#pragma mark - 属性接口

- (void)setProductId:(NSString *)productId
{
    _productId = productId;
    _productTagEditeInfo.productId = productId;
    //这里根据productId请求服务器数据  自动填充 单品图片 单品分类 品牌 颜色
}

-(void)setProductCode:(NSString *)productCode
{
    _productCode=productCode;
    _productTagEditeInfo.productCode=productCode;
    if (productCode.length<1) {
        _rePickImageButton.hidden=NO;
    }
}

-(void)setProductImageBei:(UIImage *)productImageBei
{
    _productImageBei=productImageBei;
    _productTagEditeInfo.productOriginImageBei=productImageBei;
}

- (void)setProductImage:(UIImage *)productImage
{
    _isBackUsed=NO;
    if (_productImage) {
        [self updateOkButtonState];
    }
    _productTagEditeInfo.productImage = productImage;
    
    _productImage = productImage;
    _imageView.image = _productImage;
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _isBackUsed=NO;
    _originalImage = originalImage;
    _productTagEditeInfo.productOriginImage = originalImage;
}

- (void)setTagIndex:(int)tagIndex
{
    _productTagEditeInfo.tagIndex = tagIndex;
}

- (void)setTagViewToPoint:(CGPoint)toPoint
{
    _productTagEditeInfo.tagViewToPoint = toPoint;
}



- (void)setTagViewFlip:(BOOL)flip
{
    _productTagEditeInfo.tagViewFlip = flip;
}

- (void)setProductCategoryWithCategoryId:(NSString *)categoryId categoryName:(NSString *)categoryName subCategoryId:(NSString *)subCategoryId subCategoryCode:(NSString *)subCategoryCode subCategoryName:(NSString *)subCategoryName
{
    _isBackUsed=NO;
    NSString *str=_productTagEditeInfo.productSubCategoryId;
    
    _productTagEditeInfo.productCategoryId = categoryId;
    _productTagEditeInfo.productCategoryName = categoryName;
    _productTagEditeInfo.productSubCategoryId = subCategoryId;
    _productTagEditeInfo.productSubCategoryCode = subCategoryCode;
    _productTagEditeInfo.productSubCategoryName = subCategoryName;
    
    if (categoryName.length>0) {
        _productCategoryLabel.text = [NSString stringWithFormat:@"%@ %@", categoryName, subCategoryName];
    }
    else
    {
        _productCategoryLabel.text = [NSString stringWithFormat:@"%@", subCategoryName];
    }
    
    //如果是第一次赋值
    if (str.length<1&&(_productImage==_originalImage)) {
        return;
    }
    
    [self updateOkButtonState];
}


- (void)setProductBrandWithBrandId:(NSString *)brandId brandCode:(NSString *)brandCode brandName:(NSString *)brandName
{
    _isBackUsed=NO;
    NSString *str=_productTagEditeInfo.productBrandName;
    NSString *str1=_productTagEditeInfo.productBrandCode;
    _productTagEditeInfo.productBrandId = brandId;
    _productTagEditeInfo.productBrandCode = brandCode;
    _productTagEditeInfo.productBrandName = brandName;
    
    _brandLabel.text = brandName;
    
    if ((str.length<1&&str1.length<1)&&(_productImage==_originalImage)) {
        return;
    }
    
    [self updateOkButtonState];
}

- (void)setProductColorWithColorId:(NSString *)colorId colorCode:(NSString *)colorCode colorName:(NSString *)colorName;
{
    _isBackUsed=NO;
    NSString *str=_productTagEditeInfo.productColorName;
    _productTagEditeInfo.productColorId = colorId;
    _productTagEditeInfo.productColorCode = colorCode;
    _productTagEditeInfo.productColorName = [colorName copy];
    
    _colorLabel.text = colorName;
    
    if (str.length<1&&_productId.length>0) {
        return;
    }
    
    [self updateOkButtonState];
}

- (void)updateOkButtonState
{
    if (_productTagEditeInfo.productCode.length>0) {
        _rePickImageButton.hidden=YES;
    }
//    if (([_productTagEditeInfo.productCategoryId length] > 0
//         && [_productTagEditeInfo.productSubCategoryId length] > 0
//         && [_productTagEditeInfo.productBrandCode length] > 0
//         && [_productTagEditeInfo.productColorId length] > 0))
    if (([_productTagEditeInfo.productSubCategoryId length] > 0
        && (!([_productTagEditeInfo.productBrandName length] <1&&_productTagEditeInfo.productBrandCode.length<1))
        && [_productTagEditeInfo.productColorName length] > 0))
    {
        [_okButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:222.0/255.0 blue:0 alpha:1]];
        //请求数据
        [self requestProductInfo];
        _okButton.userInteractionEnabled = YES;
    }
    else
    {
        [_okButton setBackgroundColor:[UIColor colorWithRed:0xe2/255.0 green:0xe2/255.0 blue:0xe2/255.0 alpha:1]];
        _okButton.userInteractionEnabled = NO;
    }
}

-(void)setIsBackUsed:(BOOL)isBackUsed
{
    _isBackUsed=isBackUsed;
    if (_isBackUsed) {
        [self updateOkButtonState];
    }
}

///请求数据，存在相同单品
- (void)requestProductInfo{
    NSDictionary *data=@{@"colorCode": [[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productColorCode ],
                         @"cateId": [[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productSubCategoryId],
                         @"brandCode":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productBrandCode],
                         @"page":@0,@"num":@0};
    [HttpRequest productGetRequestPath:@"Procduct" methodName:@"searchProductListByUpload" params:data success:^(NSDictionary *dict) {
        
        NSLog(@"1111 dict = %@", dict);
        //由于请求存在延迟，可能获取到数据时，此请求已过时，所以需要判断
        if (!([data[@"colorCode"] isEqualToString:_productTagEditeInfo.productColorCode]&&[data[@"cateId"] isEqualToString:_productTagEditeInfo.productSubCategoryId]&&[data[@"brandCode"] isEqualToString:_productTagEditeInfo.productBrandCode])) {
            return ;
        }
        
        if ([dict[@"isSuccess"] intValue]<1)
        {
            return;
        }
        
        _matchingProductDataArray = dict[@"results"];
        
        
        NSLog(@"_matchingProductDataArray = %@", _matchingProductDataArray);
        NSLog(@"[_matchingProductDataArray count] = %lu", (unsigned long)[_matchingProductDataArray count]);
        
        
        [_tableView reloadData];
        if (_lblMatch) {
            _lblMatch.text = [NSString stringWithFormat:@"对应的单品共%d件", (int)[_matchingProductDataArray count]];
            _lblMatch.frame=CGRectMake(0, 0, UI_SCREEN_WIDTH, 100*(UI_SCREEN_WIDTH/750.0f));
            _lblMatch.textAlignment=NSTextAlignmentCenter;
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
        
        num=0;
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        _navigationItem.leftBarButtonItems = @[backButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"编辑单品标签";
        
        _navigationItem.titleView = titleLabel;
        
        
        _productTagEditeInfo = [[SProductTagEditeInfo alloc] init];
        
        float sizeK = UI_SCREEN_WIDTH/750;
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(34 * sizeK, (330 * sizeK - 250 * sizeK)/2.0, 250 * sizeK, 250 * sizeK)];
        _imageView.image = _productImage;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _imageView.userInteractionEnabled = YES;
        _rePickImageButton = [[UIButton alloc] initWithFrame:CGRectMake(_imageView.width-25, _imageView.height-25, 25, 25)];
        [_rePickImageButton setImage:[UIImage imageNamed:@"Unico/stick_resize"] forState:UIControlStateNormal];
        [_rePickImageButton addTarget:self action:@selector(rePickImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:_rePickImageButton];
        if (_productTagEditeInfo.productCode.length>0) {
            _rePickImageButton.hidden=YES;
        }
        
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
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        
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
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    if (_productTagEditeInfo.productCode.length>0) {
        _rePickImageButton.hidden=YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    //_navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
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
        
        
        UIButton *usedProductButton = [UIButton buttonWithType:UIButtonTypeCustom];
        usedProductButton.frame = CGRectMake(0, 0, 300 * sizeK, 60 * sizeK);
        [usedProductButton setBackgroundColor:COLOR_C2];
        usedProductButton.layer.cornerRadius = 6 * sizeK;
        usedProductButton.layer.masksToBounds = YES;
        usedProductButton.center = CGPointMake(UI_SCREEN_WIDTH - 34*sizeK - usedProductButton.frame.size.width/2.0, 330*sizeK/2.0);
        
        [usedProductButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [usedProductButton setTitle:@"使用过的单品" forState:UIControlStateNormal];
        usedProductButton.titleLabel.font = FONT_t4;
        [cell addSubview:usedProductButton];
        
        [usedProductButton addTarget:self action:@selector(usedProductButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/arrow_address"]];
        imageView.frame = CGRectMake(usedProductButton.bounds.size.width-20*sizeK - 7, (usedProductButton.bounds.size.height-14)/2.0, 7, 14);
        [usedProductButton addSubview:imageView];
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
        _lblMatch = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100*sizeK)];
        _lblMatch.textAlignment=NSTextAlignmentCenter;
        _lblMatch.tag=2;
        _lblMatch.font = FONT_t4;
        _lblMatch.textColor = COLOR_C2;
        _lblMatch.text = [NSString stringWithFormat:@"对应的单品共%d件", (int)[_matchingProductDataArray count]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell addSubview:_lblMatch];
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
    
    if ([_matchingProductDataArray count] > 0)
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
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductCategoryViewWithAnimated:YES];
    }
    else if ([indexPath section] == 1 && [indexPath row] == 1)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductBrandViewWithAnimated:YES];
    }
    else if ([indexPath section] == 1 && [indexPath row] == 2)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductColorViewWithAnimated:YES];
    }
    else if ([indexPath section] == 2 && [indexPath row] == 0)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showMatchingProductListViewWithProductDataArray:_matchingProductDataArray productInfo:_productTagEditeInfo animated:YES];
    }
}

#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        _isBackUsed=NO;
        self.back();
    };
}

- (void)rePickImageButtonClick:(id)sender
{
    if (self.originalImage != nil)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageViewWithOriginalImage:self.originalImage animated:YES];
    }
    else if (self.videoURL != nil)
    {
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageViewWithVideoURL:self.videoURL animated:YES];
    }
}

- (void)usedProductButtonClick:(id)sender
{
    _matchingProductDataArray=[NSArray array];
    [_tableView reloadData];
    if (!IS_STRING(sns.ldap_uid)) {
        LoginViewController *VC = [LoginViewController new];
        [self pushController:VC animated:YES];
        return;
    }
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showUsedProductViewWithUserId:@"userId" animated:YES];
    
    
}

- (void)okButtonClick:(UIButton*)sender
{
    if (self.didFinishEdit != nil)
    {
        if (_isBackUsed) {
            _isBackUsed=NO;
            self.didFinishEdit(_productTagEditeInfo);
            return;
        }
        [Toast makeToastActivity:@"正在保存" hasMusk:NO];
        [self uploadData];
    }
}

-(void)uploadData
{
    if (_productTagEditeInfo.productImageUrl.length>0) {
        NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
        NSDictionary *parameters=@{@"token":userToken,
                            @"product_img":_productTagEditeInfo.productImageUrl,
                            @"cate_id":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productSubCategoryId],
                            @"cate_value":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productSubCategoryName],
                            @"color_code":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productColorCode],
                            @"color_value":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productColorName],
                            @"brand_code":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productBrandCode],
                            @"brand_value":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productBrandName],
                            @"product_code":[[NSString alloc] initWithFormat:@"%@",_productTagEditeInfo.productCode],
                            @"update_id":_productId.length>0?_productId:@"",
                            @"a":@"uploadUserProduct",
                            @"m":@"Product",};
        
        [[SDataCache sharedInstance] uploadProductDetailWithDic:parameters complete:^(id object)
         {
             [Toast hideToastActivity];
             
             if ([object[@"status"] intValue]!=1) {
                 [Toast makeToast:object[@"info"] duration:1.5 position:@"center"];
                 return ;
             }
             //返回一个id
             _productTagEditeInfo.productId=[[NSString alloc] initWithFormat:@"%@",object[@"data"]];
             _productId=_productTagEditeInfo.productId;
             self.didFinishEdit(_productTagEditeInfo);
        }];
    }
    else
    {
        [[SDataCache sharedInstance] uploadProductImgView:_imageView.image
                                             stickerImage:nil
                                               contentUrl:nil                                                withData:nil
                                                 complete:^(NSString * str
                                                            )
         {
             _productTagEditeInfo.productImageUrl=str;
             [self uploadData];
         }];
    }
}




@end
