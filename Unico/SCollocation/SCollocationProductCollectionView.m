//
//  SCollocationProductCollectionView.m
//  Wefafa
//
//  Created by Mr_J on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SCollocationProductCollectionView.h"
#import "SCollectionProductCollectionViewCell.h"
#import "MBAddShoppingViewController.h"
#import "SProductDetailViewController.h"
#import "SNoneProductDetailViewController.h"
#import "Toast.h"

@interface SCollocationProductCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SCollectionProductCollectionViewCellDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) UIButton *collocationBuyButton;

@end

static NSString *cellIdentifier = @"SCollectionProductCollectionViewCellIdentifier";
@implementation SCollocationProductCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 40)];
    _titleLabel.text = @"搭配单品";
    _titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_titleLabel];
    
    _collocationBuyButton = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 70, 7, 60, 23)];
    _collocationBuyButton.backgroundColor = UIColorFromRGB(0xfedc32);
    _collocationBuyButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    _collocationBuyButton.layer.masksToBounds = YES;
    _collocationBuyButton.layer.cornerRadius = 3.0;
    [_collocationBuyButton setTitle:@"加入购物袋" forState:UIControlStateSelected];
    [_collocationBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_collocationBuyButton setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
    [_collocationBuyButton setTitle:@"搭配购" forState:UIControlStateNormal];
    [_collocationBuyButton addTarget:self action:@selector(touchCollocationBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collocationBuyButton];
    
    [self initContentView];
}

- (void)touchCollocationBuyButton:(UIButton*)sender{
    if (!sender.selected) {
        for (SCollocationSubProductModel *model in _contentArray) {
            model.isSelected = YES;
            model.isShowSelected = YES;
        }
        [_contentCollectionView reloadData];
        [self collocationBuyButtonSelected];
    }else{
        if ([BaseViewController pushLoginViewController]) {
            NSMutableArray *array = [NSMutableArray array];
            for (SCollocationSubProductModel *model in _contentArray) {
                if (model.isSelected) {
                    [array addObject:model.product_code];
                }
            }
            if (array.count <= 0) {
                [Toast makeToast:@"没有选中的商品哦！"];
                return;
            }
            MBAddShoppingViewController *controller = [[MBAddShoppingViewController alloc]initWithNibName:@"MBAddShoppingViewController" bundle:nil];
            controller.itemAry = array;
            [_target.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)collocationBuyButtonSelected{
    _collocationBuyButton.selected = YES;
    _collocationBuyButton.backgroundColor = UIColorFromRGB(0x3b3b3b);
    _collocationBuyButton.frame = CGRectMake(UI_SCREEN_WIDTH - 90, 7, 80, 23);
}

- (void)collocationBuyButtonUnselected{
    _collocationBuyButton.selected = NO;
    _collocationBuyButton.backgroundColor = UIColorFromRGB(0xfedc32);
    _collocationBuyButton.frame = CGRectMake(UI_SCREEN_WIDTH - 70, 7, 60, 23);
}

- (void)initContentView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH, 10) collectionViewLayout:layout];
    _contentCollectionView.delegate = self;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SCollectionProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)setContentModel:(SCollocationDetailModel *)contentModel{
    _contentModel = contentModel;
    self.contentArray = contentModel.product_list;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    int ableBuyCount = 0;
    for (SCollocationSubProductModel *model in _contentArray) {
        if (model.product_code.length > 0 && model.product && model.product.stock_num.intValue > 0 && model.product.status.intValue == 2) {
            ableBuyCount ++;
        }
    }
    _collocationBuyButton.hidden = ableBuyCount == 0;
    NSInteger count = (_contentModel.product_list.count + 2)/ 3;
    self.height = 50 + count * ((UI_SCREEN_WIDTH - 30)/ 3.0 + 30) + 5 * (count - 1);
    _contentCollectionView.height = self.height - 40;
    [_contentCollectionView reloadData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH - 30)/ 3.0, (UI_SCREEN_WIDTH - 30)/ 3.0 + 30);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SCollectionProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentModel = _contentArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SCollocationSubProductModel *model = _contentArray[indexPath.row];
    if (model.product_code.length > 0) {
        SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
        controller.productID = model.product_code;
        [_target.navigationController pushViewController:controller animated:YES];
    }else{
        SNoneProductDetailViewController *controller = [SNoneProductDetailViewController new];
        controller.productID = model.aID;
        [_target.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark cell delegate
- (void)touchSelectedButtonAction:(UIButton *)sender{
#warning 暂时不需要取消全部后更改搭配购按钮状态
    return;
    if (sender.selected) {
        [self collocationBuyButtonSelected];
    }else{
        int count = 0;
        for (SCollocationSubProductModel *model in _contentArray) {
            count += model.isSelected? 1: 0;
        }
        if (count <= 0) {
            [self collocationBuyButtonUnselected];
        }else{
            [self collocationBuyButtonSelected];
        }
    }
}

@end
