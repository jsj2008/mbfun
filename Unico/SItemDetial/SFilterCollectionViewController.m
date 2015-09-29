//
//  SFilterCollectionViewController.m
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SFilterCollectionViewController.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "FilterPirceRangeModel.h"
#import "FilterBrandCategoryModel.h"
#import "FilterColorCategoryModel.h"
#import "FliterContentCollectionViewCell.h"
#import "FilterContentHeaderReusableView.h"
#import "SFilterSelectedModel.h"
#import "MBBrandViewController.h"
#import "Toast.h"
#import "FliterChooseCollectionReusableView.h"
#import "SAddProductTagViewControlCenter.h"
@interface SFilterCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    //保存筛选信息
    SProductTagEditeInfo *_productTagEditeInfo;
    //重置
    UIButton *_ResetButton;
    
    //单品分类数据
    NSArray *_bcurrentCategoryAry;
}
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

//-------------

@property (nonatomic, strong) NSArray *titleNameArray;

@end

static NSString *cellIdentifier = @"FliterContentCollectionViewCellIdentifier";
static NSString *headerIdentifier = @"FliterContentCollectionViewHeaderIdentifier";
static NSString *chooseIdentifier = @"FliterContentCollectionViewChooseIdentifier";
@implementation SFilterCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavbar];
    [_ResetButton setEnabled:NO];
    [self initSubViews];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)setupNavbar {
    [super setupNavbar];
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
//    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(onReset:)];
    _ResetButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _ResetButton.frame=CGRectMake(0, 0, 36, 30);
    [_ResetButton setTitleColor:COLOR_C6 forState:UIControlStateDisabled];
    [_ResetButton setTitleColor:COLOR_C3 forState:UIControlStateNormal];
    _ResetButton.titleLabel.font=FONT_t3;
    [_ResetButton setTitle:@"重置" forState:UIControlStateNormal];
    [_ResetButton addTarget:self action:@selector(onReset:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_ResetButton];
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithCustomView:_ResetButton];
    
    

    self.navigationItem.rightBarButtonItems = @[negativeSpacer,right1] ;
    
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"单品筛选" fontStyle:FONT_SIZE(18) color:COLOR_WHITE rect:CGRectMake(0, 0, 0, self.navigationController.navigationBar.height) isFitWidth:YES isAlignLeft:YES];
    [tempView setSize:CGSizeMake(tempLabel.width, self.navigationController.navigationBar.height)];
    [tempView addSubview:tempLabel];
    self.navigationItem.titleView = tempView;
}

