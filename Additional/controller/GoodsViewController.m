//
//  GoodsViewController.m
//  newdesigner
//
//  Created by Miaoz on 14-9-28.
//  Copyright (c) 2014年 mb. All rights reserved.
//
//废弃 不用 
#import "GoodsViewController.h"
#import "GoodsCollectionCell.h"
#import "FilterViewController.h"
#import "GoodObj.h"
#import "Globle.h"
#import "GoodCategoryObj.h"
#import "CustomScrollView.h"
#import "PolyvoreViewController.h"
#import "TemplateCollocationMatchVC.h"
#import "GoodsDetailVC.h"
//与FilterViewController相同focusMemoryFilter
#define focusMemoryFilterDic @"focusMemoryFilter"
#define kNavHeight 0
#define kDeviceWidth self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.height
#define kTabBarHeight 60
#define pagenumber 21
@interface GoodsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GoodsCollectionCellDelegate>
@property(nonatomic,strong)NSMutableArray *dataarray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *centerLable;
@property(nonatomic,strong)CustomScrollView *scrollView;

@property(nonatomic,strong)NSString *judgeMark;
@property(nonatomic,strong)NSString *totalStr;
@end

@implementation GoodsViewController

//static NSString * const reuseIdentifier = @"cell";
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.collectionView.backgroundColor = [UIColor clearColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataarray = [NSMutableArray new];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title =_goodCategoryObj.name;
    [self creatCenterLable];
    [self initCollectionView];
    [self createTopshowView];
    // 2.集成刷新控件
//    [self addHeader];
    [self addFooter];
    // Register cell classes
   
//     [self.collectionView registerClass:[GoodsCollectionCell class] forCellWithReuseIdentifier:@"GoodsCollectionCell"];
    // Do any additional setup after loading the view.
}
#pragma mark --筛选返回展示筛选项
-(void)createTopshowView{
    
    if (_scrollView == nil) {
        _scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 25)];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#E52027"];
        _scrollView.alpha = 0.7;
        _scrollView.hidden = YES;
        [_scrollView customScrollViewBlockWithscrollView:^(id sender) {
            //删除筛选的数据重新请求
            _scrollView.hidden = YES;
            _judgeMark = @"NOFilter";
            
            if (_dataarray.count != 0) {
                [_dataarray removeAllObjects];
            }
            NSDictionary *dic;
            //12.24 add by miao 商品详情搜索相关
            if (_goodSecondCategoryid == nil) {
                dic = @{@"Desc":_descContent,
                        @"pageIndex":[NSNumber numberWithInt:1],
                        @"pageSize":[NSNumber numberWithInt:pagenumber]};
            }else{
                dic = @{@"CategoryId":[NSNumber numberWithInt:_goodSecondCategoryid.intValue],
                        @"pageIndex":[NSNumber numberWithInt:1],
                        @"pageSize":[NSNumber numberWithInt:pagenumber]};
            }
            
            [self requestRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)dic];
//      废弃      [self requestProductCategoryClsFilterbydic:(NSMutableDictionary *)dic];

            
        }];
        [self.view addSubview:_scrollView];
    }
}
#pragma mark --没有获得数据时提示
-(void)creatCenterLable{
    if (_centerLable == nil) {
        UILabel *lab;
        lab = [UILabel new];
        lab.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        CGFloat centerY = self.view.bounds.size.height - 100;
        lab.center = CGPointMake(self.view.bounds.size.width/2, centerY/2);
//        lab.center = self.view.center;
        lab.text = @"没有商品";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont boldSystemFontOfSize:30.0f];
        _centerLable = lab;
        lab.hidden = YES;
        [self.view addSubview:lab];
    }
    
}

