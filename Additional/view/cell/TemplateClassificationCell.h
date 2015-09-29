//
//  TemplateClassificationCell.h
//  Wefafa
//
//  Created by Miaoz on 15/4/1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModuleCategoryInfo;
@interface TemplateClassificationCell : UICollectionViewCell
@property(nonatomic,strong) ModuleCategoryInfo *moduleCategoryInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;

@end
