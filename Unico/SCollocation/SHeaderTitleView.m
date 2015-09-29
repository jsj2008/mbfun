//
//  SHeaderTitleCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 6/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SHeaderTitleView.h"
#import "SUtilityTool.h"
#import "SHeaderTitleModel.h"
#import "SDiscoveryFlexibleModel.h"

@interface SHeaderTitleView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
{
    NSIndexPath *_selectedIndexPath;
}

@property (nonatomic, strong) CALayer *selectedLayer;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UILabel *showStateLabel;
@property (nonatomic, strong) UICollectionViewFlowLayout *contentCollectionViewLayout;
@property (nonatomic, strong) UIView *compensationView;

@end

static NSString *cellIdentifier = @"SHeaderTitleCellIdentifier";
@implementation SHeaderTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _showStateLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _showStateLabel.backgroundColor = [UIColor whiteColor];
        _showStateLabel.text = @"   切换类目";
        _showStateLabel.textColor = COLOR_C2;
        _showStateLabel.font = FONT_T6;
        [self addSubview:_showStateLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionViewLayout = layout;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
        _contentCollectionView.alwaysBounceHorizontal = YES;
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        [_contentCollectionView registerClass:[SHeaderTitleCell class] forCellWithReuseIdentifier:cellIdentifier];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [self addSubview:_contentCollectionView];
        
        _lineLayer = [CALayer layer];
        _lineLayer.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5);
        _lineLayer.backgroundColor = COLOR_C9.CGColor;
        _lineLayer.zPosition = 5;
        [self.layer addSublayer:_lineLayer];
        
        UIView *buttonBackView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width - 44, 0, 44, frame.size.height)];
        buttonBackView.backgroundColor = [UIColor whiteColor];
        buttonBackView.layer.masksToBounds = YES;
        [self addSubview:buttonBackView];
        _showButton = [[UIButton alloc]initWithFrame:buttonBackView.bounds];
        [_showButton setImage:[UIImage imageNamed:@"Unico/arrow_bottom"] forState:UIControlStateNormal];
        [_showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBackView addSubview:_showButton];
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        CALayer *showButtonDecorate = [CALayer layer];
        showButtonDecorate.frame = CGRectMake(frame.size.width - 44, 0, 0.5, frame.size.height);
        showButtonDecorate.backgroundColor = COLOR_C9.CGColor;
        showButtonDecorate.zPosition = 5;
        [self.layer addSublayer:showButtonDecorate];
        
        _pramsViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)setOriginOffset:(CGFloat)offset{
    CGRect frame = self.compensationView.frame;
    frame.origin.y = offset;
    _compensationView.frame = frame;
}

- (UIView *)compensationView{
    if (!_compensationView) {
        _compensationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _compensationView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:_compensationView atIndex:0];
    }
    return _compensationView;
}

- (CALayer *)selectedLayer{
    if (!_selectedLayer) {
        _selectedLayer = [CALayer layer];
        _selectedLayer.frame = CGRectMake(7, _contentCollectionView.frame.size.height - 3, 45, 3);
        _selectedLayer.backgroundColor = COLOR_C1.CGColor;
        _selectedLayer.zPosition = 5;
        [_contentCollectionView.layer addSublayer:_selectedLayer];
    }
    return _selectedLayer;
}

- (void)showButtonAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    CGAffineTransform transform;
    CGRect frame = self.frame;
    CGRect collectionFrame = _contentCollectionView.frame;
    UICollectionViewScrollDirection scrollDirection;
    UIEdgeInsets edgeInset = _contentCollectionView.contentInset;
    UIColor *contentCollectionBackColor = nil;
    _selectedLayer.opacity = 0;
    if (sender.selected) {
        frame.size.height = 44 + (_contentModelArray.count + 2)/ 3 * 44;
        collectionFrame.origin.y = 44;
        collectionFrame.size.height = (_contentModelArray.count + 2)/ 3 * 44;
        self.contentCollectionView.alpha = 1;
        transform = CGAffineTransformMakeRotation(M_PI);
        scrollDirection = UICollectionViewScrollDirectionVertical;
        edgeInset.left = 0;
        edgeInset.right = 0;
        contentCollectionBackColor = COLOR_C4;
    }else{
        frame.size.height = 44;
        collectionFrame.origin.y = 0;
        collectionFrame.size.height = 44;
        self.contentCollectionView.alpha = 1;
        transform = CGAffineTransformIdentity;
        scrollDirection = UICollectionViewScrollDirectionHorizontal;
        edgeInset.left = 17;
        edgeInset.right = 45;
        contentCollectionBackColor = [UIColor whiteColor];
    }
    self.contentCollectionViewLayout.scrollDirection = scrollDirection;
    sender.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
