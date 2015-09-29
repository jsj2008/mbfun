//
//  TemplateClassificationVC.m
//  Wefafa
//
//  Created by Miaoz on 15/4/1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//
#define PAGESIZE 21
#define kNavHeight 64
#define kDeviceWidth self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.height
#define kTabBarHeight 60

#import "TemplateClassificationVC.h"
#import "TemplateRecommendVC.h"
#import "TemplateClassificationCell.h"
#import "Globle.h"
#import "ModuleCategoryInfo.h"
@interface TemplateClassificationVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(strong ,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic) NSMutableArray *dataarray;
@end

@implementation TemplateClassificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_dataarray == nil) {
        _dataarray = [NSMutableArray new];
    }
      [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];

    [self SetLeftButton:@"关闭" Image:nil];

    [self setRightButton:@"自由搭" action:@selector(addFreeTemplateClick:)];
    [self initCollectionView];
    [self addHeader];
    [self addFooter];
//    [self requestGetCollocationModuleCategoryUserFilterWithDic:(NSMutableDictionary *)@{@"UserId":sns.ldap_uid}];
}
- (void)addHeader
{
    __weak typeof(self) vc = self;
    //    [_collectionView  removeHeader];
    // 添加下拉刷新头部控件
    [_collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.dataarray != nil ||vc.dataarray.count >0 ) {
            [vc.dataarray removeAllObjects];
        }
        
        [vc requestGetCollocationModuleCategoryUserFilterWithpageindex:@"1"];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            
            [vc.collectionView headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
    [_collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) vc = self;
    //     [_collectionView  removeFooter];
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.dataarray.count%PAGESIZE != 0 ) {//说明数据更新完
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
            return ;
        }
        int pageindex =  (int)vc.dataarray.count/PAGESIZE + 1;
        [vc requestGetCollocationModuleCategoryUserFilterWithpageindex:[NSString stringWithFormat:@"%d",pageindex]];
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        });
    }];
}

-(void)requestGetCollocationModuleCategoryUserFilterWithpageindex:(NSString *)pageindex{
    
    [[HttpRequest shareRequst] httpRequestGetCollocationModuleCategoryUserFilterWithDic:(NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:pageindex.intValue],
                                                                                          @"pageSize":[NSNumber numberWithInt:PAGESIZE],@"UserId":sns.ldap_uid} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {

            id data = [obj objectForKey:@"results"];
        //        _totalStr = [obj objectForKey:@"total"];
            if ([data isKindOfClass:[NSArray class]])
            {
                if (data != nil)
                {
                    
                    for (NSDictionary *dic in data)
                    {
                         ModuleCategoryInfo *moduleCategoryInfo =[JsonToModel objectFromDictionary:dic className:@"ModuleCategoryInfo"];
                        [_dataarray addObject:moduleCategoryInfo];
                    }
                }
            }
//            [_collectionView reloadData];
        }
    } fail:^(NSString *errorMsg) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addFreeTemplateClick:(id)sender{
    
    [self performSegueWithIdentifier:@"PolyvoreViewController" sender:nil];
    
}

//初始化是这样初始化的。
-(void) initCollectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(160, 160);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, kDeviceHeight -kNavHeight) collectionViewLayout:flowLayout];
        self.collectionView.alwaysBounceVertical = YES;//展示footrefresh
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.tag = 777;
        //注册
        [self.collectionView registerClass:[TemplateClassificationCell class] forCellWithReuseIdentifier:@"TemplateClassificationCell"];
        
        //设置代理
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.view addSubview:self.collectionView];
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
/*
 //定义每个UICollectionView 的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 return CGSizeMake(100, 120);
 }
 
 //定义每个UICollectionView 的 margin
 -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
 {
 return UIEdgeInsetsMake(5, 5, 5, 5);
 }
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _dataarray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TemplateClassificationCell *cell = (TemplateClassificationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TemplateClassificationCell" forIndexPath:indexPath];
    
  
    
    if (_dataarray == nil || _dataarray.count == 0) {
        cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    }else{
      
        ModuleCategoryInfo *moduleCategoryInfo = _dataarray[indexPath.row];//
        if (indexPath.row == 0) {
            moduleCategoryInfo.isLocked = @"0";
        }
        cell.moduleCategoryInfo = moduleCategoryInfo;
        
        
        
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
        [self performSegueWithIdentifier:@"TemplateRecommendVC" sender:_dataarray[indexPath.row]];
   
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"TemplateRecommendVC"]){
        
        TemplateRecommendVC *templateRecommendVC = segue.destinationViewController;
        templateRecommendVC.moduleCategoryInfo = (ModuleCategoryInfo *)sender;
    }
    
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
