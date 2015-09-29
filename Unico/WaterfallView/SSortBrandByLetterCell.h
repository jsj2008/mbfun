//
//  SSortBrandByLetterCell.h
//  Wefafa
//
//  Created by lizhaoxiang on 15/6/9.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSortBrandByLetterModel.h"

@interface SSortBrandByLetterCell : UITableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)updateSSorderBrandByLetterModel:(SSortBrandByLetterSubModel*)model;
@end
