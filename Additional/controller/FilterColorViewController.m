//
//  FilterColorViewController.m
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
// 废弃不用 

#import "FilterColorViewController.h"
#import "ColorCollectionCell.h"
#import "Globle.h"
#import "ColorMapping.h"
#import "UIColor+extend.h"
#define kNavHeight 5
#define kDeviceWidth self.view.bounds.size.width
#define kDeviceHeight self.view.bounds.size.height
#define kTabBarHeight 60
@interface FilterColorViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataarray;
@end

@implementation FilterColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataarray = [NSMutableArray new];
    
    [self initCollectionView];
    [self requestProductColorFilterWithpageindex:@"1"];
}
-(void)dealloc{
    
    NSLog(@"FilterColorViewController---dealloc");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)colorVCBlockWithColorMapping:(ColorVCBlock) block{

    _myblock = block;

}

- (IBAction)leftBarButtonItemClickevent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-请求商品颜色
-(void)requestProductColorFilterWithpageindex:(NSString *)pageindex{
    [[HttpRequest shareRequst] httpRequestGetBaseColorFilterWithDic:(NSMutableDictionary *)@{@"pageIndex":[NSNumber numberWithInt:pageindex.intValue],@"pageSize":[NSNumber numberWithInt:100]} success:^(id obj) {
        if ([[obj objectForKey:@"isSuccess"] integerValue]== 1)
        {
            id data = [obj objectForKey:@"results"];
            if ([data isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in data)
                {
                     ColorMapping*colorMapping;
                    colorMapping=[JsonToModel objectFromDictionary:dic className:@"ColorMapping"];
                    [_dataarray addObject:colorMapping];
                }
                [self.collectionView reloadData];
            }
        }
        
          } ail:^(NSString *errorMsg) {
                                                                                                    
          }];

}
//初始化是这样初始化的。
-(void) initCollectionView{
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(75, 75);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0f, kNavHeight, kDeviceWidth, kDeviceHeight-64) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.tag = 111;
        //注册
        [self.collectionView registerClass:[ColorCollectionCell class] forCellWithReuseIdentifier:@"ColorCollectionCell"];
        
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
 */
 //定义每个UICollectionView 的 margin
// -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
// {
// return UIEdgeInsetsMake(5, 5, 5, 5);
// }
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCollectionCell *cell =(ColorCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCollectionCell" forIndexPath:indexPath];
    
    ColorMapping *colorMapping = _dataarray[indexPath.row];
    NSLog(@"%d",colorMapping.coloR_VALUE.length);
    NSString *colorStr ;
    if (colorMapping.coloR_VALUE.length<7) {
      colorStr = [NSString stringWithFormat:@"#%@",colorMapping.coloR_VALUE];
    }else{
        colorStr = colorMapping.coloR_VALUE;
    }
    
    
    cell.colorImageView.backgroundColor = [UIColor colorWithHexString:colorMapping.coloR_VALUE];

    
   
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  ColorMapping *colorMapping = _dataarray[indexPath.row];
    if (_myblock) {
        _myblock(colorMapping);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
