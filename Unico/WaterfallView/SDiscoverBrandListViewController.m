//
//  SDiscoverBrandListViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoverBrandListViewController.h"
#import "SBrandSotryViewController.h"
#import "SDiscoverBrandNewCollectionViewCell.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "WeFaFaGet.h"
#import "SDiscoveryPicAndTextModel.h"
#import "WaterFLayout.h"
#import "SClothingCategoryViewController.h"

@interface SDiscoverBrandListViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    NSArray *collocationArray;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *listContentView;
@end
static NSString *cellIdentifier = @"SDiscoverBrandListCollectionViewCellIdentifier";
@implementation SDiscoverBrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    collocationArray = [NSArray new];
    
    [self setupNavbar];
    [self initSubViews];
    [self requestBrandCategory];
}
 -(void)initSubViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;

//    _listContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64) collectionViewLayout:layout];
    _listContentView.scrollEnabled = YES;
    _listContentView.showsHorizontalScrollIndicator = NO;
    _listContentView.backgroundColor = [UIColor whiteColor];
//    _listContentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _listContentView.delegate = self;
    _listContentView.dataSource = self;
    [_listContentView registerNib:[UINib nibWithNibName:@"SDiscoverBrandNewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
//    [self.view addSubview:_listContentView];
    
    
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
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    UILabel *tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:_titleStr fontStyle:FONT_SIZE(18) color:COLOR_WHITE rect:CGRectMake(0, 0, 0, self.navigationController.navigationBar.height) isFitWidth:YES isAlignLeft:YES];
    [tempView setSize:CGSizeMake(tempLabel.width, self.navigationController.navigationBar.height)];
    [tempView addSubview:tempLabel];
    self.navigationItem.titleView = tempView;
}
#pragma mark action mothod

-(void)onBack:(id)sender{
    [self popAnimated:YES];
}
- (void)requestBrandCategory{

    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    
     NSDictionary *params = @{
     @"m":@"Item",
     @"a":@"getItemClsListForMore",
     @"token":userToken,
     @"fid":[NSString stringWithFormat:@"%@",_brandId]
     };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *objectDic=(NSDictionary *)object;
            collocationArray = [SDiscoveryPicAndTextConfigModel modelArrayForDataArray:objectDic[@"data"]];
            [_listContentView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}
#pragma mark collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collocationArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoverBrandNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.brandModel = collocationArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH -2)/3, (UI_SCREEN_WIDTH -2) /3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SDiscoveryPicAndTextConfigModel *brandModel = collocationArray[indexPath.row];
    NSString *modelaID=[NSString stringWithFormat:@"%@",brandModel.temp_id];
    
    SClothingCategoryViewController *sclothingVC=[[SClothingCategoryViewController alloc]init];
    sclothingVC.clothingCategoryId =_brandId;
    sclothingVC.defaultId = modelaID;
    sclothingVC.defaultTitle = brandModel.name;
    [self.navigationController pushViewController:sclothingVC animated:YES];
    return;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


