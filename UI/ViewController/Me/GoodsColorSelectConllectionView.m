//
//  GoodsColorSelectConllectionView.m
//  PopView
//
//  Created by Jiang on 15/8/28.
//  Copyright (c) 2015年 Kong. All rights reserved.
//

#import "GoodsColorSelectConllectionView.h"
#import "WaterFLayout.h"

#import "MBGoodsDetailsColorModel.h"
#import "SUtilityTool.h"
#import "Utils.h"

static NSString *colorCellId = @"colorCellId";
static NSString *headId = @"headId";
static NSInteger kColumnCount = 6;
static CGFloat kHeadHeight = 40.f;

@interface ColorHeadCollectionView : UICollectionReusableView
{
    UILabel *_lb;
}
@property (nonatomic, strong) NSString *text;
@end

@implementation ColorHeadCollectionView

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
 GoodsColorSelectConllectionView
 */
@interface GoodsColorSelectConllectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@implementation GoodsColorSelectConllectionView

- (CGFloat)colorViewH
{
    CGFloat width = self.bounds.size.width;
    CGFloat w = (width - (kColumnCount-1)*10-30)/(kColumnCount);
    CGFloat h = w*1;

    _colorViewH = ((NSInteger)((self.colorArrM.count-1)/kColumnCount+1))*(h+10)+10+kHeadHeight;//(self.colorArrM.count/6)*(h+10)+10+40;
    return _colorViewH;
}

- (void)setColorArrM:(NSMutableArray *)colorArrM
{
    _colorArrM = colorArrM;
    [self reloadData];
}

- (void)setTempArrM:(NSMutableArray *)tempArrM
{
    [_tempArrM removeAllObjects];
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

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if(self.colorArrM.count>0)
    {
        [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex
                                                       inSection:0]
                           animated:NO
                     scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark -
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
        [self registerClass:[GoodsColorCollectionCell class]
 forCellWithReuseIdentifier:colorCellId];
        [self registerClass:[ColorHeadCollectionView class]
 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:headId];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;

    count = self.colorArrM.count;

    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        GoodsColorCollectionCell *colorCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:colorCellId
                                                  forIndexPath:indexPath];

        [self.containsArrM removeAllObjects];
//        colorCell.userInteractionEnabled = YES;
//        [colorCell.imgView sd_setImageWithURL:[NSURL URLWithString:self.colorArrM[indexPath.row]]
//                             placeholderImage:[UIImage imageNamed:NONE_DATA_ITEM]];
        colorCell.imageUrl = self.colorArrM[indexPath.row][@"coloR_FILE_PATH"];
        colorCell.coloR_ID = [NSString stringWithFormat:@"%@",self.colorArrM[indexPath.row][@"coloR_ID"]];
        
        if ([self.tempArrM containsObject:colorCell.imageUrl]) {
            [colorCell.imgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            colorCell.userInteractionEnabled = NO;
            colorCell.selected = NO;
            [self.containsArrM addObject:@(indexPath.row)];
        } else {
            [colorCell.imgView sd_setImageWithURL:[NSURL URLWithString:self.colorArrM[indexPath.row][@"coloR_FILE_PATH"]] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            colorCell.userInteractionEnabled = YES;
        }
        cell = colorCell;
        
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *collectionReusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ColorHeadCollectionView *headCollectionView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:headId
                                                  forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headCollectionView.text = @"颜色";
        }
        
        collectionReusableView = headCollectionView;
    }
    return collectionReusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    CGFloat width = self.frame.size.width;
    
    CGFloat w = (width - (kColumnCount-1)*10-30)/kColumnCount;
    CGFloat h = w*1;
    if (indexPath.section == 0) {
        
        size = CGSizeMake(w, h);
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsColorCollectionCell *cell = (GoodsColorCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([_clickedDelegate respondsToSelector:@selector(didClickedGoodsColorCollectionViewWithCell:index:)]) {
        [_clickedDelegate didClickedGoodsColorCollectionViewWithCell:cell index:indexPath.row];
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