//        self.contentCollectionView.alpha = 1;
        self.contentCollectionView.frame = collectionFrame;
        self.contentCollectionView.contentInset = edgeInset;
        self.contentCollectionView.backgroundColor = contentCollectionBackColor;
        self.frame = frame;
        self.showButton.transform = transform;
    }completion:^(BOOL finished) {
        
        sender.userInteractionEnabled = YES;
        self.selectedLayer.opacity = 1;
        UICollectionViewCell *cell = [self.contentCollectionView cellForItemAtIndexPath:_selectedIndexPath];
        if (!cell || cell.frame.origin.x > (UI_SCREEN_WIDTH - 100)) {
            CGFloat offset_X = 0.0;
            for (int i = 0; i < _selectedIndexPath.row; i++) {
                SHeaderTitleModel *model = _contentModelArray[i];
                CGFloat width = [model.name sizeWithAttributes:@{NSFontAttributeName: FONT_t6}].width;
                offset_X += MAX(width + 20, 60);
            }
            self.contentCollectionView .contentOffset = CGPointMake(MIN(offset_X, _contentCollectionView.contentSize.width - _contentCollectionView.frame.size.width + 45), 0);
            SHeaderTitleModel *model ;
            if([_contentArray count]<=_selectedIndexPath.row)
            {
                NSLog(@"你大爷的配置又出错了");
        
            }
            else
            {
                model = _contentModelArray[_selectedIndexPath.row];
            }
            
            CGFloat width = [model.name sizeWithAttributes:@{NSFontAttributeName: FONT_t6}].width;
            width = MAX(width + 20, 60);
            self.selectedLayer.position = CGPointMake(offset_X + width/ 2, 44 - 1.5);
            [self moveContentOffsetToCenterX:offset_X + width/ 2];
        }else{
            self.selectedLayer.position = CGPointMake(cell.centerX, CGRectGetMaxY(cell.frame) - 1.5);
        }
    }];
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    self.contentModelArray = [SHeaderTitleModel modelArrayForDataArray:contentArray];
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    self.contentModelArray = contentModel.config;
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    if (!contentModelArray || contentModelArray.count <= 0) return;
    [_contentCollectionView reloadData];
    [self upDataSelectedLayerFrame:0];
}

- (void)upDataSelectedLayerFrame:(NSInteger)index{
    CGRect frame = self.selectedLayer.frame;
    SHeaderTitleModel *model = _contentModelArray[index];
    CGSize size = [model.name sizeWithAttributes:@{NSFontAttributeName: FONT_t6}];
    frame.size.width = MAX(size.width + 8, 45);
    self.selectedLayer.frame = frame;
}

- (void)moveContentOffsetToCenterX:(CGFloat)center_X{
    if (_contentCollectionView.contentSize.width < _contentCollectionView.frame.size.width + _contentCollectionView.contentInset.left + _contentCollectionView.contentInset.right) {
        return;
    }
    CGFloat offset_X = _contentCollectionView.contentOffset.x;
    offset_X = MAX(center_X - UI_SCREEN_WIDTH/2, - 5);
    CGFloat max_X = _contentCollectionView.contentSize.width - UI_SCREEN_WIDTH + _contentCollectionView.contentInset.right;
    if (max_X > -5) {
        offset_X = MIN(offset_X, max_X);
    }
    [self.contentCollectionView setContentOffset:CGPointMake(offset_X, 0) animated:YES];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SHeaderTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SHeaderTitleModel *model = _contentModelArray[indexPath.row];
    cell.selected = model.is_seleted.boolValue;
    if (model.is_seleted.boolValue) {
         for (SDiscoveryFlexibleModel *flexibleModel in _pramsViewArray) {
             flexibleModel.selectedID = model.aID;
         }
    }
    if (model.is_seleted.boolValue == YES) {
        CGPoint point = self.selectedLayer.position;
        point.x = cell.centerX;
        self.selectedLayer.position = point;
        _selectedIndexPath = indexPath;
    }
    cell.titleLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndexPath.row == indexPath.row) {
        return;
    }
    if (_showButton.selected) {
        [self showButtonAction:_showButton];
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    if (!_showButton.selected) {
//        [self moveContentOffsetToCenterX:cell.centerX];
//    }
    [self upDataSelectedLayerFrame:indexPath.row];
    self.selectedLayer.position = CGPointMake(cell.centerX, CGRectGetMaxY(cell.frame) - 1.5);
    if ([self.headerTitleDelegate respondsToSelector:@selector(headerTitleCollectionView:selectedIndex:)]) {
        [self.headerTitleDelegate headerTitleCollectionView:collectionView selectedIndex:indexPath];
    }
    if ([self.headerTitleDelegate respondsToSelector:@selector(headerTitleCollectionView:contentModel:)]) {
        SHeaderTitleModel *model = _contentModelArray[indexPath.row];
        [self.headerTitleDelegate headerTitleCollectionView:collectionView contentModel:model];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_showButton.selected) {
        return CGSizeMake((self.frame.size.width)/ 3, 44);
    }else{
        SHeaderTitleModel *model = _contentModelArray[indexPath.row];
        CGSize size = [model.name sizeWithAttributes:@{NSFontAttributeName: FONT_t6}];
        return CGSizeMake(MAX(size.width + 20, 60), 44);
    }
}

@end

@implementation SHeaderTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:_titleLabel];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = FONT_t6;
        _titleLabel.textColor = COLOR_C6;
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        _titleLabel.font = FONT_T6;
        _titleLabel.textColor = COLOR_C2;
    }else{
        _titleLabel.font = FONT_t6;
        _titleLabel.textColor = COLOR_C6;
    }
}

@end
