//
//  myRedPackTableViewCell.h
//  Wefafa
//
//  Created by metesbonweios on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyRedPacketModel;
@class OrderRedPacketModel;

@protocol RedPacketCellDelete <NSObject>
- (void)mbCell_OnDidSelectedWithMessage:(id)message;
- (void)mbCell_OnDidSelectedGoDetailWithMessage:(id)message;
@end


@interface MyRedPackTableViewCell : UITableViewCell
{
    
}
@property (assign,nonatomic) id<RedPacketCellDelete>redPacketDelete;

@property (weak, nonatomic) IBOutlet UIImageView *showImgView;//底部图
@property (weak, nonatomic) IBOutlet UILabel *restrictionLabel;//限制
@property (weak, nonatomic) IBOutlet UILabel *packetNameLabe;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;

@property (nonatomic,strong) MyRedPacketModel *cellModel;
@property (nonatomic,strong) OrderRedPacketModel *orderCellModel;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn;

@property (assign,nonatomic) BOOL isComeFromOrder;
@property (retain, nonatomic) NSString *choosePacketId;
@property (weak, nonatomic) IBOutlet UIView *textShowView;
- (IBAction)clickBtn:(id)sender;
- (IBAction)gotoDetail:(id)sender;

@end
