//
//  MyViewController.m
//  newdesigner
//
//  Created by Miaoz on 14-9-26.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "MyViewController.h"
#import "MyCollectionCell.h"
#import "TopScrollView.h"
#import "RootScrollView.h"
#import "DataBase.h"
#import "DraftVO.h"
#import "Globle.h"
#import "CollocationElement.h"
#import "TemplateElement.h"

#import "NavTopTitleView.h"
#import "TemplateCollocationMatchVC.h"

#define PAGESIZE 15
#define kNavHeight 65
#define kDeviceWidth self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.height
#define kTabBarHeight 60
#define POSITIONID (int)scrollView.contentOffset.x/kDeviceWidth
@interface MyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MyCollectionCellDelegate,UIScrollViewDelegate>

@end

@implementation MyViewController

-(void)createRightBarbtn{
    UIButton *rightbutton = [self setNavRightBarbtnWithString:@"编辑"];
//    [rightbutton setTitleColor:[UIColor colorWithHexString:@"#F46C56"] forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    _rightbutton = rightbutton;
    [rightbutton addTarget:self action:@selector(rightButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightBarbtn];
    // Do any additional setup after loading the view.
//      [self.collectionView registerClass:[MyCollectionCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];

   
    if (_dataCollocationInfoarray1 == nil) {
            _dataCollocationInfoarray1 = [NSMutableArray new];
    }
    if (_dataCollocationInfoarray2 == nil) {
            _dataCollocationInfoarray2 = [NSMutableArray new];
    }
    if (_datatemplateElementarray == nil) {
            _datatemplateElementarray = [NSMutableArray new];
    }
    
  

    //old
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 5)];
    [topShadowImageView setImage:[UIImage imageNamed:@"top_background_shadow.png"]];
    [self.view addSubview:topShadowImageView];

    [self.view addSubview:[TopScrollView shareInstance]];
    [self.view addSubview:[RootScrollView shareInstance]];
     
    /*
    [self creatNavTitleView];
 */
//  self.automaticallyAdjustsScrollViewInsets = YES;
    [self initCollectionView];
    [self initCollectionView2];
    [self initCollectionView3];
    
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
//
    [self addHeader2];
    [self addFooter2];

    [self addHeader3];
    [self addFooter3];
    
    if (_clickNumStr != nil) {
        [self recordClickSelectShearWithclickint:_clickNumStr.intValue -1];
    }
    


}

-(void)setClickNumStr:(NSString *)clickNumStr{
    _clickNumStr = clickNumStr;
}

#pragma 焦点记忆效果

