//
//  SSelectProductBrandViewController.m
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SSelectProductBrandViewController.h"
#import "SUtilityTool.h"
#import "HttpRequest.h"
#import "FilterBrandCategoryModel.h"
#import "SSortBrandByLetterModel.h"
#import "SDataCache.h"
#import "Toast.h"

#define sizeK UI_SCREEN_WIDTH/750.0

#define ADD_BRAND @"添加品牌："


@interface SearchDataModel : NSObject
@property (nonatomic,copy) NSString *brand_code;
@property(nonatomic,copy) NSString *cname;
@property(nonatomic,copy) NSString *ename;
@property (nonatomic,copy) NSString *english_name;
@property(nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *temp_id;
-(instancetype)initWithDic:(NSDictionary*)aDic;
@end

@implementation SearchDataModel

-(instancetype)initWithDic:(NSDictionary*)aDic
{
    if (self==[super init]) {
        _brand_code=aDic[@"brand_code"];
        _cname=aDic[@"cname"];
        _ename=aDic[@"ename"];
        _english_name=aDic[@"english_name"];
        _id=aDic[@"id"];
        _temp_id=aDic[@"temp_id"];
    }
    return self;
}

@end

@interface SSelectProductBrandViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UINavigationBar *_navigationBar;
    UIButton *_doneButton;
    ///默认table
    UITableView *_defaultTable;
    ///搜索结果table
    UITableView *_searchTable;
    NSMutableArray *_myTableArray;
    ///常用品牌数组
    NSMutableArray *_usuallyArray;
    
    UISearchBar *_searchBar;
    NSMutableArray *_searchArray;
    
    ///section索引数组
    NSArray *_sectionIndexArray;
    
    ///搜索结果为空
    UIView *_resultNullV;
}

@end

@implementation SSelectProductBrandViewController

