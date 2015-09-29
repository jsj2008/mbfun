//
//  SNewBrandPavilionViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/8/19.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SNewBrandPavilionViewController.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "Toast.h"
#import "MJRefresh.h"
#import "WeFaFaGet.h"
#import "BrandDetailViewController.h"
#import "DailyNewViewController.h"
#import "SDiscoveryBrandCollectionView.h"
#import "SNewPavilionCellView.h"
#import "SBrandPavilionModel.h"
#import "HttpRequest.h"
#import "SSortBrandByLetterModel.h"
#import "SBrandShowListContentCell.h"
#import "FilterBrandCategoryModel.h"
#import "MBCustomClassifyModelView.h"
#import "AttendCustomButton.h"

@protocol SNewPavilionTabelViewCellDelegate <NSObject>
- (void)SNewPavilionTabelViewCellArrowBtnClickShow:(BOOL)isShow;

@end
@interface SNewPavilionTabelViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *showTitleImgView;
@property (nonatomic, strong) UILabel *showTitleLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) SNewPavilionCellView *sPavilionCellView;
@property (nonatomic,weak) UIViewController *target;
@property (nonatomic,strong)UIButton *arrowBtn;
@property (nonatomic, assign)id<SNewPavilionTabelViewCellDelegate>delegate;
@property  (nonatomic,strong)SBrandPavilionModel *sPavilionModle;
//-(void)updateCellWithData:(SBrandPavilionModel *)dataDicModel;

@end
@implementation SNewPavilionTabelViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showTitleImgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 125*UI_SCREEN_WIDTH/ 375.0)];
        [_showTitleImgView setContentMode:UIViewContentModeScaleAspectFit];
        [_showTitleImgView setImage:[UIImage imageNamed:DEFAULT_LOADING_BIGLOADING]];
        [self.contentView addSubview:_showTitleImgView];
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 125*UI_SCREEN_WIDTH/ 375.0)];
        [_backView setBackgroundColor:[UIColor blackColor]];
        UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgView)];
        [_backView addGestureRecognizer:tapView];
        
        _backView.alpha=0.4;
        [self.contentView addSubview:_backView];
        
        _showTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 125*UI_SCREEN_WIDTH/ 375.0)];
        [_showTitleLabel setTextAlignment:NSTextAlignmentCenter];
        _showTitleLabel.textColor=[Utils HexColor:0xffffff Alpha:1];
        _showTitleLabel.font=FONT_T4;
        _showTitleLabel.backgroundColor=[UIColor clearColor];
//        [self.contentView addSubview:_showTitleLabel];

         _arrowBtn=[UIButton buttonWithType:UIButtonTypeCustom];// arrow_top@2x
        [_arrowBtn setImage:[UIImage imageNamed:@"Unico/brand_arrow_bottom"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"Unico/brand_arrow_top"] forState:UIControlStateSelected];
        [_arrowBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_arrowBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-100, _showTitleLabel.frame.size.height/2-50, 100, 100)];
        [self.contentView addSubview:_arrowBtn];
        
        _sPavilionCellView =[[SNewPavilionCellView alloc]initWithFrame:CGRectMake(10, _showTitleImgView.frame.size.height+5, UI_SCREEN_WIDTH-20,  (125+1000000) * UI_SCREEN_WIDTH/ 375.0) ];
        _sPavilionCellView.hidden=YES;
        _sPavilionCellView.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:_sPavilionCellView];
        [self.contentView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
        
        
    }
    return self;
}
-(void)tapImgView
{
    [self btnClick:nil];
    
}

-(void)btnClick:(UIButton *)sender
{
    _arrowBtn.selected=!_arrowBtn.selected;
// 点击更改cell 高度 model 也得改
    _sPavilionModle.isCanShow =_arrowBtn.selected;

    if (_delegate && [_delegate respondsToSelector:@selector(SNewPavilionTabelViewCellArrowBtnClickShow:)]) {
        [_delegate SNewPavilionTabelViewCellArrowBtnClickShow:sender.selected];
    }
}

-(void)setTarget:(UIViewController *)target
{
    _target=target;
    _sPavilionCellView.target=_target;
}

