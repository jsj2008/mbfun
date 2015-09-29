//
//  SSearchTagCollectionView.h
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSearchTagCollectionViewDelegate <NSObject>

@optional
- (void)searchCollectionHeaderDeleteAction:(UIButton*)sender;
- (void)searchCollectionView:(UICollectionView*)collectionView didSelectedIndexPath:(NSIndexPath*)indexPath;

@end

@interface SSearchTagCollectionView : UICollectionView

@property (nonatomic, assign) id<SSearchTagCollectionViewDelegate> tagCollectionDelegate;
@property (nonatomic, strong) NSArray *hotContentArray;
@property (nonatomic, strong) NSArray *userContentArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@interface SSearchTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, copy) NSString *tagName;

@end

@protocol SSearchTagCollectionViewHeaderDelegate <NSObject>

@optional
- (void)searchDeleteButtonAction:(UIButton*)button;

@end

@interface SSearchTagCollectionViewHeader : UICollectionReusableView

@property (nonatomic, assign) id<SSearchTagCollectionViewHeaderDelegate> delegate;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, weak) UIButton *deleteButton;

@end


@interface SSearchTagCollectionViewFlowLayout : UICollectionViewFlowLayout



@end