-(void)recordClickSelectShearWithclickint:(int) clickint {
    
    if (clickint != 0) {
        _rightbutton.hidden = YES;
    }else{
        _rightbutton.hidden = NO;
    }
    for ( int i = 0 ; i < _navTopTitleView.buttonarray.count; i ++) {
        UIButton *btn =_navTopTitleView.buttonarray[i];
        
        btn.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
        btn.layer.borderWidth = 1.0f;
        btn.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
    }
    
    UIButton *sender = _navTopTitleView.buttonarray[clickint];
    //点击操作
    sender.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] CGColor];//#acacac
    sender.layer.borderWidth = 1.0f;
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffde00"];
    sender.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sender setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    

    
    [_scrollView setContentOffset:CGPointMake(kDeviceWidth*clickint, 0) animated:YES];
    
    
   
}
#pragma mark -- 创建NavTitleView
-(void)creatNavTitleView{
    if (_navTopTitleView == nil) {
        NavTopTitleView *navTopTitleView = [[NavTopTitleView alloc] initWithFrame:CGRectMake(0, 0, 49*3, 30.0f)];
        navTopTitleView.titlearray  = @[@"草稿",@"搭配",@"模板"];
        [navTopTitleView navTopTitleViewBlockWithbuttontag:^(id sender) {
            NSString *btntagStr = [NSString stringWithFormat:@"%@",sender];
            int btntag = btntagStr.intValue;
            switch (btntag) {
                case 0:
                    _rightbutton.hidden = NO;
                    if (_dataCollocationInfoarray1.count == 0) {
                          [self requestHttpCollocationInfo1Withpageindex:@"1"];
                    }
                    
                    break;
                    
                case 1:
                    _rightbutton.hidden = YES;
                    if (_dataCollocationInfoarray2.count == 0) {
                        [self requestHttpCollocationInfo2Withpageindex:@"1"];
                    }

                    break;
                case 2:
                    _rightbutton.hidden = YES;
                    if (_datatemplateElementarray.count == 0) {
                        [self requestHttpCollocationSystemModuleFilterWithpageindex:@"1"];
                    }

                    break;
                default:
                    break;
            }
            [_scrollView setContentOffset:CGPointMake(kDeviceWidth*btntag, 0) animated:YES];
        }];
        _navTopTitleView = navTopTitleView;
        self.navigationItem.titleView = navTopTitleView;
    }

    [self createScrollerView];
    [self createSwipeGesture];

}
#pragma mark -- 创建ScrollerView
-(void)createScrollerView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
        _scrollView.contentSize = CGSizeMake(3*self.view.bounds.size.width, self.view.bounds.size.height);
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
    }
    

}
#pragma mark  --滑动手势
-(void)createSwipeGesture{
    
    if (_leftSwipeGestureRecognizer == nil) {
         _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
         _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
         [self.scrollView addGestureRecognizer:_leftSwipeGestureRecognizer];
    }
   
    if (_rightSwipeGestureRecognizer == nil) {
        _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
         _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.scrollView addGestureRecognizer:_rightSwipeGestureRecognizer];
    }

}
//add by miao 11.19
static int leftint = 0;
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        leftint++;
        if (leftint >2 ) {
            leftint = 2;
            _rightbutton.hidden = YES;
            [self recordClickSelectShearWithclickint:leftint];
            return;
        }else{
            _rightbutton.hidden = YES;
            [self recordClickSelectShearWithclickint:leftint];
         [_scrollView setContentOffset:CGPointMake(kDeviceWidth*leftint+1, 0) animated:YES];
        }
       
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
       
        
        
        if (leftint <= 0) {
            [self recordClickSelectShearWithclickint:leftint];
           
            leftint =0;
            
            return;
        }else{
            _rightbutton.hidden = YES;
        leftint --;
        [self recordClickSelectShearWithclickint:leftint];
        [_scrollView setContentOffset:CGPointMake(kDeviceWidth*leftint-1, 0) animated:YES];
            if (leftint == 0) {
                 _rightbutton.hidden = NO;
            }
        }
    
    }
}

//草稿
- (void)addHeader
{
    __weak typeof(self) vc = self;
//    [_collectionView  removeHeader];
    // 添加下拉刷新头部控件
    [_collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.dataCollocationInfoarray1 != nil ||vc.dataCollocationInfoarray1.count >0 ) {
            [vc.dataCollocationInfoarray1 removeAllObjects];
        }
        
        [vc requestHttpCollocationInfo1Withpageindex:@"1"];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        
        if (vc.dataCollocationInfoarray1.count%PAGESIZE != 0 ) {//说明数据更新完
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
            return ;
        }
        int pageindex =  (int)vc.dataCollocationInfoarray1.count/PAGESIZE + 1;
        [vc requestHttpCollocationInfo1Withpageindex:[NSString stringWithFormat:@"%d",pageindex]];
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        });
    }];
}
//搭配
- (void)addHeader2
{
    __weak typeof(self) vc = self;
//    [_collectionView2  removeHeader];
 
    // 添加下拉刷新头部控件
    [_collectionView2 addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.dataCollocationInfoarray2 != nil ||vc.dataCollocationInfoarray2.count >0 ) {
            [vc.dataCollocationInfoarray2 removeAllObjects];
        }
        
        [vc requestHttpCollocationInfo2Withpageindex:@"1"];

        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView2 reloadData];
            // 结束刷新
            [vc.collectionView2 headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
        [_collectionView2 headerBeginRefreshing];
}

