//
//  SSearchTagCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchTagCollectionView.h"
#import "SUtilityTool.h"

@interface SSearchTagCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SSearchTagCollectionViewHeaderDelegate>

@end
static NSString *noSearchCellIndentifier = @"SSearchNoSearchCellCellIdentifier";
static NSString *cellIndentifier = @"SSearchTagCollectionViewCellIdentifier";
static NSString *headerIndentifier = @"SSearchTagCollectionViewHeaderIdentifier";

static const NSInteger kMaxSpacing = 6.0;

@implementation SSearchTagCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    SSearchTagCollectionViewFlowLayout *layout = [[SSearchTagCollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = kMaxSpacing;
    layout.minimumInteritemSpacing = kMaxSpacing;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setUserContentArray:(NSArray *)userContentArray{
    _userContentArray = userContentArray;
    [self reloadData];
}

- (void)setHotContentArray:(NSArray *)hotContentArray{
    _hotContentArray = hotContentArray;
    [self reloadData];
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"最近搜索", @"热门搜索"];
    }
    return _titleArray;
}

- (void)awakeFromNib{
    self.alwaysBounceVertical = YES;
    self.contentInset = UIEdgeInsetsMake(0, 17, 20, 17);
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:noSearchCellIndentifier];
    [self registerClass:[SSearchTagCollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    [self registerClass:[SSearchTagCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIndentifier];
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark delegate datesource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        if (_userContentArray.count == 0 ||_userContentArray == nil) {
            return 1;
        }
        return _userContentArray.count;
    }else{
        return _hotContentArray.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSearchTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        //无搜索记录时显示 暂无搜索历史
        if (_userContentArray.count == 0||_userContentArray==nil) {
            UICollectionViewCell *noSearchCell = [collectionView dequeueReusableCellWithReuseIdentifier:noSearchCellIndentifier forIndexPath:indexPath];
            UILabel *title = [UILabel new];
            title.textColor = COLOR_C6;
            title.font = FONT_t5;
            title.textAlignment = NSTextAlignmentCenter;
            title.frame = CGRectMake(0, 0,UI_SCREEN_WIDTH-40, 114);
            title.text = @"暂无搜索历史";
            [noSearchCell addSubview:title];
            
            return noSearchCell;
        }
        cell.tagName = _userContentArray[indexPath.row];
        return cell;
    }else{
        NSDictionary *dict = _hotContentArray[indexPath.row];
        cell.tagName = dict[@"keyword"];
        return cell;
    }
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SSearchTagCollectionViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIndentifier forIndexPath:indexPath];
        headerView.delegate = self;
        headerView.titleName = self.titleArray[indexPath.section];
        headerView.deleteButton.hidden = indexPath.section != 0;
        view = headerView;
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = @"";
    if (indexPath.section == 0) {
        if (_userContentArray.count == 0||_userContentArray==nil) {
            return CGSizeMake(UI_SCREEN_WIDTH-40, 114);
        }
        
        string = _userContentArray[indexPath.row];
    }else{
        NSDictionary *dict = _hotContentArray[indexPath.row];
        string = dict[@"keyword"];
    }
    CGSize size = [string boundingRectWithSize:CGSizeMake(0, 30)
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                            context:nil].size;
    return CGSizeMake(MIN(size.width, 80) + 20, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(UI_SCREEN_WIDTH, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tagCollectionDelegate respondsToSelector:@selector(searchCollectionView:didSelectedIndexPath:)]) {
        [self.tagCollectionDelegate searchCollectionView:collectionView didSelectedIndexPath:indexPath];
    }
}

#pragma mark header delete delegate
- (void)searchDeleteButtonAction:(UIButton *)button{
    if ([self.tagCollectionDelegate respondsToSelector:@selector(searchCollectionHeaderDeleteAction:)]) {
        [self.tagCollectionDelegate searchCollectionHeaderDeleteAction:button];
    }
}

@end

#pragma mark - cell
@implementation SSearchTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_t5;
        label.textColor = COLOR_C6;
        label.layer.cornerRadius = 3.0;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = COLOR_C9.CGColor;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        [self addSubview:label];
        _contentLabel = label;
    }
    return self;
}

- (void)setTagName:(NSString *)tagName{
    _tagName = [tagName copy];
    self.contentLabel.text = tagName;
}

@end

#pragma mark - header
@implementation SSearchTagCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.font = FONT_t6;
        label.textColor = COLOR_C2;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        [self addSubview:label];
        _contentLabel = label;
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 30, 0, 30, frame.size.height)];
        [button addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"Unico/btn_trash"] forState:UIControlStateNormal];
        [self addSubview:button];
        _deleteButton = button;
    }
    return self;
}

- (void)deleteButtonAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(searchDeleteButtonAction:)]) {
        [self.delegate searchDeleteButtonAction:sender];
    }
}

- (void)setTitleName:(NSString *)titleName{
    _titleName = [titleName copy];
    self.contentLabel.text = titleName;
}

@end


//自定义流式布局
@implementation SSearchTagCollectionViewFlowLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}


//重新计算cell的LayoutAttributes信息
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes =
    [super layoutAttributesForItemAtIndexPath:indexPath];
    
    UIEdgeInsets sectionInset = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
    
    if (indexPath.item == 0) {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left;
        currentItemAttributes.frame = frame;
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = CGRectGetMaxX(previousFrame)+ kMaxSpacing;
    
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(0,
                                              currentFrame.origin.y,
                                              self.collectionView.frame.size.width,
                                              currentFrame.size.height);
    
    if (!CGRectIntersectsRect(previousFrame, strecthedCurrentFrame)) {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left;
        currentItemAttributes.frame = frame;
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint;
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

@end