#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        self.navigationItem.leftBarButtonItems = @[backButtonItem];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(100, 0, UI_SCREEN_WIDTH-200, 44)];
        _searchBar.tintColor=[UIColor blueColor];
        _searchBar.placeholder = @"请输入品牌名称";
        _searchBar.delegate=self;
        self.navigationItem.titleView = _searchBar;
        
        _doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame=CGRectMake(0, 0, 40, 18);
        [_doneButton setTitle:@"使用" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:_doneButton];
        _doneButton.hidden=YES;
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
        
        self.navigationItem.rightBarButtonItems = @[nextButtonItem];
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
    
    if (!_brandAry) {
        [Toast makeToastActivity:@"正在努力加载..." hasMusk:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    //这里添加其他代码
    _myTableArray=[NSMutableArray array];
    _usuallyArray=[NSMutableArray array];
    _searchArray=[NSMutableArray array];
    _sectionIndexArray=@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    _defaultTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    _defaultTable.backgroundColor=[UIColor whiteColor];
    _defaultTable.tag=1;
    _defaultTable.delegate=self;
    _defaultTable.dataSource=self;
    _defaultTable.sectionFooterHeight=.1*sizeK;
    _defaultTable.sectionIndexBackgroundColor=[UIColor clearColor];
    _defaultTable.sectionIndexColor=[UIColor grayColor];
    _defaultTable.tableFooterView=[[UIView alloc] init];
    [self.view addSubview:_defaultTable];
    
    [self requestBrandCategory];
    
    _searchTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    _searchTable.backgroundColor=[UIColor whiteColor];
    _searchTable.tag=2;
    _searchTable.delegate=self;
    _searchTable.dataSource=self;
    _searchTable.hidden=YES;
    _searchTable.tableFooterView=[[UIView alloc] init];
    [self.view addSubview:_searchTable];
    
    _resultNullV=[[UIView alloc] initWithFrame:CGRectMake(0, 104*sizeK+100*sizeK, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-104*sizeK-100*sizeK)];
    _resultNullV.hidden=YES;
    [self.view addSubview:_resultNullV];
    UILabel *lblNull1=[[UILabel alloc] initWithFrame:CGRectMake(0, 300*sizeK-50*sizeK, UI_SCREEN_WIDTH, 28*sizeK)];
    lblNull1.font=FONT_t5;
    lblNull1.textColor=COLOR_C6;
    lblNull1.textAlignment=NSTextAlignmentCenter;
    lblNull1.numberOfLines=0;
    lblNull1.lineBreakMode=NSLineBreakByWordWrapping;
    lblNull1.text=@"没有找到相关品牌";
    [_resultNullV addSubview:lblNull1];
    UILabel *lblNull2=[[UILabel alloc] initWithFrame:CGRectMake(0, 342*sizeK-50*sizeK, UI_SCREEN_WIDTH, 28*sizeK)];
    lblNull2.font=FONT_t5;
    lblNull2.textColor=COLOR_C6;
    lblNull2.textAlignment=NSTextAlignmentCenter;
    lblNull2.numberOfLines=0;
    lblNull2.lineBreakMode=NSLineBreakByWordWrapping;
    lblNull2.text=@"您也可以直接使用已输入的品牌";
    [_resultNullV addSubview:lblNull2];
    
    
    [self.view addSubview:_navigationBar];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_defaultTable)
    {
        //常用品牌，需要加1
        return _myTableArray.count+1;
    }
    else
    {
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_defaultTable)
    {
        if (section==0) {
            if (_usuallyArray.count<1) {
                return 1;
            }
            return _usuallyArray.count;
        }
        SSortBrandByLetterModel * temModel = _myTableArray[section-1];
        return temModel.brandInfo_array.count;
    }
    else
    {
        if (_searchArray.count<1&&!_searchTable.hidden) {
            _searchTable.scrollEnabled=NO;
            _resultNullV.hidden=NO;
        }
        else
        {
            _searchTable.scrollEnabled=YES;
            _resultNullV.hidden=YES;
        }
//        if (_searchArray.count<1) {
//            return 2;
//        }
//        else
//        {
            if (section==0) {
                return 1;
            }
            else
            {
                return _searchArray.count;
            }
//        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_defaultTable&&indexPath.section>0)
    {
        return 88*sizeK;
    }
    return 100*sizeK;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_searchTable&&section==0)
    {
        return 0;
    }
    else
    {
        return 60*sizeK;
    }
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView==_defaultTable)
    {
        if (_myTableArray.count<1) {
            return nil;
        }
        return _sectionIndexArray;
    }
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60*sizeK)];
    sectionView.backgroundColor=COLOR_C4;
    //标题
    UILabel *sectionTitle=[[UILabel alloc] init];
    sectionTitle.font=FONT_t6;
    sectionTitle.textColor=COLOR_C2;
    [sectionView addSubview:sectionTitle];
    //数量
    UILabel *sectionNum=[[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-220, 0, 200, 60*sizeK)];
    sectionNum.font=FONT_t6;
    sectionNum.textColor=COLOR_C6;
    sectionNum.textAlignment=NSTextAlignmentRight;
    [sectionView addSubview:sectionNum];
    if (tableView==_defaultTable)
    {
        if (section==0)
        {
            sectionTitle.frame=CGRectMake(20*sizeK, 0, 200, 60*sizeK);
            sectionTitle.text=@"常用品牌";
            sectionNum.text= [[NSString alloc] initWithFormat:@"%lu",(unsigned long)_usuallyArray.count ];
        }
        else
        {
            SSortBrandByLetterModel * temModel = _myTableArray[section-1];
            sectionTitle.frame=CGRectMake(30*sizeK, 0, 200, 60*sizeK);
            sectionTitle.font=FONT_t4;
            sectionTitle.text=[temModel.sortString uppercaseString];
//            sectionNum.text= [[NSString alloc] initWithFormat:@"%lu",(unsigned long)temModel.brandInfo_array.count ];
        }
    }
    else
    {
        sectionTitle.frame=CGRectMake(20*sizeK, 0, 200, 60*sizeK);
        sectionTitle.text=@"找到相关品牌";
        sectionNum.text=[[NSString alloc] initWithFormat:@"%lu",(unsigned long)_searchArray.count ];
    }
    
    return sectionView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    if (tableView==_defaultTable&&indexPath.section!=0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.separatorInset=UIEdgeInsetsMake(87*sizeK, 30*sizeK, 0, 30*sizeK);
            
            //商标
            UIImageView *logoImg=[[UIImageView alloc] initWithFrame:CGRectMake(35*sizeK, 6*sizeK, 76*sizeK, 76*sizeK)];
            logoImg.tag=2;
            [cell addSubview:logoImg];
            
            //商标名称
            UILabel *logoName=[[UILabel alloc] init];
            logoName.tag=3;
            logoName.frame=CGRectMake(140*sizeK, 0, UI_SCREEN_WIDTH-170*sizeK, 88*sizeK);
            logoName.textAlignment=NSTextAlignmentLeft;
            logoName.font=FONT_t5;
            logoName.textColor=COLOR_C2;
            [cell addSubview:logoName];
        }
    
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.separatorInset=UIEdgeInsetsMake(99*sizeK, 34*sizeK, 0, 0);
            
            //分割线
            UIView *lineV=[[UIView alloc] initWithFrame:CGRectMake(0, 99*sizeK, UI_SCREEN_WIDTH, 1*sizeK)];
            lineV.tag=1;
            lineV.hidden=YES;
            lineV.backgroundColor=COLOR_C9;
            [cell addSubview:lineV];
            
            //商标名称
            UILabel *logoName=[[UILabel alloc] init];
            logoName.tag=3;
            logoName.font=FONT_t4;
            logoName.textColor=COLOR_C2;
            [cell addSubview:logoName];
        }
    }
    UIView *lineV=[cell viewWithTag:1];
    UIImageView *logoImg=(UIImageView*)[cell viewWithTag:2];
    UILabel *logoName=(UILabel*)[cell viewWithTag:3];
    
    if (tableView==_defaultTable) {
        if (indexPath.section==0) {
            if (_usuallyArray.count<1) {
                //如果常用品牌为空
                lineV.hidden=NO;
                logoName.frame=CGRectMake(0, 0, UI_SCREEN_WIDTH, 100*sizeK);
                logoName.textAlignment=NSTextAlignmentCenter;
                logoName.font=FONT_t5;
                logoName.textColor=COLOR_C6;
                logoName.text=@"尚未记录品牌";
            }
            else
            {
                SSortBrandByLetterSubModel *mybrandM=_usuallyArray[indexPath.row];
                lineV.hidden=YES;
                logoName.frame=CGRectMake(34*sizeK, 0, UI_SCREEN_WIDTH-34*sizeK, 100*sizeK);
                logoName.textAlignment=NSTextAlignmentLeft;
                logoName.textColor=COLOR_C2;
                logoName.font=FONT_t4;
                logoName.text=mybrandM.branD_NAME;
            }
        }
        else
        {
            SSortBrandByLetterModel * temModel = _myTableArray[indexPath.section-1];
            SSortBrandByLetterSubModel *temSubModel=temModel.brandInfo_array[indexPath.row];
            //隐藏cell间可能出现的缝隙
            if (temModel.brandInfo_array.count-1==indexPath.row) {
                cell.layer.borderWidth=1;
                cell.layer.borderColor=COLOR_C3.CGColor;
            }
            else
            {
                cell.layer.borderWidth=0;
            }
            logoName.text=temSubModel.branD_NAME;
            [logoImg sd_setImageWithURL:[NSURL URLWithString:temSubModel.logO_URL] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        }
    }
    else
    {
        logoName.textAlignment=NSTextAlignmentLeft;
        //添加品牌
        if (indexPath.section==0) {
            logoName.frame=CGRectMake(20*sizeK, 0, UI_SCREEN_WIDTH-20*sizeK, 100*sizeK);
            logoName.text=[NSString stringWithFormat:@"%@%@",ADD_BRAND,_searchBar.text];
        }
        else
        {
            logoName.frame=CGRectMake(34*sizeK, 0, UI_SCREEN_WIDTH-120*sizeK, 100*sizeK);
            SearchDataModel *searchData=_searchArray[indexPath.row];
            logoName.text=searchData.ename;
            if (searchData.ename.length<1) {
                logoName.text=searchData.cname;
            }
            if (logoName.text.length<1) {
                logoName.text=searchData.english_name;
            }

        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    
    NSString *indexStr=_sectionIndexArray[index];
    for (int i=0; i<_myTableArray.count;i++) {
        SSortBrandByLetterModel * temModel = _myTableArray[i];
        if ([indexStr isEqualToString:[temModel.sortString uppercaseString]]) {
            //获取所点目录对应的indexPath值
            NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:i+1];
            // 让table滚动到对应的indexPath位置
            [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            return i+1;
        }
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_searchTable) {
        
        SearchDataModel *searchData;
        NSString *brand_name;
        if(indexPath.section==0){
            brand_name=[_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"无效的品牌：%@：长度：%lu",brand_name,(unsigned long)brand_name.length);
            if (brand_name.length<1) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"品牌不能为空" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
                return;
            }
        }else{
            searchData=_searchArray[indexPath.row];
            if (self.didFinishBrand) {
                brand_name=searchData.ename;
                if (searchData.ename.length<1) {
                    brand_name=searchData.cname;
                }
                if (brand_name.length<1) {
                    brand_name=searchData.english_name;
                }
            }
        }
        self.didFinishBrand(searchData.id,searchData.brand_code,brand_name);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if(indexPath.section==0){
        if(_usuallyArray.count==0){
            return;
        }
        
        SSortBrandByLetterSubModel *temSubModel=_usuallyArray[indexPath.row];
        if (self.didFinishBrand) {
            self.didFinishBrand(temSubModel.idStr,temSubModel.brand_code,temSubModel.branD_NAME);
        }
    }else{
        SSortBrandByLetterModel *temModel = _myTableArray[indexPath.section-1];
        SSortBrandByLetterSubModel *temSubModel=temModel.brandInfo_array[indexPath.row];
        //    logoName.text=temSubModel.branD_NAME;
        if (self.didFinishBrand) {
            self.didFinishBrand(temSubModel.idStr,temSubModel.brand_code,temSubModel.branD_NAME);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length<1) {
        _searchTable.hidden=YES;
        _resultNullV.hidden=YES;
    }
    else
    {
        _searchTable.hidden=NO;
    }
    
    [self requestSearchBrand];
}

-(void)requestSearchBrand
{
    NSDictionary *data = @{
                           @"m": @"Search",
                           @"a": @"getBrandListByKey",
                           @"keyword": _searchBar.text,
                           @"page": @(0),
                           @"pageSize": @(500)
                           };
    
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            [_searchArray removeAllObjects];
            [_searchTable reloadData];
            return ;
        }
        NSArray *array = object[@"data"][@"list"];
        if (array.count == 0) {
            array = object[@"data"][@"hotlist"];
        }
        
        [_searchArray removeAllObjects];
        
        [array enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
            SearchDataModel *searchModel=[[SearchDataModel alloc] initWithDic:obj];
            
            [_searchArray addObject:searchModel];
            
        }];
        _resultNullV.hidden=YES;
        if (_searchArray.count<1) {
            _resultNullV.hidden=NO;
        }
        [_searchTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
        [_searchArray removeAllObjects];
        [_searchTable reloadData];
    }];

}

