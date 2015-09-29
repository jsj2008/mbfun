//
//  DesignerTopTenTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-9-26.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundHeadImageView.h"

@interface DesignerTopTenTableViewCell : UITableViewCell
{
    NSCondition *download_lock;
}

@property (strong, nonatomic) IBOutlet UILabel *lbName;

@property (strong, nonatomic) IBOutlet RoundHeadImageView *imageHead;
@property (strong, nonatomic) IBOutlet UIImageView *titleImgView;

@property (strong, nonatomic) NSDictionary * data;

@end