static int pageindex = 1;

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
//    [_collectionView  removeFooter];
    // 添加上拉刷新尾部控件
    
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        NSLog(@"vc.dataarray.count-------%d",(int)vc.dataarray.count);
//        if (vc.dataarray.count%pagenumber != 0 ) {//说明数据更新完
//             [vc.collectionView footerEndRefreshing];
//            return ;
//        }
//        int pageindex =  vc.dataarray.count/pagenumber + 1;
        if (vc.dataarray.count<vc.totalStr.intValue) {
            pageindex =  pageindex+1;
        }else{
        
            //1.5 add by miao 解决上拉数据bug
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (vc.totalStr.integerValue == vc.dataarray.count) {
//                    vc.collectionView.footerHidden = YES;
//                }
                [vc.collectionView footerEndRefreshing];
            });
            return ;
        
        }
        

        if ([vc.judgeMark isEqualToString:@"NOFilter"]) {
            
            NSDictionary *dic = @{@"CategoryId":[NSNumber numberWithInt:vc.goodSecondCategoryid.intValue],
                                  @"pageIndex":[NSNumber numberWithInt:pageindex],
                                  @"pageSize":[NSNumber numberWithInt:pagenumber]};
//    废弃        [vc requestProductCategoryClsFilterbydic:(NSMutableDictionary *)dic];
            [vc requestRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)dic];

        }else{//[vc.judgeMark isEqualToString:@"Filter"]
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:vc.getDic];
            [dic setObject:[NSNumber numberWithInt:pageindex] forKey:@"pageIndex"];
            [dic setObject:[NSNumber numberWithInt:pagenumber] forKey:@"pageSize"];
            [vc requestRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)dic];
        
        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        });
    }];
    
}



-(void)setGoodSecondCategoryid:(NSString *)goodSecondCategoryid{
    _goodSecondCategoryid = goodSecondCategoryid;
    
      _judgeMark = @"NOFilter";
    if (_dataarray != nil&&_dataarray.count != 0) {
        [_dataarray removeAllObjects];
    }
    NSDictionary *dic = @{@"CategoryId":[NSNumber numberWithInt:_goodSecondCategoryid.intValue],
                          @"pageIndex":[NSNumber numberWithInt:1],
                          @"pageSize":[NSNumber numberWithInt:pagenumber]};
    [self requestRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)dic];
//    [self requestProductCategoryClsFilterbydic:(NSMutableDictionary *)dic];

}
-(void)setGoodCategoryObj:(GoodCategoryObj *)goodCategoryObj{
    _goodCategoryObj = goodCategoryObj;

}
-(void)setDescContent:(NSString *)descContent{
    _descContent = descContent;

}
-(void)setGetDic:(NSMutableDictionary *)getDic{
    _getDic = getDic;
    
    
     _judgeMark = @"Filter";
    
    //add by miao 12.02 解决Crash bug
    if([[_getDic objectForKey:showFilterStr] length] > 0){
        //展示顶部筛选项
        _scrollView.hidden = NO;
        _scrollView.label.text = [_getDic objectForKey:showFilterStr];
        [_getDic removeObjectForKey:showFilterStr];
    } else {
        _scrollView.hidden = YES;
    }
   
    if (_dataarray != nil&&_dataarray.count != 0) {
        [_dataarray removeAllObjects];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_getDic];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    [dic setObject:[NSNumber numberWithInt:pagenumber] forKey:@"pageSize"];
    [self requestRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)dic];
}
//初始化是这样初始化的。
-(void) initCollectionView{
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(107, 106);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavHeight, kDeviceWidth, kDeviceHeight-60) collectionViewLayout:flowLayout];
        self.collectionView.alwaysBounceVertical = YES;//展示footrefresh
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.tag = 111;
        //注册
        [self.collectionView registerClass:[GoodsCollectionCell class] forCellWithReuseIdentifier:@"GoodsCollectionCell"];
        
        //设置代理
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
        [self.view addSubview:self.collectionView];
        
        
    }
}


