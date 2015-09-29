//
//  AddAddressTableViewCell.m
//  Wefafa
//
//  Created by wave on 15/5/29.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "AddAddressTableViewCell.h"
#import "Utils.h"
@interface AddAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *isDefault;
@property (weak, nonatomic) IBOutlet UILabel *defAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *sepLabel;

@end

@implementation AddAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDic:(NSDictionary*)dic {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setDic:(NSDictionary*)dic {
    self.sepLabel.height = .3;
    self.sepLabel.backgroundColor = [Utils HexColor:0xbbbbbb Alpha:1];
    NSString *nameStr = dic[@"name"];
    NSString *mobileStr = dic[@"mobileno"];
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@%@", dic[@"country"], dic[@"province"], dic[@"city"], dic[@"county"], dic[@"street"]];
    self.nameLabel.text = nameStr;
    self.phoneLabel.text = mobileStr;
    self.addLabel.text = addressStr;
    CGSize nameSize = [nameStr sizeWithAttributes:@{NSFontAttributeName : self.nameLabel.font}];
    CGSize phoneSize = [mobileStr sizeWithAttributes:@{NSFontAttributeName : self.phoneLabel.font}];
    CGSize addSize = [addressStr sizeWithAttributes:@{NSFontAttributeName : self.addLabel.font}];
    self.nameLabel.size = nameSize;
    self.phoneLabel.size = phoneSize;
    self.addLabel.size = addSize;
    if ([dic[@"isdefault"] isEqualToString:@"1"]) { //默认
        self.isDefault.selected = YES;
    }else {
        self.isDefault.selected = NO;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
