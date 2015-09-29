//
//  SSearchProductCollectionView.h
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SProductCollectionDelegate <NSObject>

- (void)listViewDidScroll:(UIScrollView *)scrollView;

@end

@interface SSearchProductCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) BOOL isShowPrice;
@property (nonatomic, assign) id<SProductCollectionDelegate> productDelegate;
@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@property (nonatomic, strong) NSNumber *isHotData;
-(void)setCategaryContentArray:(NSArray *)contentArray;
-(void)loadNextContentArray:(NSArray *)contentArray;
@end