- (void)addFooter2
{
    __weak typeof(self) vc = self;
   
//    [_collectionView2  removeFooter];
    // 添加上拉刷新尾部控件
    [self.collectionView2 addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.dataCollocationInfoarray2.count%PAGESIZE != 0 ) {//说明数据更新完
            // 结束刷新
            [vc.collectionView2 footerEndRefreshing];
            return ;
        }
        int pageindex =  (int)vc.dataCollocationInfoarray2.count/PAGESIZE + 1;
        [vc requestHttpCollocationInfo2Withpageindex:[NSString stringWithFormat:@"%d",pageindex]];
        
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView2 reloadData];
            // 结束刷新
            [vc.collectionView2 footerEndRefreshing];
        });
    }];
}

//模板
- (void)addHeader3
{
    __weak typeof(self) vc = self;
//    [_collectionView3  removeHeader];
   
    // 添加下拉刷新头部控件
    [_collectionView3 addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.datatemplateElementarray != nil ||vc.datatemplateElementarray.count >0 ) {
            [vc.datatemplateElementarray removeAllObjects];
        }
        
        [vc requestHttpCollocationSystemModuleFilterWithpageindex:@"1"];
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView3 reloadData];
            // 结束刷新
            [vc.collectionView3 headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
    [_collectionView3 headerBeginRefreshing];
}

- (void)addFooter3
{
    __weak typeof(self) vc = self;

//    [_collectionView3  removeFooter];
    // 添加上拉刷新尾部控件
    [self.collectionView3 addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.datatemplateElementarray.count%PAGESIZE != 0 ) {//说明数据更新完
            // 结束刷新
            [vc.collectionView3 footerEndRefreshing];
            return ;
        }
        int pageindex =  (int)vc.datatemplateElementarray.count/PAGESIZE + 1;
        [vc requestHttpCollocationSystemModuleFilterWithpageindex:[NSString stringWithFormat:@"%d",pageindex]];
        
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView3 reloadData];
            // 结束刷新
            [vc.collectionView3 footerEndRefreshing];
        });
    }];
}






//初始化是这样初始化的。
-(void) initCollectionView{
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(107, 106);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kDeviceWidth, [RootScrollView shareInstance].scrollView.bounds.size.height-kNavHeight) collectionViewLayout:flowLayout];// _scrollView.bounds.size.height-kNavHeight
         self.collectionView.alwaysBounceVertical = YES;//展示footrefresh
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.tag = 777;
        //注册
        
        [self.collectionView registerClass:[MyCollectionCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
        
        //设置代理
        
        self.collectionView.delegate = self;
        
        self.collectionView.dataSource = self;
        
//        [_scrollView addSubview:self.collectionView];
        [[RootScrollView shareInstance].scrollView addSubview:self.collectionView];
        

    }
}
//初始化是这样初始化的。
-(void) initCollectionView2{
    
    if (_collectionView2 == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(107, 106);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        
        self.collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake([RootScrollView shareInstance].scrollView.bounds.size.width, 0.0f, kDeviceWidth, [RootScrollView shareInstance].scrollView.bounds.size.height-kNavHeight) collectionViewLayout:flowLayout];
        self.collectionView2.alwaysBounceVertical = YES;//展示footrefresh
        self.collectionView2.backgroundColor = [UIColor clearColor];
        self.collectionView2.tag = 888;
        //注册
        
        [self.collectionView2 registerClass:[MyCollectionCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
        
        //设置代理
        
        self.collectionView2.delegate = self;
        
        self.collectionView2.dataSource = self;
//                [_scrollView addSubview:self.collectionView2];
        [[RootScrollView shareInstance].scrollView addSubview:self.collectionView2];
    }
    
    
}
-(void) initCollectionView3{
    
    if (_collectionView3 == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(107, 106);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        
        self.collectionView3 = [[UICollectionView alloc]initWithFrame:CGRectMake([RootScrollView shareInstance].scrollView.bounds.size.width*2, 0.0f, kDeviceWidth, [RootScrollView shareInstance].scrollView.bounds.size.height-kNavHeight) collectionViewLayout:flowLayout];
         self.collectionView3.alwaysBounceVertical = YES;//展示footrefresh
        self.collectionView3.backgroundColor = [UIColor clearColor];
        self.collectionView3.tag = 999;
        //注册
        
        [self.collectionView3 registerClass:[MyCollectionCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
        
        //设置代理
        
        self.collectionView3.delegate = self;
        
        self.collectionView3.dataSource = self;
        
//        [_scrollView addSubview:self.collectionView3];
        [[RootScrollView shareInstance].scrollView addSubview:self.collectionView3];
        

    }
}
//精选搭配查询需要按照Statuses =2,3,4 查询
//草稿箱搭配查询需要按照status =1 查询
#pragma mark -请求草稿信息接口
-(void)requestHttpCollocationInfo1Withpageindex:(NSString *)pageindex{
    

    [[HttpRequest shareRequst] httpRequestGetCollocationFilterWithDic:(NSMutableDictionary *)@{@"status":[NSNumber numberWithInt:1],
                                                                                               @"pageIndex":[NSNumber numberWithInt:pageindex.intValue],
                                                                                               @"pageSize":[NSNumber numberWithInt:PAGESIZE],@"UserId":sns.ldap_uid} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)//,@"UserId":[AppSetting getUserID]
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in data)
                {
                    CollocationInfo *collocationInfo;
                    collocationInfo=[JsonToModel objectFromDictionary:[dic objectForKey:@"collocationInfo"] className:@"CollocationInfo"];
                    [_dataCollocationInfoarray1 addObject:collocationInfo];
                }
//                [self.collectionView reloadData];
            }
        }
    } ail:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
    }];
    
}

