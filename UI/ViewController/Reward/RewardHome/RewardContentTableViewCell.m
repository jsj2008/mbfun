//
//  RewardContentTableViewCell.m
//  Wefafa
//
//  Created by Jiang on 3/17/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "RewardContentTableViewCell.h"

@interface RewardContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *acceptImageView;
@property (weak, nonatomic) IBOutlet UILabel *acceptLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;


@property (assign, nonatomic, getter=isOrderStatus) BOOL orderStatus;

@end

@implementation RewardContentTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.acceptLabel.transform = CGAffineTransformMakeRotation(-M_PI_4 /3 *2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

@end
