//
//  SBrandShowListControllerViewController.m
//  Wefafa
//
//  Created by lizhaoxiang on 15/5/24.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBrandShowListControllerViewController.h"
#import "SBrandShowListContentCell.h"
#import "FilterBrandCategoryModel.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "HttpRequest.h"
#import "SSortBrandByLetterCell.h"
#import "DailyNewViewController.h"
#import "BrandDetailViewController.h"

@interface SBrandShowListControllerViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _sBrandShowListTable;
    NSMutableArray * _letterIndexArr;
    NSMutableArray * _letterSortData;
    
    NSInteger _selectSortIndex;
    
    UIBarButtonItem * right1;
    UIBarButtonItem * right2;

    BOOL ifListStyle;
}

@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

//-----------
@property (nonatomic, strong) NSMutableArray *brandModelArray;
@property (nonatomic,strong) NSMutableArray *tableViewBrandModelArray;

@end

static NSString *cellIdentifier = @"SBrandShowListContentCellIdentifier";
@implementation SBrandShowListControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectSortIndex = 0;
    ifListStyle = NO;
    [self initSubViews];
    [self requestBrandNormal];
    //页面需要测试
//    [self requestBrandCategory];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavbar];
}

- (void)initSubViews{
    [_contentCollectionView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SBrandShowListContentCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
}
-(void)tableViewSet
{
    //索引数据源
    if (!_letterIndexArr) {
        _letterIndexArr = [[NSMutableArray alloc]init];
        
        for(char c ='A';c<='Z';c++)
            
        {
            
            //当前字母
            
            NSString *letter=[NSString stringWithFormat:@"%c",c];
            
            [_letterIndexArr addObject:letter];
            
        }
        
    }

    CGFloat origintY = self.navigationController.navigationBar.height+20;
    if(!_sBrandShowListTable)
    {
        _sBrandShowListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, origintY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-origintY) style:UITableViewStyleGrouped];
        _sBrandShowListTable.delegate = self;
        _sBrandShowListTable.dataSource = self;
        //    _sBrandShowListTable.sectionIndexColor =
        [self.view addSubview:_sBrandShowListTable];
        [_sBrandShowListTable setHidden:NO];
        [_sBrandShowListTable reloadData];
    }
   
    [self.contentCollectionView setHidden:YES];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
     right1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Unico/list_grid"] style:UIBarButtonItemStylePlain target:self action:@selector(onSwitchListStyle:)];
    
    right2 = [[UIBarButtonItem alloc]initWithTitle:@"A-Z" style:UIBarButtonItemStylePlain target:self action:@selector(onSwitchListStyle:)];
    self.navigationItem.rightBarButtonItem = right2;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:@"品牌列表" fontStyle:FONT_SIZE(18) color:COLOR_WHITE rect:CGRectMake(0, 0, 0, self.navigationController.navigationBar.height) isFitWidth:YES isAlignLeft:YES];
    [tempView setSize:CGSizeMake(tempLabel.width, self.navigationController.navigationBar.height)];
    [tempView addSubview:tempLabel];
    self.navigationItem.titleView = tempView;
}
//一进来是无序的  点击a－z后 再排序
-(void)requestBrandNormal
{
    // 新街口 换为  Procduct；@"WXSC_Product"
    [HttpRequest productGetRequestPath:@"Product" methodName:@"BrandFilter" params:@{@"pageIndex": @1, @"pageSize": @1000} success:^(NSDictionary *dict) {

        if ([dict[@"results"] isKindOfClass:[NSArray class]]) {
             self.brandModelArray = [FilterBrandCategoryModel modelArrayForDataArray:dict[@"results"]];
        }
    }  failed:^(NSError *error) {
        NSLog(@"品牌列表请求错误-----%@", error);
    }];
}
- (void)requestBrandCategory{
#warning BrandOrderFilter接口是A-Z排序的接口，8.7版本记得修改
    //FIXME:BrandOrderFilter接口是A-Z排序的接口，8.7版本记得修改
//    新街口 换为  Procduct；@"WXSC_Product"
    [HttpRequest productGetRequestPath:@"Procduct" methodName:@"BrandOrderFilter" params:@{@"pageIndex": @1, @"pageSize": @1000} success:^(NSDictionary *dict) {
        
        NSMutableArray * Arr = [[NSMutableArray alloc]init];
        _letterSortData = [[NSMutableArray alloc]init];
        for (NSDictionary * tempDic in dict[@"results"]) {
            
            SSortBrandByLetterModel * model = [[SSortBrandByLetterModel alloc]initWithDic:tempDic];
            [_letterSortData addObject:model];
            
            NSMutableArray * temArr = [tempDic[@"brandInfo"] mutableCopy];
            [Arr addObjectsFromArray:temArr];
        }
//        self.brandModelArray = [FilterBrandCategoryModel modelArrayForDataArray:Arr];
        _tableViewBrandModelArray = [FilterBrandCategoryModel modelArrayForDataArray:Arr];
        [_sBrandShowListTable reloadData];

    } failed:^(NSError *error) {
        NSLog(@"品牌列表请求错误-----%@", error);
    }];
}

