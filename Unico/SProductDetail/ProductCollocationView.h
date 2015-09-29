//
//  ProductCollocationView.h
//  Wefafa
//
//  Created by Jiang on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProductCollocationViewDelegate <NSObject>

- (void)ProductCollocationViewViewDidScroll:(UIScrollView *)scrollView;
- (void)productCollocationViewCellDidSelectedWithProductCode:(NSString *)productCode;

@end

@interface ProductCollocationView : UICollectionView

@property (nonatomic, weak) id<ProductCollocationViewDelegate> collocationDelegate;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) UIViewController *target;

//@property (nonatomic, copy) void (^opration)(NSIndexPath *indexPath, NSArray *array);
@property (nonatomic, strong) NSNumber *isAbandonRefresh;
@property (nonatomic, copy) void (^releaseColl)();  // 发布搭配
@property (nonatomic, copy) void (^lookFor)();  // 查看相似搭配

-(void)loadNextContentArray:(NSArray *)contentArray;

/**
 *	@简要 监听刷新 是否喜欢相关搭配
 */
-(void)loadLikeData;
@end
