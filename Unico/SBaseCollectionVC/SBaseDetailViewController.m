//
//  SBaseDetailViewController.m
//  Wefafa
//
//  Created by unico on 15/5/15.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SBaseDetailViewController.h"
#import "SWaterCollectionViewCell.h"
#import "SWaterAdvertCollectionViewCell.h"
#import "SCollocationDetailViewController.h"
#import "WaterFLayout.h"
#import "SUtilityTool.h"
#import "LNGood.h"

#import "SCollocationDetailNoneShopController.h"


@interface SBaseDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    // temp head content 暂时打个补丁，后续fix重构
    BOOL headInited;
}

//// 商品列表数组
//@property (nonatomic, strong) NSMutableArray *goodsList;
// 底部视图
@property (nonatomic) UICollectionReusableView *footerView;
@property (nonatomic) UICollectionReusableView *headerView;

// 是否正在加载数据标记
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@end

static NSString* HeaderReuseIdentifier = @"HeaderReuseIdentifier";
static NSString* FooterReuseIdentifier = @"FooterReuseIdentifier";
@implementation SBaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置页眉高度,默认600
    self.headerViewHeight = 430;
    [self getData];
}

-(void) layoutUI{
    //获取数据
    if (!headContent) {
        headContent = [UICollectionReusableView new];
    }

    if (!headInited) {
        headInited = YES;
        self.isCalculateHeight = NO;
        [self updateHeaderView:headContent];
    }
    
    // 这里需要高度，collectionView在下面创建的。
    [self setCollectionView];
    self.collectionView.backgroundColor = COLOR_C4;
    //布局界面
    [self setHeadTitle];
}


-(void)setHeadTitle{
    
    
}

-(void)getData{
    
}

-(void) updateHeaderView:(UICollectionReusableView*) headerView{
    
}

//-(void)getNewData{
//    NSArray *goods = [LNGood goodsWithIndex:self.index];
//    [self.goodsList addObjectsFromArray:goods];
//    self.index++;
//    self.collectionFlowLayout.goodsList = self.goodsList;
//    // 刷新数据
//    [self.collectionView reloadData];
//}
-(void) setCollectionView{
    // 设置布局的属性
    if (self.collectionView == nil) {
        WaterFLayout *waterLayout = [WaterFLayout new];
        waterLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:waterLayout];
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        [self.view insertSubview:self.collectionView atIndex:0];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterCellIdentifier];
        [self.collectionView registerNib:[UINib nibWithNibName:@"SWaterAdvertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterAdvertCellIdentifier];
        // 注意这里注册head的方式。
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:HeaderReuseIdentifier];
        
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:WaterFallSectionFooter withReuseIdentifier:FooterReuseIdentifier];
    }
    
    // 刷新数据
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView reloadData];
}
/**
 *  加载数据
 */
//- (void)loadData {
//    NSArray *goods = [LNGood goodsWithIndex:self.index];
//    [self.goodsList addObjectsFromArray:goods];
//    self.index++;
//   
//}
-(void)setupNavbar{
    [super setupNavbar];
}

#pragma mark - 数据源方法
#pragma mark - 数据源方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
    LNGood *goodsModel = self.goodsList[indexPath.row];
    size.height = goodsModel.h * (size.width /goodsModel.w) + 60;
    if (goodsModel.content_info.length <= 0) size.height -= 20;
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LNGood *goodsModel = self.goodsList[indexPath.row];
    UICollectionViewCell *cell;
    if ([goodsModel.show_type boolValue]) {
        //第一个
        SWaterAdvertCollectionViewCell *advertCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterAdvertCellIdentifier forIndexPath:indexPath];
        advertCell.contentGoodsModel = goodsModel;
        cell = advertCell;
    }else{
        SWaterCollectionViewCell *waterCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCellIdentifier forIndexPath:indexPath];
        waterCell.contentGoodsModel = goodsModel;
        cell = waterCell;
    }
    // 创建可重用的cell
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return self.headerViewHeight;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LNGood *goodInfo = self.goodsList[indexPath.row];
    if ([goodInfo.show_type integerValue] <= 0) {
        NSString * collocationId  = goodInfo.product_ID;
        if (collocationId<0) {
            return;
        }
        
       /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
        vc.collocationId = collocationId;
        [self pushController:vc animated:YES];*/
        
        
        
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            
            
            detailNoShoppingViewController.collocationId = collocationId;
            [self pushController:detailNoShoppingViewController animated:YES];
        }
        else
        {
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            
            
            collocationDetailVC.collocationId = collocationId;
            [self pushController:collocationDetailVC animated:YES];
        }

        
        
        
        
    }else{
        NSDictionary *tempDict = @{@"is_h5":goodInfo.is_h5,@"jump_id":goodInfo.jump_id,@"jump_type":goodInfo.jump_type,@"name":goodInfo.name,@"tid":goodInfo.tid,@"type":goodInfo.type,@"url":goodInfo.url};
        [SUTIL jumpControllerWithContent:tempDict target:self];
    }
   
}

/**
 *  追加视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *temp = nil;
    if (kind == WaterFallSectionFooter) {
        if (!self.footerView) {
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterReuseIdentifier forIndexPath:indexPath];
        }
        temp = self.footerView;
    }
    else  if(kind == WaterFallSectionHeader){
        //为空时添加
        if (!self.headerView) {
            self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderReuseIdentifier forIndexPath:indexPath];
//            self.isCalculateHeight = NO;
//            [self updateHeaderView:self.headerView];
            NSArray *views = [headContent subviews];
            for (UIView* view in views) {
                [view removeFromSuperview];
                [self.headerView addSubview:view];
            }
            // 直接加容器，会导致没有事件，所以暂时这样处理了。
//            [self.headerView addSubview:headContent];
        }
        temp = self.headerView;
    }
    return temp;
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)updateScrollViewDidScroll{
};

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    
    CGRect bounds = scrollView.bounds;
    
    CGSize size = scrollView.contentSize;
    
    UIEdgeInsets inset = scrollView.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    CGFloat maximumOffset = size.height;
    SGLOBAL_DATA_INSTANCE.scrollSelectedOffset = currentOffset;
    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
    float tempFloat = UI_SCREEN_WIDTH/4;
    if(((maximumOffset-currentOffset) <= tempFloat && (maximumOffset-currentOffset)>(tempFloat-50)) || ((maximumOffset-currentOffset) < 0 && (maximumOffset-currentOffset) > -1))
    {
        [self updateScrollViewDidScroll];
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)goodsList {
    if (_goodsList == nil) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

@end