- (void)initSubViews{
    self.contentCollectionView.allowsMultipleSelection = YES;
    
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"FliterContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"FilterContentHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
     [self.contentCollectionView registerNib:[UINib nibWithNibName:@"FliterChooseCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:chooseIdentifier];
    
    _productTagEditeInfo=[[SProductTagEditeInfo alloc]init];
    if(_parameterTagEditeInfo||_parameterTagEditeInfo.productSubCategoryId){
        _titleNameArray = @[@"单品分类",
                            @"品牌",
                            @"颜色",
                            @"尺码",
                            @"价格",
                            @""];
        _productTagEditeInfo.productSubCategoryId = _parameterTagEditeInfo.productSubCategoryId;
    }else{
        _titleNameArray = @[@"单品分类",
                        @"品牌",
                        @"颜色",
                        @"价格",
                        @""];
    }
//    if (_isComeFromBrand) {
//        _titleNameArray = @[@"单品分类",
//                            @"品牌",
//                            @"颜色",
//                            @"价格"];
//    }
    _selectedIndexModel = [SFilterSelectedModel new];
    
}
- (void)requestData{
//    [self requestPirceRange];
//    [self requestColorCategory];
//    if (!_isComeFromBrand) {
//        [self requestBrandCategory];
//    }
    
    NSMutableDictionary *data=[NSMutableDictionary new];
    data[@"m"]=@"Search";
    data[@"a"]=@"getSearchKey";
    
    if(_keyword)
        data[@"keyword"]=_keyword;
    
    if(_dailyNewModel||_dailyNewModel.brand_code)
        data[@"brand"]=_dailyNewModel.brand_code;
    
    if(_productTagEditeInfo.productSubCategoryId)
        data[@"cid"] = _productTagEditeInfo.productSubCategoryId;
    
    
    __unsafe_unretained typeof(self) p = self;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        //价格
        NSArray *valueAry;
        NSArray *ary=responseObject[@"results"];
        for(NSDictionary *resultsDict in ary){
            
            //单品分类
            if(_parameterTagEditeInfo||_parameterTagEditeInfo.productSubCategoryId){
                if([[resultsDict allKeys]containsObject:@"parentCategory"]){
                    NSDictionary *parentCategoryDict=resultsDict[@"parentCategory"];
                       NSArray *cidAry=parentCategoryDict[@"subs"];
                       for (int i=0; i<cidAry.count; i++) {
                           if(i==0){
                               _productTagEditeInfo.productSubCategoryId = cidAry[i][@"catId"];
                               _productTagEditeInfo.productSubCategoryCode = nil;
                               _productTagEditeInfo.productSubCategoryName = cidAry[i][@"catName"];
                           }else if(i==2){
                               _productTagEditeInfo.productCategoryId =cidAry[i][@"catId"];
                               _productTagEditeInfo.productCategoryName =cidAry[i][@"catName"];
                           }
                       }
                    }
                }
            
            if([[resultsDict allKeys]containsObject:@"subFilters"]){
                
                NSArray *subFiltersAry=resultsDict[@"subFilters"];
                for (NSDictionary *priceDict in subFiltersAry) {
                    
                    NSString *code=priceDict[@"code"];
                    
                    if([code isEqualToString:@"price"]){
                        valueAry=priceDict[@"values"];
                        continue;
                    }
                    if([code isEqualToString:@"size"]){
                        _sizeAry=priceDict[@"values"];
                        continue;
                    }
                    if([code isEqualToString:@"color"]){
                        _colorAry=priceDict[@"values"];
                        continue;
                    }
                    if([code isEqualToString:@"brand"]){
                        _brandAry=priceDict[@"values"];
                        continue;
                    }
                }
                
            }
            if([[resultsDict allKeys]containsObject:@"currentCategory"]){
                if(_firstBcurrentCategoryAry)
                    _bcurrentCategoryAry=resultsDict[@"currentCategory"];
                else
                    _firstBcurrentCategoryAry=resultsDict[@"currentCategory"];
            }
        }
//        if(valueAry){
        p.pirceRangeModelArray = [FilterPirceRangeModel modelArrayForDataArray:valueAry];
//        }
        [_contentCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];

    
    
    
//    [HttpRequest productPostRequestPath:@"Search" methodName:@"getSearchKey" params:nil success:^(NSDictionary *dict) {
//            //价格
//            NSArray *valueAry;
//            NSArray *ary=dict[@"results"];
//            for(NSDictionary *resultsDict in ary){
//                
//                if([[resultsDict allKeys]containsObject:@"subFilters"]){
//                    
//                    NSArray *subFiltersAry=resultsDict[@"subFilters"];
//                    
//                    for (NSDictionary *priceDict in subFiltersAry) {
//                        
//                        NSString *price=priceDict[@"code"];
//                        
//                        if([price isEqualToString:@"price"]){
//                            valueAry=priceDict[@"values"];
//                            break;
//                        }
//                    }
//                    break;
//                }
//            }
//            if(!valueAry)return;
//            p.pirceRangeModelArray = [FilterPirceRangeModel modelArrayForDataArray:valueAry];
//            [_contentCollectionView reloadData];
//        } failed:^(NSError *error) {
//            [Toast makeToast:@"网络不给力！" duration:1.5 position:@"center"];
//        }];
}

//- (void)requestPirceRange{
//    __unsafe_unretained typeof(self) p = self;
//    
//
//    [HttpRequest productPostRequestPath:@"Product" methodName:@"BasePriceFilter" params:nil success:^(NSDictionary *dict) {
//        
//        p.pirceRangeModelArray = [FilterPirceRangeModel modelArrayForDataArray:dict[@"results"]];
//        
//    } failed:^(NSError *error) {
//        
//    }];
//    
//    /*
//    [HttpRequest productGetRequestPath:nil methodName:@"BasePriceFilter" params:nil success:^(NSDictionary *dict) {
//        p.pirceRangeModelArray = [FilterPirceRangeModel modelArrayForDataArray:dict[@"results"]];
//    } failed:^(NSError *error) {
//        NSLog(@"价格区间请求错误");
//    }];
//     */
//}

//- (void)requestColorCategory{
//    __unsafe_unretained typeof(self) p = self;
//    
//    [HttpRequest productPostRequestPath:@"Product" methodName:@"BaseColorFilter" params:nil success:^(NSDictionary *dict) {
//        
//        p.colorModelArray = [FilterColorCategoryModel modelArrayForDataArray:dict[@"results"]];
//        
//    } failed:^(NSError *error) {
//        
//    }];
//    return;
//    
////    [HttpRequest productGetRequestPath:nil methodName:@"BaseColorFilter" params:nil success:^(NSDictionary *dict) {
////        p.colorModelArray = [FilterColorCategoryModel modelArrayForDataArray:dict[@"results"]];
////    } failed:^(NSError *error) {
////        
////    }];
//}

//- (void)requestBrandCategory{
//    __unsafe_unretained typeof(self) p = self;
//    
//    [HttpRequest productPostRequestPath:@"Product" methodName:@"BrandFilter" params:@{@"pageIndex": @1, @"pageSize": @20} success:^(NSDictionary *dict) {
//        p.brandModelArray = [FilterBrandCategoryModel modelArrayForDataArray:dict[@"results"]];
//    } failed:^(NSError *error) {
//        
//    }];
//    return;
////    
////    [HttpRequest productGetRequestPath:nil methodName:@"BrandFilter" params:@{@"pageIndex": @1, @"pageSize": @20} success:^(NSDictionary *dict) {
////        p.brandModelArray = [FilterBrandCategoryModel modelArrayForDataArray:dict[@"results"]];
////    } failed:^(NSError *error) {
////        
////    }];
//}


//- (void)setPirceRangeModelArray:(NSArray *)pirceRangeModelArray{
//    _pirceRangeModelArray = pirceRangeModelArray;
//    [self.contentCollectionView reloadData];
//}
//
//- (void)setBrandModelArray:(NSArray *)brandModelArray{
//    _brandModelArray = brandModelArray;
//    [self.contentCollectionView reloadData];
//}
//
//- (void)setColorModelArray:(NSArray *)colorModelArray{
//    _colorModelArray = colorModelArray;
//    [self.contentCollectionView reloadData];
//}

#pragma mark - collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    if (_isComeFromBrand) {
//        return 2;
//        
//    }
//    return 3;
    return _titleNameArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   NSString *titleName=_titleNameArray[section];
    if([titleName isEqualToString:@"价格"]){
        return self.pirceRangeModelArray.count;
    }
    return 0;
//    switch (section) {
//        case 0:
//            return self.pirceRangeModelArray.count;
//            break;
//        case 1:
//            return self.colorModelArray.count;
//            break;
//        case 2:
//            return self.brandModelArray.count;
//            break;
//        default:
//            return 0;
//            break;
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    FliterContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSIndexPath *index;
//    switch (indexPath.section) {
//        case 0:
//            index = _selectedIndexModel.firstCondition;
//            cell.pirceRangeModel = self.pirceRangeModelArray[indexPath.row];
//            break;
//        case 1:
//            index = _selectedIndexModel.secondCondition;
//            cell.colorModel = self.colorModelArray[indexPath.row];
//            break;
//        case 2:
//            index = _selectedIndexModel.thirdCondition;
//            cell.brandModel = self.brandModelArray[indexPath.row];
//            break;
//        default:
//            break;
//    }
//    if (index && indexPath.row == index.row) {
//        [cell setSelected:YES];
//    }
    
    NSString *titleName=_titleNameArray[indexPath.section];
    if([titleName isEqualToString:@"价格"]){
        index = _selectedIndexModel.firstCondition;
        cell.pirceRangeModel = self.pirceRangeModelArray[indexPath.row];
    }
    if (index && indexPath.row == index.row) {
        [cell setSelected:YES];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view=nil;
    
    NSString *titleName=_titleNameArray[indexPath.section];
    if([titleName isEqualToString:@"价格"]){
        FilterContentHeaderReusableView *contentView = nil;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            contentView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
            contentView.titleName = self.titleNameArray[indexPath.section];
            if(indexPath.section==0)
            {
                contentView.lineImageView.hidden=YES;
            }
        }
        view=contentView;
    }else{
        FliterChooseCollectionReusableView *chooseView = nil;
    
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            chooseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:chooseIdentifier forIndexPath:indexPath];
            NSString *contentText=@"";
            chooseView.chooseButton.tag=200+indexPath.section;
            chooseView.titleName = self.titleNameArray[indexPath.section];
            
            if([titleName isEqualToString:@""]){
                if(chooseView.determineButton.allTargets.count==0){
                    [chooseView.determineButton addTarget:self action:@selector(doneBtn) forControlEvents:UIControlEventTouchUpInside];
                }
                view=chooseView;
            }else{
                if(chooseView.chooseButton.allTargets.count==0){
                    [chooseView.chooseButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                if([titleName isEqualToString:@"单品分类"]){
                    contentText=[NSString stringWithFormat:@"%@ %@", _productTagEditeInfo.productCategoryName, _productTagEditeInfo.productSubCategoryName];
                }else if([titleName isEqualToString:@"品牌"]){
                    if(_dailyNewModel||_dailyNewModel.english_name)
                        contentText=_dailyNewModel.english_name;
                    else
                        contentText=_productTagEditeInfo.productBrandName;
                    
                }else if([titleName isEqualToString:@"颜色"]){
                    contentText=_productTagEditeInfo.productColorName;
                }else if([titleName isEqualToString:@"尺码"]){
                    contentText=_productTagEditeInfo.productSizeName;
                }
                chooseView.contentText=contentText;
            }
        }
        view=chooseView;
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSString *titleName=_titleNameArray[section];
    if([titleName isEqualToString:@"价格"]){
        return CGSizeMake(UI_SCREEN_WIDTH, 38);
    }
    if([titleName isEqualToString:@""]){
        return CGSizeMake(UI_SCREEN_WIDTH, 80);
    }
    return CGSizeMake(UI_SCREEN_WIDTH, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.section) {
//        case 0:
//        {
//              return CGSizeMake((UI_SCREEN_WIDTH-16*4)/3, 34);
//        }
//            break;
//        case 1:
//        {
//               return CGSizeMake((UI_SCREEN_WIDTH-16*4)/3, 34);
//        }
//            break;
//        case 2:
//        {
////            if((UI_SCREEN_WIDTH-16*5)/4>73)
////            {
////             return CGSizeMake((UI_SCREEN_WIDTH-16*5)/4,(UI_SCREEN_WIDTH-16*5)/4);
////            }
//            return CGSizeMake((UI_SCREEN_WIDTH-16*5)/4,(UI_SCREEN_WIDTH-16*5)/4);
//
//            //   return CGSizeMake((UI_SCREEN_WIDTH-16*5)/4,73);
//        }
//            break;
//            
//        default:
//            break;
//    }
    return CGSizeMake((UI_SCREEN_WIDTH-16*4)/3, 36);
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleName=_titleNameArray[indexPath.section];
    if([titleName isEqualToString:@"价格"]){
        if (_selectedIndexModel.firstCondition && indexPath.row == _selectedIndexModel.firstCondition.row) {
            _selectedIndexModel.firstCondition = nil;
        }else{
            [_ResetButton setEnabled:YES];
            _selectedIndexModel.firstCondition = indexPath;
        }
    }
//    switch (indexPath.section) {
//        case 0:
//            if (_selectedIndexModel.firstCondition && indexPath.row == _selectedIndexModel.firstCondition.row) {
//                _selectedIndexModel.firstCondition = nil;
//            }else{
//                _selectedIndexModel.firstCondition = indexPath;
//            }
//            break;
//        case 1:
//            if (_selectedIndexModel.secondCondition && indexPath.row == _selectedIndexModel.secondCondition.row) {
//                _selectedIndexModel.secondCondition = nil;
//            }else{
//                _selectedIndexModel.secondCondition = indexPath;
//            }
//            break;
//        case 2:
//            if (_selectedIndexModel.thirdCondition && indexPath.row == _selectedIndexModel.thirdCondition.row) {
//                _selectedIndexModel.thirdCondition = nil;
//            }else{
//                _selectedIndexModel.thirdCondition = indexPath;
//            }
//            break;
//        default:
//            break;
//    }
    [self.contentCollectionView reloadData];
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//跨ui传参 单品分类
- (void)setProductCategoryWithCategoryId:(NSString *)categoryId categoryName:(NSString *)categoryName subCategoryId:(NSString *)subCategoryId subCategoryCode:(NSString *)subCategoryCode subCategoryName:(NSString *)subCategoryName
{
    [_ResetButton setEnabled:YES];
    _productTagEditeInfo.productCategoryId = categoryId;
    _productTagEditeInfo.productCategoryName = categoryName;
    _productTagEditeInfo.productSubCategoryId = subCategoryId;
    _productTagEditeInfo.productSubCategoryCode = subCategoryCode;
    _productTagEditeInfo.productSubCategoryName = subCategoryName;
    
    _titleNameArray = @[@"单品分类",
                        @"品牌",
                        @"颜色",
                        @"尺码",
                        @"价格",
                        @""];
    [self requestData];
}
//跨ui传参 品牌分类
- (void)setProductBrandWithBrandId:(NSString *)brandId brandCode:(NSString *)brandCode brandName:(NSString *)brandName
{
    [_ResetButton setEnabled:YES];
    _productTagEditeInfo.productBrandId = brandId;
    _productTagEditeInfo.productBrandCode = brandCode;
    _productTagEditeInfo.productBrandName = brandName;
    [self.contentCollectionView reloadData];
}
//跨ui传参 颜色分类
- (void)setProductColorWithColorId:(NSString *)colorId colorCode:(NSString *)colorCode colorName:(NSString *)colorName;
{
    [_ResetButton setEnabled:YES];
    _productTagEditeInfo.productColorId = colorId;
    _productTagEditeInfo.productColorCode = colorCode;
    _productTagEditeInfo.productColorName = colorName;
    [self.contentCollectionView reloadData];
}

//跨ui传参 尺码分类
- (void)setProductSizeWithSizeCode:(NSString *)sizeCode sizeName:(NSString *)sizeName
{
    [_ResetButton setEnabled:YES];
    _productTagEditeInfo.productSizeCode = sizeCode;
    _productTagEditeInfo.productSizeName = sizeName;
    [self.contentCollectionView reloadData];
}

#pragma mark action mothod 

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}
-(void)onReset:(UIButton *)sender{
    [_ResetButton setEnabled:NO];
     _productTagEditeInfo=[[SProductTagEditeInfo alloc]init];
    if(_parameterTagEditeInfo){
        _productTagEditeInfo.productSubCategoryId = _parameterTagEditeInfo.productSubCategoryId;
        _titleNameArray = @[@"单品分类",
                            @"品牌",
                            @"颜色",
                            @"尺码",
                            @"价格",
                            @""];
    }else{
       
        _titleNameArray = @[@"单品分类",
                            @"品牌",
                            @"颜色",
                            @"价格",
                            @""];
    }
    
    _selectedIndexModel = [SFilterSelectedModel new];
    
        [self requestData];
}
-(void)chooseAction:(id)sender{
    UIButton *chooseButton=(UIButton *)sender;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    switch (chooseButton.tag-200) {
        case 0:{
            if(_parameterTagEditeInfo||_parameterTagEditeInfo.productSubCategoryId){
                [UIApplication sharedApplication].statusBarHidden = NO;
                [self.navigationController setNavigationBarHidden:NO];
                break;
            }
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductCategoryViewWithAnimated:YES FilterCollectionViewController:self];
        }
            break;
        case 1:{
            if(_dailyNewModel||_dailyNewModel.brand_code){
                [UIApplication sharedApplication].statusBarHidden = NO;
                [self.navigationController setNavigationBarHidden:NO];
                break;
            }
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductBrandViewWithAnimated:YES FilterCollectionViewController:self];
        }
            break;
        case 2:
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductColorViewWithAnimated:YES FilterCollectionViewController:self];
            break;
        case 3:
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductSizeViewWithAnimated:YES FilterCollectionViewController:self];
            break;
        default:
            break;
    }
    
}
- (void)doneBtn{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    FilterPirceRangeModel *pirceRangeModel = nil;

    NSIndexPath *indexPath = _selectedIndexModel.firstCondition;
    if (indexPath) {
        pirceRangeModel = self.pirceRangeModelArray[indexPath.row];
        dict[@"priceRange"] = pirceRangeModel.code;
    }
    if(_productTagEditeInfo.productSubCategoryId)
        dict[@"cid"] = _productTagEditeInfo.productSubCategoryId;
    
    if(_productTagEditeInfo.productBrandCode)
        dict[@"brand"] = _productTagEditeInfo.productBrandCode;
    
    if(_productTagEditeInfo.productSizeCode)
        dict[@"sizeCode"] = _productTagEditeInfo.productSizeCode;
    
    if(_productTagEditeInfo.productColorCode)
        dict[@"color"] = _productTagEditeInfo.productColorCode;
    
    
    if(_dailyNewModel||_dailyNewModel.brand_code)
        dict[@"brand"] = _dailyNewModel.brand_code;

    if (_isBack) {
        _didSelectedEnter(dict);
        
        [self popAnimated:YES];
        return;
    }
    MBBrandViewController *controller = [MBBrandViewController new];
    controller.searchDictionary = dict;
    [self.navigationController pushViewController:controller animated:YES];
}
@end