#pragma mark -请求搭配信息接口
-(void)requestHttpCollocationInfo2Withpageindex:(NSString *)pageindex{
//[NSNumber numberWithInt:2]
    
    [[HttpRequest shareRequst] httpRequestGetCollocationFilterWithDic:(NSMutableDictionary *)@{@"statuses":@"2,3,4",
                                                                                               @"pageIndex":[NSNumber numberWithInt:pageindex.intValue],
                                                                                               @"pageSize":[NSNumber numberWithInt:PAGESIZE],@"UserId":sns.ldap_uid} success:^(id obj) {
    if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
    {
        id data = [obj objectForKey:@"results"];
        if ([data isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dic in data)
            {
                CollocationInfo *collocationInfo;
                collocationInfo=[JsonToModel objectFromDictionary:[dic objectForKey:@"collocationInfo"] className:@"CollocationInfo"];
                [self.dataCollocationInfoarray2 addObject:collocationInfo];
            }
//            [self.collectionView2 reloadData];
        }
    }
} ail:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
}];

}
#pragma mark -请求模板信息接口
-(void)requestHttpCollocationSystemModuleFilterWithpageindex:(NSString *)pageindex{
    
    [[HttpRequest shareRequst] httpRequestGetCollocationSystemModuleFilter:(NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:pageindex.intValue],
                                                                                                    @"pageSize":[NSNumber numberWithInt:PAGESIZE]} success:^(id obj)
     {
         if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
         {
             id data = [obj objectForKey:@"results"];
             if ([data isKindOfClass:[NSArray class]])
             {
                 //遍历数组解析
                 
                 for (NSDictionary *dic in data)
                 {
                     
                     TemplateElement *templateElement = [[TemplateElement alloc] init];
                     
                     TemplateInfo *templateInfo;
                     templateInfo=[JsonToModel objectFromDictionary:[dic objectForKey:@"moduleInfo"] className:@"TemplateInfo"];
                     templateElement.templateInfo = templateInfo;
                     
                     id detaildata =[dic objectForKey:@"detailList"];
                     if ([detaildata isKindOfClass:[NSArray class]])
                     {
                         for (NSDictionary *detaildic in detaildata)
                         {
                             DetailMapping*detailMapping ;
                             detailMapping = [JsonToModel objectFromDictionary:detaildic className:@"DetailMapping"];
                             [templateElement.detailMappingList addObject:detailMapping];
                         }
                         
                     }
                     
                     id layoutdata = [dic objectForKey:@"layoutMappingList"];
                     if ([layoutdata isKindOfClass:[NSArray class]])
                     {
                         for (NSDictionary *layoutdic in layoutdata)
                         {
                             LayoutMapping *layoutMapping;
                             layoutMapping = [JsonToModel objectFromDictionary:layoutdic className:@"LayoutMapping"];
                             //add by miao 4.8
                             NSArray *contentList = [layoutdic objectForKey:@"contentList" ];
                             if (contentList>0) {
                                 layoutMapping.contentInfo = [JsonToModel objectFromDictionary:contentList.firstObject  className:@"ContentInfo"];
//                                  layoutMapping.contentInfo.crossInfo = [JsonToModel objectFromDictionary:[contentList.firstObject objectForKey:@"crossInfo"] className:@"CrossInfo"];
                             }

                             [templateElement.layoutMappingList addObject:layoutMapping];
                         }
                     }
                     [_datatemplateElementarray addObject:templateElement];
                     
                 }
             }
         }
     } ail:^(NSString *errorMsg) {
         
     }];
    
    
}

