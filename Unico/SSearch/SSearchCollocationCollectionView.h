//
//  SSearchCollocationCollectionView.h
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSearchCollocationCollectionViewDelegate <NSObject>

@optional
- (void)listViewDidScroll:(UIScrollView*)scrollView;
- (void)listViewWillBeginDraggingScroll:(UIScrollView *)scrollView;
- (void)listViewDidEndDecelerating:(UIScrollView *)scrollView;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

@interface SSearchCollocationCollectionView : UICollectionView

@property (nonatomic, assign) id<SSearchCollocationCollectionViewDelegate> collectionDelagate;

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@property (nonatomic, strong) NSNumber *isHotData;

@end
