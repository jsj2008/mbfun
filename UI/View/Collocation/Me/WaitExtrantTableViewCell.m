//
//  WaitExtrantTableViewCell.m
//  Wefafa
//
//  Created by fafatime on 14-9-12.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "WaitExtrantTableViewCell.h"
#import "Utils.h"

@implementation WaitExtrantTableViewCell
@synthesize statesLabel,timeLabel,bankLabel,priceLabel,cardNumberLabel,buyNameLabel,buyLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        int k=3;
        //编号品牌名字
        cardNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, k,150, 32)];
        cardNumberLabel.textColor=[Utils HexColor:0x353535 Alpha:1 ];
        cardNumberLabel.font=[UIFont systemFontOfSize:12.0f];
        cardNumberLabel.textAlignment=NSTextAlignmentLeft;
        cardNumberLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview: cardNumberLabel];

        buyLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 32-k,50, 32)];
        buyLabel.textColor=[Utils HexColor:0x6b6b6b Alpha:1];
        buyLabel.font=[UIFont systemFontOfSize:11.0f];
        buyLabel.textAlignment=NSTextAlignmentLeft;
        buyLabel.backgroundColor=[UIColor clearColor];
//        [self.contentView addSubview: buyLabel];
        buyNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 32-k,150, 32)];
//        buyNameLabel.textColor=[Utils HexColor:0x353535 Alpha:1];
        buyNameLabel.textColor= [Utils HexColor:0x6b6b6b Alpha:1];
        buyNameLabel.font=[UIFont systemFontOfSize:11.0f];
        buyNameLabel.textAlignment=NSTextAlignmentLeft;
        buyNameLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview: buyNameLabel];

//        UILabel *extrantTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 25, 100, 25)];
//        extrantTimeLabel.text=@"提现时间:";
//        extrantTimeLabel.textAlignment=NSTextAlignmentLeft;
//        extrantTimeLabel.backgroundColor=[UIColor clearColor];
//        extrantTimeLabel.textColor=[UIColor blackColor];
//        [self.contentView addSubview:extrantTimeLabel];
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-150, 32-5+2, 150,32)];
        timeLabel.textColor=[Utils HexColor:0x6b6b6b Alpha:1];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.font=[UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:timeLabel];
  
        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-150-30, 0, 150,32)];
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.textColor=[UIColor blackColor];
        priceLabel.font=[UIFont systemFontOfSize:12.0f];
        priceLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:priceLabel];
        
        statesLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-150-20, 0, 100,32)];
        statesLabel.backgroundColor=[UIColor clearColor];
        statesLabel.font=[UIFont systemFontOfSize:12.0f];
//        statesLabel.textColor= [Utils HexColor:0x6b6b6b Alpha:1];
        statesLabel.textColor=[UIColor blackColor];
        statesLabel.textAlignment=NSTextAlignmentRight;
//        [self.contentView addSubview:statesLabel];
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
