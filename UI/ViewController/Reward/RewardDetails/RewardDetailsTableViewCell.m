//
//  RewardCreateCompletionTableViewCell.m
//  Designer
//
//  Created by Jiang on 1/15/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "RewardDetailsTableViewCell.h"

@interface RewardDetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

- (IBAction)acceptAction:(UIButton *)sender;
- (IBAction)contactButton:(UIButton *)sender;

@end

@implementation RewardDetailsTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
//    UIImage *image = [UIImage imageNamed:@"u48"];
//    image = [image resizableImageWithCapInsets:insets];
//    [self.acceptButton setBackgroundImage:image forState:UIControlStateNormal];
//    image = [UIImage imageNamed:@"u40"];
//    image = [image resizableImageWithCapInsets:insets];
//    [self.contactButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

- (IBAction)acceptAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RewardCreateCompletionAccept" object:nil];
}

- (IBAction)contactButton:(UIButton *)sender {
}
@end
