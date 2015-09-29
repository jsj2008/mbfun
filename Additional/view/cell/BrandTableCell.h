//
//  BrandTableCell.h
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandMapping.h"
@interface BrandTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandNamLab;
@property(nonatomic,strong)BrandMapping *brandMapping;

@end
