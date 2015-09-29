//
//  PersonalInformationTableViewCell.m
//  Designer
//
//  Created by Jiang on 1/15/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "PersonalInformationContentListTableViewCell.h"

@interface PersonalInformationContentListTableViewCell ()

//用户昵称
@property (weak, nonatomic) IBOutlet UILabel *userName;
//搭配数
@property (weak, nonatomic) IBOutlet UILabel *matchCount;
//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *fansCount;

- (IBAction)attentionButton:(UIButton *)sender;

@end

@implementation PersonalInformationContentListTableViewCell

- (void)awakeFromNib {
    [self.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn-data-2-on.png"] forState:UIControlStateNormal];
    [self.attentionButton setBackgroundImage:[UIImage imageNamed:@"btn-data-2-add.png"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attentionButton:(UIButton *)sender {
    BOOL isSelected = !self.attentionButton.selected;
    [self.attentionButton setSelected:isSelected];
}
@end
