//
//  MBAddShoppingColorCell.h
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBGoodsDetailsColorModel;

@interface MBAddShoppingColorCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *coloR_ID;

@property (weak, nonatomic) IBOutlet UIImageView *showColorImageView;

@end
