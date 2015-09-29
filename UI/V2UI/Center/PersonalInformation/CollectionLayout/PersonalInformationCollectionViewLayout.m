//
//  PersonalInformationCollectionViewLayout.m
//  Designer
//
//  Created by Jiang on 1/19/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "PersonalInformationCollectionViewLayout.h"
#import "LayoutDecorationCollectionReusableView.h"

@interface PersonalInformationCollectionViewLayout ()

@end

static NSString *decorationIdentifier = @"PersonalInformationCollectionViewDecorationIdentifier";
@implementation PersonalInformationCollectionViewLayout

- (void)prepareLayout{
    [super prepareLayout];
    self.minimumInteritemSpacing = 0.0;
    self.minimumLineSpacing = 0.0;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.itemSize = CGSizeMake(160.0, 180.0);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self registerClass:[LayoutDecorationCollectionReusableView class] forDecorationViewOfKind:decorationIdentifier];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    CGRect rect = CGRectZero;
    rect.size = self.collectionViewContentSize;
    attribute.frame = rect;
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    [array addObject:[self layoutAttributesForDecorationViewOfKind:decorationIdentifier atIndexPath:indexPath]];
    return array;
}

@end
