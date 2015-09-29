//
//  MyLikeCollocationTableViewCell.h
//  Wefafa
//
//  Created by mac on 14-10-20.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUrlImageView.h"

@interface MyLikeCollocationTableViewCell : UITableViewCell
{
    NSDictionary *_data;
}
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbDesigner;
@property (strong, nonatomic) IBOutlet UIUrlImageView *imageColl;

@property (strong, nonatomic) id data;

@end