#pragma mark- 根据分类id请求商品  废弃
-(void)requestProductCategoryClsFilterbydic:(NSMutableDictionary*)dic{
    [[HttpRequest shareRequst] httpRequestGetProductCategoryClsFilterWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1) {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]]) {
                if (data != nil) {
                    NSDictionary *dic = data[0];
                    //            for (NSDictionary *dic in data) {
                    NSArray *productClsLst = [dic objectForKey:@"productClsLst"];
                    
                    for (NSDictionary *dic2 in productClsLst) {
                        GoodObj *goodobj = [GoodObj new];
                        
                        NSDictionary *clsInfodic = [dic2 objectForKey:@"clsInfo"];
                        ClsInfo *clsinfo =[JsonToModel objectFromDictionary:clsInfodic className:@"ClsInfo"];
                        goodobj.clsInfo = clsinfo;
                        
                        NSArray * clsPicUrlarray = [dic2 objectForKey:@"clsPicUrl"];
                        for (NSDictionary *clspicDic in clsPicUrlarray) {
                            ClsPicUrl *clsPicurl = [JsonToModel objectFromDictionary:clspicDic className:@"ClsPicUrl"];
//                            NSLog(@"-------%@",clsPicurl.isMainImage);
                            if (clsPicurl.isMainImage.intValue == 1) {
                                goodobj.clsPicUrl = clsPicurl;
                            }
                            
                        }
                        
                        //商品颜色
                        NSArray * colorarray = [dic2 objectForKey:@"colorList"];
                        if (colorarray != nil) {
                            NSDictionary *colorDic = colorarray.firstObject;
                            ProductColorMapping *productColorMapping = [JsonToModel objectFromDictionary:colorDic className:@"ProductColorMapping"];
                            goodobj.productColorMapping = productColorMapping;
                            
                            /*
                             for (NSDictionary *colorDic in colorarray)
                             {
                             ProductColorMapping *productColorMapping = [JsonToModel objectFromDictionary:colorDic className:@"ProductColorMapping"];
                             goodobj.productColorMapping = productColorMapping;
                             }
                             */
                        }
                        
                        //判断是否是商品标示 1代表商品
                        goodobj.sourceType = [NSString stringWithFormat:@"1"];
                        [_dataarray addObject:goodobj];
                        //                }
                        
                    }
                    
                }
                
                if (_dataarray.count == 0) {
                    _centerLable.hidden = NO;
                    
                }else{
                    _centerLable.hidden = YES;
                    
                    //                self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
                }
                [self.collectionView reloadData];
                
                
            }

        }else{
                _centerLable.hidden = NO;
        }
        
    
    } ail:^(NSString *errorMsg) {
        
    }];



}
#pragma mark ---搜索关键字商品接口
#pragma mark --商品搜索接口
-(void)requestRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)dic
{
    [[HttpRequest shareRequst] httpRequestGetProductClsSearchFilterWithdic:dic success:^(id obj)
    {
        //如果数据数组数量为0时page变为0
        if (_dataarray.count == 0) {
            pageindex = 1;
        }
        /* 商品颜色款
        id data = [obj objectForKey:@"results"];
        if ([data isKindOfClass:[NSArray class]])
        {
            if (data != nil)
            {
            
            for (NSDictionary *dic in data)
            {
                
                    //商品基本信息
                NSDictionary *clsInfodic = [dic objectForKey:@"clsInfo"];
                ClsInfo *clsinfo =[JsonToModel objectFromDictionary:clsInfodic className:@"ClsInfo"];
              
                //获得所有商品颜色
                NSMutableArray *parsercolorArray = [NSMutableArray new];
                NSArray * colorarray = [dic objectForKey:@"colorList"];
                if (colorarray != nil)
                {
                    for (NSDictionary *colorDic in colorarray)
                    {
                        ProductColorMapping *productColorMapping = [JsonToModel objectFromDictionary:colorDic className:@"ProductColorMapping"];
                        [parsercolorArray addObject:productColorMapping];
                    }
                }
                
                
                //商品图片url
                    NSArray * clsPicUrlarray = [dic objectForKey:@"clsPicUrl"];
                    for (NSDictionary *clspicDic in clsPicUrlarray)
                    {
                        GoodObj *goodobj = [GoodObj new];
                        //判断是否是商品标示 1代表商品
                        goodobj.sourceType = [NSString stringWithFormat:@"1"];
                        goodobj.clsInfo = clsinfo;
                        ClsPicUrl *clsPicurl = [JsonToModel objectFromDictionary:clspicDic className:@"ClsPicUrl"];
                        NSLog(@"clsPicurl.srC_TYPE -------%@",clsPicurl.srC_TYPE );
                        if ([clsPicurl.srC_TYPE isEqualToString:@"ProdColor"]&& clsPicurl.isMainImage.intValue == 0)
                        {
                            goodobj.clsPicUrl = clsPicurl;
                            for (ProductColorMapping *productColorMapping in parsercolorArray)
                            {
                                if (clsPicurl.srC_ID.intValue == productColorMapping.id.intValue)
                                {
                                    goodobj.productColorMapping = productColorMapping;
                                }
                            }
                            [_dataarray addObject:goodobj];
                        }
                        
                        
                    }
        
                }
                
            }
            if (_dataarray.count == 0)
            {
                _centerLable.hidden = NO;
            }else
            {
                _centerLable.hidden = YES;
               
//                self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
                
            }
             [self.collectionView reloadData];
           
        }
        */
        /*商品款
        id data = [obj objectForKey:@"results"];
        if ([data isKindOfClass:[NSArray class]])
        {
            if (data != nil)
            {
                for (NSDictionary *dic in data)
                {
                    //商品基本信息
                    GoodObj *goodobj = [GoodObj new];
                    
                    NSDictionary *clsInfodic = [dic objectForKey:@"clsInfo"];
                    ClsInfo *clsinfo =[JsonToModel objectFromDictionary:clsInfodic className:@"ClsInfo"];
                    goodobj.clsInfo = clsinfo;
                    //判断是否是商品标示 1代表商品
                    goodobj.sourceType = [NSString stringWithFormat:@"1"];
                    
                    //获得所有商品颜色
                    NSMutableArray *parsercolorArray = [NSMutableArray new];
                    NSArray * colorarray = [dic objectForKey:@"colorList"];
                    if (colorarray != nil)
                    {
                        for (NSDictionary *colorDic in colorarray)
                        {
                            ProductColorMapping *productColorMapping = [JsonToModel objectFromDictionary:colorDic className:@"ProductColorMapping"];
                            [parsercolorArray addObject:productColorMapping];
                        }
                    }
                    
                    //商品图片url
                    NSArray * clsPicUrlarray = [dic objectForKey:@"clsPicUrl"];
                    for (NSDictionary *clspicDic in clsPicUrlarray)
                    {
                
                        ClsPicUrl *clsPicurl = [JsonToModel objectFromDictionary:clspicDic className:@"ClsPicUrl"];
                        NSLog(@"clsPicurl.isMainImage -------%d",clsPicurl.isMainImage.intValue );
                        if ( clsPicurl.isMainImage.intValue == 1)
                        {
                            goodobj.clsPicUrl = clsPicurl;
                            for (ProductColorMapping *productColorMapping in parsercolorArray)
                            {
                                if (clsPicurl.srC_ID.intValue == productColorMapping.lM_PROD_CLS_ID.intValue)
                                {
                                    goodobj.productColorMapping = productColorMapping;
                                    
                                    break;
                                }
                            }
                           
                        }
                    }
                    
                    [_dataarray addObject:goodobj];
                }
            }
            if (_dataarray.count == 0)
            {
                _centerLable.hidden = NO;
            }else
            {
                _centerLable.hidden = YES;
                
                //                self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
                
            }
            [self.collectionView reloadData];

        }
        */
        // 商品颜色款  只选择第一个
        id data = [obj objectForKey:@"results"];
        _totalStr = [obj objectForKey:@"total"];
        if ([data isKindOfClass:[NSArray class]])
        {
            if (data != nil)
            {
                
                for (NSDictionary *dic in data)
                {
                    GoodObj *goodobj = [GoodObj new];
                    //商品基本信息
                    NSDictionary *clsInfodic = [dic objectForKey:@"clsInfo"];
                    ClsInfo *clsinfo =[JsonToModel objectFromDictionary:clsInfodic className:@"ClsInfo"];
                    
                    //获得所有商品颜色
                    NSMutableArray *parsercolorArray = [NSMutableArray new];
                    NSArray * colorarray = [dic objectForKey:@"colorList"];
                    if (colorarray != nil)
                    {
                        for (NSDictionary *colorDic in colorarray)
                        {
                            ProductColorMapping *productColorMapping = [JsonToModel objectFromDictionary:colorDic className:@"ProductColorMapping"];
                            [parsercolorArray addObject:productColorMapping];
                        }
                    }
                    
                    
                    //商品图片url
                    NSArray * clsPicUrlarray = [dic objectForKey:@"clsPicUrl"];
                    NSMutableArray *clsProdColorUrlArray = [NSMutableArray new];
                    for (NSDictionary *clspicDic in clsPicUrlarray)
                    {
                        
                     
                        goodobj.clsInfo = clsinfo;
                        //1.6 add by miao
                        //判断是否是商品标示 1代表商品 2是素材//
                        goodobj.sourceType = [NSString stringWithFormat:@"%@",goodobj.clsInfo.proD_FLAG];
                        ClsPicUrl *clsPicurl = [JsonToModel objectFromDictionary:clspicDic className:@"ClsPicUrl"];
                        NSLog(@"clsPicurl.srC_TYPE -------%@",clsPicurl.srC_TYPE );
                        if ([clsPicurl.srC_TYPE isEqualToString:@"ProdColor"]&& clsPicurl.isMainImage.intValue == 0)
                        {
                            
                           
                            [clsProdColorUrlArray addObject:clsPicurl];

                        }
                        
                       
                    }
                    if (clsProdColorUrlArray.count != 0) {
                         goodobj.clsPicUrl = [clsProdColorUrlArray firstObject];
                    }
                   
                      NSLog(@"goodobj.clsPicUrl-------%@",goodobj.clsPicUrl.filE_PATH);
                    if (parsercolorArray.count != 0) {
                        goodobj.productColorMapping = [parsercolorArray firstObject];
                    }
                    
                    
                    if (goodobj.clsPicUrl!= nil && goodobj.clsPicUrl != NULL) {
                        [_dataarray addObject:goodobj];
                    }
                    
                }
                
            }
            if (_dataarray.count == 0)
            {
                _centerLable.hidden = NO;
            }else
            {
                _centerLable.hidden = YES;
                
                //                self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#acacac"];
                
            }
            [self.collectionView reloadData];
            
        }

    } ail:^(NSString *errorMsg) {
        
    }];
    
    
}
-(void)dealloc{
    
    NSLog(@"GoodsViewController---dealloc");
    
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
#pragma mark --UICollectionViewDelegateFlowLayout

 //定义每个UICollectionView 的大小
// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
// {
// return CGSizeMake(106, 106);
// }
// 
// //定义每个UICollectionView 的 margin
// -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
// {
// return UIEdgeInsetsMake(0,0,0, 0);
// }
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return  -1;//-0.4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return -0.5;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataarray == nil || _dataarray.count == 0) {
        return 0;
    }
    return _dataarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCollectionCell *cell =(GoodsCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
   cell.likeButton.hidden = YES;
      cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

    if (_dataarray == nil || _dataarray.count == 0) {
        return nil;
    }

    if (indexPath.row == 0 ||indexPath.row == 1||indexPath.row == 2){
        cell.topLineImageView.hidden = NO;
    }else{
    
     cell.topLineImageView.hidden = YES;
    }
    
    GoodObj *goodobj = _dataarray[indexPath.row];
    // Configure the cell
    cell.goodObj = goodobj;

    if (goodobj.clsPicUrl.filE_PATH == nil || goodobj.clsPicUrl.filE_PATH == NULL) {
        cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
       
    }else {
        
//      NSString *imageurl =  [self changeStringWithurlString:goodobj.clsPicUrl.filE_PATH];
        NSString *imageurl = [CommMBBusiness changeStringWithurlString:goodobj.clsPicUrl.filE_PATH width:200 height:200];
        //缓存图片
        UIImageFromURLTOCache([NSURL URLWithString:imageurl], imageurl, ^(UIImage *image) {
            cell.imageView.image = image;
          
//            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            NSLog(@"cell.imageView.image---%f---%f",image.size.width,image.size.height);
            //12.22 add by miao  解决 图片展示不规则问题
//            if (cell.imageView.frame.size.width == 106.0) {
                cell.imageView.frame = CGRectMake((106 - image.size.width/2)/2, (106-image.size.height/2)/2, image.size.width/2, image.size.height/2);
//            }
            
           
        }, ^{
            cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        });

    }

    return cell;
}


