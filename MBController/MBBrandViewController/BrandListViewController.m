//
//  BrandListViewController.m
//  Wefafa
//
//  Created by CesarBlade on 15-4-1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "BrandListViewController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "HttpRequest.h"
#import "Toast.h"
#import "MJRefresh.h"
#import "MBBrandViewController.h"
#import "BrandListCollectionCell.h"

@interface BrandListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView    * _brandListCollection;
    NSMutableArray * _dataArray;
    UIView         * _headView;
    
    NSInteger currentPage;
    NSInteger pageSize;
    NSInteger totalCount;

}

@end
static NSString * cellIdentifier = @"identifier";
@implementation BrandListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configSubViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)configSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    CGFloat yPoint = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        yPoint = 64;
    }
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, yPoint)];
    _headView.backgroundColor = TITLE_BG;
    [self.view addSubview:_headView];

    
    CGRect headRect = CGRectMake(0, 0, _headView.bounds.size.width, _headView.bounds.size.height);
    NavigationTitleView * navView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [navView createTitleView:headRect delegate:self selectorBack:@selector(returnBackClicked:) selectorOk:nil selectorMenu:nil];
    navView.lbTitle.text = @"品牌";
    navView.backgroundColor = [Utils HexColor:0x262626 Alpha:1.0];
    [_headView addSubview:navView];

    [self setupCollectionView:yPoint];
//    [self networkRequestIsPull:YES];
    
    
    [self addHeader];
    [self addFooter];
    
    
    currentPage = 1;
    pageSize = 10;
    __weak BrandListViewController *weakSelf = self;
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [weakSelf networkRequestIsPull:YES];
    });
}
-(void)setupCollectionView:(CGFloat)oringinY
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 0.5;
    CGFloat matchWidth = (UI_SCREEN_WIDTH - 3)/ 4;
    layout.itemSize = CGSizeMake(matchWidth,matchWidth);
    _brandListCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, oringinY, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-oringinY) collectionViewLayout:layout];
    _brandListCollection.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1.0];
    _brandListCollection.delegate = self;
    _brandListCollection.dataSource =self;
    [self.view addSubview:_brandListCollection];

    [_brandListCollection registerClass:[BrandListCollectionCell class] forCellWithReuseIdentifier:cellIdentifier];
}
#pragma mark 网络请求方法
- (void)networkRequestIsPull:(BOOL)isPull
{
    
    if (isPull) {
        currentPage = 1;
        [_dataArray removeAllObjects];

            }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:[NSNumber numberWithInteger:currentPage] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    //新的 
    [HttpRequest productPostRequestPath:@"Product" methodName:@"BrandFilter" params:dict success:^(NSDictionary *dict) {
        NSLog(@"success");
        NSString *message = nil;
        
        totalCount = [[dict objectForKey:@"total"] integerValue];
        NSArray *result = [dict objectForKey:@"results"];
        for(NSDictionary *dict in result){
            
            BrandListCellModel *model = [[BrandListCellModel alloc] initWithBrandListCellDic:dict];
            [_dataArray addObject:model];
        }
        if (result.count <= 0) {
            message = @"没有更多信息";
        }else{
            currentPage ++;
        }
        
        [self updateViewWithRequestSuccess:YES message:message];
        

    } failed:^(NSError *error) {
        
        NSLog(@"failed");
        [self updateViewWithRequestSuccess:NO message:@""];
        
        
    }];
    
    /* 老得
    //注意把接口改下
    [HttpRequest productGetRequestPath:nil methodName:@"BrandFilter" params:dict success:^(NSDictionary *dict) {
                
        NSLog(@"success");
        NSString *message = nil;
        
        totalCount = [[dict objectForKey:@"total"] integerValue];
        NSArray *result = [dict objectForKey:@"results"];
        for(NSDictionary *dict in result){
            
            BrandListCellModel *model = [[BrandListCellModel alloc] initWithBrandListCellDic:dict];
            [_dataArray addObject:model];
        }
        if (result.count <= 0) {
            message = @"没有更多信息";
        }else{
            currentPage ++;
        }
        
        [self updateViewWithRequestSuccess:YES message:message];

        
    } failed:^(NSError *error) {
        
        
        NSLog(@"failed");
        [self updateViewWithRequestSuccess:NO message:@""];
        
    }];
     */
    
}
     
- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message
{
    if (isSuccess) {
        [_brandListCollection reloadData];
    }
    [_brandListCollection footerEndRefreshing];
    [_brandListCollection headerEndRefreshing];
    [Toast hideToastActivity];

    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
        return;
    }
    [Toast makeToast:message];

    
}
- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    currentPage = 1;
    [_brandListCollection addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [weakSelf networkRequestIsPull:YES];
        });
    }];
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [_brandListCollection addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        
        if ([weakSelf isNoMoreData]) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [weakSelf updateViewWithRequestSuccess:YES message:@"没有更多信息"];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf networkRequestIsPull:NO];
            });
        }
    }];
}

- (BOOL)isNoMoreData
{
    if (totalCount == 0) {
        return NO;
    }
    if (totalCount > _dataArray.count) {
        return NO;
    }
    return YES;
}

- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}

#pragma mark UICOLLECTIONVIEW DATASOURCE & DELEGATE METHODS

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];

}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    BrandListCellModel * model = (BrandListCellModel*)_dataArray[indexPath.row];
    [cell updateBrandListCellModel:model];
    return cell;


}

// 增加Cell点击处理和逻辑串联
// 应该到新的品牌页面。
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    BrandListCellModel *model=_dataArray[indexPath.row];
    
        if (_completeFunc) {
//            _completeFunc([NSString stringWithFormat:@"%ld",(long)model.brandID],model.brand);
            return;
        }
    
    // TODO: 传入品牌信息，并且完成品牌页面。
//    BrandStoryViewController *vc = [BrandStoryViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
    //    MBBrandViewController *mbBrandVC=[[MBBrandViewController alloc]initWithNibName:@"MBBrandViewController" bundle:nil];
    //    mbBrandVC.brandName= [NSString stringWithFormat:@"%@",model.brand];
    //    mbBrandVC.brandId= [NSString stringWithFormat:@"%ld",(long)model.brandID];
    //
    //    [self.navigationController pushViewController:mbBrandVC animated:YES];
}


//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * cellIdentifier = @"identifier";
//    BrandListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"BrandListTableCell" owner:self options:nil] objectAtIndex:0];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (_dataArray.count > indexPath.row)
//    {
//        [cell updateCellInfo:[_dataArray objectAtIndex:indexPath.row]];
//    }
//    
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BrandListCellModel *model=_dataArray[indexPath.row];
//    
//    if (_completeFunc) {
////        [self.navigationController popViewControllerAnimated:NO];
//        _completeFunc([NSString stringWithFormat:@"%ld",(long)model.brandID],model.brand);
//        
//        return;
//    }
//    
//    MBBrandViewController *mbBrandVC=[[MBBrandViewController alloc]initWithNibName:@"MBBrandViewController" bundle:nil];
//    mbBrandVC.brandName= [NSString stringWithFormat:@"%@",model.brand];
//    mbBrandVC.brandId= [NSString stringWithFormat:@"%ld",(long)model.brandID];
//    
//    [self.navigationController pushViewController:mbBrandVC animated:YES];
//}

#pragma mark 点击返回按钮
-(void)returnBackClicked:(id)sender
{
    // 用父类方法。
    [super LeftReturn:sender];
//    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
