//
//  SUploadCollectionProductDetailViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/27.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SUploadCollectionProductDetailViewController.h"
#import "SUtilityTool.h"
#import "SProductDetailViewController.h"
#import "SProductDetailModel.h"
#import "SDataCache.h"
#import "Toast.h"
#import "SNoneProductDetailViewController.h"
#import "WeFaFaGet.h"

#define sizeK UI_SCREEN_WIDTH/750.0


#import "SAddProductTagViewControlCenter.h"

@interface SUploadCollectionProductDetailViewController ()
{
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    
    SProductDetailViewController *sProductDVC;
    SNoneProductDetailViewController *sNoneDVC;
}

@end

@implementation SUploadCollectionProductDetailViewController
#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [UIApplication sharedApplication].statusBarHidden = YES;
        [self.navigationController setNavigationBarHidden:YES];
        
        self.navigationController.navigationItem.leftBarButtonItem=nil;
        
        _navigationItem=[[UINavigationItem alloc] init];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        _navigationItem.leftBarButtonItems = @[backButtonItem];
        
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"单品";
        
        _navigationItem.titleView = titleLabel;
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
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //这里添加其他代码
    
    if (_productType==SProductTypeUsedProduct) {
        sNoneDVC=[[SNoneProductDetailViewController alloc]init];
        sNoneDVC.productID=_productCode;
        sNoneDVC.isHide=YES;
        [self addChildViewController:sNoneDVC];
        [self.view addSubview:sNoneDVC.view];
    }
    else
    {
        sProductDVC=[[SProductDetailViewController alloc] init];
        sProductDVC.isHide=YES;
        sProductDVC.productID=_productCode;
        [self addChildViewController:sProductDVC];
        [self.view addSubview:sProductDVC.view];
    }
    
    
    [self setupNavbar];
    [self setBottomView];
//    [self.view addSubview:_navigationBar];
    
}


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
//添加底部视图
-(void)setBottomView
{
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-160*sizeK, UI_SCREEN_WIDTH, 160*sizeK)];
    bottomView.backgroundColor=COLOR_C4;
    [self.view addSubview:bottomView];
    
    UIView *lineV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1*sizeK)];
    lineV.backgroundColor=COLOR_C9;
    [bottomView addSubview:lineV];
    
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame=CGRectMake(20*sizeK, 42*sizeK, UI_SCREEN_WIDTH-40*sizeK, 88*sizeK);
    saveBtn.backgroundColor=COLOR_C2;
    [saveBtn setTintColor:COLOR_C3];
    saveBtn.titleLabel.font=FONT_T3;
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius=6*sizeK;
    saveBtn.layer.masksToBounds=YES;
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:saveBtn];
}

#pragma mark - 控件事件接口
-(void)saveBtnClick:(UIButton*)sender
{
//    _productTagEditeInfo.productImage=cell.productImage;
//    _productTagEditeInfo.productOriginImage=cell.productImage;
//    _productTagEditeInfo.productImageUrl=model.mainImage;
//    _productTagEditeInfo.productBrandId=[[NSString alloc]initWithFormat:@"%d",model.branD_ID.intValue];
//    _productTagEditeInfo.productBrandCode=[[NSString alloc]initWithFormat:@"%d",model.brandCode.intValue];
//    _productTagEditeInfo.productBrandName=[[NSString alloc]initWithFormat:@"%@",model.brand];
//    _productTagEditeInfo.productId=[NSString stringWithFormat:@"%d",model.aID.intValue];
//    _productTagEditeInfo.productCode=[NSString stringWithFormat:@"%@",model.code];

    ///如果存在，说明需要上传
    
    if (_sproductInfo) {
        
        if (_didFinishWithInfo) {
            _didFinishWithInfo(_sproductInfo);
            return;
        }
        
            [Toast makeToastActivity:@"正在保存" hasMusk:NO];
            NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
            NSDictionary *parameters=@{@"token":userToken,
                                       @"product_img":[[NSString alloc]initWithFormat:@"%@",_sproductInfo.productImageUrl],
                                       
                                       @"cate_id":[[NSString alloc] initWithFormat:@"%@",       _sproductInfo.productSubCategoryId],
                                       @"cate_value":[[NSString alloc] initWithFormat:@"%@",    _sproductInfo.productSubCategoryName],
                                       @"color_code":[[NSString alloc] initWithFormat:@"%@",    _sproductInfo.productColorCode],
                                       @"color_value":[[NSString alloc] initWithFormat:@"%@",   _sproductInfo.productColorName],
                                       
                                       @"brand_code":[[NSString alloc] initWithFormat:@"%@",_sproductInfo.productBrandCode],
                                       @"brand_value":[[NSString alloc] initWithFormat:@"%@",_sproductInfo.productBrandName],
                                       @"product_code":[[NSString alloc] initWithFormat:@"%@",_sproductInfo.productCode],
                                       @"a":@"uploadUserProduct",
                                       @"m":@"Product"};
            
            [[SDataCache sharedInstance] uploadProductDetailWithDic:parameters complete:^(id object)
             {
                 [Toast hideToastActivity];
                 
                 if ([object[@"status"] intValue]!=1) {
                     [Toast makeToast:object[@"info"] duration:1.5 position:@"center"];
                     return ;
                 }
                 
                 _sproductInfo.productId=[[NSString alloc] initWithFormat:@"%@",object[@"data"]];
                 
                 if (self.didFinish)
                 {
                     self.didFinish();
                 }
                 return;
             }];
        
    }
    else
    {
        if (self.didFinish)
        {
            self.didFinish();
        }

    }
}

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}


@end
