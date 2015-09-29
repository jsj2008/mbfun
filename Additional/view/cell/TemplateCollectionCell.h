//
//  TemplateCollectionCell.h
//  Wefafa
//
//  Created by Miaoz on 15/3/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TemplateElement;
@interface TemplateCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,strong)TemplateElement *templateElement;
@end