- (void)requestBrandCategory{
    
//    if(_brandAry){
//        NSMutableArray * Arr = [[NSMutableArray alloc]init];
//        for (NSDictionary * tempDic in _brandAry) {
//            
//            SSortBrandByLetterModel * model = [[SSortBrandByLetterModel alloc]initWithDic:tempDic];
//            if (!([[model.sortString lowercaseString] characterAtIndex:0]<123&&[[model.sortString lowercaseString] characterAtIndex:0]>96)) {
//                
//                if (Arr.count>0) {
//                    SSortBrandByLetterModel * model_=Arr[0];
//                    if (![model_.sortString isEqualToString:@"#"]) {
//                        model.sortString=@"#";
//                        [Arr insertObject:model_ atIndex:0];
//                    }
//                    else
//                    {
//                        [model_.brandInfo_array addObjectsFromArray:model.brandInfo_array];
//                    }
//                }
//                else
//                {
//                    model.sortString=@"#";
//                    [Arr addObject:model];
//                }
//            }
//            else
//            {
//                
//                for (int i=0; i<Arr.count; i++) {
//                    SSortBrandByLetterModel *mode=Arr[i];
//                    if ([model.sortString.uppercaseString isEqualToString:mode.sortString.uppercaseString]) {
//                        [mode.brandInfo_array addObjectsFromArray:model.brandInfo_array];
//                        break;
//                    }
//                    if (i==Arr.count-1) {
//                        [Arr addObject:model];
//                    }
//                }
//            }
//            
//        }
//        _myTableArray=Arr;
//        [_defaultTable reloadData];
//        return;
//    }
    
    [Toast makeToastActivity:@"正在努力加载..." hasMusk:NO];
    //FIXME:BrandOrderFilter接口是A-Z排序的接口，8.7版本记得修改
    //    新街口 换为  Procduct；@"WXSC_Product"
    [HttpRequest productGetRequestPath:@"Procduct" methodName:@"BrandOrderFilterWithUse" params:@{@"pageIndex": @1, @"pageSize": @1000} success:^(NSDictionary *dict) {
        
        if ([dict[@"isSuccess"] intValue] != 1) {
            [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
            return ;
        }
        
        
        NSMutableArray * Arr = [[NSMutableArray alloc]init];
        
        NSMutableArray *brandListAry=dict[@"results"][0][@"brandList"];
        NSArray *myBrand=dict[@"results"][0][@"myBrand"];
        
        [myBrand enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            SSortBrandByLetterSubModel *myBrandModel=[[SSortBrandByLetterSubModel alloc] init];
            myBrandModel.idStr=[[NSString alloc]initWithFormat:@"%@",obj[@"brandInfo"][0][@"id"]];
            myBrandModel.brand_code=[[NSString alloc]initWithFormat:@"%@",obj[@"brandInfo"][0][@"brand_code"]];
            myBrandModel.branD_NAME=[[NSString alloc]initWithFormat:@"%@",obj[@"brandInfo"][0][@"branD_NAME"]];
            [_usuallyArray addObject:myBrandModel];
        }];
        
        for (NSDictionary * tempDic in brandListAry) {
            
            SSortBrandByLetterModel * model = [[SSortBrandByLetterModel alloc]initWithDic:tempDic];
            if ([[model.sortString lowercaseString] characterAtIndex:0]<123&&[[model.sortString lowercaseString] characterAtIndex:0]>96) {
                if (Arr.count<1) {
                    [Arr addObject:model];
                }
                else
                {
                    for (int i=0; i<Arr.count; i++) {
                        SSortBrandByLetterModel *mode=Arr[i];
                        if ([model.sortString.uppercaseString isEqualToString:mode.sortString.uppercaseString]) {
                            [mode.brandInfo_array addObjectsFromArray:model.brandInfo_array];
                            
                            break;
                        }
                        if (i==Arr.count-1) {
                            [Arr addObject:model];
                            break;
                        }
                    }
                }
            }
            else
            {
                if (Arr.count>0) {
                    SSortBrandByLetterModel * model_=Arr[0];
                    if (![model_.sortString isEqualToString:@"#"]) {
                        model.sortString=@"#";
                        [Arr insertObject:model_ atIndex:0];
                    }
                    else
                    {
                        [model_.brandInfo_array addObjectsFromArray:model.brandInfo_array];
                    }
                }
                else
                {
                    model.sortString=@"#";
                    [Arr addObject:model];
                }
                
            }
            
        }
        _myTableArray=Arr;
        [Toast hideToastActivity];
        [_defaultTable reloadData];
        
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
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
    [_navigationBar pushNavigationItem:self.navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
}

#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}

-(void)doneButtonClick:(UIButton*)sender
{
    
}
/**
 *   获取所有的品牌
 */
-(void)setBrandAry:(NSArray *)brandAry
{
    _brandAry=brandAry;
}

@end