#pragma mark-删除功能
-(void)requestHttpdeleteCollocationInfo:(CollocationInfo *)collocationInfo{

    [CommMBBusiness getStaffInfoByStaffID:sns.ldap_uid staffType:STAFF_TYPE_OPENID defaultProcess:^{
    }complete:^(SNSStaffFull *staff, BOOL success){
        if (success)
        {
            [[HttpRequest shareRequst] httpRequestPostCollocationDeleteWithDic:(NSMutableDictionary *)@{@"ID":collocationInfo.id,@"LAST_MODIFIED_USER":staff.nick_name} success:^(id obj) {
                
                [_dataCollocationInfoarray1 removeObject:collocationInfo];
                [_collectionView reloadData];
                
            } ail:^(NSString *errorMsg) {
                NSLog(@"%@",errorMsg);
            }];
        }
    }];
    //collocationInfo.lasT_MODIFIED_USER
    

}

#pragma mark- MyCollectionCellDelegate  删除
-(void)callBackMyCollectionCellWithCollocationInfo:(id)sender{
    CollocationInfo *collocationInfo = (CollocationInfo *)sender;
    NSLog(@"------%@",collocationInfo.pictureUrl);

    [self requestHttpdeleteCollocationInfo:collocationInfo];
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
    
    return -1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return -0.5;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    switch (collectionView.tag) {
        case 777:
            if (_dataCollocationInfoarray1 == nil ||_dataCollocationInfoarray1.count == 0)
            {
                return 0;
            }else{
                 return _dataCollocationInfoarray1.count;
            }
            break;
            
        case 888:
            if (self.dataCollocationInfoarray2 == nil ||self.dataCollocationInfoarray2.count == 0)
            {
                return 0;
            }else{
                return self.dataCollocationInfoarray2.count;
            }

            break;
            
        case 999:
            if (_datatemplateElementarray == nil ||_datatemplateElementarray.count == 0)
            {
                return 0;
            }else{
                return _datatemplateElementarray.count;
            }
            
            break;
      
        default:
            return 9;
            break;
    }
    

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectionCell *cell = (MyCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row == 0 ||indexPath.row == 1||indexPath.row == 2) {
        cell.topLineImageView.hidden = NO;
    }else{
        cell.topLineImageView.hidden = YES;
    }
    
    /*本地数据库时代码
    if (_dataDraftarray == nil || _dataDraftarray.count == 0) {
        cell.imageView.image = [UIImage imageNamed:@"3"];
    }else{
        DraftVO *draftvo = _dataDraftarray[indexPath.row];
        cell.imageView.image =[UIImage imageWithData:[draftvo valueForKey:@"draftimageData"]];
        
    }
   */
    switch (collectionView.tag) {
        case 777:
            if (_isEdit == YES) {
                cell.aboveImageView.backgroundColor = [UIColor blackColor];
                cell.aboveImageView.alpha = 0.2f;
                cell.deleteButton.hidden = NO;
            }else{
                cell.aboveImageView.backgroundColor = [UIColor clearColor];
                cell.aboveImageView.alpha = 1.0f;
                cell.deleteButton.hidden = YES;
            }
            
            if (_dataCollocationInfoarray1 == nil || _dataCollocationInfoarray1.count == 0) {
                cell.imageView.image = [UIImage imageNamed:@"3"];
            }else{
//                if (indexPath.row == 0 ||indexPath.row == 1||indexPath.row == 2) {
//                    cell.topLineImageView.hidden = NO;
//                }else{
//                cell.topLineImageView.hidden = YES;
//                }
                CollocationInfo *collocationInfo = _dataCollocationInfoarray1[indexPath.row];//
                cell.collocationInfo = collocationInfo;
                
               
                NSString *url =  [self changeStringWithurlString:collocationInfo.pictureUrl];
              
                UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
                    cell.imageView.image = image;
                }, ^{
                    cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_MEDIUM];
                });
                