-(void)setSPavilionModle:(SBrandPavilionModel *)sPavilionModle
{
    _sPavilionModle =sPavilionModle;
    if (_sPavilionModle.isCanShow) {
        _sPavilionCellView.hidden=NO;
        _arrowBtn.selected=YES;
        
        //4S严重延迟
        _sPavilionCellView.contentModel=_sPavilionModle;
    }
    else
    {
        _sPavilionCellView.hidden=YES;
        _arrowBtn.selected=NO;
    }
    
    _showTitleLabel.text=[Utils getSNSString:_sPavilionModle.name];
    NSString *imgSt =[_sPavilionModle.brand_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_showTitleImgView sd_setImageWithURL:[NSURL URLWithString:imgSt] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    
   
//    NSString*type = [NSString stringWithFormat:@"%@",_sPavilionModle.type];
//    if([type isEqualToString:@"1"])//风格馆
//    {
////        _sPavilionCellView.contentArray = _sPavilionModle.fixed_list;
//       
//    }else//其它的
//    {
////       _sPavilionCellView.contentArray = _sPavilionModle.brand_list;
//        _sPavilionCellView.contentModel=_sPavilionModle;
//    }
    
}
@end


@interface SNewBrandPavilionViewController ()<UITableViewDataSource,UITableViewDelegate,SNewPavilionTabelViewCellDelegate,MBCustomClassifyModelViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UITableView *brandPaVilionTabelView;
    NSMutableArray *pavilionArray;
    NSInteger currentPage;
    MBCustomClassifyModelView *customClassifyModelV;
    UICollectionView *contentCollectionView;
    NSArray *letterArray;//字符表数组
    NSMutableArray *choostTagModelArray;//选择字幕后分组的model
    UIView *bottomView;
    
    
}
@property (nonatomic,strong)NSArray *brandModelArray;
@property (nonatomic,strong) NSArray *chooseBrandModelArray;


