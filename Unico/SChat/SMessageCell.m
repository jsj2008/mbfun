//
//  SMessageCell.m
//  Wefafa
//
//  Created by wave on 15/7/30.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMessageCell.h"
#import "Utils.h"
#import "SUtilityTool.h"

@interface SMessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@end

@implementation SMessageCell

- (void)awakeFromNib {
    // Initialization code
    _countLabel.backgroundColor = [Utils HexColor:0xfb5b4e Alpha:1];
    _countLabel.layer.cornerRadius = _countLabel.frame.size.height/2;
    _countLabel.layer.masksToBounds = YES;
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    int count = [dic[@"count"] intValue];
    [_countLabel setText:[NSString stringWithFormat:@"%d", count]];
    if (count == 0)_countLabel.hidden = YES;else _countLabel.hidden = NO;
    
    [self.headImg setImage:[UIImage imageNamed:dic[@"img"]]];
    [self.textlabel setText:dic[@"text"]];
    [self.textlabel sizeToFit];
}

@end