#pragma mark <UICollectionViewDelegate>



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodObj *goodobj = _dataarray[indexPath.row];
    //12.12 add by miao 
    if (goodobj.clsPicUrl.filE_PATH == nil || goodobj.clsPicUrl.filE_PATH == NULL) {
        
        return;
    }
 
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[PolyvoreViewController class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ADDCHOOSEGOODS object:nil userInfo:@{@"GoodObj":goodobj}];
           [self.navigationController popToViewController:vc animated:YES];
            
        }else if ([vc isKindOfClass:[TemplateCollocationMatchVC class]]) {
//            [self.navigationController popToViewController:vc animated:YES];

            [self performSegueWithIdentifier:@"GoodsDetailVC" sender:goodobj];
        }
    }
//[self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark -- GoodsCollectionCellDelegate
-(void)callBackGoodsCollectionCellWithjudgeType:(id)sender withGoodobj:(id)senderobj{
    
    NSString *judgetype = [NSString stringWithFormat:@"%@",sender];
    GoodObj *goodobj = (GoodObj *)senderobj;
    if (judgetype.intValue == 1) {//喜欢@"9999" @"ios-miao"
        //add by miao 11.14
//      SNSStaffFull *userinfo =  [[Globle shareInstance] getUserInfo];
        //add by miao 11.26
        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
               [self requestFavoriteCreateWithdic:(NSMutableDictionary *)@{@"UserId":sns.ldap_uid,@"SOURCE_ID":goodobj.clsInfo.id,@"SOURCE_TYPE":@"1",@"Create_User":staff.nick_name}];
            }
        }];
      
        
    }else{//取消喜欢
        
        [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
        }complete:^(SNSStaffFull *staff, BOOL success){
            if (success)
            {
              
                [self requestFavoriteDeleteWithdic:(NSMutableDictionary *)@{@"SourceIds":[NSString stringWithFormat:@"%@",goodobj.clsInfo.id],@"SOURCE_TYPE":@"1",@"UserId":sns.ldap_uid}];
            }
        }];
        
    }

}