@end
static NSString *cellIdentifier = @"SBrandShowListContentCellIdentifier";
@implementation SNewBrandPavilionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    [self initView];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [Toast makeToastActivity:@""];
    [self requestPaVilionListIsPull:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestBrandCategory{

    [HttpRequest productGetRequestPath:@"Procduct" methodName:@"BrandOrderFilter" params:@{@"pageIndex": @1, @"pageSize": @1000} success:^(NSDictionary *dict) {
        
        NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
        if([isSuccess boolValue] ==1)
        {
            self.brandModelArray = [SSortBrandByLetterModel modelArrayForDataArray:dict[@"results"]];
            [self checkOrderSeriationFilterWithTag:0];
            [contentCollectionView reloadData];
            
        }
        else
        {
             NSLog(@"品牌列表请求错误-");
        }
        
    } failed:^(NSError *error) {
        NSLog(@"品牌列表请求错误-----%@", error);
    }];
}
//品牌 分组 排序
-(void)checkOrderSeriationFilterWithTag:(int)tapTag
{
    [choostTagModelArray removeAllObjects];
    
    //最外层的
    for (SSortBrandByLetterModel *model in self.brandModelArray) {
        NSString *sortString = [NSString stringWithFormat:@"%@",model.sortString];
        if ([letterArray[tapTag] containsObject:sortString]) {//sortstring判断 是哪个字母
     
            for ( FilterBrandCategoryModel *categoryModel in model.brandInfo_array) {
                
                [choostTagModelArray addObject:categoryModel];
            }
     
        }
    }
    self.chooseBrandModelArray = choostTagModelArray;
    
}
-(void)setChooseBrandModelArray:(NSArray *)chooseBrandModelArray
{
    _chooseBrandModelArray=chooseBrandModelArray;
    NSInteger a=[_chooseBrandModelArray count];
    int k = 0;
    int m = 0;
    k= a%3;//取余数
    m=(int )a/3;
    if (k!=0) {
        m=m+1;
    }
    
    [bottomView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, (60*m) * UI_SCREEN_WIDTH/ 375.0+ customClassifyModelV.frame.size.height+customClassifyModelV.frame.origin.y)];
    
    contentCollectionView.frame = CGRectMake(0,  customClassifyModelV.frame.size.height+customClassifyModelV.frame.origin.y, UI_SCREEN_WIDTH, (60*m) * UI_SCREEN_WIDTH/ 375.0);
 
    [contentCollectionView reloadData];
    brandPaVilionTabelView.tableFooterView=bottomView;
    [brandPaVilionTabelView reloadData];
    
}
-(void)initbottomView
{
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 500)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *funLabel=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-45, 30,90, 20)];
    funLabel.textColor=[Utils HexColor:0x000000 Alpha:1];
    funLabel.font=FONT_t1;
    funLabel.textAlignment=NSTextAlignmentCenter;
    funLabel.text=@"所有品牌";
    funLabel.backgroundColor=[UIColor clearColor];
    [bottomView addSubview:funLabel];
    UIImageView *leftImgView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 40, UI_SCREEN_WIDTH/2-45-26-25, 1)];
    [leftImgView setBackgroundColor:[Utils HexColor:0x000000 Alpha:1]];
    [bottomView addSubview:leftImgView];
    UIImageView *rightImgView=[[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2+45+26, 40,UI_SCREEN_WIDTH/2-45-26-25 , 1)];
    [rightImgView setBackgroundColor:[Utils HexColor:0x000000 Alpha:1]];
    [bottomView addSubview:rightImgView];
    
    
    NSArray *titleArray=@[@"A-E",@"F-J",@"K-O",@"P-T",@"U-Z"];
    letterArray =@[@[@"A",@"B",@"C",@"D",@"E"],@[@"F",@"G",@"H",@"I",@"J"],@[@"K",@"L",@"M",@"N",@"0"],@[@"P",@"Q",@"R",@"S",@"T"],@[@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    choostTagModelArray=[[NSMutableArray alloc]init];
    
    customClassifyModelV=[[MBCustomClassifyModelView alloc]initWithFrame:CGRectMake(0,funLabel.frame.origin.y+funLabel.frame.size.height+10, UI_SCREEN_WIDTH, 44) WithTitleArray:titleArray useScroll:NO WithPicAndText:NO WithPicArray:nil WithSelectPicArray:nil WithShowRightBtnLine:YES WithShowBottomBtnLine:NO];
    customClassifyModelV.backgroundColor=[UIColor blackColor];
    customClassifyModelV.delegate=self;
    [customClassifyModelV setFont: FONT_t3];
    [customClassifyModelV setTextColor:COLOR_C9];
    [customClassifyModelV setSelectedTextColor:COLOR_C3];
    [bottomView addSubview:customClassifyModelV];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, customClassifyModelV.frame.size.height+customClassifyModelV.frame.origin.y,UI_SCREEN_WIDTH, 150 * UI_SCREEN_WIDTH/ 375.0) collectionViewLayout:layout];
    contentCollectionView.scrollEnabled = NO;
    contentCollectionView.showsHorizontalScrollIndicator = NO;
    contentCollectionView.backgroundColor =[UIColor whiteColor];
    contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    contentCollectionView.delegate = self;
    contentCollectionView.dataSource = self;
    [contentCollectionView registerNib:[UINib nibWithNibName:@"SBrandShowListContentCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [bottomView addSubview:contentCollectionView];
    
    

}
-(void)initView
{
    [self initbottomView];
    
    pavilionArray = [[NSMutableArray alloc]init];
    brandPaVilionTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    brandPaVilionTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    brandPaVilionTabelView.delegate=self;
    brandPaVilionTabelView.dataSource=self;
    brandPaVilionTabelView.tableFooterView=[UIView new];
    [self.view addSubview:brandPaVilionTabelView];
    __weak typeof(self) weakSelf = self;
//    [brandPaVilionTabelView addFooterWithCallback:^{

        //暂无分页
//        [weakSelf requestPaVilionListIsPull:NO];
        
//    }];
    
    [brandPaVilionTabelView addHeaderWithCallback:^{
        
        [weakSelf requestPaVilionListIsPull:YES];
    }];
}
- (void)requestPaVilionListIsPull:(BOOL)isPull{
    if (isPull) {
        currentPage = 0;
    }else{
        currentPage = (pavilionArray.count + 9)/ 10;
    }

    NSDictionary *params = @{
                             @"m":@"BrandMb",
                             @"a":@"getBrandCateList"
                             };
    
    __weak typeof(self) weakSelf = self;
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        
        [weakSelf updateTableViewWithData:object[@"data"] isPull:isPull];
        [self requestBrandCategory];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle];
        [brandPaVilionTabelView footerEndRefreshing];
        [brandPaVilionTabelView headerEndRefreshing];
        [self requestBrandCategory];
        
    }];
}
- (void)updateTableViewWithData:(id)object isPull:(BOOL)isPull
{
    if (isPull) {
        [pavilionArray removeAllObjects];
    }
    [Toast hideToastActivity];
    [brandPaVilionTabelView footerEndRefreshing];
    [brandPaVilionTabelView headerEndRefreshing];
    NSArray *array =nil;
    if ([object isKindOfClass:[NSArray class]]) {
        array = (NSArray *)object;
        array = [SBrandPavilionModel modelArrayForDataArray:array];
    }
    else
    {
        return;
    }
    if (array.count > 0) {
        currentPage ++;
    }
    [pavilionArray addObjectsFromArray:array];
    [brandPaVilionTabelView reloadData];
}
- (void)setupNavbar {
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backHome:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"品牌馆";
}

