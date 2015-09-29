//
//  TemplateMoreVC.m
//  Wefafa
//
//  Created by Miaoz on 15/3/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "TemplateMoreVC.h"
#import "Globle.h"
#import "TemplateCollectionCell.h"
#import "TemplateElement.h"
#import "TemplateCollocationMatchVC.h"
#define PAGESIZE 21
#define kNavHeight 65
#define kDeviceWidth self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.height
#define kTabBarHeight 60

@interface TemplateMoreVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(strong ,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray  *datatemplateElementarray;
@end

@implementation TemplateMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (IOS7_OR_LATER) {
//        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#000000"];
//        
//    }else{
//        　self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#000000"];
//    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil]];
    
    [self SetLeftButton:nil Image:@"ion_back"];
//    [self setRightButton:@"更多" action:@selector(addMoreTemplateClick:)];
    if (_datatemplateElementarray == nil) {
        _datatemplateElementarray = [NSMutableArray new];
    }

    [self initCollectionView];
    
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
}
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    //    [_collectionView  removeHeader];
    // 添加下拉刷新头部控件
    [_collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.datatemplateElementarray != nil ||vc.datatemplateElementarray.count >0 ) {
            [vc.datatemplateElementarray removeAllObjects];
        }
        [vc requestHttpCollocationSystemModuleFilterWithpageindex:@"1"];
        
              // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView headerEndRefreshing];
        });
    }];
    
//#warning 自动刷新(一进入程序就下拉刷新)
    [_collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    //     [_collectionView  removeFooter];
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        if (vc.datatemplateElementarray.count%PAGESIZE != 0 ) {//说明数据更新完
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
            return ;
        }
        int pageindex =  (int)vc.datatemplateElementarray.count/PAGESIZE + 1;
        [vc requestHttpCollocationSystemModuleFilterWithpageindex:[NSString stringWithFormat:@"%d",pageindex]];
        
       
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
        });
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

//初始化是这样初始化的。
-(void) initCollectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(160, 160);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0f, kNavHeight, kDeviceWidth, kDeviceHeight -kNavHeight) collectionViewLayout:flowLayout];
        self.collectionView.alwaysBounceVertical = YES;//展示footrefresh
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.tag = 777;
        //注册
        [self.collectionView registerClass:[TemplateCollectionCell class] forCellWithReuseIdentifier:@"TemplateCollectionCell"];
        
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
    if (_datatemplateElementarray == nil ||_datatemplateElementarray.count == 0)
    {
        return 0;
    }else{
        return _datatemplateElementarray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TemplateCollectionCell *cell = (TemplateCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TemplateCollectionCell" forIndexPath:indexPath];
    
    
    if (_datatemplateElementarray == nil || _datatemplateElementarray.count == 0) {
        cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    }else{
        //                if (indexPath.row == 0 ||indexPath.row == 1||indexPath.row == 2) {
        //                    cell.topLineImageView.hidden = NO;
        //                }else{
        //                    cell.topLineImageView.hidden = YES;
        //                }
        
        
        if (indexPath.row > _datatemplateElementarray.count - 1 ) {
            return cell;
        }
        TemplateElement *templateElement = _datatemplateElementarray[indexPath.row];//
        
        NSString *imageurl =[CommMBBusiness changeStringWithurlString:templateElement.templateInfo.pictureUrl size:3];
        
        NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
            cell.imageView.image = image;
        }, ^{
            cell.imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
        });
        
    }

    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TemplateElement *templateElement =  _datatemplateElementarray[indexPath.row];
    [self performSegueWithIdentifier:@"TemplateCollocationMatchVC" sender:templateElement];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"TemplateCollocationMatchVC"]) {
        TemplateCollocationMatchVC *viewController =segue.destinationViewController;
        viewController.templateElement = sender;
    }
    
    
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