#pragma 请求喜欢接口
-(void)requestFavoriteCreateWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteCreateWithdic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"喜欢成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定" ,nil];
            [alert show];
        }
        
    } fail:^(NSString *errorMsg) {
        
    }];
    
}
#pragma 请求取消喜欢接口
-(void)requestFavoriteDeleteWithdic:(NSMutableDictionary *)dic{
    [[HttpRequest shareRequst] httpRequestPostFavoriteDeleteWithDic:dic success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消喜欢成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: @"确定",nil];
            [alert show];
        }
    } fail:^(NSString *errorMsg) {
        
    }];

}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
/*
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(96, 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"FliterViewController"]){
        
        FilterViewController *filterViewController = segue.destinationViewController;
        filterViewController.goodCategoryObj =  (GoodCategoryObj *)sender;
        filterViewController.descContent = _descContent;
        
        [filterViewController filterVCBlockWithpostDic:^(id sender) {
            [self setGetDic:(NSMutableDictionary *)sender];
        }];
    }
    else if ([segue.identifier isEqualToString:@"GoodsDetailVC"]){
        GoodsDetailVC *gooddetailVC = segue.destinationViewController;
        gooddetailVC.goodObj = (GoodObj *)sender;
        
    }
  
    
}
- (IBAction)rightBarButtonItemClickevent:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"FliterViewController" sender:_goodCategoryObj];
}

- (IBAction)leftBarButtonItemClickevent:(id)sender {
    //12.4 add by miao
    [[TMCache sharedCache] removeObjectForKey:focusMemoryFilterDic];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
