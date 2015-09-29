//
//  TipInfoCell.h
//  Wefafa
//
//  Created by mac on 13-10-29.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipInfoCell : UITableViewCell
{
    UILabel *lbTipInfo;
}

@property(nonatomic,strong) NSString *tipInfo;
@property(nonatomic,strong) UIImageView *noMessageImage;
@property (nonatomic,assign)BOOL picIshidden;
@end
