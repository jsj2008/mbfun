//
//  ProductSimilarityView.h
//  Wefafa
//
//  Created by Jiang on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductSimilarityViewDelegate <NSObject>

- (void)productSimilartyViewViewDidScroll:(UIScrollView *)scrollView;
- (void)productSimilartyViewViewWillBeginDraggingScroll:(UIScrollView *)scrollView;
- (void)productSimilartyViewCellDidSelectedWithProductCode:(NSString *)productCode;

@end


@interface ProductSimilarityView : UICollectionView

@property (nonatomic, weak) id<ProductSimilarityViewDelegate> similarityDelegate;

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@property (nonatomic, assign) UIViewController *target;

-(void)setCategaryContentArray:(NSArray *)contentArray;
-(void)loadNextContentArray:(NSArray *)contentArray;

@end