//              NSString *url =  [self changeStringWithurlString:collocationInfo.pictureUrl];
//                [cell.imageView setImageAFWithURL:[NSURL URLWithString:url] placeholderImage:nil];
                
                
          
            }

            break;
            
        case 888:
           
            if (self.dataCollocationInfoarray2 == nil || self.dataCollocationInfoarray2.count == 0) {
                cell.imageView.image = [UIImage imageNamed:@"3"];
            }else{
               
                CollocationInfo *collocationInfo = self.dataCollocationInfoarray2[indexPath.row];//
                cell.collocationInfo = collocationInfo;
                
                NSString *imageurl =  [self changeStringWithurlString:collocationInfo.pictureUrl];
                NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
                    cell.imageView.image = image;
                }, ^{
                    cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_MEDIUM];
                });
//                [[HttpRequest shareRequst] downloadImageUrl:imageurl defaultImageName:DEFAULT_LOADING_MEDIUM WithImageView:cell.imageView];
//                 NSString *url =  [self changeStringWithurlString:collocationInfo.pictureUrl];
//                [cell.imageView setImageAFWithURL:[NSURL URLWithString:url] placeholderImage:nil];
//
            }
           break;
        case 999:
           
            if (_datatemplateElementarray == nil || _datatemplateElementarray.count == 0) {
                cell.imageView.image = [UIImage imageNamed:@"3"];
            }else{
//                if (indexPath.row == 0 ||indexPath.row == 1||indexPath.row == 2) {
//                    cell.topLineImageView.hidden = NO;
//                }else{
//                    cell.topLineImageView.hidden = YES;
//                }
                TemplateElement *templateElement = _datatemplateElementarray[indexPath.row];//
               
                 NSString *imageurl = [self changeStringWithurlString:templateElement.templateInfo.pictureUrl];
                 NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
                    cell.imageView.image = image;
                }, ^{
                    cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_MEDIUM];
                });

           
//                NSString *url = [self changeStringWithurlString:templateElement.templateInfo.pictureUrl];
//               [cell.imageView setImageAFWithURL:[NSURL URLWithString:url] placeholderImage:nil];
            }

            break;
            
        default:
            
            break;
    }
    
    return cell;
}

