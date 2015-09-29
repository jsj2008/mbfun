//
//  OtherPeopleTableViewCell.m
//  Wefafa
//
//  Created by Jiang on 2/3/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "OtherPeopleTableViewCell.h"
#import "Utils.h"

@implementation OtherPeopleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [Utils HexColor:0x333333 Alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCellType:(CellType)cellType{
    
    self.accessoryView = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.contentTextLabel.hidden = YES;
    self.imgQRcode.hidden = YES;
    if (cellType == cellTypePlain) return;
    
    if (cellType == cellTypeContentText) {
        self.contentTextLabel.hidden = NO;
    }
    if (cellType == cellTypeIndicator) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (cellType == cellTypeQRCode){
        //二维码图片
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 15, 15)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_profile_QRcode"]];
        
        self.accessoryView = view;
        self.imgQRcode.hidden = NO;
    }
}

@end