- (void)setBrandModelArray:(NSMutableArray *)brandModelArray{
    _brandModelArray = brandModelArray;
    
    [self.contentCollectionView reloadData];
}

#pragma mark action mothod

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}

-(void)onSwitchListStyle:(id)sender
{
    ifListStyle = !ifListStyle;
    if(ifListStyle)
    {
        if (!_sBrandShowListTable) {
            [self tableViewSet];
        }
        else [_sBrandShowListTable setHidden:NO];
        [self requestBrandCategory];
        self.navigationItem.rightBarButtonItem = right1;

    }
    else
    {
        [self.contentCollectionView setHidden:NO];
        [_sBrandShowListTable setHidden:YES];
        self.navigationItem.rightBarButtonItem = right2;
        [_brandModelArray removeAllObjects];
        [self requestBrandNormal];
        
  


    }
    
}

#pragma mark collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _brandModelArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SBrandShowListContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.brandModel = _brandModelArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH - 3)/ 4, (UI_SCREEN_WIDTH - 3)/ 4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterBrandCategoryModel *brandModel = _brandModelArray[indexPath.row];
    DailyNewViewController *dailyNewVC=[[DailyNewViewController alloc]init];
//    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",brandModel.aID];
    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",brandModel.brand_code];
    
    dailyNewVC.isCanSocial = NO;//不是社交
    [self.navigationController pushViewController:dailyNewVC animated:YES];
}

#pragma mark tableView delegate

//添加索引列

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    return _letterIndexArr;
}

////索引列点击事件
//
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    for (int i =0; i<_letterSortData.count; i++) {
        
        SSortBrandByLetterModel * temModel0 = _letterSortData[(i-1)>0?(i-1):0];
        NSString * temSortStr0 = [temModel0.sortString uppercaseString];
        
        SSortBrandByLetterModel * temModel1 = _letterSortData[i];
        NSString * temSortStr1 = [temModel1.sortString uppercaseString];
        
        char  char0 = [temSortStr0 characterAtIndex:0];
        char  char1 = [temSortStr1 characterAtIndex:0];
        char  charTitle = [title characterAtIndex:0];

        
        if(( char0<charTitle) && (charTitle<char1))
        {
            _selectSortIndex = i;
        }
        if (char1 == charTitle) {
            _selectSortIndex = i;
            break;
        }
        
        
    }
    return _selectSortIndex;
}



//.........................................................................................................................
//.........................................................................................................................
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    //标题背景
    UIView *letterTitleView = [[UIView alloc]init];
    letterTitleView.backgroundColor = [UIColor whiteColor];
    letterTitleView.frame=CGRectMake(0, 0, UI_SCREEN_WIDTH, 30);
    
    //标题文字
    UILabel * letterTitle = [[UILabel alloc]init];
    letterTitle.backgroundColor = [UIColor clearColor];
    letterTitle.textAlignment = NSTextAlignmentLeft;
    letterTitle.font = [UIFont systemFontOfSize:15];
    letterTitle.textColor = [UIColor blackColor];
    letterTitle.frame = CGRectMake(15, 7.5, 200, 15);
    
    SSortBrandByLetterModel * temModel = _letterSortData[section];
    letterTitle.text = [temModel.sortString uppercaseString];
    [letterTitleView addSubview:letterTitle];
    
    
    return letterTitleView;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"identifier";
    SSortBrandByLetterCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SSortBrandByLetterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    SSortBrandByLetterModel * temModel = _letterSortData[indexPath.section];
    SSortBrandByLetterSubModel * temSubModel = temModel.brandInfo_array[indexPath.row];
    [cell updateSSorderBrandByLetterModel:temSubModel];
    return cell;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _letterSortData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SSortBrandByLetterModel * temModel = _letterSortData[section];
    return temModel.brandInfo_array.count;


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSortBrandByLetterModel * temModel = _letterSortData[indexPath.section];
    SSortBrandByLetterSubModel * temSubModel = temModel.brandInfo_array[indexPath.row];
//    BrandDetailViewController *controller = [[BrandDetailViewController alloc]init];
//    controller.brandId = [temSubModel.id integerValue];
//    [self.navigationController pushViewController:controller animated:YES];
    
    DailyNewViewController *dailyNewVC=[[DailyNewViewController alloc]init];
    dailyNewVC.isCanSocial = NO;//不是社交
    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",temSubModel.brand_code];
    
    [self.navigationController pushViewController:dailyNewVC animated:YES];
}

@end