-(NSString *)changeStringWithurlString:(NSString *)imageurl{
    NSMutableString *mainurlString;
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:imageurl];
    NSRange range = [String1 rangeOfString:@"--"];
    
    int location =(int) range.location;
    int leight = (int)range.length;
    
    if (leight == 2) {////有--400x400
        mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location]];
        [mainurlString appendString:[NSString stringWithFormat:@".png"]];
        
        
    }else{//没有--400x400 //有后缀.png
        NSRange range = [String1 rangeOfString:@".png"];
        
        int leight = (int)range.length;
        if (leight == 4){//有后缀.png
            
            mainurlString = [[NSMutableString alloc] initWithString:String1];
            
        }else{//没有后缀png
            
            //后缀jpg
            NSRange range2 = [String1 rangeOfString:@".jpg"];
            int location2 = (int)range2.location;
            int leight2 = (int)range2.length;
            if (leight2 == 4){//有后缀.jpg
                
                mainurlString = [[NSMutableString alloc] initWithString:[String1 substringToIndex:location2]];
                [mainurlString appendString:[NSString stringWithFormat:@".jpg"]];
            }else{//没有后缀
                
                mainurlString = [[NSMutableString alloc] initWithString:String1];
                [mainurlString appendString:[NSString stringWithFormat:@".png"]];
                
            }
            
            
        }
        
    }
    
    
    
    [mainurlString insertString:[NSString stringWithFormat:@"--%dx%d",(int)200,(int)200] atIndex:mainurlString.length -4];
        NSLog(@"mainurlString--------%@",mainurlString);
    return mainurlString;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    if (collectionView.tag == 777) {
   
        if (_isEdit == YES) {
            CollocationInfo *collocationInfo = _dataCollocationInfoarray1[indexPath.row];
            [self requestHttpdeleteCollocationInfo:collocationInfo];
            
            return;
        }
        
        CollocationInfo *collocationInfo = _dataCollocationInfoarray1[indexPath.row];
//        if (collocationInfo.templateId.integerValue != -1)
//           {
//                [self performSegueWithIdentifier:@"TemplateCollocationMatchVC2" sender:collocationInfo];
//               
//           }else
//           {
        
               if (_delegate && [_delegate respondsToSelector:@selector(callBackMyViewControllerWithServiceCollocationInfo:)]) {
                   [_delegate callBackMyViewControllerWithServiceCollocationInfo:collocationInfo];
               }
               
               [self.navigationController popViewControllerAnimated:YES];
           
//           }
    }
    
    if (collectionView.tag == 888) {
        
        CollocationInfo *collocationInfo = self.dataCollocationInfoarray2[indexPath.row];
//        if (collocationInfo.templateId.integerValue != -1)//-1是自由搭配
//        {
//            [self performSegueWithIdentifier:@"TemplateCollocationMatchVC2" sender:collocationInfo];
//        }
//        else
//        {
            if (_delegate && [_delegate respondsToSelector:@selector(callBackMyViewControllerWithServiceCollocationInfo:)]) {
                [_delegate callBackMyViewControllerWithServiceCollocationInfo:collocationInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }
        
//        }

    }
  
    if (collectionView.tag == 999) {
         TemplateElement *templateElement = _datatemplateElementarray[indexPath.row];
        
        DetailMapping * detailMapping = templateElement.detailMappingList.firstObject;
//        if (detailMapping.productPictureUrl.length == 0) {// 是纯图片模板
//           [self performSegueWithIdentifier:@"TemplateCollocationMatchVC2" sender:templateElement];
//        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(callBackMyViewControllerWithServicemubantemplateElement:)]) {
                                    [_delegate callBackMyViewControllerWithServicemubantemplateElement:templateElement];
                                }
                                [self.navigationController popViewControllerAnimated:YES];

//        }
        
    }

}


- (void)didReceiveMemoryWarning {
    
    if ([self.view window] == nil)// 是否是正在使用的视图
        
    {
        self.view = nil;
    
    }
    [super didReceiveMemoryWarning];
        NSLog(@"MyViewController--didReceiveMemoryWarning---");
    // Dispose of any resources that can be recreated.
}
/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    [_collectionView removeFromSuperview];
    [_collectionView2 removeFromSuperview];
    [_collectionView3 removeFromSuperview];
    _collectionView = nil;
    _collectionView2 = nil;
    _collectionView3 = nil;
    [_dataCollocationInfoarray1 removeAllObjects];//左 草稿
    [_dataCollocationInfoarray2 removeAllObjects];//中 搭配
    [_datatemplateElementarray removeAllObjects];//右  模板
    _dataCollocationInfoarray1 = nil;
    _dataCollocationInfoarray2 = nil;
    _datatemplateElementarray = nil;
    NSLog(@"MyViewController--dealloc---");
}

/**/
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"TemplateCollocationMatchVC2"]) {
        TemplateCollocationMatchVC *vc = segue.destinationViewController;
        if ([sender isKindOfClass:[TemplateElement class]]) {
            [vc callBackMyViewControllerWithServicemubantemplateElement:sender];
        }else if([sender isKindOfClass:[CollocationInfo class]]){
            [vc callBackMyViewControllerWithServiceCollocationInfo:sender];
        
        }
       
    }
 
}


- (IBAction)rightBarButtonItemClickevent:(UIBarButtonItem *)sender {
   
    if (_isEdit== NO) {//点击编辑
        
        [sender setTitle:@"完成"];
        _isEdit = YES;
    }else{//点击完成
        
        [sender setTitle:@"编辑"];
        _isEdit = NO;
    }
    
    [self.collectionView reloadData];

}

-(void)rightButtonCLick:(UIButton *)sender{
    
    if (_isEdit== NO) {//点击编辑
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    
        _isEdit = YES;
    }else{//点击完成
        
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
       
        _isEdit = NO;
    }
    
    [self.collectionView reloadData];


}

- (IBAction)leftBarButtonItemClickevent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
