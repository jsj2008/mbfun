//
//  FittingRoomSecondCell.h
//  Wefafa
//
//  Created by yintengxiang on 15/3/19.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FittingRoomSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selsectButton;

- (void)configWithData:(id)data isFromAPI:(BOOL)isFromAPI;
@end
