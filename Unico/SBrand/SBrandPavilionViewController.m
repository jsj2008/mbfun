//
//  SBrandPavilionViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBrandPavilionViewController.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "Toast.h"
#import "MJRefresh.h"
#import "WeFaFaGet.h"
#import "BrandDetailViewController.h"
#import "DailyNewViewController.h"
#import "SBrandPavilionModel.h"

@interface SPavilionTabelViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *showTitleImgView;
@property (nonatomic, strong) UILabel *showTitleLabel;
@property (nonatomic, strong) UIView *backView;
-(void)updateCellWithData:(SBrandPavilionModel *)dataDicModel;

@end
@implementation SPavilionTabelViewCell

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
        _backView.alpha=0.4;
        [self.contentView addSubview:_backView];
        
        _showTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 125*UI_SCREEN_WIDTH/ 375.0)];
        [_showTitleLabel setTextAlignment:NSTextAlignmentCenter];
        _showTitleLabel.textColor=[Utils HexColor:0xffffff Alpha:1];
        _showTitleLabel.font=FONT_T4;
        _showTitleLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_showTitleLabel];
        
    }
    return self;
}
-(void)updateCellWithData:(SBrandPavilionModel *)dataDicModel
{
//     [_showTitleImgView sd_setImageWithURL:[dataDic objectForKey:@"head_img"] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW]];
   _showTitleLabel.text=[Utils getSNSString:dataDicModel.name];
    NSString *imgSt =[dataDicModel.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_showTitleImgView sd_setImageWithURL:[NSURL URLWithString:imgSt] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    
   
}
@end

@interface SBrandPavilionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *brandPaVilionTabelView;
    NSMutableArray *pavilionArray;
    NSInteger currentPage;
}
@end

@implementation SBrandPavilionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    [self initView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [Toast makeToastActivity:@""];
    [self requestPaVilionListIsPull:YES];
 
}
-(void)initView
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
    [bottomView setBackgroundColor:[Utils HexColor:0x3b3b3b Alpha:1]];
    UILabel *funLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 100)];
    funLabel.textColor=[Utils HexColor:0x666666 Alpha:1];
    funLabel.font=FONT_t6;
    funLabel.textAlignment=NSTextAlignmentCenter;
    funLabel.text=@"有范品牌馆";
    funLabel.backgroundColor=[UIColor clearColor];
    [bottomView addSubview:funLabel];
    
    pavilionArray = [[NSMutableArray alloc]init];
    brandPaVilionTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    brandPaVilionTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    brandPaVilionTabelView.delegate=self;
    brandPaVilionTabelView.dataSource=self;
    brandPaVilionTabelView.tableFooterView=bottomView;
    [self.view addSubview:brandPaVilionTabelView];
    __weak typeof(self) weakSelf = self;
    [brandPaVilionTabelView addFooterWithCallback:^{
        
        [weakSelf requestPaVilionListIsPull:NO];
        
    }];
    
    [brandPaVilionTabelView addHeaderWithCallback:^{

        [weakSelf requestPaVilionListIsPull:YES];
    }];
}
- (void)requestPaVilionListIsPull:(BOOL)isPull{
    if (isPull) {
        currentPage = 0;
    }else{
    }
    //m=item
//    a=getItemClsListForMore($fid, $token = null)
//    
//    fid : 模块中config下对应数据的id
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    /*
    NSDictionary *params = @{
                           @"m":@"Item",
                           @"a":@"getItemClsListForMore",
                           @"page":@(currentPage),
                           @"token":userToken,
                           @"fid":[NSString stringWithFormat:@"%@",_brandId]};

    */
//    m=Brand&a=getBrandListForMore&fid=
    NSDictionary *params = @{
                             @"m":@"BrandMb",
                             @"a":@"getBrandListForMore",
                             @"page":@(currentPage),
                             @"token":userToken,
                             @"fid":[NSString stringWithFormat:@"%@",_brandId]};
    
    __weak typeof(self) weakSelf = self;
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
 
        
        [weakSelf updateTableViewWithData:object[@"data"] isPull:isPull];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Toast makeToast:kNoneInternetTitle];
        [brandPaVilionTabelView footerEndRefreshing];
        [brandPaVilionTabelView headerEndRefreshing];
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
    self.title=_titleStr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125*UI_SCREEN_WIDTH/ 375;
}
//*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//     return [pavilionArray count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pavilionArray count];
//    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseCell = @"ReuseCell";
    SPavilionTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseCell];
    if (cell == nil) {
        cell = [[SPavilionTabelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseCell];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell updateCellWithData:pavilionArray[indexPath.row]];
    return cell;
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBrandPavilionModel *pavilionModel =pavilionArray[indexPath.row];
//    NSString *tempID=[NSString stringWithFormat:@"%@",pavilionModel.temp_id];
    NSString * tempID =[NSString stringWithFormat:@"%@",pavilionModel.brand_code];
//    NSString *tempID=[NSString stringWithFormat:@"%@",pavilionArray[indexPath.row][@"temp_id"]];
    
    DailyNewViewController * dailyNewVC=[[DailyNewViewController alloc]init];
    dailyNewVC.isCanSocial = NO;
    dailyNewVC.brandId =tempID;
    [self.navigationController pushViewController:dailyNewVC animated:YES];
    return;
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