-(void)SNewPavilionTabelViewCellArrowBtnClickShow:(BOOL)isShow
{
    [brandPaVilionTabelView reloadData];
    
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)TabItemClick:(id)sender button:(id)param
{
    NSInteger page=0;
    AttendCustomButton*  otherBtn = (AttendCustomButton *)param;
    page=otherBtn.tag;
    NSLog(@" PAGE---%ld",(long)page);
    [self checkOrderSeriationFilterWithTag:(int)page];
    
    [contentCollectionView reloadData];
}
- (void)setBrandModelArray:(NSMutableArray *)brandModelArray{
    _brandModelArray = brandModelArray;
}

#pragma mark - DataSource and Delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [pavilionArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseCell = @"ReuseCell";
    SNewPavilionTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseCell];
    if (cell == nil) {
        cell = [[SNewPavilionTabelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseCell];
    }
    cell.delegate=self;
    cell.sPavilionModle =pavilionArray[indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setTarget:self];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBrandPavilionModel *model =pavilionArray[indexPath.row];
    //判断上一层点击哪个 直接展开
     if([model.idStr isEqualToString:[NSString stringWithFormat:@"%@",_brandType]]&&[Utils getSNSString:[NSString stringWithFormat:@"%@",model.idStr] ].length!=0)
     {
         model.isCanShow=YES;
         _brandType = @"";
         [tableView setContentOffset:CGPointMake(0, (125*UI_SCREEN_WIDTH/ 375)*indexPath.row) animated:YES];
     }
    
    if(model.isCanShow)
    {
        NSString*type = [NSString stringWithFormat:@"%@",model.type];
        if([type isEqualToString:@"1"])//风格馆
        {
            return 125*UI_SCREEN_WIDTH/ 375+ ( 172+10)*((UI_SCREEN_WIDTH-20)/UI_SCREEN_WIDTH) * UI_SCREEN_WIDTH/ 375.0 *[model.fixed_list count];//125+10
        }else//其它的
        {
            NSInteger a=[model.brand_list count];
            
            int k = 0;
            int m = 0;
            k= a%3;//取余数
            m=(int )a/3;
            if (k!=0) {
                m=m+1;
            }
            int bannerHeight=0;
            
            if ([model.banner count]>0) {
                bannerHeight=140*UI_SCREEN_WIDTH/ 375;
            }
         return 130*UI_SCREEN_WIDTH/ 375+ (bannerHeight+10+ 70*((UI_SCREEN_WIDTH-20)/UI_SCREEN_WIDTH)*m) * UI_SCREEN_WIDTH/ 375.0;
        }
//     125*UI_SCREEN_WIDTH/ 375+ ( 150+15) * UI_SCREEN_WIDTH/ 375.0;//125+10
    }
    else
    {
         return 125*UI_SCREEN_WIDTH/ 375;
    }
   
}
//*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return;
    SBrandPavilionModel *pavilionModel =pavilionArray[indexPath.row];
//    NSString *tempID=[NSString stringWithFormat:@"%@",pavilionModel.temp_id];
    NSString *tempID=[NSString stringWithFormat:@"%@",pavilionModel.idStr];
    DailyNewViewController * dailyNewVC=[[DailyNewViewController alloc]init];
    dailyNewVC.isCanSocial = NO;
    dailyNewVC.brandId =tempID;
    [self.navigationController pushViewController:dailyNewVC animated:YES];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _chooseBrandModelArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SBrandShowListContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.brandModel = _chooseBrandModelArray[indexPath.row];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterBrandCategoryModel *brandModel = _chooseBrandModelArray[indexPath.row];
    DailyNewViewController *dailyNewVC=[[DailyNewViewController alloc]init];
    //    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",brandModel.aID];
    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",brandModel.brand_code];
    
    dailyNewVC.isCanSocial = NO;//不是社交
    [self.navigationController pushViewController:dailyNewVC animated:YES];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH)/ 3.0, 60*(UI_SCREEN_WIDTH/375.0));
}

@end
