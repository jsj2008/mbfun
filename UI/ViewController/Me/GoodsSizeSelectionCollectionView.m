//
//  GoodsSizeSelectionCollectionView.m
//  Wefafa
//
//  Created by Jiang on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "GoodsSizeSelectionCollectionView.h"
#import "SUtilityTool.h"
#import "WaterFLayout.h"

static NSString *sizeCellId = @"sizeCellId";
static NSString *headId = @"headId";
static NSInteger kColumnCount = 3;
static CGFloat kHeadHeight = 40.f;

@interface SizeHeadCollectionView : UICollectionReusableView
{
    UILabel *_lb;
}
@property (nonatomic, strong) NSString *text;
@end

@implementation SizeHeadCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(10, 0, 100, 40);
        UILabel *lb = [[UILabel alloc] initWithFrame:rect];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.textColor = COLOR_C2;//[UIColor blackColor];
        lb.font = FONT_t6;//[UIFont systemFontOfSize:12.f];
        [self addSubview:lb];
        
        _lb = lb;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _lb.text = text;
}

@end


/** 
 GoodsSizeSelectionCollectionView
 */
@interface GoodsSizeSelectionCollectionView ()<UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation GoodsSizeSelectionCollectionView

#pragma mark -
- (void)setSizeArrM:(NSMutableArray *)sizeArrM
{
    _sizeArrM = sizeArrM;
    [self reloadData];
}

- (void)setTempArrM:(NSMutableArray *)tempArrM
{
    _tempArrM = tempArrM;
    [self reloadData];
}

- (NSMutableArray *)containsArrM
{
    if (!_containsArrM) {
        _containsArrM = [NSMutableArray array];
    }
    return _containsArrM;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    if(self.sizeArrM.count>0)
    {
        if (_selectedIndex==-1) {
            
        }
        else
        {
          [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

- (CGFloat)sizeViewH
{
    CGFloat width = self.bounds.size.width;
    CGFloat w = (width - (kColumnCount-1)*10-30)/kColumnCount;
    CGFloat h = w/5*2;
    
    _sizeViewH = ((NSInteger)((self.sizeArrM.count-1)/(kColumnCount))+1)*(h+10)+10+kHeadHeight+10;//(self.colorArrM.count/6)*(h+10)+10+40;
    return _sizeViewH;
}

- (id)initWithFrame:(CGRect)frame
{
    //    WaterFLayout *waterLayout = [[WaterFLayout alloc] init];
    //    waterLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 20);
    //    waterLayout.minimumColumnSpacing = 10;
    //    waterLayout.minimumInteritemSpacing = 10;
    //    waterLayout.columnCount = 6;
    //    waterLayout.headerHeight = 40.f;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 20);
    layout.headerReferenceSize = CGSizeMake(self.bounds.size.width, kHeadHeight);
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[GoodsSizeCollectionCell class]
 forCellWithReuseIdentifier:sizeCellId];
        [self registerClass:[SizeHeadCollectionView class]
 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:headId];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    count = self.sizeArrM.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
#if 0
     if (indexPath.section == 0) {
        GoodsSizeCollectionCell *sizeCell =
         [collectionView dequeueReusableCellWithReuseIdentifier:sizeCellId
                                                   forIndexPath:indexPath];
//         MBGoodsDetailesSpecModel *model = self.sizeArrM[indexPath.row];
//         sizeCell.contentModel = model;
         [self.containsArrM removeAllObjects];
//         sizeCell.userInteractionEnabled = YES;
         sizeCell.lb.text = self.sizeArrM[indexPath.row];
         if ([self.tempArrM containsObject:sizeCell.lb.text]) {
             sizeCell.lb.textColor = COLOR_C6;
             sizeCell.userInteractionEnabled = NO;
             sizeCell.selected = NO;
             [self.containsArrM addObject:@(indexPath.row)];
         } else {
             sizeCell.lb.textColor = COLOR_C2;
             sizeCell.userInteractionEnabled = YES;
         }
        cell = sizeCell;
    }
    
#else
    
    GoodsSizeCollectionCell *sizeCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:sizeCellId
                                              forIndexPath:indexPath];
    sizeCell.lb.text = self.sizeArrM[indexPath.row];
    cell = sizeCell;
    
#endif
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *collectionReusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SizeHeadCollectionView *headCollectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                    withReuseIdentifier:headId
                                                                                           forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headCollectionView.text = @"尺码";
        }
        
        collectionReusableView = headCollectionView;
    }
    return collectionReusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    CGFloat width = self.frame.size.width;
    
    //    width-
    if (indexPath.section == 0){
        CGFloat w = (width - (kColumnCount-1)*10-30)/kColumnCount;
        size = CGSizeMake(w, w/5*2);
    }
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsSizeCollectionCell *cell = (GoodsSizeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([_clickedDelegate respondsToSelector:@selector(didClickedGoodsSizeCollectionViewWithcell: index:)]) {
        [_clickedDelegate didClickedGoodsSizeCollectionViewWithcell:cell index:indexPath.row];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
